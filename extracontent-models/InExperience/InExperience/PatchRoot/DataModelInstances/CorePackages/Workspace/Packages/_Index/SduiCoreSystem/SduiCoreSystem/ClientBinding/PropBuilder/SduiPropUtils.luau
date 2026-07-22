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
local FFlagSduiFocusNavActionsStructured = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFocusNavActionsStructured
local FFlagSduiRenderPerf = require(SduiCoreSystemParent.SharedFlags).FFlagSduiRenderPerf
local v29 = game:DefineFastFlag("SduiPropBuilderSupportNilHydration", false)
local v30 = table.freeze({
	status = DataStatus.Failed
})
local v31 = table.freeze({})

local function resolveHydrationBinding(t1: {[any]: any}, p1, p2, b1: boolean?) -- line: 87
	-- upvalues: v29 (copy), SduiDataBindingContentType (copy), FFlagSduiHydrationFetchIfMissing (copy), SduiDataBinder (copy)
	local v48 = table.concat(t1, ".")
	local v49 = t1[1]
	local v50 = p1 and p1[v49]

	if v50 == nil then
		if v29 then
			if SduiDataBindingContentType[v49] ~= nil then
				error(`Could not find data bindingSource for key { v49 }, bindingPath: { v48 }`)
			end

			return nil, nil
		end

		error(`Could not find data bindingSource for key { v49 }, bindingPath: { v48 }`)
	end

	local contentType = v50.contentType
	local id = v50.id

	if #t1 < 2 then
		error(`Unsupported path for contentType { contentType }, bindingPath: { v48 }`)
	end

	local v53 = if not FFlagSduiHydrationFetchIfMissing then b1 else v50.fetchIfMissing or b1
	local v54, v55 = SduiDataBinder.getFieldValue(contentType, t1, id, p2, v53)

	return v54, v55
end
local function resolveBindingPathValue(p3, t2: {[any]: any}, p4, p5, p6: ((...any) -> ...any)?, b2: boolean?, p7) -- line: 143
	-- upvalues: tryGetPathFromData (copy), SduiDataBinder (copy), FFlagSduiClientPageScope (copy), resolveHydrationBinding (copy), FFlagSduiRenderPerf (copy), SduiParseHelpers (copy)
	local v63, v64 = tryGetPathFromData(p5(p3), t2)

	if v63 and v64 ~= nil then
		if p6 then
			return p6(v64, p3)
		end

		return v64
	end

	local v65 = t2 and t2[1]

	if SduiDataBinder.isClientContentType(v65) then
		local v66 = SduiDataBinder.getFieldValueForClientContentType(v65, t2, p3, if not FFlagSduiClientPageScope then nil else p7)

		if p6 and v66 ~= nil then
			return p6(v66, p3)
		end

		return v66
	end

	local v67 = p4(p3)
	local u68, v69 = resolveHydrationBinding(t2, v67, p3, b2)

	if p6 and u68 ~= nil then
		if FFlagSduiRenderPerf then
			u68 = p6(u68, p3)
		else
			local ok, result = pcall(function() -- line: 189
				-- upvalues: p6 (copy), u68 (ref), p3 (copy)
				return p6(u68, p3)
			end)

			if not ok then
				local v72 = SduiParseHelpers.stringifyValue(result)
				local v73 = table.concat(t2, ".")

				error(`Parser failed for bindingPath: { v73 }. err{ v72 }`)
			end

			u68 = result
		end
	end

	return u68, v69
