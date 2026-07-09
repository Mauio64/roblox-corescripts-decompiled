local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local React = require(CorePackages.Packages.React)
local LaunchExperienceConnector = require(Modules.LuaApp.Common.Experience.Connectors.LaunchExperienceConnector)
local PlayButtonStates = require(CorePackages.Workspace.Packages.GamePlayButton).PlayButtonStates
local GetFFlagLuaAppEnableVirtualEventPlaceId = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableVirtualEventPlaceId
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled

local function LaunchGameOnMount(t1: {[any]: any}) -- line: 34
	-- upvalues: GetFFlagIsSquadEnabled (copy), React (copy), PlayButtonStates (copy)
	local u10 = if not GetFFlagIsSquadEnabled() then t1 else t1

	React.useEffect(function() -- line: 42
		-- upvalues: u10 (ref), PlayButtonStates (copy), GetFFlagIsSquadEnabled (copy)
		if u10.playButtonState == PlayButtonStates.Playable or GetFFlagIsSquadEnabled() and u10.playButtonState == PlayButtonStates.PlayableWithParty then
			if u10.onGameLaunching then
				u10.onGameLaunching()
			end

			if u10.playButtonState == PlayButtonStates.PlayableWithParty then
				u10.onPlayButtonActivated(PlayButtonStates.Playable)

				return
			end

			u10.onPlayButtonActivated()
		end
	end, { u10.playButtonState })

	return nil
end

return LaunchExperienceConnector.connect(function(t2: {[any]: any}) -- line: 64
	-- upvalues: GetFFlagLuaAppEnableVirtualEventPlaceId (copy)
	return {
		universeId = t2.universeId,
		placeId = if not GetFFlagLuaAppEnableVirtualEventPlaceId() then nil else t2.placeId,
		launchSource = t2.launchSource,
		referralSource = t2.referralSource,
		extraParams = if not t2.experienceJoinData then nil else t2.experienceJoinData
	}
end, function(p1) -- line: 72
	return {
		playabilityStatus = p1.playabilityStatus,
		playButtonState = p1.playButtonState,
		onPlayButtonActivated = p1.onPlayButtonActivated
	}
end)(LaunchGameOnMount)
