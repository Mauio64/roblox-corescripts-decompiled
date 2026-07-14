local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)

require(SduiCoreSystemParent.ServiceContractsProto)

local Signals = require(SduiCoreSystemParent.Signals)
local buildInputsForNestedComponent = require(SduiCoreSystem.ClientBinding.PropBuilder.buildInputsForNestedComponent)
local buildComponentList = require(SduiCoreSystem.ClientBinding.PropBuilder.buildComponentList)

require(SduiCoreSystem.SduiBuilderTypes)

local SduiClientBindingTypes = require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)
local buildConfigForComponent = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder).buildConfigForComponent

require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)

local PropResultCategory = SduiClientBindingTypes.PropResultCategory
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local splitDottedPath = require(SduiCoreSystem.ClientBinding.splitDottedPath)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)

require(SduiCoreSystem.SduiComponentType)

local FFlagSduiLazyNestedComponentArrayMapItemResolutionSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiLazyNestedComponentArrayMapItemResolutionSupport
local FFlagSduiFixEmptyRobloxComponentInPropBuilder = require(SduiCoreSystemParent.SharedFlags).FFlagSduiFixEmptyRobloxComponentInPropBuilder
local FFlagSduiOrderedTemplateDataSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiOrderedTemplateDataSupport
local FFlagSduiLocalizedLiterals = require(SduiCoreSystemParent.SharedFlags).FFlagSduiLocalizedLiterals
local FFlagSduiImprovedErrorDimensions = require(SduiCoreSystemParent.SharedFlags).FFlagSduiImprovedErrorDimensions
local FFlagSduiInlineNestedComponentSchema = require(SduiCoreSystemParent.SharedFlags).FFlagSduiInlineNestedComponentSchema
local FFlagSduiClientPageScope = require(SduiCoreSystemParent.SharedFlags).FFlagSduiClientPageScope
local FFlagSduiRenderPerf = require(SduiCoreSystemParent.SharedFlags).FFlagSduiRenderPerf
local t1 = {}

