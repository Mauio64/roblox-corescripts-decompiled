local parent = script:FindFirstAncestor("GameTile").Parent

local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServiceTags2 = require(parent.RoactServiceTags)
local AppSessionService = RoactServiceTags2.AppSessionService

local GamePlayButton = require(parent.GamePlayButton)
local PlayButtonStates = GamePlayButton.PlayButtonStates
local usePlayButtonState = GamePlayButton.usePlayButtonState
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback

local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType

local function InstantPlayLauncher(data): nil
	local v = useRoactService(RoactNetworking)
	local v2 = useRoactService(AppSessionService)
	local v3 = usePlayButtonState(v, data.universeId, nil, true)
	local ref = React.useRef(false)

	local v4 = React.useMemo(function()
		return { launchData = data.launchData }
	end, { data.launchData })

	local v5 = useOnPlayButtonCallback(
		data.universeId,
		data.referralSource,
		data.eventContext,
		nil,
		data.launchSource,
		v4,
		data.placeId
	)

	React.useEffect(function()
		if ref.current or v3.playButtonState == PlayButtonStates.Loading then
			return
		end

		ref.current = true

		if v3.playButtonState == PlayButtonStates.Playable then
			SetGamePlaySession(v2, SessionType.StructuralIdentifier.GamePlayFromInstantPlay, true)
			v5(v3.playButtonState, data.reportExperienceLaunched)
		else
			data.openGameDetails()
		end

		data.onLaunchAttemptCompleted()
	end, {
		v5,
		v3.playButtonState,
		v2,
		data.openGameDetails,
		data.onLaunchAttemptCompleted,
		data.reportExperienceLaunched
	})

	return nil
end

return InstantPlayLauncher
