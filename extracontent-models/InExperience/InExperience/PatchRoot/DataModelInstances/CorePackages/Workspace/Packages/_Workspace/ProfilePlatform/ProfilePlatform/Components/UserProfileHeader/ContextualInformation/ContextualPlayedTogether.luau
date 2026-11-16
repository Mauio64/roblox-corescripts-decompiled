local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local TextKeys = require(ProfilePlatform.Common.TextKeys)

local UIBlox = require(parent.UIBlox)
local PlayerContext = UIBlox.App.Indicator.PlayerContext

local function ContextualPlayedTogether(p)
	local experienceName = p.experienceName
	local playedTogetherText

	if experienceName == "" then
		playedTogetherText = TextKeys.PlayedTogether
	else
		playedTogetherText = {
			TextKeys.PlayedTogetherInGameDescription,
			experience_name = experienceName
		}
	end

	local v = useLocalization({ playedTogetherText = playedTogetherText })

	return React.createElement(PlayerContext, { text = v.playedTogetherText })
end

return ContextualPlayedTogether
