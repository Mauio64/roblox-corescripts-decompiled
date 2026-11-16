local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/React")

local SduiBuilderTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local sduiErrorType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors").SduiErrorType
local SduiParseHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiParseHelpers")
local sduiBuilderProcessingPhase = SduiBuilderTypes.SduiBuilderProcessingPhase

local serverBindingPropMap = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCompat").ServerBindingPropMap
local function parseProps(p2, item, p3, data, p4, p5, p6)
	if not item then
		return
	end

	assert(item, "props must exist")

	local v5 = p5 or data.componentDefinitions:getPropParsers(p2)

	if not v5 then
		return
	end

	assert(v5, "componentInterface must exist")

	for k, item2 in item do
		local v6 = v5[k]

		if not (v6 and (p6 ~= sduiBuilderProcessingPhase.Render or data.componentDefinitions:doesParserRequireRenderContext(v6))) then
			continue
		end

		local success, result = pcall(function()
			if typeof(v6) == "table" then
				if typeof(item2) ~= "table" then
					error({
						message = `Invalid input {typeof(item2)} for prop. Expected table`
					})
				end

				local serverBindingProps = nil

				for k2, v7 in item2 do
					local serverBindingProp = serverBindingPropMap[k2]

					if not serverBindingProp then
						continue
					end

					serverBindingProps = serverBindingProps or {}
					serverBindingProps[k2] = serverBindingProp
				end

				if serverBindingProps then
					for k2, v7 in serverBindingProps do
						item2[v7] = item2[k2]
					end
				end

				parseProps(p2, item2, p3, data, p4, v6, p6)

				return item2
			elseif item2 == "NULL_PROP" then
				return React.None
			else
				return v6(item2, data, p4, p6)
			end
		end)

		if success then
			if result == React.None then
				item[k] = nil
			else
				item[k] = result
			end
		else
			data.dependencies.logger.reportError(
				sduiErrorType.FailedToParseProp,
				Cryo.Dictionary.union(
					{
						name = p3,
						componentType = p2,
						propName = k,
						value = SduiParseHelpers.stringifyValue(item2)
					},
					typeof(result) ~= "table" and (typeof(result) == "string" and {
						message = result
					} or {}) or result
				),
				data.appPage
			)

			if typeof(result) == "table" then
				if result.overrideValue then
					item[k] = result.overrideValue
				else
					item[k] = nil
				end
			end
		end
	end
end
return parseProps
