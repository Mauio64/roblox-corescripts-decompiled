local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)

require(SduiCoreSystemParent.Signals)

local buildInputsForNestedComponent = require(SduiCoreSystem.ClientBinding.PropBuilder.buildInputsForNestedComponent)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.ClientBinding.SduiClientBindingTypes)

local SduiClientBindingBuilder = require(SduiCoreSystem.ClientBinding.SduiClientBindingBuilder)
local SduiPropUtils = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiPropUtils)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local SduiErrors = require(SduiCoreSystem.SduiErrors)

require(SduiCoreSystem.SduiComponentType)

local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)

require(SduiCoreSystem.ClientBinding.PropBuilder.SduiListEntryNormalizer)

local FFlagSduiPoolBackedFeed = require(SduiCoreSystemParent.SharedFlags).FFlagSduiPoolBackedFeed
local buildConfigForComponent = SduiClientBindingBuilder.buildConfigForComponent
local SduiDeferredItemStub = require(SduiCoreSystem.ClientBinding.PropBuilder.SduiDeferredItemStub)
local FFlagSduiDeferredListItems = require(SduiCoreSystemParent.SharedFlags).FFlagSduiDeferredListItems
local t1 = {}

local function unwrapEntryData(p1) -- line: 75
	if typeof(p1) ~= "table" then
		return {
			value = p1
		}
	end

	local input_data = p1.input_data

	if input_data and input_data.kind and input_data.kind.value then
		local t2 = {}

		if typeof(input_data.kind.value) == "table" then
			for v21, v22 in input_data.kind.value do
				t2[v21] = v22
			end
		end

		return t2
	end

	return table.clone(p1)
end
local function fillInputs(t3: {[any]: any}, t4: {[any]: any}?, p2, p3, p4, p5, t5: {[any]: any}) -- line: 99
	-- upvalues: buildInputsForNestedComponent (copy), SduiLogger (copy), SduiErrors (copy), SduiParseHelpers (copy)
	if t4 == nil then
		return
	end

	local ok, result = pcall(function() -- line: 111
		-- upvalues: buildInputsForNestedComponent (copy), p2 (copy), t4 (copy), p3 (copy), p4 (copy), t3 (copy), p5 (copy)
		buildInputsForNestedComponent(p2, t4, p3, p4, t3, p5)
	end)

	if not ok then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
			message = `Failed to build inputs for ComponentList item: { SduiParseHelpers.stringifyValue(result) }`,
			name = t5.name,
			componentType = t5.componentType,
			parserName = t5.parserName
		}, t5.appPage)
	end
end

return {
	captureErrorContext = function(p6) -- line: 63
		return {
			name = p6.debugName,
			componentType = p6.currentComponentType,
			parserName = p6.currentParserName,
			appPage = p6.appPage
		}
	end,
	createInputSlicer = function(p7, p8, p9, t6: {[any]: any}, p10: ((...any) -> ...any)?) -- line: 142
		-- upvalues: fillInputs (copy), Cryo (copy), t1 (copy), unwrapEntryData (copy), FFlagSduiPoolBackedFeed (copy)
		local function rawSlice(p11, b1: boolean) -- line: 149
			-- upvalues: p7 (copy), fillInputs (copy), p8 (copy), p9 (copy), t6 (copy), Cryo (copy), t1 (copy), unwrapEntryData (copy)
			if p11.sourceMode == "literal" then
				if b1 then
					return p7
				end

				return function(p12) -- line: 159
					-- upvalues: fillInputs (copy), p11 (copy), p7 (copy), p8 (copy), p9 (copy), t6 (copy)
					local t7 = {}

					fillInputs(t7, p11.inputs, p7, p8, p12, p9, t6)

					return t7
				end
			end

			local item = p11.item

			if b1 then
				return function(p13) -- line: 179
					-- upvalues: Cryo (copy), p7 (copy), item (copy), t1 (copy)
					return Cryo.Dictionary.join(p7(p13), if typeof(item) ~= "table" then t1 else item)
				end
			end

			return function(p14) -- line: 186
				-- upvalues: unwrapEntryData (copy), item (copy), fillInputs (copy), p11 (copy), p7 (copy), p8 (copy), p9 (copy), t6 (copy)
				local v77 = unwrapEntryData(item)

				fillInputs(v77, p11.inputs, p7, p8, p14, p9, t6)

				return v77
			end
		end

		if not FFlagSduiPoolBackedFeed or p10 == nil then
			return rawSlice
		end

		return function(p15, p16) -- line: 204
			-- upvalues: rawSlice (copy), p10 (copy), Cryo (copy)
			local v72 = rawSlice(p15, p16)

			return function(p17) -- line: 206
				-- upvalues: p10 (copy), p15 (copy), v72 (copy), Cryo (copy)
				local v79 = p10(p15)

				if v79 == nil then
					return v72(p17)
				end

				return Cryo.Dictionary.join(v72(p17), v79)
			end
		end
	end,
	buildEntryConfigs = function(t8: {[any]: any}, p18: ((...any) -> ...any), t9: {[any]: any}?, p19, t10: {[any]: any}, p20, p21, p22, b2: boolean?, p23: ((...any) -> ...any)?) -- line: 235
		-- upvalues: FFlagSduiPoolBackedFeed (copy), SduiPropUtils (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiDeferredListItems (copy), SduiDeferredItemStub (copy), buildConfigForComponent (copy)
		local t11 = {}
		local t12 = {}
		local v50 = FFlagSduiPoolBackedFeed and p23 ~= nil

		for v51, v52 in t8 do
			if t9 and t9[v51] then
				local v53 = t9[v51]

				if SduiPropUtils.isComponentVisible(v53, p22) then
					if v50 then
						local v54 = p23(v52, p22)

						if v54 ~= nil then
							for v55, v56 in v54 do
								v53[v55] = v56
							end
						end
					end

					table.insert(t11, v53)
					table.insert(t12, v51)
				end
			elseif v52.template == nil then
				SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToParseProp, {
					message = `No template found for ComponentList item (identifier: { v52.identifier or tostring(v51) })`,
					name = t10.name,
					componentType = t10.componentType,
					parserName = t10.parserName
				}, t10.appPage)
			else
				local v57 = p18(v52, v52.isInline)
				local v58 = if not v52.isInline then nil else p21

				if FFlagSduiDeferredListItems and b2 and (not v52.template or (not v52.template.kind or (not v52.template.kind.value or (not v52.template.kind.value.shared or v52.template.kind.value.shared.is_component_filtered == nil)))) then
					local v59 = SduiDeferredItemStub.makeStub(v52.template, v57, p19, p20, v58, t10)

					if v50 then
						local v60 = p23(v52, p22)

						if v60 ~= nil then
							for v61, v62 in v60 do
								v59[v61] = v62
							end
						end
					end

					table.insert(t11, v59)
					table.insert(t12, v51)
				else
					local v63 = buildConfigForComponent(v52.template, v57, p19, p20, nil, v58)

					if v63 and SduiPropUtils.isComponentVisible(v63, p22) then
						if v50 then
							local v64 = p23(v52, p22)

							if v64 ~= nil then
								for v65, v66 in v64 do
									v63[v65] = v66
								end
							end
						end

						table.insert(t11, v63)
						table.insert(t12, v51)
					end
				end
			end
		end

		return t11, t12
	end
}
