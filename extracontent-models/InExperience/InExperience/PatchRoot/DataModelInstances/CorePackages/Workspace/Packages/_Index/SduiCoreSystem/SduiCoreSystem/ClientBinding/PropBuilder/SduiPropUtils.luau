local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local DataHydration = require(SduiCoreSystemParent.DataHydration)

require(SduiCoreSystemParent.ServiceContractsProto)

local Signals = require(SduiCoreSystemParent.Signals)
local Cryo = require(SduiCoreSystemParent.Cryo)
local tutils = require(SduiCoreSystemParent.tutils)
local SduiDataBinder = require(SduiCoreSystem.ClientBinding.SduiDataBinder)
local tryGetPathFromData = require(SduiCoreSystem.ClientBinding.tryGetPathFromData)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)
local buildDataBindingSourcesForTemplate = require(SduiCoreSystem.ClientBinding.buildDataBindingSourcesForTemplate)
local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local SduiDataBindingContentType = require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)

require(SduiCoreSystem.SduiBuilderTypes)

local getSduiTokensStore = require(SduiCoreSystem.ClientBinding.getSduiTokensStore)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
local SduiParsers = require(SduiCoreSystem.SduiParsers)

require(SduiCoreSystem.SduiComponentType)

local PropResultCategory = SduiClientBindingTypes.PropResultCategory
local applyFormatArgFormatter = require(SduiCoreSystem.ClientBinding.PropBuilder.applyFormatArgFormatter).applyFormatArgFormatter
local DataStatus = DataHydration.DataHydrationTypes.DataStatus
local FFlagSduiImprovedErrorDimensions = require(SduiCoreSystemParent.SharedFlags).FFlagSduiImprovedErrorDimensions
local FFlagSduiFormatArgFormatters = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFormatArgFormatters
local FFlagSduiInlineNestedComponentSchema = require(SduiCoreSystemParent.SharedFlags).FFlagSduiInlineNestedComponentSchema
local FFlagSduiIsEmptyConditions = require(SduiCoreSystemParent.SharedFlags).FFlagSduiIsEmptyConditions
local FFlagSduiHydrationFetchIfMissing = require(SduiCoreSystemParent.SharedFlags).FFlagSduiHydrationFetchIfMissing
local FFlagSduiClientPageScope = require(SduiCoreSystemParent.SharedFlags).FFlagSduiClientPageScope
local FFlagLuaAppSduiColorPropMigration = require(SduiCoreSystemParent.SharedFlags).FFlagLuaAppSduiColorPropMigration
local FFlagSduiFocusNavActionsStructured = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFocusNavActionsStructured
local FFlagSduiRenderPerf = require(SduiCoreSystemParent.SharedFlags).FFlagSduiRenderPerf
local v30 = game:DefineFastFlag("SduiPropBuilderSupportNilHydration", false)
local v31 = table.freeze({
	status = DataStatus.Failed
})
local v32 = table.freeze({})

local function resolveHydrationBinding(t1: {[any]: any}, p1, p2, b1: boolean?) -- line: 88
	-- upvalues: v30 (copy), SduiDataBindingContentType (copy), FFlagSduiHydrationFetchIfMissing (copy), SduiDataBinder (copy)
	local v49 = table.concat(t1, ".")
	local v50 = t1[1]
	local v51 = p1 and p1[v50]

	if v51 == nil then
		if v30 then
			if SduiDataBindingContentType[v50] ~= nil then
				error(`Could not find data bindingSource for key { v50 }, bindingPath: { v49 }`)
			end

			return nil, nil
		end

		error(`Could not find data bindingSource for key { v50 }, bindingPath: { v49 }`)
	end

	local contentType = v51.contentType
	local id = v51.id

	if #t1 < 2 then
		error(`Unsupported path for contentType { contentType }, bindingPath: { v49 }`)
	end

	local v54 = if not FFlagSduiHydrationFetchIfMissing then b1 else v51.fetchIfMissing or b1
	local v55, v56 = SduiDataBinder.getFieldValue(contentType, t1, id, p2, v54)

	return v55, v56
