local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/React")

local CallPip = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/Components/CallPip/CallPip")
local v5 = {
	displayOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCalling/FriendsCalling/CallPipDisplayOrder").InApp,
	exposesTopSafeArea = false,
	followsAppColorMode = true,
	screenInsets = Enum.ScreenInsets.None
}

local function AppFriendsCallingCallPip()
	return React.createElement(CallPip, {
		host = v5,
		isMicrophoneMuted = false,
		initialPresentation = "Expanded"
	})
end

return AppFriendsCallingCallPip
