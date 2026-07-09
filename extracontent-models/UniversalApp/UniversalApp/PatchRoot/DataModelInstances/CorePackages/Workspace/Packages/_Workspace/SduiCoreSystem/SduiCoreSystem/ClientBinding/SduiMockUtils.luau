return {
	createLiteralKind = function(p1) -- line: 16
		return {
			type = "literal",
			value = p1
		}
	end,
	createBindingPathKind = function(s1: string) -- line: 26
		return {
			type = "binding_path",
			value = s1
		}
	end,
	createLiteralProp = function(p2, s2: string) -- line: 42
		return {
			kind = {
				type = "literal",
				value = p2
			},
			descriptor = {
				name = s2,
				fullName = s2
			}
		}
	end,
	createBindingPathProp = function(s3: string, s4: string) -- line: 70
		return {
			kind = {
				type = "binding_path",
				value = s3
			},
			descriptor = {
				name = s4,
				fullName = s4
			}
		}
	end,
	createTokenProp = function(p3, s5: string) -- line: 56
		return {
			kind = {
				type = "token",
				value = p3
			},
			descriptor = {
				name = s5,
				fullName = s5
			}
		}
	end,
	createMockInlineComponent = function(s6: string, t1: {[any]: any}?) -- line: 113
		return {
			kind = {
				value = {
					props = t1,
					shared = {
						component_type = s6
					}
				}
			}
		}
	end,
	createMockInputForNestedComponent = function(s7: string, p4) -- line: 133
		if s7 == "literal" then
			return {
				kind = {
					type = "literal",
					value = {
						kind = {
							value = p4
						}
					}
				}
			}
		end

		if s7 == "translation" then
			return {
				kind = {
					type = "translation",
					value = p4
				}
			}
		end

		return {
			kind = {
				type = "binding_path",
				value = p4
			}
		}
	end,
	createMockConditionalPropValue = function(t2: {[any]: any}, p5) -- line: 186
		return {
			kind = {
				type = "conditional",
				value = {
					options = t2
				}
			},
			descriptor = {
				fullName = p5,
				name = p5
			}
		}
	end,
	createMockConditionalOptions = function(t3: {[any]: any}) -- line: 318
		return {
			options = t3
		}
	end,
	createMockComparisonConditionOption = function(s8: string, s9: string, p6, t4: {[any]: any}) -- line: 205
		return {
			condition = {
				kind = {
					type = "comparison",
					value = {
						op = s8,
						field = s9,
						kind = {
							value = p6
						}
					}
				}
			},
			kind = t4
		}
	end,
	createMockIsNullConditionOption = function(s10: string, t5: {[any]: any}) -- line: 228
		return {
			condition = {
				kind = {
					type = "is_null",
					value = {
						field = s10
					}
				}
			},
			kind = t5
		}
	end,
	createMockIsNotNullConditionOption = function(s11: string, t6: {[any]: any}) -- line: 242
		return {
			condition = {
				kind = {
					type = "is_not_null",
					value = {
						field = s11
					}
				}
			},
			kind = t6
		}
	end,
	createMockIsEmptyConditionOption = function(s12: string, t7: {[any]: any}) -- line: 256
		return {
			condition = {
				kind = {
					type = "is_empty",
					value = {
						field = s12
					}
				}
			},
			kind = t7
		}
	end,
	createMockIsNotEmptyConditionOption = function(s13: string, t8: {[any]: any}) -- line: 270
		return {
			condition = {
				kind = {
					type = "is_not_empty",
					value = {
						field = s13
					}
				}
			},
			kind = t8
		}
	end,
	createMockAndConditionOption = function(t9: {[any]: any}, t10: {[any]: any}) -- line: 284
		return {
			condition = {
				kind = {
					type = "and_condition",
					value = {
						conditions = t9
					}
				}
			},
			kind = t10
		}
	end,
	createMockOrConditionOption = function(t11: {[any]: any}, t12: {[any]: any}) -- line: 298
		return {
			condition = {
				kind = {
					type = "or_condition",
					value = {
						conditions = t11
					}
				}
			},
			kind = t12
		}
	end,
	createMockNestedComponentConditionalOption = function(p7, p8, p9) -- line: 169
		return {
			condition = p7,
			kind = {
				type = "literal",
				value = {
					roblox_component = p8,
					inputs = p9
				}
			}
		}
	end
}
