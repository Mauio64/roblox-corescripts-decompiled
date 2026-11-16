local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local parent = script:FindFirstAncestor("BuildExperiencePlaytestLaunch").Parent
local SharedFlags = require(parent.SharedFlags)
local teamCreateUtils = require(script.Parent.teamCreateUtils)

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

local BuildModeLaunch = require(script.Parent.BuildModeLaunch)
local PlaytestRejoin = require(script.Parent.PlaytestRejoin)
local launchExperience = require(script.Parent.launchExperience)
local leaveExperience = require(script.Parent.leaveExperience)
local teleportToPlace = require(script.Parent.teleportToPlace)

local Debug = CreatorAgentChat.debug
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local FFlagLuaAppPrivatePlaytestEarlyTesting = SharedFlags.FFlagLuaAppPrivatePlaytestEarlyTesting

local function isAlreadyInPlace(p: number, p2: number): boolean -- 1 equivalent call inferred from this helper
	return p2 ~= 0 and p2 == p
end

local function listenForTeleportFailure(fn) -- 1 equivalent call inferred from this helper
	local localPlayer = Players.LocalPlayer

	local teleportInitFailedConnection = TeleportService.TeleportInitFailed:Connect(function(p)
		if p == localPlayer then
			fn()
		end
	end)

	return function()
		teleportInitFailedConnection:Disconnect()
	end
end

local function playtestExperience(placeId: number, source: string, data): string
	local currentPlaceId

	if data and data.currentPlaceId ~= nil then
		currentPlaceId = data.currentPlaceId
	else
		currentPlaceId = game.PlaceId
	end

	local isTeamTest

	if data then
		isTeamTest = data.isTeamTest
	else
		isTeamTest = nil
	end

	local isEarlyTesting

	if data then
		isEarlyTesting = data.isEarlyTesting
	else
		isEarlyTesting = nil
	end

	Debug.log("info", "playtestExperience", {
		isTeamTest = isTeamTest,
		isEarlyTesting = isEarlyTesting,
		placeId = placeId,
		currentPlaceId = currentPlaceId,
		source = source
	})

	local viewer = teamCreateUtils.isViewer()

	if
		isAlreadyInPlace(placeId, currentPlaceId) -- inferred equivalent call
		and not (viewer or isEarlyTesting and FFlagLuaAppPrivatePlaytestEarlyTesting)
	then
		local v = nil

		if data and data.onTeleportFailed then
			local onTeleportFailed = data.onTeleportFailed
			local function fn()
				if v then
					v()
					v = nil
				end

				onTeleportFailed()
			end

			v = listenForTeleportFailure(fn) -- inferred equivalent call
		end

		BuildModeLaunch:set()
		teleportToPlace(placeId)
		return "teleport_pending"
	end

	if viewer and FFlagBuildExperienceLibrary then
		PlaytestRejoin.request(placeId, source, isTeamTest, isEarlyTesting)
		leaveExperience()
	elseif viewer then
		leaveExperience(function()
			launchExperience(placeId, source, isTeamTest, nil, isEarlyTesting)
		end)
	else
		launchExperience(placeId, source, isTeamTest, nil, isEarlyTesting)
	end

	return "experience_launch"
end

return playtestExperience
