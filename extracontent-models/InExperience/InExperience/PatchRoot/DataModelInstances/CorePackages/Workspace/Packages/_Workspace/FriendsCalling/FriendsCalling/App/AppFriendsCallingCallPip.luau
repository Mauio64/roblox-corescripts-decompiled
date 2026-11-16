local FriendsCalling = script:FindFirstAncestor("FriendsCalling")
local parent = FriendsCalling.Parent

local React = require(parent.React)

local CallPip = require(FriendsCalling.Components.CallPip.CallPip)
local CallPipDisplayOrder = require(FriendsCalling.CallPipDisplayOrder)

local host = {
	displayOrder = CallPipDisplayOrder.InApp,
	exposesTopSafeArea = false,
	followsAppColorMode = true,
	screenInsets = Enum.ScreenInsets.None
}

local function AppFriendsCallingCallPip()
	return React.createElement(CallPip, {
		host = host,
		isMicrophoneMuted = false,
		initialPresentation = "Expanded"
	})
end

return AppFriendsCallingCallPip
