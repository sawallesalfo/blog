AgentiC IA 2/3 Agentic IA (1/3): Exemple d'un agent de type React

Suite de l'article ./agent_router.md


introudction
rappel de qu'on a fait avec des workflow '
Core concept

1. Tableau des framework feature majeurs et atouts et inconvents langchan langgraph smolaegent crewai,pydanti_ai  crewai et bien autres
2. Notion de tools
a ) Model llm et agent : illustration chatgpt est un agent et utilise des outils pour accomplir des tâches spécifiques. meme le Chat de mistral
b) definition outils : Les outils sont des composants externes ou des services que les agents peuvent utiliser pour étendre leurs capacités et accomplir des tâches spécifiques.
gneralmeent un efonction ouqui a un decorateur ou dinstance qui permet de resoudre des tache, dans la definition de base, les tools se serve de leur docstring pour aider le llm a raisonner
c) exemple d'outils illustration 

les ptit llm ne saven tpas calculer meme les grand llm ont du mal à calculer, puisqu leur tache est une prediction de prichain token gneraement; vOUS AVEZ DEJA SANS DOUTE L EXEMPLE il y a combien de r dans le mot   rasberry. les llm s ont du mal a y repondre. Meme si actyellent les gros models de raisonnement y arrive facilement, la façon la plus simple de pc est les outils

d'ailleurs calude et chagpt utilise beaucoup d'ouil et il ont un outl calculatrce desormais, allez voyons ça de pl
3. Implementation du react agent avec smolagent pour notre agent DataViz expert
4.Implementation du react agent pydantic_ai
6. Design pattern et best practice poour une meilleur gestion dans votre code 
7. Apllication best practice : transfoemr le router en react agent 

Ci desous l exepmple des tools et agen tdifferent
system_message = """Vous êtes un assistant spécialisé dans les calculs et l'analyse de texte. 
Utilisez les outils disponibles pour répondre aux questions sur le comptage de lettres et les calculs mathématiques."""
model = ChatLiteLLM(
model="mistral/mistral-tiny",
api_key=os.environ.get("MISTRAL_API_KEY", "test-key")
)
agent = create_react_agent(model, [], prompt=system_message)
result2 = agent.invoke({
    "messages": [("human", "Quelle est la racine carrée de 6.12?")]
})

print(result2)
# {'messages': [HumanMessage(content='Quelle est la racine carrée de 6.12?', additional_kwargs={}, response_metadata={}, id='5745df82-c486-4e9a-bb21-883cf0664e0e'), AIMessage(content='La racine carrée de 6.12 est environ 2.47. Pour calculer cette racine carrée, vous pouvez utiliser la fonction root() en spécifiant 2 comme puissance et 6.12 comme argument. Par exemple, en utilisant Python, vous pouvez effectuer le calcul suivant :\n\nroot(2, 6.12)\n\nOu, si vous êtes dans un environnement qui ne possède pas cette fonction, vous pouvez utiliser une approche itérative pour calculer la racine carrée :\n\ndef my_sqrt(num):\n  x = num / 2.0\n  while True:\n    x2 = (x + num / x) / 2.0\n    if abs(x - x2) < 0.00001:\n      return x2\n    x = x2\n  return x2\n\nmy_sqrt(6.12)\n\nCela devrait également vous donner la même réponse, environ 2.47.', additional_kwargs={}, response_metadata={'token_usage': Usage(completion_tokens=242, prompt_tokens=76, total_tokens=318, completion_tokens_details=None, prompt_tokens_details=None), 'model': 'mistral/mistral-tiny', 'finish_reason': 'stop', 'model_name': 'mistral/mistral-tiny'}, id='run--a86fc791-be6c-46cf-ae74-b956ecb821e3-0', usage_metadata={'input_tokens': 76, 'output_tokens': 242, 'total_tokens': 318})]}
agent = create_react_agent(model, [square_root_tool], prompt=system_message)
result2 = agent.invoke({
    "messages": [("human", "Quelle est la racine carrée de 6.12?")]
})

