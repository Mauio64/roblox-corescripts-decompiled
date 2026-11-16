local parent = script:FindFirstAncestor("BuildExperiencePlaytestLaunch").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local FFlagConnectionRelaunchBuildPlaytest = SharedFlags.FFlagConnectionRelaunchBuildPlaytest
local FFlagDeferInExperienceRbxmDownload = SharedFlags.FFlagDeferInExperienceRbxmDownload
local FFlagEnableDeferredAssetManagerService = SharedFlags.FFlagEnableDeferredAssetManagerService
local FFlagLuaAppPrivatePlaytestEarlyTesting = SharedFlags.FFlagLuaAppPrivatePlaytestEarlyTesting
local FFlagLuaAppPrivatePlaytestWithoutBuildMode = SharedFlags.FFlagLuaAppPrivatePlaytestWithoutBuildMode

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService
local GameParams = ExperienceService.GameParams

local BuildModeLaunch = require(script.Parent.BuildModeLaunch)

local Debug = CreatorAgentChat.debug

local function launchExperience(joiningPlaceId: number, source: string, flag: boolean?, p, flag2: boolean?)
	local v = flag2 and not FFlagLuaAppPrivatePlaytestEarlyTesting and true or flag

	if FFlagLuaAppPrivatePlaytestWithoutBuildMode then
		BuildModeLaunch:clear()
	end

	if not (flag2 and FFlagLuaAppPrivatePlaytestWithoutBuildMode) then
		local sessionId

		if p ~= nil then
			sessionId = p.sessionId
		end

		local v2

		if FFlagConnectionRelaunchBuildPlaytest then
			v2 = v
		end

		BuildModeLaunch:set(sessionId, joiningPlaceId, v2)
	end

	local gameParams

	if flag2 and FFlagLuaAppPrivatePlaytestEarlyTesting then
		gameParams = GameParams.fromParams({ placeId = joiningPlaceId, isEarlyTesting = true })
	else
		gameParams = GameParams.fromPlaceId(joiningPlaceId, v)
	end

	if FFlagBuildExperienceLibrary then
		gameParams.isTeamCreateViewer = p ~= nil or nil

		if p == nil then
			local ProgressLoading = require(parent.ProgressLoading)
			ProgressLoading.PregameOverride.setPregameOverride(nil)
		end

		if FFlagDeferInExperienceRbxmDownload and FFlagEnableDeferredAssetManagerService then
			local DeferredAssetManagerService = game:GetService("DeferredAssetManagerService")
			DeferredAssetManagerService.JoiningPlaceId = joiningPlaceId
			DeferredAssetManagerService.JoiningUniverseId = 0
		end
	end

	Debug.log("info", "LaunchExperience gameParams", { gameParams = gameParams, source = source })

	experienceService:LaunchExperience(gameParams, source)
end

return launchExperience
