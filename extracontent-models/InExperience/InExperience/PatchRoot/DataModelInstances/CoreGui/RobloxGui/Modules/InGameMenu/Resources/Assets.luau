local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local UIBlox = InGameMenuDependencies.UIBlox

local Images = require(script.Parent.Images)

local images = UIBlox.App.ImageSet.Images

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation

local defineFastFlag = game:DefineFastFlag("FixInGameMenuMoreButtonIcon", false)

local images2 = {}
images2.RobloxLogo = Images["LuaApp/graphic/ic_logo"]
images2.CloseButton = "rbxasset://textures/ui/TopBar/close.png"
images2.RespawnIcon = Images["InGameMenu/Icons/RespawnIcon"]

images2.ReportIcon = FFlagCoreUiMigrateUIBloxToFoundation and "icons/actions/feedback"
	or Images["LuaApp/icons/GameDetails/feedback"]

images2.CloseModal = FFlagCoreUiMigrateUIBloxToFoundation and "icons/navigation/close"
	or Images["LuaApp/icons/navigation/close"]

images2.NavigateBack = FFlagCoreUiMigrateUIBloxToFoundation and "icons/navigation/pushBack"
	or Images["LuaApp/icons/navigation/pushBack"]
images2.NavigateForward = Images["LuaApp/icons/navigation/pushRight"]

images2.SendInvite = Images["LuaApp/icons/GameDetails/invite"]
images2.InviteSuccess = Images["LuaApp/icons/status_progress"]
images2.InviteMenu = Images["InGameMenu/Icons/MenuFriends"]
images2.InviteFail = Images["LuaApp/graphic/ic_alert"]

images2.ControlsMenu = Images["InGameMenu/Icons/MenuControls"]
images2.Gamepad = "rbxasset://textures/ui/InGameMenu/GenericController.png"
images2.GamepadXbox = "rbxasset://textures/ui/InGameMenu/XboxController.png"
images2.GamepadQuest = "rbxassetid://13262267483"
images2.KeyBorder = Images["InGameMenu/Icons/KeyBorder"]

images2.Mouse1Press = Images["InGameMenu/Graphic/ClickLeft"]
images2.Mouse2Press = Images["InGameMenu/Graphic/ClickRight"]
images2.MouseWheelScroll = Images["InGameMenu/Graphic/WheelScroll"]

images2.UpArrow = Images["InGameMenu/Icons/ArrowUp"]
images2.DownArrow = Images["InGameMenu/Icons/ArrowDown"]
images2.LeftArrow = Images["InGameMenu/Icons/ArrowLeft"]
images2.RightArrow = Images["InGameMenu/Icons/ArrowRight"]
images2.ScrollTop = "rbxasset://textures/ui/InGameMenu/ScrollTop.png"
images2.ScrollMid = "rbxasset://textures/ui/InGameMenu/ScrollMiddle.png"
images2.ScrollBottom = "rbxasset://textures/ui/InGameMenu/ScrollBottom.png"
images2.RadialGlow = "rbxasset://textures/ui/InGameMenu/BackgroundGlow.png"
images2.PlayersMenu = Images["InGameMenu/Icons/MenuPlayers"]

images2.AddFriend = Images["LuaApp/graphic/actions_friends_addfriend"]
images2.CancelFriendRequest = Images["InGameMenu/Icons/CancelFriendRequest"]
images2.UnFriend = Images["InGameMenu/Icons/UnFriend"]
images2.Friends = Images["InGameMenu/Icons/Friends"]
local moreActions

if defineFastFlag then
	moreActions = images["icons/common/more"]
else
	moreActions = Images["LuaApp/icons/GameDetails/more"]
end

images2.MoreActions = moreActions

images2.ViewAvatar = Images["InGameMenu/Icons/ViewAvatar"]

images2.RoundedRectImageKey = "component_assets/circle_17"
images2.RoundedRect = {
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(8, 8, 9, 9),
	Image = images["component_assets/circle_17"]
}

images2.RoundedRectBorder = {
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(8, 8, 9, 9),
	Image = images["component_assets/circle_17_stroke_1"]
}

images2.WhiteSquare = {
	ScaleType = Enum.ScaleType.Stretch,
	SliceCenter = Rect.new(0, 0, 0, 0),
	Image = "rbxasset://textures/ui/InGameMenu/WhiteSquare.png"
}

images2.Circle = FFlagCoreUiMigrateUIBloxToFoundation and "component_assets/circle_29"
	or images["component_assets/circle_29"]
images2.CircleCutout = "rbxasset://textures/ui/InGameMenu/CircleCutout.png"

images2.QuarterCircle = "rbxasset://textures/ui/InGameMenu/QuarterCircle.png"
images2.ExpandArrow = Images["InGameMenu/Icons/ExpandArrow"]
images2.SelectedCheck = Images["InGameMenu/Icons/SelectedCheck"]
images2.SuccessTick = Images["LuaApp/icons/status_progress"]

images2.RetryIcon = Images["LuaApp/icons/common_refresh"]
images2.ClearIcon = Images["InGameMenu/Icons/Clear"]
images2.SearchIcon = Images["LuaApp/icons/ic-search-new"]

images2.GameSettings = Images["InGameMenu/Icons/GameSettings"]

images2.Shadow = {
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(12, 12, 40, 40),
	Size = 8,
	Image = Images["InGameMenu/9Slice/DropShadow"]
}

images2.ToggleOutline = {
	Image = Images["InGameMenu/9Slice/ToggleOutline"],
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(18, 18, 18, 18)
}

images2.ToggleFill = {
	Image = Images["InGameMenu/9Slice/ToggleFill"],
	ScaleType = Enum.ScaleType.Slice,
	SliceCenter = Rect.new(18, 18, 18, 18)
}

images2.ToggleKnob = Images["InGameMenu/Graphic/SliderButton"]

images2.SliderHover = Images["InGameMenu/Graphic/sliderHover"]
images2.SliderCircle = {
	Image = Images["InGameMenu/9Slice/sliderCircle"],
	SliceCenter = Rect.new(8, 8, 9, 9),
	ScaleType = Enum.ScaleType.Slice
}

images2.SliderButton = Images["InGameMenu/Graphic/SliderButton"]

images2.PlaceholderGameIcon = FFlagCoreUiMigrateUIBloxToFoundation and "icons/imageUnavailable"
	or images["icons/imageUnavailable"]
return { Images = images2 }
