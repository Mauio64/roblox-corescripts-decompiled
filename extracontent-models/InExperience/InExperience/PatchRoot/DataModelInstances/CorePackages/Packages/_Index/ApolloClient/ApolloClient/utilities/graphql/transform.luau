local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Boolean = LuauPolyfill.Boolean
local String = LuauPolyfill.String
local t1 = {}
local GraphQL = require(ParentParentParent.GraphQL)
local visit = GraphQL.visit
local REMOVE = GraphQL.REMOVE
local invariant = require(ParentParent.jsutils.invariant).invariant
local getFromAST = require(script.Parent.getFromAST)
local checkDocument = getFromAST.checkDocument
local getOperationDefinition = getFromAST.getOperationDefinition
local getFragmentDefinition = getFromAST.getFragmentDefinition
local getFragmentDefinitions = getFromAST.getFragmentDefinitions
local getMainDefinition = getFromAST.getMainDefinition
local filterInPlace = require(script.Parent.Parent.common.filterInPlace).filterInPlace
local storeUtils = require(script.Parent.storeUtils)
local isField = storeUtils.isField
local isInlineFragment = storeUtils.isInlineFragment

local function createFragmentMap(p1) -- line: 58
	-- upvalues: Array (copy)
	local t2 = {}

	Array.forEach(p1, function(p2) -- line: 60
		-- upvalues: t2 (copy)
		t2[p2.name.value] = p2
	end)

	return t2
end

local hasDirectivesInSelection = nil
local removeArgumentsFromDocument = nil
local removeFragmentSpreadFromDocument = nil
local getAllFragmentSpreadsFromSelectionSet = nil
local t3 = {
	kind = "Field",
	name = {
		kind = "Name",
		value = "__typename"
	}
}

local function isEmpty(p3, t4: {[any]: any}) -- line: 90
	-- upvalues: Array (copy), isEmpty (copy)
	return Array.every(p3.selectionSet.selections, function(p4) -- line: 91
		-- upvalues: isEmpty (copy), t4 (copy)
		return p4.kind == "FragmentSpread" and isEmpty(t4[p4.name.value], t4)
	end, nil)
end
local function nullIfDocIsEmpty(p5) -- line: 97
	-- upvalues: getOperationDefinition (copy), getFragmentDefinition (copy), getFragmentDefinitions (copy), Array (copy), isEmpty (copy)
	local v41 = getOperationDefinition(p5) or getFragmentDefinition(p5)
	local v42 = getFragmentDefinitions(p5)
	local t5 = {}

	Array.forEach(v42, function(p6) -- line: 60
		-- upvalues: t5 (copy)
		t5[p6.name.value] = p6
	end)

	local v44 = t5

	if Array.every(v41.selectionSet.selections, function(p7) -- line: 91
		-- upvalues: isEmpty (copy), v44 (copy)
		return p7.kind == "FragmentSpread" and isEmpty(v44[p7.name.value], v44)
	end, nil) then
		return nil
	end

	return p5
end
local function getDirectiveMatcher(p8) -- line: 110
	-- upvalues: Array (copy), Boolean (copy)
	return function(p9) -- line: 111
		-- upvalues: Array (copy), p8 (copy), Boolean (copy)
		return Array.some(p8, function(p10) -- line: 112
			-- upvalues: Boolean (copy), p9 (copy)
			return Boolean.toJSBoolean(p10.name) and p10.name == p9.name.value or Boolean.toJSBoolean(p10.test) and p10:test(p9)
		end)
	end