local function buildItemList(p1, t2: {[any]: any}, t3: {[any]: any}?, p2, p3, p4, t4: {[any]: any}?, p5, p6, b1: boolean?) -- line: 48
	-- upvalues: FFlagSduiInlineNestedComponentSchema (copy), FFlagSduiLazyNestedComponentArrayMapItemResolutionSupport (copy), FFlagSduiFixEmptyRobloxComponentInPropBuilder (copy), FFlagSduiOrderedTemplateDataSupport (copy), SduiPropUtils (copy), Signals (copy), Cryo (copy), t1 (copy), buildInputsForNestedComponent (copy), FFlagSduiLocalizedLiterals (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), FFlagSduiImprovedErrorDimensions (copy), buildConfigForComponent (copy)
	local t5 = {}

	for v38, v39 in t2 do
		local inline_component, u41

		if FFlagSduiInlineNestedComponentSchema and v39 and v39.inline_component ~= nil then
			inline_component = v39.inline_component
			u41 = true
		elseif FFlagSduiLazyNestedComponentArrayMapItemResolutionSupport and v39 and v39.roblox_component and (not FFlagSduiFixEmptyRobloxComponentInPropBuilder or v39.roblox_component ~= "") then
			inline_component = p3.getTemplateForRobloxComponent(v39.roblox_component) or p1
			u41 = false
		else
			inline_component = p1
			u41 = FFlagSduiInlineNestedComponentSchema and b1 == true
		end

		if t4 and t4[v38] then
			local v42 = t4[v38]

			if FFlagSduiOrderedTemplateDataSupport then
				if SduiPropUtils.isComponentVisible(v42, p6) then
					table.insert(t5, v42)
				end
			elseif v42.isComponentFilteredSignal == nil or not v42.isComponentFilteredSignal(p6).data then
				table.insert(t5, v42)
			end
		else
			local v43 = Signals.createComputed(function(p7) -- line: 103
				-- upvalues: FFlagSduiInlineNestedComponentSchema (copy), u41 (ref), Cryo (copy), p2 (copy), v39 (copy), t1 (copy), t3 (copy), buildInputsForNestedComponent (copy), p5 (copy), FFlagSduiLocalizedLiterals (copy), p3 (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), FFlagSduiImprovedErrorDimensions (copy)
				if FFlagSduiInlineNestedComponentSchema and u41 then
					return Cryo.Dictionary.join(p2(p7), v39 or t1)
				end

				local u71

				if t3 then
					u71 = table.clone(v39)

					local ok, result = pcall(function() -- line: 115
						-- upvalues: buildInputsForNestedComponent (copy), p2 (copy), t3 (copy), p5 (copy), p7 (copy), u71 (ref), FFlagSduiLocalizedLiterals (copy), p3 (copy)
						buildInputsForNestedComponent(p2, t3, p5, p7, u71, if not FFlagSduiLocalizedLiterals then nil else p3)
					end)

					if not ok then
						SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
							message = `Failed to build inputs for nested component in list: { SduiParseHelpers.stringifyValue(result) }`,
							name = p3.debugName,
							componentType = if not FFlagSduiImprovedErrorDimensions then nil else p3.currentComponentType,
							parserName = if not FFlagSduiImprovedErrorDimensions then nil else p3.currentParserName
						}, p3.appPage)
					end
				else
					u71 = v39
				end

				return u71
			end)
			local v44 = buildConfigForComponent(inline_component, v43, p3, p4, nil, if not FFlagSduiInlineNestedComponentSchema or not u41 then nil else p5)

			if v44 then
				if FFlagSduiOrderedTemplateDataSupport then
					if SduiPropUtils.isComponentVisible(v44, p6) then
						table.insert(t5, v44)
					end
				elseif v44.isComponentFilteredSignal == nil or not v44.isComponentFilteredSignal(p6).data then
					table.insert(t5, v44)
				end
			end
		end
	end

	return t5
