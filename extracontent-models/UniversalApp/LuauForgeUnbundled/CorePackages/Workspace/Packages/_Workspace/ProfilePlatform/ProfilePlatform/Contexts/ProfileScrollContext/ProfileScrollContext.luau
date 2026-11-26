local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local fFlagProfileInspectAvatarSlideIn = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileInspectAvatarSlideIn
local fFlagProfileInspectAvatarShopChip = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileInspectAvatarShopChip

return (React.createContext({
	scrollY = 0,
	setAbsoluteYPosition = function() end,
	peekViewOpenPercent = 0,
	setPeekViewOpenPercent = function() end,
	isPeekViewFullyOpen = (fFlagProfileInspectAvatarSlideIn or fFlagProfileInspectAvatarShopChip) and true or nil,
	setIsPeekViewFullyOpen = (fFlagProfileInspectAvatarSlideIn or fFlagProfileInspectAvatarShopChip) and function() end or nil
}))
