local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Signals = require(SduiCoreSystemParent.Signals)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local buildDataBindingSourcesForTemplate = require(SduiCoreSystem.ClientBinding.buildDataBindingSourcesForTemplate)
local buildAnalyticsContextForClientBinding = require(SduiCoreSystem.ClientBinding.buildAnalyticsContextForClientBinding)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiComponentType)

local PropResultCategory = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes).PropResultCategory
local ProtoVariableMapper = require(SduiCoreSystem.ClientBinding.ProtoVariableMapper)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
local SharedFlags = require(SduiCoreSystemParent.SharedFlags)
local FFlagSduiOneofPropSupport = SharedFlags.FFlagSduiOneofPropSupport
local FFlagSduiNestedComponentListProp = SharedFlags.FFlagSduiNestedComponentListProp
local FFlagSduiImprovedErrorDimensions = SharedFlags.FFlagSduiImprovedErrorDimensions
local FFlagSduiInlineNestedComponentSchema = SharedFlags.FFlagSduiInlineNestedComponentSchema
local FFlagSduiGenericContainerDispatch = SharedFlags.FFlagSduiGenericContainerDispatch
local FFlagSduiDeferredListItems = SharedFlags.FFlagSduiDeferredListItems

local function buildProp(p1, p2, p3, p4, p5) -- line: 36
	-- upvalues: FFlagSduiOneofPropSupport (copy), buildProp (copy), FFlagSduiGenericContainerDispatch (copy), FFlagSduiImprovedErrorDimensions (copy)
	if FFlagSduiOneofPropSupport and (p1.oneof_prop and p1.oneof_prop.value) then
		return buildProp(p1.oneof_prop.value, p2, p3, p4, p5)
	end

	if FFlagSduiGenericContainerDispatch and typeof(p1) == "table" and p1.descriptor == nil then
		return p4.getPropBuilder("ContainerProp")(nil, p1, p2, p3, p4, p5)
	end

	local v26 = p1 and (p1.kind and p1.kind.type)

	if v26 == nil then
		error("No propDefinitionType provided")
	end

	if p1.descriptor == nil then
		error(`No propDefinitionType descriptor provided for { v26 }`)
	end

	local name = p1.descriptor.name

	if FFlagSduiImprovedErrorDimensions then
		p4.currentParserName = name
	end

	local v28 = p4.getPropBuilder(name)
	local v29 = p1.kind and p1.kind.value

	if FFlagSduiOneofPropSupport and v29 == nil then
		error(`No propDefinitionValue provided for { v26 }`)
	end

	local v30, v31, v32 = v28(v26, v29, p2, p3, p4, p5)

	return v30, v31, v32
end
local function buildPropTable(p6, p7, p8, p9, p10) -- line: 96
	-- upvalues: FFlagSduiImprovedErrorDimensions (copy), ProtoVariableMapper (copy), buildProp (copy), PropResultCategory (copy), FFlagSduiNestedComponentListProp (copy), SduiLogger (copy), SduiErrors (copy)
	local t1 = {}

	if p6 == nil then
		error("Attempt to buildPropTable with nil")
	end

	local currentComponentType = nil

	if FFlagSduiImprovedErrorDimensions then
		currentComponentType = p9.currentComponentType
	end

	local t2 = nil
	local t3 = nil
	local t4 = nil

	for v43, v44 in p6 do
		local v45 = ProtoVariableMapper.mapPropName(v43)
		local ok, result = pcall(function() -- line: 118
			-- upvalues: buildProp (copy), v44 (copy), p7 (copy), p8 (copy), p9 (copy), p10 (copy), PropResultCategory (copy), t2 (ref), v45 (copy), t3 (ref), FFlagSduiNestedComponentListProp (copy), t4 (ref), t1 (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref)
			local v77, v78, v79 = buildProp(v44, p7, p8, p9, p10)

			if v78 == PropResultCategory.PropSignal then
				if t2 == nil then
					t2 = {}
				end

				t2[v45] = v77

				return
			end

			if v78 == PropResultCategory.NestedComponentConfig then
				if t3 == nil then
					t3 = {}
				end

				t3[v45] = v77

				return
			end

			if FFlagSduiNestedComponentListProp and v78 == PropResultCategory.NestedComponentConfigListPropSignal then
				if t2 == nil then
					t2 = {}
				end

				t2[v45] = v77

				if t4 == nil then
					t4 = {}
				end

				t4[v45] = true

				return
			end

			if v78 == PropResultCategory.Failed then
				t1[v45] = v77
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
					message = `ClientBinding - failed to build prop { v45 }: { v77 }, { v79 }`,
					propName = `{ v45 }`,
					name = p9.debugName,
					componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
					parserName = if not FFlagSduiImprovedErrorDimensions then nil else v44.descriptor.name,
					value = v44
				}, p9.appPage)

				return
			end

			if v78 == PropResultCategory.Literal then
				t1[v45] = v77

				return
			end

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
				message = `ClientBinding - unexpected propResultCategory: { v78 }. { v45 }: { v77 }, { v79 }`,
				propName = `{ v45 }`,
				name = p9.debugName,
				componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
				parserName = if not FFlagSduiImprovedErrorDimensions then nil else v44.descriptor.name,
				value = v44
			}, p9.appPage)
			t1[v45] = v77
		end)

		if not ok then
			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
				message = `ClientBinding - failed to build prop { v45 }: { result }. { result }`,
				propName = `{ v45 }`,
				name = p9.debugName,
				componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
				parserName = if not FFlagSduiImprovedErrorDimensions then nil else v44.descriptor.name,
				value = v44
			}, p9.appPage)
		end
	end

	return t1, t2, t3, t4