end
local function removeDirectivesFromDocument(p11, p12) -- line: 119
	-- upvalues: visit (copy), Boolean (copy), Array (copy), getAllFragmentSpreadsFromSelectionSet (ref), REMOVE (copy), getOperationDefinition (copy), getFragmentDefinition (copy), getFragmentDefinitions (copy), isEmpty (copy), filterInPlace (copy), removeArgumentsFromDocument (ref), removeFragmentSpreadFromDocument (ref)
	local t6 = {}
	local t7 = {}
	local t8 = {}
	local t9 = {}
	local v52 = visit(p12, {
		Variable = {
			enter = function(_, p14, _, p16) -- line: 131
				-- upvalues: t6 (copy)
				if p16.kind ~= "VariableDefinition" then
					t6[p14.name.value] = true
				end

				return nil
			end
		},
		Field = {
			enter = function(_, p18) -- line: 144
				-- upvalues: Boolean (copy), p11 (copy), Array (copy), t7 (copy), getAllFragmentSpreadsFromSelectionSet (ref), t9 (copy), REMOVE (copy)
				if Boolean.toJSBoolean(p11) and (Boolean.toJSBoolean(p18.directives) and Array.some(p11, function(p19) -- line: 148
					return p19.remove
				end) and p18.directives) then
					local some = Array.some
					local directives = p18.directives
					local v112 = p11

					if some(directives, function(p20) -- line: 111
						-- upvalues: Array (copy), v112 (copy), Boolean (copy)
						return Array.some(v112, function(p21) -- line: 112
							-- upvalues: Boolean (copy), p20 (copy)
							return Boolean.toJSBoolean(p21.name) and p21.name == p20.name.value or Boolean.toJSBoolean(p21.test) and p21:test(p20)
						end)
					end) then
						if p18.arguments then
							Array.forEach(p18.arguments, function(p22) -- line: 160
								-- upvalues: t7 (copy)
								if p22.value.kind == "Variable" then
									table.insert(t7, {
										name = p22.value.name.value
									})
								end
							end)
						end

						if p18.selectionSet then
							Array.forEach(getAllFragmentSpreadsFromSelectionSet(p18.selectionSet), function(p23) -- line: 175
								-- upvalues: t9 (copy)
								table.insert(t9, {
									name = p23.name.value
								})
							end)
						end

						return REMOVE
					end
				end

				return nil
			end
		},
		FragmentSpread = {
			enter = function(_, p25) -- line: 190
				-- upvalues: t8 (copy)
				t8[p25.name.value] = true
			end
		},
		Directive = {
			enter = function(_, p27) -- line: 197
				-- upvalues: Boolean (copy), p11 (copy), Array (copy), REMOVE (copy)
				local toJSBoolean = Boolean.toJSBoolean
				local v118 = p11

				if toJSBoolean((function(p28) -- line: 111
					-- upvalues: Array (copy), v118 (copy), Boolean (copy)
					return Array.some(v118, function(p29) -- line: 112
						-- upvalues: Boolean (copy), p28 (copy)
						return Boolean.toJSBoolean(p29.name) and p29.name == p28.name.value or Boolean.toJSBoolean(p29.test) and p29:test(p28)
					end)
				end)(p27)) then
					return REMOVE
				end

				return nil
			end
		}
	})
	local v53 = getOperationDefinition(v52) or getFragmentDefinition(v52)
	local v54 = getFragmentDefinitions(v52)
	local t10 = {}

	Array.forEach(v54, function(p30) -- line: 60
		-- upvalues: t10 (copy)
		t10[p30.name.value] = p30
	end)

	local v56 = t10
	local v57 = if not Array.every(v53.selectionSet.selections, function(p31) -- line: 91
		-- upvalues: isEmpty (copy), v56 (copy)
		return p31.kind == "FragmentSpread" and isEmpty(v56[p31.name.value], v56)
	end, nil) then v52 else nil

	if Boolean.toJSBoolean(v57) and Boolean.toJSBoolean(#filterInPlace(t7, function(p32) -- line: 213
		-- upvalues: Boolean (copy), t6 (copy)
		return not not Boolean.toJSBoolean(p32.name) and not t6[p32.name]
	end)) then
		v57 = removeArgumentsFromDocument(t7, v57)
	end

	if Boolean.toJSBoolean(v57) and Boolean.toJSBoolean(#filterInPlace(t9, function(p33) -- line: 225
		-- upvalues: Boolean (copy), t8 (copy)
		return not not Boolean.toJSBoolean(p33.name) and not t8[p33.name]
	end)) then
		v57 = removeFragmentSpreadFromDocument(t9, v57)
	end

	return v57