end
local function resolveBindingPathValue(p3, t2: {[any]: any}, p4, p5, p6: ((...any) -> ...any)?, b2: boolean?, p7) -- line: 144
	-- upvalues: tryGetPathFromData (copy), SduiDataBinder (copy), FFlagSduiClientPageScope (copy), resolveHydrationBinding (copy), FFlagSduiRenderPerf (copy), SduiParseHelpers (copy)
	local v64, v65 = tryGetPathFromData(p5(p3), t2)

	if v64 and v65 ~= nil then
		if p6 then
			return p6(v65, p3)
		end

		return v65
	end

	local v66 = t2 and t2[1]

	if SduiDataBinder.isClientContentType(v66) then
		local v67 = SduiDataBinder.getFieldValueForClientContentType(v66, t2, p3, if not FFlagSduiClientPageScope then nil else p7)

		if p6 and v67 ~= nil then
			return p6(v67, p3)
		end

		return v67
	end

	local v68 = p4(p3)
	local u69, v70 = resolveHydrationBinding(t2, v68, p3, b2)

	if p6 and u69 ~= nil then
		if FFlagSduiRenderPerf then
			u69 = p6(u69, p3)
		else
			local ok, result = pcall(function() -- line: 190
				-- upvalues: p6 (copy), u69 (ref), p3 (copy)
				return p6(u69, p3)
			end)

			if not ok then
				local v73 = SduiParseHelpers.stringifyValue(result)
				local v74 = table.concat(t2, ".")

				error(`Parser failed for bindingPath: { v74 }. err{ v73 }`)
			end

			u69 = result
		end
	end

	return u69, v70
end
local function generateDynamicBindingPropValue(s1: string, p8, p9, p10, p11: ((...any) -> ...any)?, b3: boolean?) -- line: 236
	-- upvalues: FFlagSduiImprovedErrorDimensions (copy), FFlagSduiRenderPerf (copy), splitDottedPath (copy), Signals (copy), resolveBindingPathValue (copy), FFlagSduiClientPageScope (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), v31 (copy), tutils (copy)
	local currentComponentType = nil
	local currentParserName = nil

	if FFlagSduiImprovedErrorDimensions then
		currentComponentType = p9.currentComponentType
		currentParserName = p9.currentParserName
	end

	local v85 = if not FFlagSduiRenderPerf then string.split(s1, ".") else splitDottedPath(s1)

	if not v85 or #v85 == 0 then
		error(`Invalid bindingPath: { s1 }`)
	end

	return Signals.createComputed(function(p12) -- line: 258
		-- upvalues: resolveBindingPathValue (copy), v85 (copy), p8 (copy), p10 (copy), p11 (copy), b3 (copy), FFlagSduiClientPageScope (copy), p9 (copy), SduiLogger (copy), SduiErrors (copy), s1 (copy), SduiParseHelpers (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), v31 (copy)
		local ok, result, v244 = pcall(function() -- line: 259
			-- upvalues: resolveBindingPathValue (copy), p12 (copy), v85 (copy), p8 (copy), p10 (copy), p11 (copy), b3 (copy), FFlagSduiClientPageScope (copy), p9 (copy)
			local v277, v278 = resolveBindingPathValue(p12, v85, p8, p10, p11, b3, if not FFlagSduiClientPageScope then nil else p9)

			return v277, v278
		end)

		if ok then
			return {
				data = result,
				status = v244
			}
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToComputeDynamicBinding, {
			value = s1,
			message = SduiParseHelpers.stringifyValue(result),
			name = p9.debugName,
			componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
			parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
		}, p9.appPage)

		return v31
	end, tutils.shallowEqual)
end
local function validateNumbers(p13, p14, p15) -- line: 483
	if typeof(p14) ~= "number" then
		p14 = tonumber(p14)
	end

	if typeof(p15) ~= "number" then
		p15 = tonumber(p15)
	end

	if typeof(p14) ~= "number" or typeof(p15) ~= "number" then
		error(`{ p13 } without numbers, { p14 }: { typeof(p14) }, { p15 }: { typeof(p15) }`)
	end

	return p14, p15
