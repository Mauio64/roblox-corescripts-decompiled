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
		local v5 = {}

		for k, item2 in item do
			v5[k] = createStructValue(item2)
		end

		return {
			kind = {
				type = "list_value",
				value = { values = v5 }
			}
		}
	else
		local v5 = {}

		for k, item2 in item do
			v5[k] = createStructValue(item2)
		end

		return {
			kind = {
				type = "struct_value",
				value = { fields = v5 }
			}
		}
	end
end

return {
	createLiteralKind = function(p2)
		return { type = "literal", value = p2 }
	end,
	createBindingPathKind = function(p2)
		return { type = "binding_path", value = p2 }
	end,
	createStructValue = createStructValue,
	createMockStruct = function(items)
		local v5 = {}

		for k, item in items do
			v5[k] = createStructValue(item)
		end

		return { fields = v5 }
	end,
	createLiteralProp = function(p2, p3)
		return {
			kind = { type = "literal", value = p2 },
			descriptor = { name = p3, fullName = p3 }
		}
	end,
	createBindingPathProp = function(p2, p3)
		return {
			kind = { type = "binding_path", value = p2 },
			descriptor = { name = p3, fullName = p3 }
		}
	end,
	createTokenProp = function(p2, p3)
		return {
			kind = { type = "token", value = p2 },
			descriptor = { name = p3, fullName = p3 }
		}
	end,
	createMockInlineComponent = function(p2, p3)
		return {
			kind = {
				value = {
					props = p3,
					shared = { component_type = p2 }
				}
			}
		}
	end,
	createMockInputForNestedComponent = function(p2, p3)
		if p2 == "literal" then
			return {
				kind = {
					type = "literal",
					value = {
						kind = { value = p3 }
					}
				}
			}
		elseif p2 == "translation" then
			return {
				kind = { type = "translation", value = p3 }
			}
		end

		return {
			kind = { type = "binding_path", value = p3 }
		}
	end,
	createMockConditionalPropValue = function(p2, p3)
		return {
			kind = {
				type = "conditional",
				value = { options = p2 }
			},
			descriptor = { fullName = p3, name = p3 }
		}
	end,
	createMockConditionalOptions = function(p2)
		return { options = p2 }
	end,
	createMockComparisonConditionOption = function(p2, p3, p4, p5)
		return {
			condition = {
				kind = {
					type = "comparison",
					value = {
						op = p2,
						field = p3,
						kind = { value = p4 }
					}
				}
			},
			kind = p5
		}
	end,
	createMockIsNullConditionOption = function(p2, p3)
		return {
			condition = {
				kind = {
					type = "is_null",
					value = { field = p2 }
				}
			},
			kind = p3
		}
	end,
	createMockIsNotNullConditionOption = function(p2, p3)
		return {
			condition = {
				kind = {
					type = "is_not_null",
					value = { field = p2 }
				}
			},
			kind = p3
		}
	end,
	createMockIsEmptyConditionOption = function(p2, p3)
		return {
			condition = {
				kind = {
					type = "is_empty",
					value = { field = p2 }
				}
			},
			kind = p3
		}
	end,
	createMockIsNotEmptyConditionOption = function(p2, p3)
		return {
			condition = {
				kind = {
					type = "is_not_empty",
					value = { field = p2 }
				}
			},
			kind = p3
		}
	end,
	createMockContainsConditionOption = function(p2, p3, p4, p5)
		return {
			condition = {
				kind = {
					type = "contains",
					value = {
						field = p2,
						kind = { type = p3, value = p4 }
					}
				}
			},
			kind = p5
		}
	end,
	createMockAndConditionOption = function(p2, p3)
		return {
			condition = {
				kind = {
					type = "and_condition",
					value = { conditions = p2 }
				}
			},
			kind = p3
		}
	end,
	createMockOrConditionOption = function(p2, p3)
		return {
			condition = {
				kind = {
					type = "or_condition",
					value = { conditions = p2 }
				}
			},
			kind = p3
		}
	end,
	createMockNestedComponentConditionalOption = function(p2, p3, p4)
		return {
			condition = p2,
			kind = {
				type = "literal",
				value = { roblox_component = p3, inputs = p4 }
			}
		}
	end
}
