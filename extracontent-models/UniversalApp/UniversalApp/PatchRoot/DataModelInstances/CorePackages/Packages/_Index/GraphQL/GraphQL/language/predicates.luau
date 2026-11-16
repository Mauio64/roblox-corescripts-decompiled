local kinds = require(script.Parent.kinds)
local kind = kinds.Kind

local isExecutableDefinitionNode

local isTypeSystemDefinitionNode
local isTypeDefinitionNode
local isTypeSystemExtensionNode
local isTypeExtensionNode

local function isDefinitionNode(p)
	return isExecutableDefinitionNode(p) or isTypeSystemDefinitionNode(p) or isTypeSystemExtensionNode(p)
end

isExecutableDefinitionNode = function(p): boolean
	return p.kind == kind.OPERATION_DEFINITION or p.kind == kind.FRAGMENT_DEFINITION
end

isTypeSystemDefinitionNode = function(p)
	return p.kind == kind.SCHEMA_DEFINITION or (isTypeDefinitionNode(p) or p.kind == kind.DIRECTIVE_DEFINITION)
end

isTypeDefinitionNode = function(p): boolean
	return p.kind == kind.SCALAR_TYPE_DEFINITION
		or p.kind == kind.OBJECT_TYPE_DEFINITION
		or p.kind == kind.INTERFACE_TYPE_DEFINITION
		or p.kind == kind.UNION_TYPE_DEFINITION
		or p.kind == kind.ENUM_TYPE_DEFINITION
		or p.kind == kind.INPUT_OBJECT_TYPE_DEFINITION
end

isTypeSystemExtensionNode = function(p)
	return p.kind == kind.SCHEMA_EXTENSION or isTypeExtensionNode(p)
end

isTypeExtensionNode = function(p): boolean
	return p.kind == kind.SCALAR_TYPE_EXTENSION
		or p.kind == kind.OBJECT_TYPE_EXTENSION
		or p.kind == kind.INTERFACE_TYPE_EXTENSION
		or p.kind == kind.UNION_TYPE_EXTENSION
		or p.kind == kind.ENUM_TYPE_EXTENSION
		or p.kind == kind.INPUT_OBJECT_TYPE_EXTENSION
end

local Predicates = {}
Predicates.isDefinitionNode = isDefinitionNode
Predicates.isExecutableDefinitionNode = isExecutableDefinitionNode

function Predicates.isSelectionNode(p): boolean
	return p.kind == kind.FIELD or p.kind == kind.FRAGMENT_SPREAD or p.kind == kind.INLINE_FRAGMENT
end

function Predicates.isValueNode(p): boolean
	return p.kind == kind.VARIABLE
		or p.kind == kind.INT
		or p.kind == kind.FLOAT
		or p.kind == kind.STRING
		or p.kind == kind.BOOLEAN
		or p.kind == kind.NULL
		or p.kind == kind.ENUM
		or p.kind == kind.LIST
		or p.kind == kind.OBJECT
end

function Predicates.isTypeNode(p): boolean
	return p.kind == kind.NAMED_TYPE or p.kind == kind.LIST_TYPE or p.kind == kind.NON_NULL_TYPE
end

Predicates.isTypeSystemDefinitionNode = isTypeSystemDefinitionNode
Predicates.isTypeDefinitionNode = isTypeDefinitionNode
Predicates.isTypeSystemExtensionNode = isTypeSystemExtensionNode
Predicates.isTypeExtensionNode = isTypeExtensionNode
return Predicates
