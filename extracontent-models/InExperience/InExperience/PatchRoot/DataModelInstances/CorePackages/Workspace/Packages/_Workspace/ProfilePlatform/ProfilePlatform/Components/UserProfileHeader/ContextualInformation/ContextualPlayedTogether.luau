local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local PlayerContext = require(ProfilePlatformParent.UIBlox).App.Indicator.PlayerContext

local function ContextualPlayedTogether(t1: {[any]: any}) -- line: 16
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), PlayerContext (copy)
	local experienceName = t1.experienceName
	local v10 = useLocalization({
		playedTogetherText = if experienceName == "" then TextKeys.PlayedTogether else {
			TextKeys.PlayedTogetherInGameDescription,
			experience_name = experienceName
		}
	})

	return React.createElement(PlayerContext, {
		text = v10.playedTogetherText
	})
end

return ContextualPlayedTogether
