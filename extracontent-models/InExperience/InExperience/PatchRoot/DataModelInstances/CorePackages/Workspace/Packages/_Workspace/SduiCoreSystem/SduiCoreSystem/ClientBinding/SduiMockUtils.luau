local function createStructValue(item)
	local typeName = typeof(item)

	if item == nil then
		return {
			kind = { type = "null_value", value = 0 }
		}
	end

	if typeName == "string" then
		return {
			kind = { type = "string_value", value = item }
		}
	elseif typeName == "number" then
		return {
			kind = { type = "number_value", value = item }
		}
	elseif typeName == "boolean" then
		return {
			kind = { type = "bool_value", value = item }
		}
	end

	if typeName ~= "table" then
		error(`createStructValue cannot represent a {typeName}`)
	end

	if next(item) == nil or item[1] ~= nil then
		local values = {}

		for k, item2 in item do
			values[k] = createStructValue(item2)
		end

		return {
			kind = {
				type = "list_value",
				value = { values = values }
			}
		}
	else
		local fields = {}

		for k, item2 in item do
			fields[k] = createStructValue(item2)
		end

		return {
			kind = {
				type = "struct_value",
				value = { fields = fields }
			}
		}
	end
end

local SduiMockUtils = {}

function SduiMockUtils.createLiteralKind(p)
	return { type = "literal", value = p }
end

function SduiMockUtils.createBindingPathKind(p: string)
	return { type = "binding_path", value = p }
end

SduiMockUtils.createStructValue = createStructValue

function SduiMockUtils.createMockStruct(items)
	local fields = {}

	for k, item in items do
		fields[k] = createStructValue(item)
	end

	return { fields = fields }
end

function SduiMockUtils.createLiteralProp(p, p2: string)
	return {
		kind = { type = "literal", value = p },
		descriptor = { name = p2, fullName = p2 }
	}
end

function SduiMockUtils.createBindingPathProp(p: string, p2: string)
	return {
		kind = { type = "binding_path", value = p },
		descriptor = { name = p2, fullName = p2 }
	}
end

function SduiMockUtils.createTokenProp(p, p2: string)
	return {
		kind = { type = "token", value = p },
		descriptor = { name = p2, fullName = p2 }
	}
end

function SduiMockUtils.createMockInlineComponent(component_type: string, props)
	return {
		kind = {
			value = {
				props = props,
				shared = { component_type = component_type }
			}
		}
	}
end

function SduiMockUtils.createMockInputForNestedComponent(p: string, p2)
	if p == "literal" then
		return {
			kind = {
				type = "literal",
				value = {
					kind = { value = p2 }
				}
			}
		}
	elseif p == "translation" then
		return {
			kind = { type = "translation", value = p2 }
		}
	end

	return {
		kind = { type = "binding_path", value = p2 }
	}
end

function SduiMockUtils.createMockConditionalPropValue(options, p)
	return {
		kind = {
			type = "conditional",
			value = { options = options }
		},
		descriptor = { fullName = p, name = p }
	}
end

function SduiMockUtils.createMockConditionalOptions(options)
	return { options = options }
end

function SduiMockUtils.createMockComparisonConditionOption(op: string, field: string, p, kind)
	return {
		condition = {
			kind = {
				type = "comparison",
				value = {
					op = op,
					field = field,
					kind = { value = p }
				}
			}
		},
		kind = kind
	}
end

function SduiMockUtils.createMockIsNullConditionOption(field: string, kind)
	return {
		condition = {
			kind = {
				type = "is_null",
				value = { field = field }
			}
		},
		kind = kind
	}
end

function SduiMockUtils.createMockIsNotNullConditionOption(field: string, kind)
	return {
		condition = {
			kind = {
				type = "is_not_null",
				value = { field = field }
			}
		},
		kind = kind
	}
end

function SduiMockUtils.createMockIsEmptyConditionOption(field: string, kind)
	return {
		condition = {
			kind = {
				type = "is_empty",
				value = { field = field }
			}
		},
		kind = kind
	}
end

function SduiMockUtils.createMockIsNotEmptyConditionOption(field: string, kind)
	return {
		condition = {
			kind = {
				type = "is_not_empty",
				value = { field = field }
			}
		},
		kind = kind
	}
end

function SduiMockUtils.createMockContainsConditionOption(field: string, p: string, p2: string, kind)
	return {
		condition = {
			kind = {
				type = "contains",
				value = {
					field = field,
					kind = { type = p, value = p2 }
				}
			}
		},
		kind = kind
	}
end

function SduiMockUtils.createMockAndConditionOption(conditions, kind)
	return {
		condition = {
			kind = {
				type = "and_condition",
				value = { conditions = conditions }
			}
		},
		kind = kind
	}
end

function SduiMockUtils.createMockOrConditionOption(conditions, kind)
	return {
		condition = {
			kind = {
				type = "or_condition",
				value = { conditions = conditions }
			}
		},
		kind = kind
	}
end

function SduiMockUtils.createMockNestedComponentConditionalOption(condition, roblox_component, inputs)
	return {
		condition = condition,
		kind = {
			type = "literal",
			value = { roblox_component = roblox_component, inputs = inputs }
		}
	}
end

return SduiMockUtils
