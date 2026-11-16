local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)

local isEnabled = SharedFlags.FFlagBuildExperienceManageMonetizationTool and FFlagBuildExperienceManageDevProduct

local v = {}
local toolsByKind = {}
local localToolDefinition

if isEnabled then
	local studioManageMonetizationTool = CreatorAgentChat.StudioManageMonetizationTool
	local v2 = {
		developerProduct = true,
		gamePass = SharedFlags.FFlagBuildExperienceManageGamePass,
		subscription = SharedFlags.FFlagBuildExperienceManageSubscription
	}

	for _, v3 in studioManageMonetizationTool.KINDS do
		if not v2[v3] then
			continue
		end

		table.insert(v, v3)
		toolsByKind[v3] = studioManageMonetizationTool.forKind(v3, v2)
	end

	localToolDefinition = studioManageMonetizationTool.createLocalToolDefinition(v)
end

return {
	isEnabled = isEnabled,
	toolsByKind = toolsByKind,
	localToolDefinition = localToolDefinition
}