end
local function generateDynamicBindingPropValue(s1: string, p8, p9, p10, p11: ((...any) -> ...any)?, b3: boolean?) -- line: 235
	-- upvalues: FFlagSduiImprovedErrorDimensions (copy), FFlagSduiRenderPerf (copy), splitDottedPath (copy), Signals (copy), resolveBindingPathValue (copy), FFlagSduiClientPageScope (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), v30 (copy), tutils (copy)
	local currentComponentType = nil
	local currentParserName = nil

	if FFlagSduiImprovedErrorDimensions then
		currentComponentType = p9.currentComponentType
		currentParserName = p9.currentParserName
	end

	local v84 = if not FFlagSduiRenderPerf then string.split(s1, ".") else splitDottedPath(s1)

	if not v84 or #v84 == 0 then
		error(`Invalid bindingPath: { s1 }`)
	end

	return Signals.createComputed(function(p12) -- line: 257
		-- upvalues: resolveBindingPathValue (copy), v84 (copy), p8 (copy), p10 (copy), p11 (copy), b3 (copy), FFlagSduiClientPageScope (copy), p9 (copy), SduiLogger (copy), SduiErrors (copy), s1 (copy), SduiParseHelpers (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), v30 (copy)
		local ok, result, v243 = pcall(function() -- line: 258
			-- upvalues: resolveBindingPathValue (copy), p12 (copy), v84 (copy), p8 (copy), p10 (copy), p11 (copy), b3 (copy), FFlagSduiClientPageScope (copy), p9 (copy)
			local v276, v277 = resolveBindingPathValue(p12, v84, p8, p10, p11, b3, if not FFlagSduiClientPageScope then nil else p9)

			return v276, v277
		end)

		if ok then
			return {
				data = result,
				status = v243
			}
		end

		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToComputeDynamicBinding, {
			value = s1,
			message = SduiParseHelpers.stringifyValue(result),
			name = p9.debugName,
			componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
			parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
		}, p9.appPage)

		return v30
	end, tutils.shallowEqual)
end
local function validateNumbers(p13, p14, p15) -- line: 478
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
local function isEmpty(p16) -- line: 497
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
local function isSame(p17, p18) -- line: 522
	-- upvalues: SduiParsers (copy)
	if p17 == p18 then
		return true
	end

	if p17 == nil then
		return false
	end

	local v112 = typeof(p18)

	if v112 ~= typeof(p17) then
		if v112 == "string" then
			p17 = tostring(p17)
		elseif v112 == "number" then
			p17 = tonumber(p17)
		elseif v112 == "boolean" then
			p17 = SduiParsers.parseBooleanProp_(p17, nil, nil)
		end
	end

	return p17 == p18