end

t1.removeDirectivesFromDocument = removeDirectivesFromDocument
t1.addTypenameToDocument = Object.assign(setmetatable({}, {
	__call = function(_, p35) -- line: 238
		-- upvalues: visit (copy), checkDocument (copy), Boolean (copy), Array (copy), isField (copy), String (copy), Object (copy), t3 (copy)
		return visit(checkDocument(p35), {
			SelectionSet = {
				enter = function(_, p37, _, p39) -- line: 241
					-- upvalues: Boolean (copy), Array (copy), isField (copy), String (copy), Object (copy), t3 (copy)
					if Boolean.toJSBoolean(p39) and p39.kind == "OperationDefinition" then
						return
					end

					local selections = p37.selections

					if not Boolean.toJSBoolean(selections) then
						return
					end

					if Array.some(selections, function(p40) -- line: 258
						-- upvalues: isField (copy), String (copy)
						return isField(p40) and (p40.name.value == "__typename" or String.lastIndexOf(p40.name.value, "__", 1) == 1)
					end) then
						return
					end

					if isField(p39) and Boolean.toJSBoolean(p39.directives) and Boolean.toJSBoolean(Array.some(p39.directives, function(p41) -- line: 275
						return p41.name.value == "export"
					end)) then
						return
					end

					return Object.assign({}, p37, {
						selections = Array.concat({}, selections, { t3 })
					})
				end
			}
		})
	end
}), {
	added = function(_, p43) -- line: 294
		-- upvalues: t3 (copy)
		return p43 == t3
	end
})

local t11 = {
	test = function(_, p45) -- line: 302
		-- upvalues: Boolean (copy), Array (copy), invariant (copy)
		local v64 = p45.name.value == "connection"

		if v64 and (not Boolean.toJSBoolean(p45.arguments) or Array.some(p45.arguments, function(p46) -- line: 307
			return p46.name.value == "key"
		end)) then
			invariant.warn("Removing an @connection directive even though it does not have a key. You may want to use the key parameter to specify a store key.")
		end

		return v64
	end
}

function t1.removeConnectionDirectiveFromDocument(p47) -- line: 322
	-- upvalues: removeDirectivesFromDocument (copy), t11 (copy), checkDocument (copy)
	return (removeDirectivesFromDocument({ t11 }, checkDocument(p47)))
end

local function hasDirectivesInSelectionSet(p48, p49, b1: boolean?) -- line: 327
	-- upvalues: Array (copy), hasDirectivesInSelection (ref)
	if b1 == nil then
		b1 = true
	end

	return not not p49 and (not not p49.selections and (Array.some(p49.selections, function(p50) -- line: 338
		-- upvalues: hasDirectivesInSelection (ref), p48 (copy), b1 (ref)
		return hasDirectivesInSelection(p48, p50, b1)
	end) or false))
end

function hasDirectivesInSelection(p51, p52, b2: boolean?) -- line: 346
	-- upvalues: isField (copy), Array (copy), Boolean (copy), hasDirectivesInSelection (ref)
	local g74 = nil

	if b2 == nil then
		b2 = true
	end

	if not isField(p52) then
		return true
	end

	if not p52.directives then
		return false
	end

	local v73 = Array.some(p52.directives, function(p53) -- line: 111
		-- upvalues: Array (copy), p51 (copy), Boolean (copy)
		return Array.some(p51, function(p54) -- line: 112
			-- upvalues: Boolean (copy), p53 (copy)
			return Boolean.toJSBoolean(p54.name) and p54.name == p53.name.value or Boolean.toJSBoolean(p54.test) and p54:test(p53)
		end)
	end)

	if not v73 then
		repeat
			if g74 or not b2 then
				g74 = false
				v73 = false

				return v73
			end

			local selectionSet = p52.selectionSet
			local u76 = b2

			if u76 == nil then
				u76 = true
			end

			v73 = not not selectionSet and (not not selectionSet.selections and (Array.some(selectionSet.selections, function(p55) -- line: 338
				-- upvalues: hasDirectivesInSelection (ref), p51 (copy), u76 (ref)
				return hasDirectivesInSelection(p51, p55, u76)
			end) or false))

			if not v73 then
				g74 = true
			end
		until not g74
	end

	return v73
