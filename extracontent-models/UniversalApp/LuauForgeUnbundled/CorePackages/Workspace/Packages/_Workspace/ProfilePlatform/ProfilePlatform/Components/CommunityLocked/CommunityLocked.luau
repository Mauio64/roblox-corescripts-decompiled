local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local text = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Text
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local function CommunityLocked(p2)
	local v5 = useLocalization({ groupLocked = TextKeys.GroupLocked })

	return React.createElement(text, {
		Text = v5.groupLocked,
		tag = "padding-top-xlarge"
	})
end

return CommunityLocked
