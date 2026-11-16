local parent = script:FindFirstAncestor("HoldToPlay").Parent

local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local AppSessionService = RoactServiceTags.AppSessionService

local GamePlayButton = require(parent.GamePlayButton)
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local usePlayButtonState = GamePlayButton.usePlayButtonState
local PlayButtonStates = GamePlayButton.PlayButtonStates

local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType

local ExperienceAnalytics = require(parent.ExperienceAnalytics)
local HoldToPlayLauncher = ExperienceAnalytics.Constants.Context.HoldToPlayLauncher

local function HoldToPlayLoader(data): nil
	local v = useRoactService(RoactNetworking)
	local v2 = useRoactService(AppSessionService)
	local v3 = usePlayButtonState(v, data.universeId)
	local v4 = useOnPlayButtonCallback(data.universeId, nil, HoldToPlayLauncher, nil, nil)

	React.useEffect(function()
		local playButtonState = v3.playButtonState

		if data.shouldAttemptLaunch then
			SetGamePlaySession(v2, SessionType.StructuralIdentifier.GamePlayFromHoldToPlay, true)
			v4(playButtonState, data.reportExperienceLaunched)

			if data.onLaunched and playButtonState == PlayButtonStates.Playable then
				data.onLaunched()
			end
		end
	end, {
		data.shouldAttemptLaunch,
		data.onLaunched,
		v3.playButtonState,
		v2,
		data.reportExperienceLaunched,
		v4
	})

	return nil
end

return HoldToPlayLoader