end

local function getArgumentMatcher(p56) -- line: 375
	-- upvalues: Array (copy)
	return function(p57) -- line: 376
		-- upvalues: Array (copy), p56 (copy)
		return Array.some(p56, function(p58) -- line: 377
			-- upvalues: p57 (copy)
			return not not p57.value and (p57.value.kind == "Variable" and (not not p57.value.name and (p58.name == p57.value.name.value or not not p58.test and (p58:test(p57) or false))))
		end)
	end
end

function removeArgumentsFromDocument(p59, p60) -- line: 398
	-- upvalues: Array (copy), visit (copy), Object (copy), REMOVE (copy), Boolean (copy), getOperationDefinition (copy), getFragmentDefinition (copy), getFragmentDefinitions (copy), isEmpty (copy)
	local function v80(p61) -- line: 376
		-- upvalues: Array (copy), p59 (copy)
		return Array.some(p59, function(p62) -- line: 377
			-- upvalues: p61 (copy)
			return not not p61.value and (p61.value.kind == "Variable" and (not not p61.value.name and (p62.name == p61.value.name.value or not not p62.test and (p62:test(p61) or false))))
		end)
	end

	local v81 = visit(p60, {
		OperationDefinition = {
			enter = function(_, p64) -- line: 403
				-- upvalues: Object (copy), Array (copy), p59 (copy)
				return Object.assign({}, p64, {
					variableDefinitions = p64.variableDefinitions and Array.filter(p64.variableDefinitions, function(p65) -- line: 407
						-- upvalues: Array (copy), p59 (copy)
						return not Array.some(p59, function(p66) -- line: 408
							-- upvalues: p65 (copy)
							return p66.name == p65.variable.name.value
						end)
					end) or {}
				})
			end
		},
		Field = {
			enter = function(_, p68) -- line: 418
				-- upvalues: Array (copy), p59 (copy), v80 (copy), REMOVE (copy)
				if Array.some(p59, function(p69) -- line: 421
					return p69.remove
				end) then
					local n1 = 0

					if p68.arguments then
						Array.forEach(p68.arguments, function(p70) -- line: 428
							-- upvalues: v80 (copy), n1 (ref)
							if v80(p70) then
								n1 += 1
							end
						end)
					end

					if n1 == 1 then
						return REMOVE
					end
				end

				return nil
			end
		},
		Argument = {
			enter = function(_, p72) -- line: 444
				-- upvalues: Boolean (copy), v80 (copy), REMOVE (copy)
				if Boolean.toJSBoolean(v80(p72)) then
					return REMOVE
				end

				return nil
			end
		}
	})
	local v82 = getOperationDefinition(v81) or getFragmentDefinition(v81)
	local v83 = getFragmentDefinitions(v81)
	local t12 = {}

	Array.forEach(v83, function(p73) -- line: 60
		-- upvalues: t12 (copy)
		t12[p73.name.value] = p73
	end)

	local v85 = t12

	if Array.every(v82.selectionSet.selections, function(p74) -- line: 91
		-- upvalues: isEmpty (copy), v85 (copy)
		return p74.kind == "FragmentSpread" and isEmpty(v85[p74.name.value], v85)
	end, nil) then
		return nil
	end

	return v81
end