end
local function isEmpty(p16) -- line: 502
	if p16 == nil then
		return true
	end

	if type(p16) == "string" then
		return p16 == ""
	end

	if type(p16) == "table" then
		return next(p16) == nil
	end

	return false
end
local function isSame(p17, p18) -- line: 527
	-- upvalues: SduiParsers (copy)
	if p17 == p18 then
		return true
	end

	if p17 == nil then
		return false
	end

	local v113 = typeof(p18)

	if v113 ~= typeof(p17) then
		if v113 == "string" then
			p17 = tostring(p17)
		elseif v113 == "number" then
			p17 = tonumber(p17)
		elseif v113 == "boolean" then
			p17 = SduiParsers.parseBooleanProp_(p17, nil, nil)
		end
	end

	return p17 == p18
end
local function evaluateCondition(p19, t3: {[any]: any}, p20, p21, p22) -- line: 571
	-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy), resolveBindingPathValue (copy), FFlagSduiClientPageScope (copy), DataStatus (copy), validateNumbers (copy), isSame (copy), FFlagSduiIsEmptyConditions (copy), evaluateCondition (copy)
	if t3 == nil then
		return true
	end

	local v119 = t3 and (t3.kind and t3.kind.type)
	local v120 = t3 and (t3.kind and t3.kind.value)

	if v119 == nil then
		error("nil conditionType in condition")
	end

	if v120 == nil then
		error("nil conditionValue in condition")
	end

	local function getFieldObject(s2: string) -- line: 591
		-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy), resolveBindingPathValue (copy), p19 (copy), p20 (copy), p22 (copy), FFlagSduiClientPageScope (copy), p21 (copy)
		local v262 = if not FFlagSduiRenderPerf then string.split(s2, ".") else splitDottedPath(s2)
		local ok, result, v265 = pcall(function() -- line: 597
			-- upvalues: resolveBindingPathValue (copy), p19 (copy), v262 (copy), p20 (copy), p22 (copy), FFlagSduiClientPageScope (copy), p21 (copy)
			return resolveBindingPathValue(p19, v262, p20, p22, nil, true, if not FFlagSduiClientPageScope then nil else p21)
		end)

		if ok then
			return result, v265
		end

		return nil, v265
	end

	if v119 == "comparison" then
		local v122, v123 = getFieldObject(v120.field)

		if v122 == nil or v123 and v123 ~= DataStatus.Ready then
			return nil, v123
		end

		local value = v120.kind.value
		local op = v120.op

		if op == "OP_LT" then
			local v126, v127 = validateNumbers(op, v122, value)

			return v126 < v127
		end

		if op == "OP_LTE" then
			local v128, v129 = validateNumbers(op, v122, value)

			return v128 <= v129
		end

		if op == "OP_GT" then
			local v130, v131 = validateNumbers(op, v122, value)

			return v131 < v130
		end

		if op == "OP_GTE" then
			local v132, v133 = validateNumbers(op, v122, value)

			return v133 <= v132
		end

		if op == "OP_E" then
			return (isSame(v122, value))
		end

		if op == "OP_NE" then
			return not isSame(v122, value)
		end

		error(`Unknown operator for comparison { op }`)
	else
		if v119 == "is_null" then
			local v134, v135 = getFieldObject(v120.field)

			if v135 and v135 ~= DataStatus.Ready then
				return nil, v135
			end

			return v134 == nil
		end

		if v119 == "is_not_null" then
			local v136, v137 = getFieldObject(v120.field)

			if v137 and v137 ~= DataStatus.Ready then
				return nil, v137
			end

			return v136 ~= nil
		end

		if FFlagSduiIsEmptyConditions and v119 == "is_empty" then
			local v138, v139 = getFieldObject(v120.field)

			if v139 and v139 ~= DataStatus.Ready then
				return nil, v139
			end

			if v138 == nil then
				return true
			end

			if type(v138) == "string" then
				return v138 == ""
			end

			if type(v138) == "table" then
				return next(v138) == nil
			end

			return false
		end

		if FFlagSduiIsEmptyConditions and v119 == "is_not_empty" then
			local v140, v141 = getFieldObject(v120.field)

			if v141 and v141 ~= DataStatus.Ready then
				return nil, v141
			end

			return not (v140 == nil or if type(v140) ~= "string" then type(v140) == "table" and next(v140) == nil else v140 == "")
		end

		if v119 == "and_condition" then
			for _, v143 in v120.conditions do
				local v144, v145 = evaluateCondition(p19, v143, p20, p21, p22)

				if v145 and v145 ~= DataStatus.Ready then
					return v144, v145
				end

				if not v144 then
					return v144
				end
			end

			return true
		end

		if v119 == "or_condition" then
			for _, v147 in v120.conditions do
				local v148, v149 = evaluateCondition(p19, v147, p20, p21, p22)

				if v149 and v149 ~= DataStatus.Ready then
					return v148, v149
				end

				if v148 or v148 == nil then
					return v148, v149
				end
			end

			return false
		end
	end

	return nil
