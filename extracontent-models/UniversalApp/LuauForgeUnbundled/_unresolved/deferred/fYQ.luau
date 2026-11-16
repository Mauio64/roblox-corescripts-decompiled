local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/deferred/fYR")
local playButtonStates = require("@luauforge/bundled/fWH").PlayButtonStates

local getFFlagLuaAppEnableVirtualEventPlaceId = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnableVirtualEventPlaceId
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled

local function LaunchGameOnMount(data): nil
	getFFlagIsSquadEnabled()

	React.useEffect(function()
		if
			data.playButtonState == playButtonStates.Playable
			or getFFlagIsSquadEnabled() and data.playButtonState == playButtonStates.PlayableWithParty
		then
			if data.onGameLaunching then
				data.onGameLaunching()
			end

			if data.playButtonState == playButtonStates.PlayableWithParty then
				data.onPlayButtonActivated(playButtonStates.Playable)
			else
				data.onPlayButtonActivated()
			end
		end
	end, { data.playButtonState })

	return nil
end

return module.connect(function(data)
	local v5 = {
		universeId = data.universeId,
		placeId = 0,
		launchSource = 0,
		referralSource = 0,
		extraParams = 0
	}
	local v6 = if getFFlagLuaAppEnableVirtualEventPlaceId() then data.placeId else nil
	v5.placeId = v6
	v5.launchSource = data.launchSource
	v5.referralSource = data.referralSource
	local v7 = if data.experienceJoinData then data.experienceJoinData else nil
	v5.extraParams = v7
	return v5
end, function(data)
	return {
		playabilityStatus = data.playabilityStatus,
		playButtonState = data.playButtonState,
		onPlayButtonActivated = data.onPlayButtonActivated
	}
end)(LaunchGameOnMount)
