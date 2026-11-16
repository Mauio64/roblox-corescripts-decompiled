local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local CallPip = require(CorePackages.Workspace.Packages.FriendsCalling.CallPip)
local CallPipDisplayOrder = require(CorePackages.Workspace.Packages.FriendsCalling.CallPipDisplayOrder)
local FFlagFriendsCallingCallPip = require(CorePackages.Workspace.Packages.FriendsCalling.FFlagFriendsCallingCallPip)

local VoiceCallReceivedEventReceiver = require(CorePackages.Workspace.Packages.FriendsCalling.VoiceCallReceivedEventReceiver)

local friendsCalling = Instance.new("Folder")
friendsCalling.Name = "FriendsCalling"
friendsCalling.Parent = CoreGui

local host = {
	displayOrder = CallPipDisplayOrder.InExperience,
	exposesTopSafeArea = true,
	followsAppColorMode = false,
	screenInsets = Enum.ScreenInsets.None
}

local root = ReactRoblox.createRoot(friendsCalling)
local createElement = React.createElement
local Fragment = React.Fragment
local callPip

if FFlagFriendsCallingCallPip then
	callPip = React.createElement(CallPip, { host = host, isMicrophoneMuted = false })
end

root:render(createElement(Fragment, nil, {
	CallPip = callPip,
	VoiceCallReceivedEventReceiver = React.createElement(VoiceCallReceivedEventReceiver)
}))
