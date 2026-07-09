local Parent = script:FindFirstAncestor("HoldToPlay").Parent
local React = require(Parent.React)
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactServiceTags = require(Parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local AppSessionService = RoactServiceTags.AppSessionService
local GamePlayButton = require(Parent.GamePlayButton)
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local usePlayButtonState = GamePlayButton.usePlayButtonState
local PlayButtonStates = GamePlayButton.PlayButtonStates
local RobloxAppSessionization = require(Parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local HoldToPlayLauncher = require(Parent.ExperienceAnalytics).Constants.Context.HoldToPlayLauncher

local function HoldToPlayLoader(t1: {[any]: any}) -- line: 33
	-- upvalues: useRoactService (copy), RoactNetworking (copy), AppSessionService (copy), usePlayButtonState (copy), useOnPlayButtonCallback (copy), HoldToPlayLauncher (copy), React (copy), SetGamePlaySession (copy), SessionType (copy), PlayButtonStates (copy)
	local v17 = useRoactService(RoactNetworking)
	local v18 = useRoactService(AppSessionService)
	local v19 = usePlayButtonState(v17, t1.universeId)
	local v20 = useOnPlayButtonCallback(t1.universeId, nil, HoldToPlayLauncher, nil, nil)

	React.useEffect(function() -- line: 40
		-- upvalues: v19 (copy), t1 (copy), SetGamePlaySession (copy), v18 (copy), SessionType (copy), v20 (copy), PlayButtonStates (copy)
		local playButtonState = v19.playButtonState

		if t1.shouldAttemptLaunch then
			SetGamePlaySession(v18, SessionType.StructuralIdentifier.GamePlayFromHoldToPlay, true)
			v20(playButtonState, t1.reportExperienceLaunched)

			if t1.onLaunched and playButtonState == PlayButtonStates.Playable then
				t1.onLaunched()
			end
		end
	end, {
		t1.shouldAttemptLaunch,
		t1.onLaunched,
		v19.playButtonState,
		v18,
		t1.reportExperienceLaunched,
		v20
	})

	return nil
end

return HoldToPlayLoader