end
local function evaluateCondition(p19, t3: {[any]: any}, p20, p21, p22) -- line: 566
	-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy), resolveBindingPathValue (copy), FFlagSduiClientPageScope (copy), DataStatus (copy), validateNumbers (copy), isSame (copy), FFlagSduiIsEmptyConditions (copy), evaluateCondition (copy)
	if t3 == nil then
		return true
	end

	local v118 = t3 and (t3.kind and t3.kind.type)
	local v119 = t3 and (t3.kind and t3.kind.value)

	if v118 == nil then
		error("nil conditionType in condition")
	end

	if v119 == nil then
		error("nil conditionValue in condition")
	end

	local function getFieldObject(s2: string) -- line: 586
		-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy), resolveBindingPathValue (copy), p19 (copy), p20 (copy), p22 (copy), FFlagSduiClientPageScope (copy), p21 (copy)
		local v261 = if not FFlagSduiRenderPerf then string.split(s2, ".") else splitDottedPath(s2)
		local ok, result, v264 = pcall(function() -- line: 592
			-- upvalues: resolveBindingPathValue (copy), p19 (copy), v261 (copy), p20 (copy), p22 (copy), FFlagSduiClientPageScope (copy), p21 (copy)
			return resolveBindingPathValue(p19, v261, p20, p22, nil, true, if not FFlagSduiClientPageScope then nil else p21)
		end)

		if ok then
			return result, v264
		end

		return nil, v264
	end

	if v118 == "comparison" then
		local v121, v122 = getFieldObject(v119.field)

		if v121 == nil or v122 and v122 ~= DataStatus.Ready then
			return nil, v122
		end

		local value = v119.kind.value
		local op = v119.op

		if op == "OP_LT" then
			local v125, v126 = validateNumbers(op, v121, value)

			return v125 < v126
		end

		if op == "OP_LTE" then
			local v127, v128 = validateNumbers(op, v121, value)

			return v127 <= v128
		end

		if op == "OP_GT" then
			local v129, v130 = validateNumbers(op, v121, value)

			return v130 < v129
		end

		if op == "OP_GTE" then
			local v131, v132 = validateNumbers(op, v121, value)

			return v132 <= v131
		end

		if op == "OP_E" then
			return (isSame(v121, value))
		end

		if op == "OP_NE" then
			return not isSame(v121, value)
		end

		error(`Unknown operator for comparison { op }`)
	else
		if v118 == "is_null" then
			local v133, v134 = getFieldObject(v119.field)

			if v134 and v134 ~= DataStatus.Ready then
				return nil, v134
			end

			return v133 == nil
		end

		if v118 == "is_not_null" then
			local v135, v136 = getFieldObject(v119.field)

			if v136 and v136 ~= DataStatus.Ready then
				return nil, v136
			end

			return v135 ~= nil
		end

		if FFlagSduiIsEmptyConditions and v118 == "is_empty" then
			local v137, v138 = getFieldObject(v119.field)

			if v138 and v138 ~= DataStatus.Ready then
				return nil, v138
			end

			if v137 == nil then
				return true
			end

			if type(v137) == "string" then
				return v137 == ""
			end

			if type(v137) == "table" then
				return next(v137) == nil
			end

			return false
		end

		if FFlagSduiIsEmptyConditions and v118 == "is_not_empty" then
			local v139, v140 = getFieldObject(v119.field)

			if v140 and v140 ~= DataStatus.Ready then
				return nil, v140
			end

			return not (v139 == nil or if type(v139) ~= "string" then type(v139) == "table" and next(v139) == nil else v139 == "")
		end

		if v118 == "and_condition" then
			for _, v142 in v119.conditions do
				local v143, v144 = evaluateCondition(p19, v142, p20, p21, p22)

				if v144 and v144 ~= DataStatus.Ready then
					return v143, v144
				end

				if not v143 then
					return v143
				end
			end

			return true
		end

		if v118 == "or_condition" then
			for _, v146 in v119.conditions do
				local v147, v148 = evaluateCondition(p19, v146, p20, p21, p22)

				if v148 and v148 ~= DataStatus.Ready then
					return v147, v148
				end

				if v147 or v147 == nil then
					return v147, v148
				end
			end

			return false
		end
	end

	return nil
end
local function selectConditionalOption(p23, t4: {[any]: any}, p24, p25, p26) -- line: 713
	-- upvalues: evaluateCondition (copy), DataStatus (copy)
	for _, v155 in t4 do
		local v156, v157 = evaluateCondition(p23, v155.condition, p24, p25, p26)

		if v156 then
			return v155, v157
		end

		if v157 and v157 ~= DataStatus.Ready then
			return v156, v157
		end
	end

	return nil
end
local function resolveTablePropValue(p27, t5: {[any]: any}, t6: {[any]: any}?, t7: {[any]: any}?, _, _, _, _, _: ((...any) -> ...any)?) -- line: 818
	-- upvalues: FFlagSduiRenderPerf (copy), Cryo (copy), v31 (copy), DataStatus (copy)
	local v178 = if not FFlagSduiRenderPerf then Cryo.Dictionary.join(t7 or {}, t5 or {}) else Cryo.Dictionary.join(t7 or v31, t5 or v31)
	local v179 = nil

	if t6 then
		for v180, v181 in t6 do
			v178[v180] = v181(p27).data

			local status = v181(p27).status

			if status and status ~= DataStatus.Ready then
				v179 = status
			end
		end
	end

	return v178, v179
end
local function resolveTemplate_legacy(s3: string?, p33) -- line: 1060
	if s3 == nil then
		error("Missing roblox_component")
	end

	local v230 = p33.getTemplateForRobloxComponent(s3)

	if v230 == nil then
		error(`Could not find template for roblox_component { s3 }`)
	end

	return v230
end
local function resolveTemplate(s4: string?, p34, p35) -- line: 1093
	if p34 ~= nil then
		return p34
	end

	if s4 == nil or s4 == "" then
		error("Missing roblox_component")
	end

	local v234 = p35.getTemplateForRobloxComponent(s4)

	if v234 == nil then
		error(`Could not find template for roblox_component { s4 }`)
	end

	return v234
