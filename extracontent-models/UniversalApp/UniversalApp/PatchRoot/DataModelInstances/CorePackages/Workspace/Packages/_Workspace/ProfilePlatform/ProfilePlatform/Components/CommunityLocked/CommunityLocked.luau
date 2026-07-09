local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Text = require(ProfilePlatformParent.Foundation).Text
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization

local function CommunityLocked(_: {[any]: any}) -- line: 13
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), Text (copy)
	local v9 = useLocalization({
		groupLocked = TextKeys.GroupLocked
	})

	return React.createElement(Text, {
		tag = "padding-top-xlarge",
		Text = v9.groupLocked
	})
end

return CommunityLocked