end
local function selectConditionalOption(p23, t4: {[any]: any}, p24, p25, p26) -- line: 718
	-- upvalues: evaluateCondition (copy), DataStatus (copy)
	for _, v156 in t4 do
		local v157, v158 = evaluateCondition(p23, v156.condition, p24, p25, p26)

		if v157 then
			return v156, v158
		end

		if v158 and v158 ~= DataStatus.Ready then
			return v157, v158
		end
	end

	return nil
end
local function resolveTablePropValue(p27, t5: {[any]: any}, t6: {[any]: any}?, t7: {[any]: any}?, _, _, _, _, _: ((...any) -> ...any)?) -- line: 823
	-- upvalues: FFlagSduiRenderPerf (copy), Cryo (copy), v32 (copy), DataStatus (copy)
	local v179 = if not FFlagSduiRenderPerf then Cryo.Dictionary.join(t7 or {}, t5 or {}) else Cryo.Dictionary.join(t7 or v32, t5 or v32)
	local v180 = nil

	if t6 then
		for v181, v182 in t6 do
			v179[v181] = v182(p27).data

			local status = v182(p27).status

			if status and status ~= DataStatus.Ready then
				v180 = status
			end
		end
	end

	return v179, v180
end
local function resolveTemplate_legacy(s3: string?, p33) -- line: 1065
	if s3 == nil then
		error("Missing roblox_component")
	end

	local v231 = p33.getTemplateForRobloxComponent(s3)

	if v231 == nil then
		error(`Could not find template for roblox_component { s3 }`)
	end

	return v231
end
local function resolveTemplate(s4: string?, p34, p35) -- line: 1098
	if p34 ~= nil then
		return p34
	end

	if s4 == nil or s4 == "" then
		error("Missing roblox_component")
	end

	local v235 = p35.getTemplateForRobloxComponent(s4)

	if v235 == nil then
		error(`Could not find template for roblox_component { s4 }`)
	end

	return v235
end
local function resolveTemplateFromData(p36, p37) -- line: 1123
	local inline_component = p36.inline_component
	local roblox_component = p36.roblox_component

	if inline_component ~= nil then
		return inline_component
	end

	if roblox_component == nil or roblox_component == "" then
		error("Missing roblox_component")
	end

	local v240 = p37.getTemplateForRobloxComponent(roblox_component)

	if v240 == nil then
		error(`Could not find template for roblox_component { roblox_component }`)
	end

	return v240
end

