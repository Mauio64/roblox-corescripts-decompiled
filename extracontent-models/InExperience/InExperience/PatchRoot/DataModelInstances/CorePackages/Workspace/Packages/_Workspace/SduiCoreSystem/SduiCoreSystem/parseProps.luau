local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local SduiBuilderTypes = require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiConfigTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiErrorType = SduiErrors.SduiErrorType
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
local SduiBuilderProcessingPhase = SduiBuilderTypes.SduiBuilderProcessingPhase

local SduiCompat = require(parent.SduiCompat)
local ServerBindingPropMap = SduiCompat.ServerBindingPropMap
local function parseProps(componentType, item, name: string, data, p, p2, p3)
	if not item then
		return
	end

	assert(item, "props must exist")

	local v = p2 or data.componentDefinitions:getPropParsers(componentType)

	if not v then
		return
	end

	assert(v, "componentInterface must exist")

	for k, item2 in item do
		local v2 = v[k]

		if not (v2 and (p3 ~= SduiBuilderProcessingPhase.Render or data.componentDefinitions:doesParserRequireRenderContext(v2))) then
			continue
		end

		local success, result = pcall(function()
			if typeof(v2) == "table" then
				if typeof(item2) ~= "table" then
					error({
						message = `Invalid input {typeof(item2)} for prop. Expected table`
					})
				end

				local serverBindingProps = nil

				for k2, _ in item2 do
					local serverBindingProp = ServerBindingPropMap[k2]

					if not serverBindingProp then
						continue
					end

					serverBindingProps = serverBindingProps or {}
					serverBindingProps[k2] = serverBindingProp
				end

				if serverBindingProps then
					for k2, v3 in serverBindingProps do
						item2[v3] = item2[k2]
					end
				end

				parseProps(componentType, item2, name, data, p, v2, p3)

				return item2
			elseif item2 == "NULL_PROP" then
				return React.None
			else
				return v2(item2, data, p, p3)
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
				SduiErrorType.FailedToParseProp,
				Cryo.Dictionary.union(
					{
						name = name,
						componentType = componentType,
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
