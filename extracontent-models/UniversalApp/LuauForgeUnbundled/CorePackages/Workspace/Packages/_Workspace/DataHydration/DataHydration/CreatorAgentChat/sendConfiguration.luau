require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/acpSession")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/model")
local fFlagBuildExperienceAdvancedPreviewSpecs = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceAdvancedPreviewSpecs

return {
	capture = function(p2, p3)
		assert(p2 == "default" or p2 == "advanced", "invalid model tier")
		local clone = if p3 ~= nil then table.clone(p3) else nil

		if clone ~= nil then
			if clone.clientToolConfig ~= nil then
				local clone2 = table.clone(clone.clientToolConfig)
				clone2.tools = table.freeze(table.clone(clone2.tools))
				clone.clientToolConfig = table.freeze(clone2)
			end

			table.freeze(clone)
		end

		return table.freeze({ tier = p2, experiment = clone })
	end,
	sameExperiment = function(data, data2): boolean
		if data == nil or data2 == nil then
			return data == data2
		end

		if
			data.specVersion ~= data2.specVersion
			or data.runId ~= data2.runId
			or fFlagBuildExperienceAdvancedPreviewSpecs and data.specName ~= data2.specName
		then
			return false
		end

		local clientToolConfig = data.clientToolConfig
		local clientToolConfig2 = data2.clientToolConfig

		if clientToolConfig == nil or clientToolConfig2 == nil then
			return clientToolConfig == clientToolConfig2
		end

		if
			clientToolConfig.mode ~= clientToolConfig2.mode
			or #clientToolConfig.tools ~= #clientToolConfig2.tools
		then
			return false
		end

		for k, tool in clientToolConfig.tools do
			if tool ~= clientToolConfig2.tools[k] then
				return false
			end
		end

		return true
	end
}
