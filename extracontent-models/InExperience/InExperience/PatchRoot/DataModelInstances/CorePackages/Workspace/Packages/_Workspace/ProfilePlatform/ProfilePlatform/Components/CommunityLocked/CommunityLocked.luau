local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local TextKeys = require(ProfilePlatform.Common.TextKeys)

local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function CommunityLocked(_)
	local v = useLocalization({ groupLocked = TextKeys.GroupLocked })

	return React.createElement(Text, { Text = v.groupLocked, tag = "padding-top-xlarge" })
end

return CommunityLocked
