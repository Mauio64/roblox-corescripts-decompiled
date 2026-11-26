local React = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/React")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/RobloxAppHooks").useRoactService
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/RoactServiceTags")
local roactNetworking = RoactServiceTags.RoactNetworking
local appSessionService = RoactServiceTags.AppSessionService

local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/GamePlayButton")
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local usePlayButtonState = GamePlayButton.usePlayButtonState
local playButtonStates = GamePlayButton.PlayButtonStates

local RobloxAppSessionization = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/RobloxAppSessionization")
local setGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local sessionType = RobloxAppSessionization.SessionType

local holdToPlayLauncher = require("@game/CorePackages/Workspace/Packages/_Workspace/HoldToPlay/DiscoveryAnalytics").Constants.Context.HoldToPlayLauncher

local function HoldToPlayLoader(data): nil
	local v5 = useRoactService(roactNetworking)
	local v6 = useRoactService(appSessionService)
	local v7 = usePlayButtonState(v5, data.universeId)
	local v8 = useOnPlayButtonCallback(data.universeId, nil, holdToPlayLauncher, nil, nil)

	React.useEffect(function()
		local playButtonState = v7.playButtonState

		if data.shouldAttemptLaunch then
			setGamePlaySession(v6, sessionType.StructuralIdentifier.GamePlayFromHoldToPlay, true)
			v8(playButtonState, data.reportExperienceLaunched)

			if data.onLaunched and playButtonState == playButtonStates.Playable then
				data.onLaunched()
			end
		end
	end, {
		data.shouldAttemptLaunch,
		data.onLaunched,
		v7.playButtonState,
		v6,
		data.reportExperienceLaunched,
		v8
	})

	return nil
end

return HoldToPlayLoader