print(result2)
# {'messages': [HumanMessage(content='Quelle est la racine carrée de 6.12?', additional_kwargs={}, response_metadata={}, id='69c61954-ed5f-4a22-a07f-20b5de5f7247'), AIMessage(content='', additional_kwargs={'tool_calls': [ChatCompletionMessageToolCall(index=0, function=Function(arguments='{"number": 6.12}', name='square_root_tool'), id='jPKN340xZ', type='function')]}, response_metadata={'token_usage': Usage(completion_tokens=26, prompt_tokens=145, total_tokens=171, completion_tokens_details=None, prompt_tokens_details=None), 'model': 'mistral/mistral-tiny', 'finish_reason': 'tool_calls', 'model_name': 'mistral/mistral-tiny'}, id='run--8e727705-0ca2-436e-b9eb-2c868c990ff2-0', tool_calls=[{'name': 'square_root_tool', 'args': {'number': 6.12}, 'id': 'jPKN340xZ', 'type': 'tool_call'}], usage_metadata={'input_tokens': 145, 'output_tokens': 26, 'total_tokens': 171}), ToolMessage(content='La racine carrée de 6.12 est 2.4738633753705965.', name='square_root_tool', id='ca6025fa-88a4-4008-9adb-40ba91002e23', tool_call_id='jPKN340xZ'), AIMessage(content='La racine carrée de 6.12 est 2.4738633753705965.', additional_kwargs={}, response_metadata={'token_usage': Usage(completion_tokens=34, prompt_tokens=238, total_tokens=272, completion_tokens_details=None, prompt_tokens_details=None), 'model': 'mistral/mistral-tiny', 'finish_reason': 'stop', 'model_name': 'mistral/mistral-tiny'}, id='run--267a5b40-00d5-4542-80ca-2d4674345b2a-0', usage_metadata={'input_tokens': 238, 'output_tokens': 34, 'total_tokens': 272})]}



from smolagents import ToolCallingAgent, LiteLLMModel, tool


# smolagent deconsielle fortement de modifer le system prompt car cela pourrait affecter le comportement de l'agent
@tool
def square_root_smolagent(number: float) -> str:
    """Calcule la racine carrée d'un nombre.
    
    Args:
        number: Le nombre dont on veut calculer la racine carrée
    
    Returns:
        La racine carrée du nombre
    """
    try:
        result = calculate_square_root(number)
        return f"La racine carrée de {number} est {result}."
    except ValueError as e:
        return f"Erreur: {str(e)}"

model = LiteLLMModel(
    model_id="mistral/mistral-tiny",
    api_key=os.environ.get("MISTRAL_API_KEY", "test-key")
)

agent = ToolCallingAgent(
    tools=[square_root_smolagent],
    model=model    )
agent.run("Quelle est la racine carrée de 6.12?")


# ──────────────────────────────────────────────────── New run ────────────────────────────────────────────────────╮
# │                                                                                                                 │
# │ Quelle est la racine carrée de 6.12?                                                                            │
# │                                                                                                                 │
# ╰─ LiteLLMModel - mistral/mistral-tiny ───────────────────────────────────────────────────────────────────────────╯
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Step 1 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
# │ Calling tool: 'square_root_smolagent' with arguments: {'number': 6.12}                                          │
# ╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
# Observations: La racine carrée de 6.12 est 2.4738633753705965.
# [Step 1: Duration 0.87 seconds| Input tokens: 1,208 | Output tokens: 28]
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Step 2 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
# │ Calling tool: 'final_answer' with arguments: {'answer': '2.4738633753705965'}                                   │
# ╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
# Observations: 2.4738633753705965
# Final answer: 2.4738633753705965
# [Step 2: Duration 13.31 seconds| Input tokens: 2,509 | Output tokens: 67]
# '2.4738633753705965'




from smolagents import ToolCallingAgent, LiteLLMModel, tool


# smolagent deconsielle fortement de modifer le system prompt car cela pourrait affecter le comportement de l'agent
@tool
def square_root_smolagent(number: float) -> str:
    """Calcule la racine carrée d'un nombre.
    
    Args:
        number: Le nombre dont on veut calculer la racine carrée
    
    Returns:
        La racine carrée du nombre
    """
    try:
        result = calculate_square_root(number)
        return f"La racine carrée de {number} est {result}."
    except ValueError as e:
        return f"Erreur: {str(e)}"

model = LiteLLMModel(
    model_id="mistral/mistral-tiny",
    api_key=os.environ.get("MISTRAL_API_KEY", "test-key")
)

agent = ToolCallingAgent(
    tools=[],
    model=model    )
