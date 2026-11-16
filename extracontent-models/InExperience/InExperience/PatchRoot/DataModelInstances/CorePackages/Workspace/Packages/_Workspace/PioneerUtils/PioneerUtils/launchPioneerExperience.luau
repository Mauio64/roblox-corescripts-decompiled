local parent = script:FindFirstAncestor("PioneerUtils").Parent

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService
local ExperienceService2 = require(parent.ExperienceService)
local GameParams = ExperienceService2.GameParams
local PioneerInfo = require(script.Parent.PioneerInfo)

local function pendingJoinTargetsPlace(p: number): boolean
	local success, result = pcall(function()
		return experienceService:GetPendingJoinAttempt()
	end)

	if not success or type(result) ~= "table" then
		return false
	end

	local placeId = tonumber(result.placeId)
	return placeId ~= nil and placeId == p
end

local function launchPioneerExperience()
	local pioneerRootPlaceId = PioneerInfo.getPioneerRootPlaceId()

	if not pioneerRootPlaceId then
		Logger:warning("launchPioneerExperience: could not resolve a valid Pioneer root place id")
		return
	end

	local success, result = pcall(function()
		return experienceService:GetPendingJoinAttempt()
	end)
	local v

	if success and type(result) == "table" then
		local placeId = tonumber(result.placeId)

		if placeId == nil then
			v = false
		else
			v = placeId == pioneerRootPlaceId
		end
	else
		v = false
	end

	if v then
		return
	end

	experienceService:LaunchExperience(GameParams.fromPlaceId(pioneerRootPlaceId), "PioneerLaunch")
end

return launchPioneerExperience
