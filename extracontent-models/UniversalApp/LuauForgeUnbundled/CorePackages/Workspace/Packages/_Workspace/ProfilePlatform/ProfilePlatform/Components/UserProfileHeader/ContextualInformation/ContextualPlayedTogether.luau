local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local playerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.Indicator.PlayerContext

local function ContextualPlayedTogether(p2)
	local experienceName = p2.experienceName

	local v7 = if experienceName == "" then TextKeys.PlayedTogether else {
		TextKeys.PlayedTogetherInGameDescription,
		experience_name = experienceName
	}
	local v8 = useLocalization({ playedTogetherText = v7 })

	return React.createElement(playerContext, { text = v8.playedTogetherText })
end

return ContextualPlayedTogether