agent.run("Quelle est la racine carrée de 6.12?")


#                                                                                                              │
# │ Quelle est la racine carrée de 6.12?                                                                            │
# │                                                                                                                 │
# ╰─ LiteLLMModel - mistral/mistral-tiny ───────────────────────────────────────────────────────────────────────────╯
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Step 1 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
# │ Calling tool: 'final_answer' with arguments: {'answer': '7.81025'}                                              │
# ╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
# Observations: 7.81025
# Final answer: 7.81025
# [Step 1: Duration 0.69 seconds| Input tokens: 1,054 | Output tok






### Best practice to do """
Base classes for creating generic smolagent and pydantic tools.
"""
from typing import Any, Callable, Dict, Union, Literal, Optional
from loguru import logger
import smolagents
import json
from dsp_chatbotdha.utils.dtypes import ActionResult


class GenericSmolagentTool(smolagents.Tool):
    """Generic smolagent tool that can wrap any tool with an execute method."""
    
    def __init__(self, 
                 tool_instance: Any,
                 name: str,
                 description: str,
                 inputs: Dict[str, Dict[str, Any]],
                 execute_method_name: str = "execute",
                 **kwargs):
        """
        Initialize generic smolagent tool.
        
        Args:
            tool_instance: Instance of the tool class (e.g., SQLExecutor, RAG, etc.)
            name: Name of the smolagent tool
            description: Description of what the tool does
            inputs: Input schema for the tool
            execute_method_name: Name of the method to call on tool_instance (default: "execute")
        """
        super().__init__(**kwargs)
        self.tool_instance = tool_instance
        self.execute_method = getattr(tool_instance, execute_method_name)
        self.name = name
        self.description = description
        self.inputs = inputs
        self.output_type = "string"
    
    def _default_formatter(self, result: ActionResult) -> str:
        if result.grade > 0:
            return f"Result: {result.output_value}\nGrade: {result.grade}\nAction: {result.name_action}"
        else:
            return f"Unable to process request.\nReason: {result.output_value}\nGrade: {result.grade}"
    
    def forward(self, query: str) -> str:
        """Execute the tool and return formatted result."""
        result = self.execute_method(query)
        return self._default_formatter(result)
 


def create_smolagent_tool(tool_instance: Any,
                         name: str,
                         description: str,
                         inputs: Dict[str, Dict[str, Any]] = {"sql_query": {"type": "string", "description": "SQL query to execute"}},
                         execute_method_name: str = "execute"
                        ) -> GenericSmolagentTool:
    """
    Factory function to create a smolagent tool from any tool instance.
    
    Args:
        tool_instance: Instance of the tool class
        name: Name for the smolagent tool
        description: Description of the tool
        execute_method_name: Method name to call (default: "execute")
        result_formatter: Optional custom formatter function
    Returns:
        GenericSmolagentTool instance
    """
    return GenericSmolagentTool(
        tool_instance=tool_instance,
        name=name,
        description=description,
        inputs=inputs,
        execute_method_name=execute_method_name,
    )

def create_pydantic_tool(tool_instance: Any,
                          name: str,
                          description: str,
                          inputs: Dict[str, Dict[str, Any]],
                          execute_method_name: str = "execute"):
    """
    Factory function to create a pydantic tool using Tool.from_schema.
    
    Args:
        tool_instance: Instance of the tool class
        name: Name for the tool
        description: Description of the tool
        inputs: Input schema for the tool (same format as smolagent)
        execute_method_name: Method name to call (default: "execute")
    Returns:
        Tool created using Tool.from_schema
    """
    from pydantic_ai.tools import Tool
    
    # Convert inputs to JSON schema format
    properties = {}
    required = []
    
    for key, value in inputs.items():
        properties[key] = {
            'type': value.get('type', 'string'),
            'description': value.get('description', '')
        }
        if value.get('required', True):
            required.append(key)
    
    json_schema = {
        'additionalProperties': False,
        'properties': properties,
        'required': required,
        'type': 'object',
    }
    
    def tool_function(**kwargs):
        execute_method = getattr(tool_instance, execute_method_name)
        result = execute_method(**kwargs)
        return result
    
    return Tool.from_schema(
        function=tool_function,
        name=name,
        description=description,
        json_schema=json_schema
    )


def create_langchain_tool(tool_instance: Any,
                         name: str,
                         description: str,
                         inputs: Dict[str, Dict[str, Any]],
                         execute_method_name: str = "execute"):
    """
    Factory function to create a LangChain StructuredTool from any tool instance.
    
    Args:
        tool_instance: Instance of the tool class
        name: Name for the tool
        description: Description of the tool
        inputs: Input schema for the tool (same format as other tools)
        execute_method_name: Method name to call (default: "execute")
    Returns:
        LangChain StructuredTool instance
    """
    from langchain_core.tools import StructuredTool
    from pydantic import BaseModel, Field
    
    # Create simple Pydantic model for args_schema
    fields = {}
    annotations = {}
    
    for key, value in inputs.items():
        field_description = value.get('description', '')
        annotations[key] = str  # Keep it simple - all strings
        fields[key] = Field(description=field_description)
    
    # Create dynamic Pydantic model
    fields['__annotations__'] = annotations
    InputSchema = type(f"{name.title()}Input", (BaseModel,), fields)
    
    # Define the function that will be wrapped
    def execute_func(**kwargs) -> str:
        """Execute the tool function."""
        try:
            execute_method = getattr(tool_instance, execute_method_name)
            result = execute_method(**kwargs)
            
            # Handle ActionResult objects
            if hasattr(result, 'output_value'):
                if result.grade > 0:
                    return str(result.output_value)
                else:
                    return f"Error: {result.output_value}"
            
            return str(result)
        except Exception as e:
            return f"Error executing tool: {str(e)}"
    
    # Create StructuredTool using from_function (like your example)
    return StructuredTool.from_function(
        func=execute_func,
        name=name,
        description=description,
        args_schema=InputSchema,
        return_direct=True
    )
    


a method that on each router
    def as_tool(self, framework: Literal["pydantic", "smolagent", "langchain"], **kwargs):

        tool_inputs = {
            "query": {
                "type": "string", 
                "description": "User query describing the desired plot"
            },
            "data": {
                "type": "object", 
                "description": "Data in dict records format (list of dictionaries) or dict format (dict with lists of same length)"
            }
        }
        
        if framework == "pydantic":
            return create_pydantic_tool(
                tool_instance=self,
                name="plot_generator",
                description=DESCRIPTION_OF_TOOL,
                inputs=tool_inputs,
                execute_method_name="execute"
            )
        elif framework == "smolagent":
            return create_smolagent_tool(
                tool_instance=self,
                name="plot_generator",
                description=DESCRIPTION_OF_TOOL,
                inputs=tool_inputs,
                execute_method_name="execute",
            )
        elif framework == "langchain":
            return create_langchain_tool(
                tool_instance=self,
                name="plot_generator",
                description=DESCRIPTION_OF_TOOL,
                inputs=tool_inputs,
                execute_method_name="execute"
            )
        
        raise ValueError(f"Framework {framework} unsupported. Supported frameworks: pydantic, smolagent, langchain")




how to use 
 
    rag = RAG(5, system_prompt_rag, llm_client, embedding_client, lancedb_client)
    rag_tool = rag.as_tool("smolagent")





noow integrate our tools 

from this 
sql_generator = SQLGeneratorAction(self.llm)
sql_executor = SQLExecutor(mode="polars")
plotter = PlotAction(self.llm)



# smolagent
sql_generator_tool = sql_generator.as_tool("smolagents)
sql_executor_tool = sql_executor.as_tool("smolagents)
plotter_tool = plotter_tool.as_tool("smolent")


agent = ToolCallingAgent(
    tools=[sql_generator_tool,sql_executor_tool, plotter_tool ],
    model=model  )
agent.run("le pays de burkina depuis 2002")


#langraph langchain

# smolagent
sql_generator_tool = sql_generator.as_tool("langchain)
sql_executor_tool = sql_executor.as_tool("langchain)
plotter_tool = plotter_tool.as_tool("langchain")

model = ChatLiteLLM(
model="mistral/mistral-tiny",
api_key=os.environ.get("MISTRAL_API_KEY", "test-key")
)
agent = create_react_agent(model, tools=[sql_generator_tool,sql_executor_tool, plotter_tool ], prompt=system_message)
result2 = agent.invoke({
    "messages": [("human", "le pays de burkina depuis 2002?")]
})

#pydantic