end
local function buildOrderedTemplateDataList(p8, p9, p10, p11, p12) -- line: 172
	-- upvalues: FFlagSduiRenderPerf (copy), splitDottedPath (copy), Signals (copy), SduiPropUtils (copy), FFlagSduiClientPageScope (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), buildInputsForNestedComponent (copy), FFlagSduiLocalizedLiterals (copy), buildConfigForComponent (copy), SduiParseHelpers (copy), PropResultCategory (copy)
	local entry_map_path = p8.entry_map_path
	local entry_order = p8.entry_order
	local template_data_map = p8.template_data_map

	if entry_order == nil then
		error("Missing entry_order in ordered_template_data")
	end

	if template_data_map == nil or typeof(template_data_map) ~= "table" then
		error("Missing or invalid template_data_map in ordered_template_data")
	end

	local v53 = if not entry_map_path or entry_map_path == "" then nil else if not FFlagSduiRenderPerf then string.split(entry_map_path, ".") else splitDottedPath(entry_map_path)
	local v54 = if not entry_order then nil else entry_order.kind
	local v55 = if not v54 or v54.type ~= "binding_path" then nil else if not FFlagSduiRenderPerf then string.split(v54.value, ".") else splitDottedPath(v54.value)

	return Signals.createComputed(function(p13) -- line: 199
		-- upvalues: v55 (copy), SduiPropUtils (copy), p9 (copy), p10 (copy), FFlagSduiClientPageScope (copy), p11 (copy), v54 (copy), v53 (copy), template_data_map (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), Signals (copy), buildInputsForNestedComponent (copy), FFlagSduiLocalizedLiterals (copy), buildConfigForComponent (copy), p12 (copy), SduiParseHelpers (copy)
		local ok, result = pcall(function() -- line: 200
			-- upvalues: v55 (copy), SduiPropUtils (copy), p13 (copy), p9 (copy), p10 (copy), FFlagSduiClientPageScope (copy), p11 (copy), v54 (copy), v53 (copy), template_data_map (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), Signals (copy), buildInputsForNestedComponent (copy), FFlagSduiLocalizedLiterals (copy), buildConfigForComponent (copy), p12 (copy), SduiParseHelpers (copy)
			local v84 = nil

			if v55 then
				v84 = SduiPropUtils.resolveBindingPathValue(p13, v55, p9, p10, nil, nil, if not FFlagSduiClientPageScope then nil else p11)
			elseif v54 and v54.type == "literal" then
				v84 = v54.value and v54.value.items
			end

			if v84 == nil then
				error("entry_order resolved to nil in ordered_template_data")
			end

			local v85 = if not v53 then nil else SduiPropUtils.resolveBindingPathValue(p13, v53, p9, p10, nil, nil, if not FFlagSduiClientPageScope then nil else p11)
			local t6 = {}

			for _, v88 in v84 do
				local v89 = if typeof(v88) ~= "table" then v88 else v88.identifier

				if v89 ~= nil and v89 ~= "" then
					local v90 = template_data_map[v89]
					local v91 = if not v85 then nil else v85[v89]
					local v92 = if not FFlagSduiInlineNestedComponentSchema or not v90 then nil else v90.inline_component
					local v93 = if not v91 or (not v91.roblox_component or v91.roblox_component == "") then if not v90 or not v90.roblox_component then nil else v90.roblox_component else v91.roblox_component

					if v93 == nil and (not FFlagSduiInlineNestedComponentSchema or v92 == nil) then
						local v94 = if not FFlagSduiInlineNestedComponentSchema then `No roblox_component for identifier "{ v89 }" in ordered_template_data (not in template_data_map or feed entry)` else `No roblox_component or inline_component for identifier "{ v89 }" in ordered_template_data (not in template_data_map or feed entry)`

						SduiLogger.reportError(SduiErrors.SduiErrorType.UnknownTemplateDataIdentifier, {
							message = v94,
							name = p11.debugName,
							componentType = if not FFlagSduiImprovedErrorDimensions then nil else p11.currentComponentType,
							parserName = if not FFlagSduiImprovedErrorDimensions then nil else p11.currentParserName
						}, p11.appPage)
					else
						local ok, result = pcall(function() -- line: 273
							-- upvalues: FFlagSduiInlineNestedComponentSchema (copy), SduiPropUtils (copy), v93 (copy), v92 (copy), p11 (copy), v90 (copy), Signals (copy), p10 (copy), buildInputsForNestedComponent (copy), p9 (copy), FFlagSduiLocalizedLiterals (copy), v91 (copy), buildConfigForComponent (copy), p12 (copy)
							local v106 = if not FFlagSduiInlineNestedComponentSchema then SduiPropUtils.resolveTemplate(v93, p11) else SduiPropUtils.resolveTemplate(v93, v92, p11)
							local v107 = FFlagSduiInlineNestedComponentSchema and v92 ~= nil
							local v108 = if not v90 then nil else v90.inputs
							local v109 = Signals.createComputed(function(p14) -- line: 285
								-- upvalues: v107 (copy), p10 (copy), v108 (copy), buildInputsForNestedComponent (copy), p9 (copy), FFlagSduiLocalizedLiterals (copy), p11 (copy), v91 (copy)
								local v116

								if v107 then
									v116 = table.clone(p10(p14))
								else
									v116 = {}

									if v108 then
										buildInputsForNestedComponent(p10, v108, p9, p14, v116, if not FFlagSduiLocalizedLiterals then nil else p11)
									end
								end

								if v91 then
									local v117 = if not v91.input_data or (not v91.input_data.kind or not v91.input_data.kind.value) then nil else v91.input_data.kind.value

									if typeof(v117) == "table" then
										for v118, v119 in v117 do
											v116[v118] = v119
										end
									end
								end

								return v116
							end)

							return buildConfigForComponent(v106, v109, p11, p12, nil, if not FFlagSduiInlineNestedComponentSchema or not v107 then nil else p9)
						end)

						if not ok then
							local v97 = SduiParseHelpers.stringifyValue(result)

							SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
								message = `Failed to build ordered_template_data entry for identifier { v89 }: { v97 }`,
								name = p11.debugName,
								componentType = if not FFlagSduiImprovedErrorDimensions then nil else p11.currentComponentType,
								parserName = if not FFlagSduiImprovedErrorDimensions then nil else p11.currentParserName
							}, p11.appPage)
						elseif result and SduiPropUtils.isComponentVisible(result, p13) then
							table.insert(t6, result)
						end
					end
				end
			end

			return t6
		end)

		if not ok then
			local v77 = SduiParseHelpers.stringifyValue(result)

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
				message = `Failed to build ordered_template_data component list: { v77 }`,
				name = p11.debugName,
				componentType = if not FFlagSduiImprovedErrorDimensions then nil else p11.currentComponentType,
				parserName = if not FFlagSduiImprovedErrorDimensions then nil else p11.currentParserName
			}, p11.appPage)

			return {
				data = {}
			}
		end

		return {
			data = result
		}
	end), PropResultCategory.PropSignal
