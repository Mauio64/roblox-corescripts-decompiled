local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local FFlagBuildExperienceManageDevProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceManageDevProduct")

local v5 = SharedFlags.FFlagBuildExperienceManageMonetizationTool and FFlagBuildExperienceManageDevProduct

local v6 = {}
local v7 = {}
local v8

if v5 then
	local studioManageMonetizationTool = CreatorAgentChat.StudioManageMonetizationTool
	local v9 = {
		developerProduct = true,
		gamePass = SharedFlags.FFlagBuildExperienceManageGamePass,
		subscription = SharedFlags.FFlagBuildExperienceManageSubscription
	}

	for k, v10 in studioManageMonetizationTool.KINDS do
		if not v9[v10] then
			continue
		end

		table.insert(v6, v10)
		v7[v10] = studioManageMonetizationTool.forKind(v10, v9)
	end

	v8 = studioManageMonetizationTool.createLocalToolDefinition(v6)
end

return { isEnabled = v5, toolsByKind = v7, localToolDefinition = v8 }
