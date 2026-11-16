local BuildModeLaunch = require(script.Parent.BuildModeLaunch)
local PlaytestRejoin = require(script.Parent.PlaytestRejoin)
local leaveExperience = require(script.Parent.leaveExperience)
local teamCreateUtils = require(script.Parent.teamCreateUtils)

local function isTeamTest(object) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		local RunService = object:GetService("RunService")
		return RunService:IsTeamTest()
	end)

	return success and result == true
end

local PlaytestReconnect = {}

function PlaytestReconnect.getRelaunchPlaceId(p)
	local v = p or game

	if not BuildModeLaunch:hasBuildMode() or teamCreateUtils.isViewer(v) then
		return nil
	end

	if v.PlaceId ~= 0 and isTeamTest(v) then -- inferred equivalent call
		return v.PlaceId
	end

	return BuildModeLaunch:getTeamTestPlaceId()
end

function PlaytestReconnect.relaunch(p: number)
	PlaytestRejoin.request(p, "BuildPlaytestReconnect", true)
	leaveExperience()
end

return PlaytestReconnect
