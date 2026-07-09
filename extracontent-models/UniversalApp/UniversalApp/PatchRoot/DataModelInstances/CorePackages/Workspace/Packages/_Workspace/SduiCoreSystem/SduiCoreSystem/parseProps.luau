local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local Cryo = require(SduiCoreSystemParent.Cryo)
local React = require(SduiCoreSystemParent.React)
local SduiBuilderTypes = require(SduiCoreSystem.SduiBuilderTypes)

require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiConfigTypes)

local SduiErrorType = require(SduiCoreSystem.SduiErrors).SduiErrorType
local SduiParseHelpers = require(SduiCoreSystem.SduiParseHelpers)
local SduiBuilderProcessingPhase = SduiBuilderTypes.SduiBuilderProcessingPhase
local ServerBindingPropMap = require(SduiCoreSystemParent.SduiCompat).ServerBindingPropMap

local function parseProps(p1, t1: {[any]: any}, s1: string, p2, p3, p4, p5) -- line: 32
	-- upvalues: SduiBuilderProcessingPhase (copy), ServerBindingPropMap (copy), parseProps (copy), React (copy), SduiErrorType (copy), Cryo (copy), SduiParseHelpers (copy)
	if not t1 then
		return
	end

	assert(t1, "props must exist")

	local v18 = p4 or p2.componentDefinitions:getPropParsers(p1)

	if not v18 then
		return
	end

	assert(v18, "componentInterface must exist")

	for v19, v20 in t1 do
		local v21 = v18[v19]

		if v21 and (p5 ~= SduiBuilderProcessingPhase.Render or p2.componentDefinitions:doesParserRequireRenderContext(v21)) then
			local ok, result = pcall(function() -- line: 66
				-- upvalues: v21 (copy), v20 (copy), ServerBindingPropMap (copy), parseProps (copy), p1 (copy), s1 (copy), p2 (copy), p3 (copy), p5 (copy), React (copy)
				if typeof(v21) == "table" then
					if typeof(v20) ~= "table" then
						error({
							message = `Invalid input { typeof(v20) } for prop. Expected table`
						})
					end

					local v24 = nil

					for v25, _ in v20 do
						local v27 = ServerBindingPropMap[v25]

						if v27 then
							v24 = v24 or {}
							v24[v25] = v27
						end
					end

					if v24 then
						for v28, v29 in v24 do
							v20[v29] = v20[v28]
						end
					end

					parseProps(p1, v20, s1, p2, p3, v21, p5)

					return v20
				end

				if v20 == "NULL_PROP" then
					return React.None
				end

				return v21(v20, p2, p3, p5)
			end)

			if not ok then
				p2.dependencies.logger.reportError(SduiErrorType.FailedToParseProp, Cryo.Dictionary.union({
					name = s1,
					componentType = p1,
					propName = v19,
					value = SduiParseHelpers.stringifyValue(v20)
				}, if typeof(result) ~= "table" then if typeof(result) ~= "string" then {} else {
					message = result
				} else result), p2.appPage)

				if typeof(result) == "table" then
					if result.overrideValue then
						t1[v19] = result.overrideValue
					else
						t1[v19] = nil
					end
				end
			elseif result == React.None then
				t1[v19] = nil
			else
				t1[v19] = result
			end
		end
	end
end

return parseProps
