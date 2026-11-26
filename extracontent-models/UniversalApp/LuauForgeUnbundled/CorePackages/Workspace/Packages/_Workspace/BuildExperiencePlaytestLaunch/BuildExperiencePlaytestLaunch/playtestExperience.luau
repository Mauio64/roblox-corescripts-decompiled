local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/SharedFlags")
local teamCreateUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/teamCreateUtils")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/DataHydration/CreatorAgentChat")

local BuildModeLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/BuildModeLaunch")
local PlaytestRejoin = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/PlaytestRejoin")
local launchExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/launchExperience")
local leaveExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/leaveExperience")
local teleportToPlace = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/teleportToPlace")

local Debug = CreatorAgentChat.debug
local fFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local fFlagLuaAppPrivatePlaytestEarlyTesting = SharedFlags.FFlagLuaAppPrivatePlaytestEarlyTesting

local function isAlreadyInPlace(p2, p3): boolean
	return p3 ~= 0 and p3 == p2
end

local function listenForTeleportFailure(callback)
	local localPlayer = Players.LocalPlayer

	local teleportInitFailedConnection = TeleportService.TeleportInitFailed:Connect(function(p2)
		if p2 == localPlayer then
			callback()
		end
	end)

	return function()
		teleportInitFailedConnection:Disconnect()
	end
end

local function playtestExperience(p2, p3, data): string
	local v5 = if data and data.currentPlaceId ~= nil then data.currentPlaceId else game.PlaceId
	local isTeamTest = if data then data.isTeamTest else nil
	local isEarlyTesting = if data then data.isEarlyTesting else nil

	Debug.log("info", "playtestExperience", {
		isTeamTest = isTeamTest,
		isEarlyTesting = isEarlyTesting,
		placeId = p2,
		currentPlaceId = v5,
		source = p3
	})

	local viewer = teamCreateUtils.isViewer()
	local v7 = not (v5 == 0) and v5 == p2

	if v7 and not (viewer or isEarlyTesting and fFlagLuaAppPrivatePlaytestEarlyTesting) then
		local fn = nil

		if data and data.onTeleportFailed then
			local onTeleportFailed = data.onTeleportFailed
			local function fn2()
				if fn then
					fn()
					fn = nil
				end

				onTeleportFailed()
			end

			local localPlayer = Players.LocalPlayer

			local teleportInitFailedConnection = TeleportService.TeleportInitFailed:Connect(function(p4)
				if p4 == localPlayer then
					fn2()
				end
			end)

			fn = function()
				teleportInitFailedConnection:Disconnect()
			end
		end

		BuildModeLaunch:set()
		teleportToPlace(p2)
		return "teleport_pending"
	end

	if viewer and fFlagBuildExperienceLibrary then
		PlaytestRejoin.request(p2, p3, isTeamTest, isEarlyTesting)
		leaveExperience()
	elseif viewer then
		leaveExperience(function()
			launchExperience(p2, p3, isTeamTest, nil, isEarlyTesting)
		end)
	else
		launchExperience(p2, p3, isTeamTest, nil, isEarlyTesting)
	end

	return "experience_launch"
end

return playtestExperience
