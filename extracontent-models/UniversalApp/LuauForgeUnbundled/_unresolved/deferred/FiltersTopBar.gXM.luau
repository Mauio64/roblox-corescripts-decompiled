local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
require("@game/CorePackages/Workspace/Packages/AppCommonLib")

local module = require("@luauforge/bundled/fuD")
require("@luauforge/bundled/dHK")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local platform = UserInputService:GetPlatform()
local v5 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX

local iconsnavigationclose = images["icons/navigation/close"]
local v6 = v5 and 0.5 or 0

local function FiltersTopBar(props)
	local v7 = useSelector(function(p2)
		return p2.TopBar.statusBarHeight
	end, getUseSelectorDeepEquals())

	local v8 = useSelector(module.getTopBarHeightAvatarScene, getUseSelectorDeepEquals())

	local v9 = useNavigation()

	local v10 = React.useCallback(function()
		props.closePeekViewSignal:fire()
	end, { v9, props.closePeekViewSignal })

	local v11 = useSelectionCursor(cursorKind.RoundedRectNoInset)

	return React.createElement(
		"Frame",
		{
			Active = true,
			Size = UDim2.new(1, 0, 0, v8),
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		},
		{
			TouchFriendlyNavigationButton = React.createElement(focusable.TextButton, {
				AnchorPoint = Vector2.new(0, v6),
				Position = UDim2.new(0, 15, v6, v7),
				Size = UDim2.new(0, 36, 0, 36),
				BackgroundTransparency = 1,
				Text = "",
				[React.Event.Activated] = v10,
				ref = props.buttonRef,
				NextSelectionLeft = props.NextSelectionLeft,
				NextSelectionRight = props.NextSelectionRight,
				NextSelectionUp = props.NextSelectionUp,
				NextSelectionDown = props.NextSelectionDown,
				SelectionImageObject = v11
			}, {
				CloseButton = React.createElement(imageSetLabel, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(0, 36, 0, 36),
					Image = iconsnavigationclose,
					ImageColor3 = Color3.new(1, 1, 1)
				})
			})
		}
	)
end

return FiltersTopBar
