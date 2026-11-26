local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/PioneerUtils/Loggers").Logger
local experienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/PioneerUtils/ExperienceService").ExperienceService
local gameParams = require("@game/CorePackages/Workspace/Packages/_Workspace/PioneerUtils/ExperienceService").GameParams
local PioneerInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PioneerUtils/PioneerUtils/PioneerInfo")

local function pendingJoinTargetsPlace(p2): boolean
	local success, result = pcall(function()
		return experienceService:GetPendingJoinAttempt()
	end)

	if not success or type(result) ~= "table" then
		return false
	end

	local placeId = tonumber(result.placeId)
	return placeId ~= nil and placeId == p2
end

local function launchPioneerExperience()
	local pioneerRootPlaceId = PioneerInfo.getPioneerRootPlaceId()

	if not pioneerRootPlaceId then
		logger:warning("launchPioneerExperience: could not resolve a valid Pioneer root place id")
		return
	end

	local success, result = pcall(function()
		return experienceService:GetPendingJoinAttempt()
	end)
	local v5

	if success and type(result) == "table" then
		local placeId = tonumber(result.placeId)
		v5 = not (placeId == nil) and placeId == pioneerRootPlaceId
	else
		v5 = false
	end

	if v5 then
		return
	end

	experienceService:LaunchExperience(gameParams.fromPlaceId(pioneerRootPlaceId), "PioneerLaunch")
end

return launchPioneerExperience
