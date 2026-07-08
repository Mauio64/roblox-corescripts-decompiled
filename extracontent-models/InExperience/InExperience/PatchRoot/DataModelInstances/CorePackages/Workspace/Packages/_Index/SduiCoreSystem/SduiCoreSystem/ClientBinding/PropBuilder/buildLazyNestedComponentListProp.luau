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
local FFlagSduiOrderedTemplateDataSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiOrderedTemplateDataSupport
local FFlagSduiLocalizedLiterals = require(SduiCoreSystemParent.SharedFlags).FFlagSduiLocalizedLiterals
local FFlagSduiImprovedErrorDimensions = require(SduiCoreSystemParent.SharedFlags).FFlagSduiImprovedErrorDimensions
local FFlagSduiInlineNestedComponentSchema = require(SduiCoreSystemParent.SharedFlags).FFlagSduiInlineNestedComponentSchema
local FFlagSduiClientPageScope = require(SduiCoreSystemParent.SharedFlags).FFlagSduiClientPageScope
local FFlagSduiRenderPerf = require(SduiCoreSystemParent.SharedFlags).FFlagSduiRenderPerf
local t1 = {}

local function buildItemList(p1, t2: {[any]: any}, t3: {[any]: any}?, p2, p3, p4, t4: {[any]: any}?, p5, p6, b1: boolean?) -- line: 46
	-- upvalues: FFlagSduiInlineNestedComponentSchema (copy), FFlagSduiLazyNestedComponentArrayMapItemResolutionSupport (copy), FFlagSduiOrderedTemplateDataSupport (copy), SduiPropUtils (copy), Signals (copy), Cryo (copy), t1 (copy), buildInputsForNestedComponent (copy), FFlagSduiLocalizedLiterals (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), FFlagSduiImprovedErrorDimensions (copy), buildConfigForComponent (copy)
	local t5 = {}

	for v37, v38 in t2 do
		local inline_component, u40

		if FFlagSduiInlineNestedComponentSchema and v38 and v38.inline_component ~= nil then
			inline_component = v38.inline_component
			u40 = true
		elseif FFlagSduiLazyNestedComponentArrayMapItemResolutionSupport and v38 and v38.roblox_component then
			inline_component = p3.getTemplateForRobloxComponent(v38.roblox_component) or p1
			u40 = false
		else
			inline_component = p1
			u40 = FFlagSduiInlineNestedComponentSchema and b1 == true
		end

		if t4 and t4[v37] then
			local v41 = t4[v37]

			if FFlagSduiOrderedTemplateDataSupport then
				if SduiPropUtils.isComponentVisible(v41, p6) then
					table.insert(t5, v41)
				end
			elseif v41.isComponentFilteredSignal == nil or not v41.isComponentFilteredSignal(p6).data then
				table.insert(t5, v41)
			end
		else
			local v42 = Signals.createComputed(function(p7) -- line: 96
				-- upvalues: FFlagSduiInlineNestedComponentSchema (copy), u40 (ref), Cryo (copy), p2 (copy), v38 (copy), t1 (copy), t3 (copy), buildInputsForNestedComponent (copy), p5 (copy), FFlagSduiLocalizedLiterals (copy), p3 (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy), FFlagSduiImprovedErrorDimensions (copy)
				if FFlagSduiInlineNestedComponentSchema and u40 then
					return Cryo.Dictionary.join(p2(p7), v38 or t1)
				end

				local u70

				if t3 then
					u70 = table.clone(v38)

					local ok, result = pcall(function() -- line: 108
						-- upvalues: buildInputsForNestedComponent (copy), p2 (copy), t3 (copy), p5 (copy), p7 (copy), u70 (ref), FFlagSduiLocalizedLiterals (copy), p3 (copy)
						buildInputsForNestedComponent(p2, t3, p5, p7, u70, if not FFlagSduiLocalizedLiterals then nil else p3)
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
					u70 = v38
				end

				return u70
			end)
			local v43 = buildConfigForComponent(inline_component, v42, p3, p4, nil, if not FFlagSduiInlineNestedComponentSchema or not u40 then nil else p5)

			if v43 then
				if FFlagSduiOrderedTemplateDataSupport then
					if SduiPropUtils.isComponentVisible(v43, p6) then
						table.insert(t5, v43)
					end
				elseif v43.isComponentFilteredSignal == nil or not v43.isComponentFilteredSignal(p6).data then
					table.insert(t5, v43)
				end
			end
		end
	end

	return t5
end
local function buildOrderedTemplateDataList(p8, p9, p10, p11, p12) -- line: 165
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

	local v52 = if not entry_map_path or entry_map_path == "" then nil else if not FFlagSduiRenderPerf then string.split(entry_map_path, ".") else splitDottedPath(entry_map_path)
	local v53 = if not entry_order then nil else entry_order.kind
	local v54 = if not v53 or v53.type ~= "binding_path" then nil else if not FFlagSduiRenderPerf then string.split(v53.value, ".") else splitDottedPath(v53.value)

	return Signals.createComputed(function(p13) -- line: 192
		-- upvalues: v54 (copy), SduiPropUtils (copy), p9 (copy), p10 (copy), FFlagSduiClientPageScope (copy), p11 (copy), v53 (copy), v52 (copy), template_data_map (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), Signals (copy), buildInputsForNestedComponent (copy), FFlagSduiLocalizedLiterals (copy), buildConfigForComponent (copy), p12 (copy), SduiParseHelpers (copy)
		local ok, result = pcall(function() -- line: 193
			-- upvalues: v54 (copy), SduiPropUtils (copy), p13 (copy), p9 (copy), p10 (copy), FFlagSduiClientPageScope (copy), p11 (copy), v53 (copy), v52 (copy), template_data_map (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), Signals (copy), buildInputsForNestedComponent (copy), FFlagSduiLocalizedLiterals (copy), buildConfigForComponent (copy), p12 (copy), SduiParseHelpers (copy)
			local v83 = nil

			if v54 then
				v83 = SduiPropUtils.resolveBindingPathValue(p13, v54, p9, p10, nil, nil, if not FFlagSduiClientPageScope then nil else p11)
			elseif v53 and v53.type == "literal" then
				v83 = v53.value and v53.value.items
			end

			if v83 == nil then
				error("entry_order resolved to nil in ordered_template_data")
			end

			local v84 = if not v52 then nil else SduiPropUtils.resolveBindingPathValue(p13, v52, p9, p10, nil, nil, if not FFlagSduiClientPageScope then nil else p11)
			local t6 = {}

			for _, v87 in v83 do
				local v88 = if typeof(v87) ~= "table" then v87 else v87.identifier

				if v88 ~= nil and v88 ~= "" then
					local v89 = template_data_map[v88]
					local v90 = if not v84 then nil else v84[v88]
					local v91 = if not FFlagSduiInlineNestedComponentSchema or not v89 then nil else v89.inline_component
					local v92 = if not v90 or (not v90.roblox_component or v90.roblox_component == "") then if not v89 or not v89.roblox_component then nil else v89.roblox_component else v90.roblox_component

					if v92 == nil and (not FFlagSduiInlineNestedComponentSchema or v91 == nil) then
						local v93 = if not FFlagSduiInlineNestedComponentSchema then `No roblox_component for identifier "{ v88 }" in ordered_template_data (not in template_data_map or feed entry)` else `No roblox_component or inline_component for identifier "{ v88 }" in ordered_template_data (not in template_data_map or feed entry)`

						SduiLogger.reportError(SduiErrors.SduiErrorType.UnknownTemplateDataIdentifier, {
							message = v93,
							name = p11.debugName,
							componentType = if not FFlagSduiImprovedErrorDimensions then nil else p11.currentComponentType,
							parserName = if not FFlagSduiImprovedErrorDimensions then nil else p11.currentParserName
						}, p11.appPage)
					else
						local ok, result = pcall(function() -- line: 266
							-- upvalues: FFlagSduiInlineNestedComponentSchema (copy), SduiPropUtils (copy), v92 (copy), v91 (copy), p11 (copy), v89 (copy), Signals (copy), p10 (copy), buildInputsForNestedComponent (copy), p9 (copy), FFlagSduiLocalizedLiterals (copy), v90 (copy), buildConfigForComponent (copy), p12 (copy)
							local v105 = if not FFlagSduiInlineNestedComponentSchema then SduiPropUtils.resolveTemplate(v92, p11) else SduiPropUtils.resolveTemplate(v92, v91, p11)
							local v106 = FFlagSduiInlineNestedComponentSchema and v91 ~= nil
							local v107 = if not v89 then nil else v89.inputs
							local v108 = Signals.createComputed(function(p14) -- line: 278
								-- upvalues: v106 (copy), p10 (copy), v107 (copy), buildInputsForNestedComponent (copy), p9 (copy), FFlagSduiLocalizedLiterals (copy), p11 (copy), v90 (copy)
								local v115

								if v106 then
									v115 = table.clone(p10(p14))
								else
									v115 = {}

									if v107 then
										buildInputsForNestedComponent(p10, v107, p9, p14, v115, if not FFlagSduiLocalizedLiterals then nil else p11)
									end
								end

								if v90 then
									local v116 = if not v90.input_data or (not v90.input_data.kind or not v90.input_data.kind.value) then nil else v90.input_data.kind.value

									if typeof(v116) == "table" then
										for v117, v118 in v116 do
											v115[v117] = v118
										end
									end
								end

								return v115
							end)

							return buildConfigForComponent(v105, v108, p11, p12, nil, if not FFlagSduiInlineNestedComponentSchema or not v106 then nil else p9)
						end)

						if not ok then
							local v96 = SduiParseHelpers.stringifyValue(result)

							SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
								message = `Failed to build ordered_template_data entry for identifier { v88 }: { v96 }`,
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
			local v76 = SduiParseHelpers.stringifyValue(result)

			SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
				message = `Failed to build ordered_template_data component list: { v76 }`,
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
local function buildLazyNestedComponentListProp(s1: string, p15, p16, p17, p18, p19) -- line: 386
	-- upvalues: FFlagSduiImprovedErrorDimensions (copy), FFlagSduiOrderedTemplateDataSupport (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiPropUtils (copy), buildItemList (copy), PropResultCategory (copy), Signals (copy), buildInputsForNestedComponent (copy), FFlagSduiLocalizedLiterals (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), buildConfigForComponent (copy), buildOrderedTemplateDataList (copy), buildLazyNestedComponentListProp (copy), buildComponentList (copy)
	local currentComponentType = nil
	local currentParserName = nil

	if FFlagSduiImprovedErrorDimensions then
		currentComponentType = p18.currentComponentType
		currentParserName = p18.currentParserName
	end

	if s1 == "array_map" then
		local u63

		if FFlagSduiOrderedTemplateDataSupport then
			u63 = if not FFlagSduiInlineNestedComponentSchema then SduiPropUtils.resolveTemplate(p15.roblox_component, p18) else SduiPropUtils.resolveTemplateFromData(p15, p18)
		else
			if p15.roblox_component == nil then
				error("Missing templateData.roblox_component")
			end

			local v64 = p18.getTemplateForRobloxComponent(p15.roblox_component)

			if v64 == nil then
				error(`Could not find template for roblox_component { p15.roblox_component }`)
			end

			u63 = v64
		end

		local binding_path = p15.binding_path

		if binding_path == nil or binding_path == "" then
			error(`No bindingPath specified for roblox_component { p15.roblox_component }`)
		end

		local v66 = FFlagSduiInlineNestedComponentSchema and p15.inline_component ~= nil
		local u67 = nil

		return SduiPropUtils.generateDynamicBindingPropValue(binding_path, p16, p18, p17, function(p20, p21) -- line: 435
			-- upvalues: u67 (ref), buildItemList (copy), u63 (ref), p15 (copy), p17 (copy), p18 (copy), p19 (copy), p16 (copy), v66 (copy)
			u67 = buildItemList(u63, p20, p15.inputs, p17, p18, p19, u67, p16, p21, v66)

			return u67
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

		return Signals.createComputed(function(p22) -- line: 465
			-- upvalues: items (copy), FFlagSduiOrderedTemplateDataSupport (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiPropUtils (copy), p18 (copy), p17 (copy), Signals (copy), buildInputsForNestedComponent (copy), p16 (copy), FFlagSduiLocalizedLiterals (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), buildConfigForComponent (copy), p19 (copy)
			local ok, result = pcall(function() -- line: 466
				-- upvalues: items (copy), FFlagSduiOrderedTemplateDataSupport (copy), FFlagSduiInlineNestedComponentSchema (copy), SduiPropUtils (copy), p18 (copy), p17 (copy), Signals (copy), buildInputsForNestedComponent (copy), p16 (copy), FFlagSduiLocalizedLiterals (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref), buildConfigForComponent (copy), p19 (copy), p22 (copy)
				local t7 = {}

				for _, v99 in items do
					local v100

					if FFlagSduiOrderedTemplateDataSupport then
						v100 = if not FFlagSduiInlineNestedComponentSchema then SduiPropUtils.resolveTemplate(v99.roblox_component, p18) else SduiPropUtils.resolveTemplateFromData(v99, p18)
					else
						if v99.roblox_component == nil then
							error("Missing templateData.roblox_component")
						end

						v100 = p18.getTemplateForRobloxComponent(v99.roblox_component)

						if v100 == nil then
							error(`Could not find template for roblox_component { v99.roblox_component }`)
						end
					end

					local v101 = FFlagSduiInlineNestedComponentSchema and v99.inline_component ~= nil
					local inputs = v99.inputs
					local v103 = if not FFlagSduiInlineNestedComponentSchema or not v101 then Signals.createComputed(function(p23) -- line: 494
						-- upvalues: inputs (copy), buildInputsForNestedComponent (copy), p17 (copy), p16 (copy), FFlagSduiLocalizedLiterals (copy), p18 (copy), SduiParseHelpers (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiImprovedErrorDimensions (copy), currentComponentType (ref), currentParserName (ref)
						local t8 = {}

						if inputs then
							local ok, result = pcall(function() -- line: 497
								-- upvalues: buildInputsForNestedComponent (copy), p17 (copy), inputs (copy), p16 (copy), p23 (copy), t8 (copy), FFlagSduiLocalizedLiterals (copy), p18 (copy)
								buildInputsForNestedComponent(p17, inputs, p16, p23, t8, if not FFlagSduiLocalizedLiterals then nil else p18)
							end)

							if not ok then
								local v113 = SduiParseHelpers.stringifyValue(result)

								SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
									message = `Failed to build inputs for nested component in item_list: { v113 }`,
									name = p18.debugName,
									componentType = if not FFlagSduiImprovedErrorDimensions then nil else currentComponentType,
									parserName = if not FFlagSduiImprovedErrorDimensions then nil else currentParserName
								}, p18.appPage)
							end
						end

						return t8
					end) else p17
					local v104 = buildConfigForComponent(v100, v103, p18, p19, nil, if not FFlagSduiInlineNestedComponentSchema or not v101 then nil else p16)

					if v104 then
						if FFlagSduiOrderedTemplateDataSupport then
							if SduiPropUtils.isComponentVisible(v104, p22) then
								table.insert(t7, v104)
							end
						elseif v104.isComponentFilteredSignal == nil or not v104.isComponentFilteredSignal(p22).data then
							table.insert(t7, v104)
						end
					end
				end

				return t7
			end)

			if not ok then
				local v82 = SduiParseHelpers.stringifyValue(result)

				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
					message = `Failed to build item_list component list: { v82 }`,
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