t1.removeArgumentsFromDocument = removeArgumentsFromDocument

function removeFragmentSpreadFromDocument(p75, p76) -- line: 456
	-- upvalues: Array (copy), REMOVE (copy), visit (copy), getOperationDefinition (copy), getFragmentDefinition (copy), getFragmentDefinitions (copy), isEmpty (copy)
	local function enter(_, p78) -- line: 460
		-- upvalues: Array (copy), p75 (copy), REMOVE (copy)
		if Array.some(p75, function(p79) -- line: 461
			-- upvalues: p78 (copy)
			return p79.name == p78.name.value
		end) then
			return REMOVE
		end

		return nil
	end

	local v89 = visit(p76, {
		FragmentSpread = {
			enter = enter
		},
		FragmentDefinition = {
			enter = enter
		}
	})
	local v90 = getOperationDefinition(v89) or getFragmentDefinition(v89)
	local v91 = getFragmentDefinitions(v89)
	local t13 = {}

	Array.forEach(v91, function(p80) -- line: 60
		-- upvalues: t13 (copy)
		t13[p80.name.value] = p80
	end)

	local v93 = t13

	if Array.every(v90.selectionSet.selections, function(p81) -- line: 91
		-- upvalues: isEmpty (copy), v93 (copy)
		return p81.kind == "FragmentSpread" and isEmpty(v93[p81.name.value], v93)
	end, nil) then
		return nil
	end

	return v89
end

t1.removeFragmentSpreadFromDocument = removeFragmentSpreadFromDocument

function getAllFragmentSpreadsFromSelectionSet(p82) -- line: 473
	-- upvalues: Array (copy), isField (copy), isInlineFragment (copy), getAllFragmentSpreadsFromSelectionSet (ref)
	local t14 = {}

	Array.forEach(p82.selections, function(p83) -- line: 475
		-- upvalues: isField (copy), isInlineFragment (copy), Array (copy), getAllFragmentSpreadsFromSelectionSet (ref), t14 (copy)
		if (isField(p83) or isInlineFragment(p83)) and p83.selectionSet then
			Array.forEach(getAllFragmentSpreadsFromSelectionSet(p83.selectionSet), function(p84) -- line: 486
				-- upvalues: t14 (copy)
				table.insert(t14, p84)
			end)

			return
		end

		if p83.kind == "FragmentSpread" then
			table.insert(t14, p83)
		end
	end)

	return t14
end
function t1.buildQueryFromSelectionSet(p85) -- line: 501
	-- upvalues: getMainDefinition (copy), visit (copy), Object (copy)
	if getMainDefinition(p85).operation == "query" then
		return p85
	end

	return (visit(p85, {
		OperationDefinition = {
			enter = function(_, p87) -- line: 513
				-- upvalues: Object (copy)
				return Object.assign({}, p87, {
					operation = "query"
				})
			end
		}
	}))
end
function t1.removeClientSetsFromDocument(p88) -- line: 523
	-- upvalues: checkDocument (copy), removeDirectivesFromDocument (copy), Boolean (copy), visit (copy), Array (copy), isField (copy), REMOVE (copy)
	checkDocument(p88)

	local v98 = removeDirectivesFromDocument({{
		remove = true,
		test = function(_, p90) -- line: 528
			return p90.name.value == "client"
		end
	}}, p88)

	if Boolean.toJSBoolean(v98) then
		v98 = visit(v98, {
			FragmentDefinition = {
				enter = function(_, p92) -- line: 542
					-- upvalues: Array (copy), isField (copy), Boolean (copy), REMOVE (copy)
					if p92.selectionSet then
						local v154 = Array.every(p92.selectionSet.selections, function(p93) -- line: 544
							-- upvalues: isField (copy)
							return isField(p93) and p93.name.value == "__typename"
						end)

						if Boolean.toJSBoolean(v154) then
							return REMOVE
						end
					end

					return nil
				end
			}
		})
	end

	return v98
end

return t1
