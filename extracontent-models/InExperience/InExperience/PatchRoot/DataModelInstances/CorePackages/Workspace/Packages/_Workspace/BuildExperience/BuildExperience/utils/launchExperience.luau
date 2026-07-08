local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)
local ExperienceService = require(Parent.ExperienceService)
local ExperienceService2 = ExperienceService.ExperienceService
local GameParams = ExperienceService.GameParams
local BuildModeLaunch = require(script.Parent.BuildModeLaunch)
local debug = CreatorAgentChat.debug

local function launchExperience(n1: number, s1: string, b1: boolean?) -- line: 13
	-- upvalues: BuildModeLaunch (copy), GameParams (copy), debug (copy), ExperienceService2 (copy)
	BuildModeLaunch:set()

	local v12 = GameParams.fromPlaceId(n1, b1)

	debug.log("info", "LaunchExperience gameParams", {
		gameParams = v12,
		source = s1
	})
	ExperienceService2:LaunchExperience(v12, s1)
end

return launchExperience