return {
	generateStaticPropValue = function(p38, p39: ((...any) -> ...any)?) -- line: 212
		if p39 then
			return p39(p38)
		end

		return p38
	end,
	generateDynamicBindingPropValue = generateDynamicBindingPropValue,
	generateTokenBindingPropValue = function(s5: string, p40, p41: ((...any) -> ...any)?) -- line: 298
		-- upvalues: FFlagSduiImprovedErrorDimensions (copy), FFlagSduiRenderPerf (copy), splitDottedPath (copy), Signals (copy), getSduiTokensStore (copy), tryGetPathFromData (copy), SduiLogger (copy), SduiErrors (copy), v31 (copy), FFlagLuaAppSduiColorPropMigration (copy), DataStatus (copy), tutils (copy)
		local currentComponentType = nil
		local currentParserName = nil

		if FFlagSduiImprovedErrorDimensions then
			currentComponentType = p40.currentComponentType
			currentParserName = p40.currentParserName
		end

		local v91 = if not FFlagSduiRenderPerf then string.split(s5, ".") else splitDottedPath(s5)

		return Signals.createComputed(function(p42) -- line: 314
			-- upvalues: getSduiTokensStore (copy), p40 (copy), tryGetPathFromData (copy), v91 (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), v31 (copy), FFlagLuaAppSduiColorPropMigration (copy), p41 (copy), DataStatus (copy)
			local v246 = getSduiTokensStore().getTokens(p42, p40.appPage)
			local v247, v248 = tryGetPathFromData(v246, v91)

			if not v247 then
				local v249 = table.concat(v91, ".")

				SduiLogger.reportError(SduiErrors.SduiErrorType.TokenBindingFailed, {
					message = `Could not find token with tokenPath { v249 }`,
					name = p40.debugName,
					componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
					parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
				}, p40.appPage)

				return v31
			end

			if FFlagLuaAppSduiColorPropMigration and p41 then
				v248 = p41(v248)
			end

			return {
				data = v248,
				status = DataStatus.Ready
			}
		end, tutils.shallowEqual)
	end,
	generateFormatStringPropValue = function(t8: {[any]: any}, p43, p44, p45, p46: ((...any) -> ...any)?) -- line: 361
		-- upvalues: FFlagSduiImprovedErrorDimensions (copy), FFlagSduiFormatArgFormatters (copy), applyFormatArgFormatter (copy), v31 (copy), generateDynamicBindingPropValue (copy), Signals (copy), SduiLogger (copy), SduiErrors (copy), tutils (copy)
		local currentComponentType = nil
		local currentParserName = nil

		if FFlagSduiImprovedErrorDimensions then
			currentComponentType = p44.currentComponentType
			currentParserName = p44.currentParserName
		end

		if typeof(t8) ~= "table" then
			error(`Unexpected type for stringFormat { typeof(t8) }`)
		end

		local str = t8.str

		if (not str or str == "") and t8.translation then
			str = p44.resolveLocalizedLiteral(t8.translation)
		end

		if not str or str == "" then
			error("No format string for prop")
		end

		if not t8.args then
			error(`No args found for format. If no args needed, use literal. { str }`)
		end

		local t9 = {}
		local t10 = {}

		for v102, v103 in t8.args do
			local type2 = v103.kind.type
			local value = v103.kind.value

			if type2 ~= "literal" then
				if type2 == "binding_path" then
					t9[v102] = generateDynamicBindingPropValue(value, p43, p44, p45)

					if FFlagSduiFormatArgFormatters and v103.formatter then
						t10[v102] = v103.formatter
					end
				else
					warn(`Unrecognized argType in buildFormatString { type2 }`)
				end

				continue
			end

			if FFlagSduiFormatArgFormatters and v103.formatter then
				local v106 = applyFormatArgFormatter(value, v103.formatter, p44.appPage)

				if v106 == nil then
					return function() -- line: 409
						-- upvalues: v31 (copy)
						return v31
					end
				end

				str = str:gsub("{" .. v102 .. "}", v106)

				continue
			end

			str = str:gsub("{" .. v102 .. "}", (tostring(value)))
		end

		return Signals.createComputed(function(p47) -- line: 427
			-- upvalues: str (ref), t9 (copy), FFlagSduiFormatArgFormatters (copy), t10 (copy), applyFormatArgFormatter (copy), p44 (copy), v31 (copy), p46 (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref)
			local u251 = str

			for v252, v253 in t9 do
				local v254 = v253(p47)
				local data = v254.data
				local status = v254.status

				if data == nil then
					return {
						status = status
					}
				end

				local v257 = if not FFlagSduiFormatArgFormatters or not t10 then nil else t10[v252]

				if v257 then
					local v258 = applyFormatArgFormatter(data, v257, p44.appPage)

					if v258 == nil then
						return v31
					end

					u251 = u251 and u251:gsub("{" .. v252 .. "}", v258)

					continue
				end

				u251 = u251 and u251:gsub("{" .. v252 .. "}", (tostring(data)))
			end

			if p46 then
				local ok, result = pcall(function() -- line: 454
					-- upvalues: p46 (copy), u251 (ref)
					return p46(u251)
				end)

				if not ok then
					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
						value = u251,
						message = `Parser in formatString for str { str }`,
						name = p44.debugName,
						componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
						parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
					}, p44.appPage)

					return v31
				end

				return {
					data = result
				}
			end

			return {
				data = u251
			}
		end, tutils.shallowEqual)
	end,
	generateConditionalPropValue = function(t11: {[any]: any}, p48, p49, p50, p51, p52: ((...any) -> ...any), p53: ((...any) -> ...any)?, b4: boolean?) -- line: 754
		-- upvalues: FFlagSduiImprovedErrorDimensions (copy), Signals (copy), selectConditionalOption (copy), PropResultCategory (copy), DataStatus (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), v31 (copy), tutils (copy)
		local currentComponentType = nil
		local currentParserName = nil

		if FFlagSduiImprovedErrorDimensions then
			currentComponentType = p49.currentComponentType
			currentParserName = p49.currentParserName
		end

		local options = t11.options

		return Signals.createComputed(function(p54) -- line: 773
			-- upvalues: selectConditionalOption (copy), options (copy), p48 (copy), p49 (copy), p51 (copy), p52 (copy), p50 (copy), p53 (copy), PropResultCategory (copy), DataStatus (copy), b4 (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), v31 (copy)
			local ok, result, v269 = pcall(function() -- line: 774
				-- upvalues: selectConditionalOption (copy), p54 (copy), options (copy), p48 (copy), p49 (copy), p51 (copy), p52 (copy), p50 (copy), p53 (copy), PropResultCategory (copy), DataStatus (copy)
				local v279, v280 = selectConditionalOption(p54, options, p48, p49, p51)

				if v279 == nil then
					return nil, v280
				end

				local v281 = v279 and (v279.kind and v279.kind.type)
				local v282 = v279 and (v279.kind and v279.kind.value)
				local v283, v284 = p52(v281, v282, p48, p51, p49, p50, p53)

				if v284 == PropResultCategory.PropSignal then
					local v285 = v283(p54)

					v283 = v285.data

					if v285.status and v285.status ~= DataStatus.Ready then
						v280 = v285.status
					end
				end

				return v283, v280
			end)

			if ok then
				return {
					data = result,
					status = v269,
					isNestedComponentConfig = b4
				}
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToEvaluateConditionalProp, {
				message = SduiParseHelpers.stringifyValue(result),
				name = p49.debugName,
				componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
				parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
			}, p49.appPage)

			return v31
		end, tutils.shallowEqual)
	end,
	generateTablePropSignalValue = function(t12: {[any]: any}, p55, p56, p57, p58, p59: ((...any) -> ...any), p60: ((...any) -> ...any)?) -- line: 853
		-- upvalues: FFlagSduiImprovedErrorDimensions (copy), Signals (copy), resolveTablePropValue (copy), FFlagSduiFocusNavActionsStructured (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), v31 (copy), tutils (copy)
		local currentComponentType = nil
		local currentParserName = nil

		if FFlagSduiImprovedErrorDimensions then
			currentComponentType = p56.currentComponentType
			currentParserName = p56.currentParserName
		end

		local v193, v194, v195 = p59(t12, p55, p58, p56, p57)

		return Signals.createComputed(function(p61) -- line: 876
			-- upvalues: resolveTablePropValue (copy), v193 (copy), v194 (copy), v195 (copy), p55 (copy), p56 (copy), p57 (copy), p58 (copy), p59 (copy), FFlagSduiFocusNavActionsStructured (copy), p60 (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), v31 (copy)
			local ok, result, v273 = pcall(function() -- line: 877
				-- upvalues: resolveTablePropValue (copy), p61 (copy), v193 (copy), v194 (copy), v195 (copy), p55 (copy), p56 (copy), p57 (copy), p58 (copy), p59 (copy)
				local v286, v287 = resolveTablePropValue(p61, v193, v194, v195, p55, p56, p57, p58, p59)

				return v286, v287
			end)

			if ok then
				if FFlagSduiFocusNavActionsStructured and p60 and result ~= nil then
					local ok2, result2 = pcall(function() -- line: 894
						-- upvalues: p60 (copy), result (ref)
						return p60(result)
					end)

					if not ok2 then
						local v276 = SduiParseHelpers.stringifyValue(result2)

						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
							value = SduiParseHelpers.stringifyValue(result),
							message = `Failed to apply propParser to table prop { v276 }`,
							name = p56.debugName,
							componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
							parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
						}, p56.appPage)

						return v31
					end

					result = result2
				end

				return {
					data = result,
					status = v273
				}
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
				message = SduiParseHelpers.stringifyValue(result),
				name = p56.debugName,
				componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
				parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
			}, p56.appPage)

			return v31
		end, tutils.shallowEqual)
	end,
	selectConditionalOption = selectConditionalOption,
	evaluateCondition = evaluateCondition,
	resolveHydrationBinding = resolveHydrationBinding,
	resolveBindingPathValue = resolveBindingPathValue,
	resolveTablePropValue = resolveTablePropValue,
	resolveSourceArray = function(s6: string?, p62, p63, p64, p65, p66) -- line: 937
		-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy), resolveBindingPathValue (copy), FFlagSduiClientPageScope (copy)
		if s6 == "binding_path" then
			local v202 = if not FFlagSduiRenderPerf then string.split(p62, ".") else splitDottedPath(p62)

			return resolveBindingPathValue(p63, v202, p64, p65, nil, nil, if not FFlagSduiClientPageScope then nil else p66)
		end

		if s6 == "literal" then
			return p62 and p62.items
		end

		return nil
	end,
	resolveFieldMap = function(t13: {[any]: any}, p67, p68, p69, p70, p71, p72: ((...any) -> ...any)) -- line: 980
		-- upvalues: resolveTablePropValue (copy)
		local v210, v211 = p72(t13, p67, p68, p69, p70)

		return resolveTablePropValue(p71, v210, v211, nil, p67, p69, p70, p68, nil)
	end,
	mapArrayWithFieldMap = function(t14: {[any]: any}, t15: {[any]: any}, t16: {[any]: any}, p73, p74, p75, p76: ((...any) -> ...any)) -- line: 1020
		-- upvalues: buildDataBindingSourcesForTemplate (copy), resolveTablePropValue (copy)
		local t17 = {}

		for _, v221 in t14 do
			local v222 = buildDataBindingSourcesForTemplate(v221, t15)

			local function v223() -- line: 1032
				-- upvalues: v222 (copy)
				return v222
			end
			local function v224() -- line: 1035
				-- upvalues: v221 (copy)
				return v221
			end

			local v225, v226 = p76(t16, v223, v224, p73, p74)

			table.insert(t17, (resolveTablePropValue(p75, v225, v226, nil, v223, p73, p74, v224, nil)))
		end

		return t17
	end,
	isComponentVisible = function(p77, p78) -- line: 1052
		if p77.isComponentFilteredSignal == nil then
			return true
		end

		return p77.isComponentFilteredSignal(p78).data ~= true
	end,
	resolveTemplate = if not FFlagSduiInlineNestedComponentSchema then resolveTemplate_legacy else resolveTemplate,
	resolveTemplateFromData = if not FFlagSduiInlineNestedComponentSchema then nil else resolveTemplateFromData
}
