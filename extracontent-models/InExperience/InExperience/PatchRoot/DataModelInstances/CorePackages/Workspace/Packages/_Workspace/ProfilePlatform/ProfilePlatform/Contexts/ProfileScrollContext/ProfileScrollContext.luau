local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfileInspectAvatarSlideIn = SharedFlags.FFlagProfileInspectAvatarSlideIn
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfileInspectAvatarShopChip = SharedFlags2.FFlagProfileInspectAvatarShopChip

return (React.createContext({
	scrollY = 0,
	setAbsoluteYPosition = function() end,
	peekViewOpenPercent = 0,
	setPeekViewOpenPercent = function() end,
	isPeekViewFullyOpen = (FFlagProfileInspectAvatarSlideIn or FFlagProfileInspectAvatarShopChip) and true or nil,
	setIsPeekViewFullyOpen = (FFlagProfileInspectAvatarSlideIn or FFlagProfileInspectAvatarShopChip) and function() end or nil
}))
