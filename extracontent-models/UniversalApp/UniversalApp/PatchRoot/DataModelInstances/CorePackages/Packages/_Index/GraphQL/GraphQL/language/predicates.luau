local Kind = require(script.Parent.kinds).Kind
local isExecutableDefinitionNode = nil
local isTypeSystemDefinitionNode = nil
local isTypeDefinitionNode = nil
local isTypeSystemExtensionNode = nil
local isTypeExtensionNode = nil

function isExecutableDefinitionNode(p1) -- line: 26
	-- upvalues: Kind (copy)
	return p1.kind == Kind.OPERATION_DEFINITION or p1.kind == Kind.FRAGMENT_DEFINITION
end
function isTypeSystemDefinitionNode(p2) -- line: 54
	-- upvalues: Kind (copy), isTypeDefinitionNode (ref)
	return p2.kind == Kind.SCHEMA_DEFINITION or (isTypeDefinitionNode(p2) or p2.kind == Kind.DIRECTIVE_DEFINITION)
end
function isTypeDefinitionNode(p3) -- line: 60
	-- upvalues: Kind (copy)
	return p3.kind == Kind.SCALAR_TYPE_DEFINITION or (p3.kind == Kind.OBJECT_TYPE_DEFINITION or (p3.kind == Kind.INTERFACE_TYPE_DEFINITION or (p3.kind == Kind.UNION_TYPE_DEFINITION or (p3.kind == Kind.ENUM_TYPE_DEFINITION or p3.kind == Kind.INPUT_OBJECT_TYPE_DEFINITION))))
end
function isTypeSystemExtensionNode(p4) -- line: 69
	-- upvalues: Kind (copy), isTypeExtensionNode (ref)
	return p4.kind == Kind.SCHEMA_EXTENSION or isTypeExtensionNode(p4)
end
function isTypeExtensionNode(p5) -- line: 73
	-- upvalues: Kind (copy)
	return p5.kind == Kind.SCALAR_TYPE_EXTENSION or (p5.kind == Kind.OBJECT_TYPE_EXTENSION or (p5.kind == Kind.INTERFACE_TYPE_EXTENSION or (p5.kind == Kind.UNION_TYPE_EXTENSION or (p5.kind == Kind.ENUM_TYPE_EXTENSION or p5.kind == Kind.INPUT_OBJECT_TYPE_EXTENSION))))
end

return {
	isDefinitionNode = function(p6) -- line: 20
		-- upvalues: isExecutableDefinitionNode (ref), isTypeSystemDefinitionNode (ref), isTypeSystemExtensionNode (ref)
		return isExecutableDefinitionNode(p6) or (isTypeSystemDefinitionNode(p6) or isTypeSystemExtensionNode(p6))
	end,
	isExecutableDefinitionNode = isExecutableDefinitionNode,
	isSelectionNode = function(p7) -- line: 30
		-- upvalues: Kind (copy)
		return p7.kind == Kind.FIELD or (p7.kind == Kind.FRAGMENT_SPREAD or p7.kind == Kind.INLINE_FRAGMENT)
	end,
	isValueNode = function(p8) -- line: 36
		-- upvalues: Kind (copy)
		return p8.kind == Kind.VARIABLE or (p8.kind == Kind.INT or (p8.kind == Kind.FLOAT or (p8.kind == Kind.STRING or (p8.kind == Kind.BOOLEAN or (p8.kind == Kind.NULL or (p8.kind == Kind.ENUM or (p8.kind == Kind.LIST or p8.kind == Kind.OBJECT)))))))
	end,
	isTypeNode = function(p9) -- line: 48
		-- upvalues: Kind (copy)
		return p9.kind == Kind.NAMED_TYPE or (p9.kind == Kind.LIST_TYPE or p9.kind == Kind.NON_NULL_TYPE)
	end,
	isTypeSystemDefinitionNode = isTypeSystemDefinitionNode,
	isTypeDefinitionNode = isTypeDefinitionNode,
	isTypeSystemExtensionNode = isTypeSystemExtensionNode,
	isTypeExtensionNode = isTypeExtensionNode
}