end

local t5 = {
	__index = function(p11, p12) -- line: 187
		if p12 == "analyticsData" then
			return p11.analyticsContext and p11.analyticsContext.analyticsData
		end

		return nil
	end
}

return {
	buildPropTable = buildPropTable,
	buildProp = buildProp,
	buildConfigForComponent = function(p13, p14, p15, p16, _, p18, t6: {[any]: any}?) -- line: 196
		-- upvalues: FFlagSduiImprovedErrorDimensions (copy), ProtoVariableMapper (copy), FFlagSduiInlineNestedComponentSchema (copy), Signals (copy), buildDataBindingSourcesForTemplate (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), FFlagSduiDeferredListItems (copy), t5 (copy), buildPropTable (copy), buildAnalyticsContextForClientBinding (copy), FFlagSduiNestedComponentListProp (copy), buildProp (copy), PropResultCategory (copy)
		if not p13 or not next(p13) then
			error("Attempt to buildConfigForComponent with nil template")
		end

		local value = p13.kind.value
		local u58 = nil

		if FFlagSduiImprovedErrorDimensions then
			local v59 = value.shared and value.shared.component_type

			if not v59 then
				error("Could not determine ui component type")
			end

			u58 = ProtoVariableMapper.mapUiComponentTypeToLua(v59)
			p15.currentComponentType = u58
		end

		local u60

		if FFlagSduiInlineNestedComponentSchema and p18 ~= nil then
			u60 = p18
		else
			local v61 = value.shared and value.shared.data or {}

			u60 = Signals.createComputed(function(p19) -- line: 237
				-- upvalues: buildDataBindingSourcesForTemplate (copy), p14 (copy), v61 (copy), SduiLogger (copy), SduiErrors (copy), p15 (copy), FFlagSduiImprovedErrorDimensions (copy), u58 (ref), SduiParseHelpers (copy)
				local ok, result = pcall(function() -- line: 238
					-- upvalues: buildDataBindingSourcesForTemplate (copy), p14 (copy), p19 (copy), v61 (copy)
					return buildDataBindingSourcesForTemplate(p14(p19), v61)
				end)

				if not ok then
					SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToBuildBindingSources, {
						name = p15.debugName,
						componentType = if not FFlagSduiImprovedErrorDimensions then nil else u58,
						message = SduiParseHelpers.stringifyValue(result)
					}, p15.appPage)

					return {}
				end

				return result
			end)
		end

		if not FFlagSduiImprovedErrorDimensions then
			local v62 = value.shared and value.shared.component_type

			if not v62 then
				error("Could not determine ui component type")
			end

			u58 = ProtoVariableMapper.mapUiComponentTypeToLua(v62)
		end

		local u63

		if FFlagSduiDeferredListItems then
			u63 = t6 or {}
			u63.__processed = true
			u63.__isClientBinding = true
			u63.componentType = u58
		else
			u63 = {
				__processed = true,
				__isClientBinding = true,
				componentType = u58
			}
		end

		setmetatable(u63, t5)

		local v64 = nil
		local v65 = nil

		if value.shared and value.shared.analytics_data then
			v64, v65 = buildPropTable(value.shared.analytics_data, u60, p14, p15, nil)
		end

		u63.analyticsContext = buildAnalyticsContextForClientBinding(v64, v65, p16, p15)

		if value.props then
			local v66, v67, v68, v69 = buildPropTable(value.props, u60, p14, p15, u63.analyticsContext)

			u63.props = v66

			if v67 ~= nil and next(v67) then
				u63.propSignals = v67
			end

			if v68 ~= nil and next(v68) then
				u63.nestedComponentConfigs = v68
			end

			if FFlagSduiNestedComponentListProp and v69 ~= nil and next(v69) then
				u63.nestedComponentConfigListPropSignalNames = v69
			end
		end

		if value.shared and value.shared.is_component_filtered then
			local is_component_filtered = value.shared.is_component_filtered
			local ok, result, v73, v74 = pcall(function() -- line: 319
				-- upvalues: buildProp (copy), is_component_filtered (copy), u60 (ref), p14 (copy), p15 (copy), u63 (ref)
				return buildProp(is_component_filtered, u60, p14, p15, u63.analyticsContext)
			end)

			if not ok or v74 or v73 == PropResultCategory.Failed then
				local v75 = if not v74 then SduiParseHelpers.stringifyValue(result) else SduiParseHelpers.stringifyValue(v74)
				local v76 = SduiParseHelpers.stringifyValue(is_component_filtered)

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
					message = `Failed to build is_component_filtered prop: { v75 }`,
					name = p15.debugName,
					componentType = if not FFlagSduiImprovedErrorDimensions then nil else u58,
					value = v76
				}, p15.appPage)
			elseif v73 == PropResultCategory.PropSignal then
				u63.isComponentFilteredSignal = result
			elseif v73 == PropResultCategory.Literal then
				function u63.isComponentFilteredSignal() -- line: 344
					-- upvalues: result (copy)
					return {
						data = result
					}
				end
			end
		end

		return u63
	end
}
