local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags").RoactNetworking
local appSessionService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags").AppSessionService

local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GamePlayButton")
local playButtonStates = GamePlayButton.PlayButtonStates
local usePlayButtonState = GamePlayButton.usePlayButtonState
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback

local RobloxAppSessionization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppSessionization")
local setGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local sessionType = RobloxAppSessionization.SessionType

local function InstantPlayLauncher(data): nil
	local v5 = useRoactService(roactNetworking)
	local v6 = useRoactService(appSessionService)
	local v7 = usePlayButtonState(v5, data.universeId, nil, true)
	local ref = React.useRef(false)

	local v8 = React.useMemo(function()
		return { launchData = data.launchData }
	end, { data.launchData })

	local v9 = useOnPlayButtonCallback(
		data.universeId,
		data.referralSource,
		data.eventContext,
		nil,
		data.launchSource,
		v8,
		data.placeId
	)

	React.useEffect(function()
		if ref.current or v7.playButtonState == playButtonStates.Loading then
			return
		end

		ref.current = true

		if v7.playButtonState == playButtonStates.Playable then
			setGamePlaySession(v6, sessionType.StructuralIdentifier.GamePlayFromInstantPlay, true)
			v9(v7.playButtonState, data.reportExperienceLaunched)
		else
			data.openGameDetails()
		end

		data.onLaunchAttemptCompleted()
	end, {
		v9,
		v7.playButtonState,
		v6,
		data.openGameDetails,
		data.onLaunchAttemptCompleted,
		data.reportExperienceLaunched
	})

	return nil
end

return InstantPlayLauncher
