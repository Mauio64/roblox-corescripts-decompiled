local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/SharedFlags")
local fFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local fFlagConnectionRelaunchBuildPlaytest = SharedFlags.FFlagConnectionRelaunchBuildPlaytest
local fFlagDeferInExperienceRbxmDownload = SharedFlags.FFlagDeferInExperienceRbxmDownload
local fFlagEnableDeferredAssetManagerService = SharedFlags.FFlagEnableDeferredAssetManagerService
local fFlagLuaAppPrivatePlaytestEarlyTesting = SharedFlags.FFlagLuaAppPrivatePlaytestEarlyTesting
local fFlagLuaAppPrivatePlaytestWithoutBuildMode = SharedFlags.FFlagLuaAppPrivatePlaytestWithoutBuildMode

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/DataHydration/CreatorAgentChat")
local ExperienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/ExperienceService")
local experienceService = ExperienceService.ExperienceService
local gameParams = ExperienceService.GameParams

local BuildModeLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/BuildModeLaunch")

local Debug = CreatorAgentChat.debug

local function launchExperience(joiningPlaceId, p2, p3, p4, p5)
	local v6 = p5 and not fFlagLuaAppPrivatePlaytestEarlyTesting and true or p3

	if fFlagLuaAppPrivatePlaytestWithoutBuildMode then
		BuildModeLaunch:clear()
	end

	if not (p5 and fFlagLuaAppPrivatePlaytestWithoutBuildMode) then
		local sessionId = if p4 ~= nil then p4.sessionId else nil
		BuildModeLaunch:set(sessionId, joiningPlaceId, if fFlagConnectionRelaunchBuildPlaytest then v6 else nil)
	end

	local v7

	if p5 and fFlagLuaAppPrivatePlaytestEarlyTesting then
		v7 = gameParams.fromParams({ placeId = joiningPlaceId, isEarlyTesting = true })
	else
		v7 = gameParams.fromPlaceId(joiningPlaceId, v6)
	end

	if fFlagBuildExperienceLibrary then
		v7.isTeamCreateViewer = p4 ~= nil or nil

		if p4 == nil then
			require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/ProgressLoading").PregameOverride.setPregameOverride(nil)
		end

		if fFlagDeferInExperienceRbxmDownload and fFlagEnableDeferredAssetManagerService then
			local DeferredAssetManagerService = game:GetService("DeferredAssetManagerService")
			DeferredAssetManagerService.JoiningPlaceId = joiningPlaceId
			DeferredAssetManagerService.JoiningUniverseId = 0
		end
	end

	Debug.log("info", "LaunchExperience gameParams", { gameParams = v7, source = p2 })

	experienceService:LaunchExperience(v7, p2)
end

return launchExperience