end
local function buildLazyNestedComponentListProp(s1: string, p15, p16, p17, p18, p19) -- line: 393
	-- upvalues: FFlagSduiImprovedErrorDimensions (copy), FFlagSduiOrderedTemplateDataSupport (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiPropUtils (copy), buildItemList (copy), PropResultCategory (copy), Signals (copy), buildInputsForNestedComponent (copy), FFlagSduiLocalizedLiterals (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), buildConfigForComponent (copy), buildOrderedTemplateDataList (copy), buildLazyNestedComponentListProp (copy), buildComponentList (copy)
	local currentComponentType = nil
	local currentParserName = nil

	if FFlagSduiImprovedErrorDimensions then
		currentComponentType = p18.currentComponentType
		currentParserName = p18.currentParserName
	end

	if s1 == "array_map" then
		local u64

		if FFlagSduiOrderedTemplateDataSupport then
			u64 = if not FFlagSduiInlineNestedComponentSchema then SduiPropUtils.resolveTemplate(p15.roblox_component, p18) else SduiPropUtils.resolveTemplateFromData(p15, p18)
		else
			if p15.roblox_component == nil then
				error("Missing templateData.roblox_component")
			end

			local v65 = p18.getTemplateForRobloxComponent(p15.roblox_component)

			if v65 == nil then
				error(`Could not find template for roblox_component { p15.roblox_component }`)
			end

			u64 = v65
		end

		local binding_path = p15.binding_path

		if binding_path == nil or binding_path == "" then
			error(`No bindingPath specified for roblox_component { p15.roblox_component }`)
		end

		local v67 = FFlagSduiInlineNestedComponentSchema and p15.inline_component ~= nil
		local u68 = nil

		return SduiPropUtils.generateDynamicBindingPropValue(binding_path, p16, p18, p17, function(p20, p21) -- line: 442
			-- upvalues: u68 (ref), buildItemList (copy), u64 (ref), p15 (copy), p17 (copy), p18 (copy), p19 (copy), p16 (copy), v67 (copy)
			u68 = buildItemList(u64, p20, p15.inputs, p17, p18, p19, u68, p16, p21, v67)

			return u68
		end), PropResultCategory.PropSignal
	end

	if s1 == "item_list" then
		if typeof(p15) ~= "table" then
			error(`Missing or invalid templateDataList { typeof(p15) }`)
		end

		local items = p15.items

		if typeof(items) ~= "table" then
			error(`Missing or invalid templateDataList.items { typeof(p15) }`)
		end

		return Signals.createComputed(function(p22) -- line: 472
			-- upvalues: items (copy), FFlagSduiOrderedTemplateDataSupport (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiPropUtils (copy), p18 (copy), p17 (copy), Signals (copy), buildInputsForNestedComponent (copy), p16 (copy), FFlagSduiLocalizedLiterals (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), buildConfigForComponent (copy), p19 (copy)
			local ok, result = pcall(function() -- line: 473
				-- upvalues: items (copy), FFlagSduiOrderedTemplateDataSupport (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiPropUtils (copy), p18 (copy), p17 (copy), Signals (copy), buildInputsForNestedComponent (copy), p16 (copy), FFlagSduiLocalizedLiterals (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), buildConfigForComponent (copy), p19 (copy), p22 (copy)
				local t7 = {}

				for _, v100 in items do
					local v101

					if FFlagSduiOrderedTemplateDataSupport then
						v101 = if not FFlagSduiInlineNestedComponentSchema then SduiPropUtils.resolveTemplate(v100.roblox_component, p18) else SduiPropUtils.resolveTemplateFromData(v100, p18)
					else
						if v100.roblox_component == nil then
							error("Missing templateData.roblox_component")
						end

						v101 = p18.getTemplateForRobloxComponent(v100.roblox_component)

						if v101 == nil then
							error(`Could not find template for roblox_component { v100.roblox_component }`)
						end
					end

					local v102 = FFlagSduiInlineNestedComponentSchema and v100.inline_component ~= nil
					local inputs = v100.inputs
					local v104 = if not FFlagSduiInlineNestedComponentSchema or not v102 then Signals.createComputed(function(p23) -- line: 501
						-- upvalues: inputs (copy), buildInputsForNestedComponent (copy), p17 (copy), p16 (copy), FFlagSduiLocalizedLiterals (copy), p18 (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref)
						local t8 = {}

						if inputs then
							local ok, result = pcall(function() -- line: 504
								-- upvalues: buildInputsForNestedComponent (copy), p17 (copy), inputs (copy), p16 (copy), p23 (copy), t8 (copy), FFlagSduiLocalizedLiterals (copy), p18 (copy)
								buildInputsForNestedComponent(p17, inputs, p16, p23, t8, if not FFlagSduiLocalizedLiterals then nil else p18)
							end)

							if not ok then
								local v114 = SduiParseHelpers.stringifyValue(result)

								SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
									message = `Failed to build inputs for nested component in item_list: { v114 }`,
									name = p18.debugName,
									componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
									parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
								}, p18.appPage)
							end
						end

						return t8
					end) else p17
					local v105 = buildConfigForComponent(v101, v104, p18, p19, nil, if not FFlagSduiInlineNestedComponentSchema or not v102 then nil else p16)

					if v105 then
						if FFlagSduiOrderedTemplateDataSupport then
							if SduiPropUtils.isComponentVisible(v105, p22) then
								table.insert(t7, v105)
							end
						elseif v105.isComponentFilteredSignal == nil or not v105.isComponentFilteredSignal(p22).data then
							table.insert(t7, v105)
						end
					end
				end

				return t7
			end)

			if not ok then
				local v83 = SduiParseHelpers.stringifyValue(result)

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
					message = `Failed to build item_list component list: { v83 }`,
					name = p18.debugName,
					componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
					parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
				}, p18.appPage)

				return {
					data = {}
				}
			end

			return {
				data = result
			}
		end), PropResultCategory.PropSignal
	end

	if FFlagSduiOrderedTemplateDataSupport and s1 == "ordered_template_data" then
		return buildOrderedTemplateDataList(p15, p16, p17, p18, p19)
	end

	if s1 == "conditional" then
		return SduiPropUtils.generateConditionalPropValue(p15, p16, p18, p19, p17, buildLazyNestedComponentListProp), PropResultCategory.PropSignal
	end

	if s1 == "component_list" then
		return buildComponentList(s1, p15, p16, p17, p18, p19)
	end

	error(`Could not build prop. Unknown propDefinitionType: { s1 }`)
end

return buildLazyNestedComponentListProp
