local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local springAnimatedItem = UIBlox.Utility.SpringAnimatedItem

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/bundled/fBz")

local useProperty = require("@luauforge/bundled/fyQ").useProperty
local module2 = require("@luauforge/deferred/gLm")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module3 = require("@luauforge/deferred/gTH")
require("@luauforge/bundled/dKT")

local useRouteName = require("@game/CorePackages/Workspace/Packages/Navigation").useRouteName
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local vector2 = Vector2.new(8, 8)
local vector2_2 = Vector2.new(36, 36)

local v5 = { dampingRatio = 0.6, frequency = 4.25 }

local v6 = { dampingRatio = 1, frequency = 3.5 }

local function mapValuesToProps(p2)
	return { Size = UDim2.new(1, 0, 0, p2.height) }
end

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local function useTopPanelRef()
	local v7 = useRouteName()
	return React.useContext(module2)[v7 .. "TopPanel"]
end

local function useButtonHeight(isUIFullView, sceneHeight)
	local v7 = useRouteName()
	local v9 = useProperty(React.useContext(module2)[v7 .. "TopPanel"], "Size") or UDim2.fromScale(0, 0)
	local v10 = useSelector(selectDeviceOrientation, getUseSelectorDeepEquals()) == deviceOrientationMode.Portrait

	if isUIFullView and v10 then
		sceneHeight += vector2_2.Y + vector2.Y + 14 + v9.Y.Offset
	end

	return sceneHeight
end

local function SceneButtons(props)
	local isUIFullView = props.isUIFullView or false
	local sceneHeight = props.sceneHeight or 0
	local isSceneFullView = props.isSceneFullView
	local changeViewFunction = props.changeViewFunction
	local zIndex = props.ZIndex

	local v7 = useSelector(module, getUseSelectorDeepEquals())
	local v8 = useSelector(selectDeviceOrientation, getUseSelectorDeepEquals()) == deviceOrientationMode.Portrait

	local v9 = useButtonHeight(isUIFullView, sceneHeight)

	local v10 = 0
	local v11

	if isUIFullView then
		v11 = v5
	else
		v11 = v6
		v10 = 11
	end

	return React.createElement(springAnimatedItem.AnimatedFrame, {
		regularProps = {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 0, 0, v8 and v7 or 0),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = zIndex,
			Visible = changeViewFunction ~= nil and (v8 or isSceneFullView)
		},
		animatedValues = { height = v9 },
		mapValuesToProps = mapValuesToProps,
		springOptions = v11
	}, {
		Container = React.createElement(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1
			},
			{
				UIListLayout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 14)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, v10),
					PaddingRight = UDim.new(0, v10)
				}),
				FullViewEntryButton = React.createElement(module3, {
					isUIFullView = props.isUIFullView,
					isSceneFullView = props.isSceneFullView,
					changeViewFunction = props.changeViewFunction,
					LayoutOrder = 2
				})
			}
		)
	})
end

return SceneButtons