end
local function resolveTemplateFromData(p36, p37) -- line: 1118
	local inline_component = p36.inline_component
	local roblox_component = p36.roblox_component

	if inline_component ~= nil then
		return inline_component
	end

	if roblox_component == nil or roblox_component == "" then
		error("Missing roblox_component")
	end

	local v239 = p37.getTemplateForRobloxComponent(roblox_component)

	if v239 == nil then
		error(`Could not find template for roblox_component { roblox_component }`)
	end

	return v239
end

return {
	generateStaticPropValue = function(p38, p39: ((...any) -> ...any)?) -- line: 211
		if p39 then
			return p39(p38)
		end

		return p38
	end,
	generateDynamicBindingPropValue = generateDynamicBindingPropValue,
	generateTokenBindingPropValue = function(s5: string, p40, _: ((...any) -> ...any)?) -- line: 297
		-- upvalues: FFlagSduiImprovedErrorDimensions (copy), FFlagSduiRenderPerf (copy), splitDottedPath (copy), Signals (copy), getSduiTokensStore (copy), tryGetPathFromData (copy), SduiLogger (copy), SduiErrors (copy), v30 (copy), DataStatus (copy), tutils (copy)
		local currentComponentType = nil
		local currentParserName = nil

		if FFlagSduiImprovedErrorDimensions then
			currentComponentType = p40.currentComponentType
			currentParserName = p40.currentParserName
		end

		local v90 = if not FFlagSduiRenderPerf then string.split(s5, ".") else splitDottedPath(s5)

		return Signals.createComputed(function(p42) -- line: 313
			-- upvalues: getSduiTokensStore (copy), p40 (copy), tryGetPathFromData (copy), v90 (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), v30 (copy), DataStatus (copy)
			local v245 = getSduiTokensStore().getTokens(p42, p40.appPage)
			local v246, v247 = tryGetPathFromData(v245, v90)

			if not v246 then
				local v248 = table.concat(v90, ".")

				SduiLogger.reportError(SduiErrors.SduiErrorType.TokenBindingFailed, {
					message = `Could not find token with tokenPath { v248 }`,
					name = p40.debugName,
					componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
					parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
				}, p40.appPage)

				return v30
			end

			return {
				data = v247,
				status = DataStatus.Ready
			}
		end, tutils.shallowEqual)
	end,
	generateFormatStringPropValue = function(t8: {[any]: any}, p43, p44, p45, p46: ((...any) -> ...any)?) -- line: 356
		-- upvalues: FFlagSduiImprovedErrorDimensions (copy), FFlagSduiFormatArgFormatters (copy), applyFormatArgFormatter (copy), v30 (copy), generateDynamicBindingPropValue (copy), Signals (copy), SduiLogger (copy), SduiErrors (copy), tutils (copy)
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

		for v101, v102 in t8.args do
			local type2 = v102.kind.type
			local value = v102.kind.value

			if type2 ~= "literal" then
				if type2 == "binding_path" then
					t9[v101] = generateDynamicBindingPropValue(value, p43, p44, p45)

					if FFlagSduiFormatArgFormatters and v102.formatter then
						t10[v101] = v102.formatter
					end
				else
					warn(`Unrecognized argType in buildFormatString { type2 }`)
				end

				continue
			end

			if FFlagSduiFormatArgFormatters and v102.formatter then
				local v105 = applyFormatArgFormatter(value, v102.formatter, p44.appPage)

				if v105 == nil then
					return function() -- line: 404
						-- upvalues: v30 (copy)
						return v30
					end
				end

				str = str:gsub("{" .. v101 .. "}", v105)

				continue
			end

			str = str:gsub("{" .. v101 .. "}", (tostring(value)))
		end

		return Signals.createComputed(function(p47) -- line: 422
			-- upvalues: str (ref), t9 (copy), FFlagSduiFormatArgFormatters (copy), t10 (copy), applyFormatArgFormatter (copy), p44 (copy), v30 (copy), p46 (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref)
			local u250 = str

			for v251, v252 in t9 do
				local v253 = v252(p47)
				local data = v253.data
				local status = v253.status

				if data == nil then
					return {
						status = status
					}
				end

				local v256 = if not FFlagSduiFormatArgFormatters or not t10 then nil else t10[v251]

				if v256 then
					local v257 = applyFormatArgFormatter(data, v256, p44.appPage)

					if v257 == nil then
						return v30
					end

					u250 = u250 and u250:gsub("{" .. v251 .. "}", v257)

					continue
				end

				u250 = u250 and u250:gsub("{" .. v251 .. "}", (tostring(data)))
			end

			if p46 then
				local ok, result = pcall(function() -- line: 449
					-- upvalues: p46 (copy), u250 (ref)
					return p46(u250)
				end)

				if not ok then
					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
						value = u250,
						message = `Parser in formatString for str { str }`,
						name = p44.debugName,
						componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
						parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
					}, p44.appPage)

					return v30
				end

				return {
					data = result
				}
			end

			return {
				data = u250
			}
		end, tutils.shallowEqual)
	end,
	generateConditionalPropValue = function(t11: {[any]: any}, p48, p49, p50, p51, p52: ((...any) -> ...any), p53: ((...any) -> ...any)?, b4: boolean?) -- line: 749
		-- upvalues: FFlagSduiImprovedErrorDimensions (copy), Signals (copy), selectConditionalOption (copy), PropResultCategory (copy), DataStatus (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), v30 (copy), tutils (copy)
		local currentComponentType = nil
		local currentParserName = nil

		if FFlagSduiImprovedErrorDimensions then
			currentComponentType = p49.currentComponentType
			currentParserName = p49.currentParserName
		end

		local options = t11.options

		return Signals.createComputed(function(p54) -- line: 768
			-- upvalues: selectConditionalOption (copy), options (copy), p48 (copy), p49 (copy), p51 (copy), p52 (copy), p50 (copy), p53 (copy), PropResultCategory (copy), DataStatus (copy), b4 (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), v30 (copy)
			local ok, result, v268 = pcall(function() -- line: 769
				-- upvalues: selectConditionalOption (copy), p54 (copy), options (copy), p48 (copy), p49 (copy), p51 (copy), p52 (copy), p50 (copy), p53 (copy), PropResultCategory (copy), DataStatus (copy)
				local v278, v279 = selectConditionalOption(p54, options, p48, p49, p51)

				if v278 == nil then
					return nil, v279
				end

				local v280 = v278 and (v278.kind and v278.kind.type)
				local v281 = v278 and (v278.kind and v278.kind.value)
				local v282, v283 = p52(v280, v281, p48, p51, p49, p50, p53)

				if v283 == PropResultCategory.PropSignal then
					local v284 = v282(p54)

					v282 = v284.data

					if v284.status and v284.status ~= DataStatus.Ready then
						v279 = v284.status
					end
				end

				return v282, v279
			end)

			if ok then
				return {
					data = result,
					status = v268,
					isNestedComponentConfig = b4
				}
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToEvaluateConditionalProp, {
				message = SduiParseHelpers.stringifyValue(result),
				name = p49.debugName,
				componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
				parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
			}, p49.appPage)

			return v30
		end, tutils.shallowEqual)
	end,
	generateTablePropSignalValue = function(t12: {[any]: any}, p55, p56, p57, p58, p59: ((...any) -> ...any), p60: ((...any) -> ...any)?) -- line: 848
		-- upvalues: FFlagSduiImprovedErrorDimensions (copy), Signals (copy), resolveTablePropValue (copy), FFlagSduiFocusNavActionsStructured (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), v30 (copy), tutils (copy)
		local currentComponentType = nil
		local currentParserName = nil

		if FFlagSduiImprovedErrorDimensions then
			currentComponentType = p56.currentComponentType
			currentParserName = p56.currentParserName
		end

		local v192, v193, v194 = p59(t12, p55, p58, p56, p57)

		return Signals.createComputed(function(p61) -- line: 871
			-- upvalues: resolveTablePropValue (copy), v192 (copy), v193 (copy), v194 (copy), p55 (copy), p56 (copy), p57 (copy), p58 (copy), p59 (copy), FFlagSduiFocusNavActionsStructured (copy), p60 (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), v30 (copy)
			local ok, result, v272 = pcall(function() -- line: 872
				-- upvalues: resolveTablePropValue (copy), p61 (copy), v192 (copy), v193 (copy), v194 (copy), p55 (copy), p56 (copy), p57 (copy), p58 (copy), p59 (copy)
				local v285, v286 = resolveTablePropValue(p61, v192, v193, v194, p55, p56, p57, p58, p59)

				return v285, v286
			end)

			if ok then
				if FFlagSduiFocusNavActionsStructured and p60 and result ~= nil then
					local ok2, result2 = pcall(function() -- line: 889
						-- upvalues: p60 (copy), result (ref)
						return p60(result)
					end)

					if not ok2 then
						local v275 = SduiParseHelpers.stringifyValue(result2)

						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
							value = SduiParseHelpers.stringifyValue(result),
							message = `Failed to apply propParser to table prop { v275 }`,
							name = p56.debugName,
							componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
							parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
						}, p56.appPage)

						return v30
					end

					result = result2
				end

				return {
					data = result,
					status = v272
				}
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
				message = SduiParseHelpers.stringifyValue(result),
				name = p56.debugName,
				componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
				parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
			}, p56.appPage)

			return v30
		end, tutils.shallowEqual)
	end,
	selectConditionalOption = selectConditionalOption,
	evaluateCondition = evaluateCondition,
	resolveHydrationBinding = resolveHydrationBinding,
	resolveBindingPathValue = resolveBindingPathValue,
	resolveTablePropValue = resolveTablePropValue,
	resolveSourceArray = function(s6: string?, p62, p63, p64, p65, p66) -- line: 932
		-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy), resolveBindingPathValue (copy), FFlagSduiClientPageScope (copy)
		if s6 == "binding_path" then
			local v201 = if not FFlagSduiRenderPerf then string.split(p62, ".") else splitDottedPath(p62)

			return resolveBindingPathValue(p63, v201, p64, p65, nil, nil, if not FFlagSduiClientPageScope then nil else p66)
		end

		if s6 == "literal" then
			return p62 and p62.items
		end

		return nil
	end,
	resolveFieldMap = function(t13: {[any]: any}, p67, p68, p69, p70, p71, p72: ((...any) -> ...any)) -- line: 975
		-- upvalues: resolveTablePropValue (copy)
		local v209, v210 = p72(t13, p67, p68, p69, p70)

		return resolveTablePropValue(p71, v209, v210, nil, p67, p69, p70, p68, nil)
	end,
	mapArrayWithFieldMap = function(t14: {[any]: any}, t15: {[any]: any}, t16: {[any]: any}, p73, p74, p75, p76: ((...any) -> ...any)) -- line: 1015
		-- upvalues: buildDataBindingSourcesForTemplate (copy), resolveTablePropValue (copy)
		local t17 = {}

		for _, v220 in t14 do
			local v221 = buildDataBindingSourcesForTemplate(v220, t15)

			local function v222() -- line: 1027
				-- upvalues: v221 (copy)
				return v221
			end
			local function v223() -- line: 1030
				-- upvalues: v220 (copy)
				return v220
			end

			local v224, v225 = p76(t16, v222, v223, p73, p74)

			table.insert(t17, (resolveTablePropValue(p75, v224, v225, nil, v222, p73, p74, v223, nil)))
		end

		return t17
	end,
	isComponentVisible = function(p77, p78) -- line: 1047
		if p77.isComponentFilteredSignal == nil then
			return true
		end

		return p77.isComponentFilteredSignal(p78).data ~= true
	end,
	resolveTemplate = if not FFlagSduiInlineNestedComponentSchema then resolveTemplate_legacy else resolveTemplate,
	resolveTemplateFromData = if not FFlagSduiInlineNestedComponentSchema then nil else resolveTemplateFromData
}
