local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/bundled/dKX")

local focusable = RoactGamepad.Focusable
local iconButton = UIBlox.App.Button.IconButton
local images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local withNavigationFocus = RoactNavigation.withNavigationFocus

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local colorGradientCircle = AvatarExperienceCommon.Components.ColorGradientCircle

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module3 = require("@luauforge/bundled/gTh")
local module4 = require("@luauforge/bundled/eie")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local module5 = require("@luauforge/deferred/hhZ")
local module6 = require("@luauforge/deferred/hia")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local headRefinementEntryButton = module.Components.HeadRefinementEntryButton

local iconSize = UIBlox.App.Constant.IconSize

local iconsmenuclothinghats_on = images["icons/menu/clothing/hats_on"]
local iconsmenuclothinghats_off = images["icons/menu/clothing/hats_off"]
local iconsmenuclothingclothing_on = images["icons/menu/clothing/clothing_on"]
local iconsmenuclothingclothing_off = images["icons/menu/clothing/clothing_off"]
local iconsmenuclothingeyelash_on = images["icons/menu/clothing/eyelash_on"]
local iconsmenuclothingeyelash_off = images["icons/menu/clothing/eyelash_off"]

local function selectIsPortrait(p2): boolean
	return p2.DeviceOrientation == deviceOrientationMode.Portrait
end

local function selectTopbarHeight(p2)
	return p2.TopBar.topBarHeight
end

local function RefinementEntryButton(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local v5 = useStyle()
	local v6 = useTokens()
	local theme = v5.Theme
	local v7 = useDispatch()

	local v8 = module4(module5)

	local v9 = React.useCallback(function()
		v7(module6(v8.avatarAARefineNavigationTap))
		props.navigation.navigate(avatarScreen.AccessoryAdjustment)
	end, { props.navigation, v8 })

	local v10 = React.useCallback(function()
		props.navigation.navigate(avatarScreen.ColorAdjustment)
	end, { props.navigation })

	local v11 = React.useCallback(function()
		v7(module6(v8.avatarLCRefineNavigationTap))
		props.navigation.navigate(avatarScreen.LayeredClothingSort)
	end, { props.navigation, v8 })

	local v12 = React.useCallback(function()
		v7(module6(v8.avatarLayeredMakeupNavigationTap))
		props.navigation.navigate(avatarScreen.LayeredMakeupSort)
	end, { props.navigation, v8 })

	local v13 = React.useCallback(function()
		props.navigation.navigate(avatarScreen.HeadRefinement)
	end, { props.navigation })

	local v14 = useSelector(selectIsPortrait)
	local v15 = useSelector(selectTopbarHeight)
	local v16 = useSelector(selectColorAdjustmentButtonColor)

	local v18 = props.avatarRoute.opaque.name == avatarScreen.AccessoryAdjustment
	local v19 = props.avatarRoute.opaque.name == avatarScreen.LayeredClothingSort
	local v20 = props.avatarRoute.opaque.name == avatarScreen.LayeredMakeupSort
	local v21 = props.avatarRoute.opaque.name == avatarScreen.HeadRefinement

	local element = React.createElement(iconButton, {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		layoutOrder = 4,
		showBackground = true,
		iconSize = iconSize.Medium,
		onActivated = v10,
		buttonRef = ref5,
		NextSelectionUp = ref3
	}, {
		Color = React.createElement(colorGradientCircle, {
			Size = UDim2.fromOffset(v6.Size.Size_700, v6.Size.Size_700),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Colors = { v16 }
		})
	})

	local createElement = React.createElement
	local v23 = {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		layoutOrder = 3,
		showBackground = true,
		icon = if v18 then iconsmenuclothinghats_on else iconsmenuclothinghats_off,
		iconSize = iconSize.Medium,
		iconColor3 = 0,
		iconTransparency = 0,
		onActivated = 0,
		buttonRef = 0,
		NextSelectionUp = 0,
		NextSelectionDown = 0
	}
	local v25 = if v18 then theme.IconEmphasis.Color else theme.IconDefault.Color
	v23.iconColor3 = v25

	local v26 = if v18 then theme.IconEmphasis.Transparency else theme.IconDefault.Transparency
	v23.iconTransparency = v26

	v23.onActivated = v9

	v23.buttonRef = ref3
	v23.NextSelectionUp = ref2
	v23.NextSelectionDown = ref5
	local element2 = createElement(iconButton, v23)

	local createElement2 = React.createElement
	local frame = focusable.Frame
	local defaultChildRefsByRef = {
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.new(0, v14 and 24 or 88, 0, v15 + 4),
		BackgroundColor3 = theme.BackgroundMuted.Color,
		BackgroundTransparency = theme.BackgroundMuted.Transparency,
		ZIndex = 2,
		[Roact.Ref] = props.defaultChildRef,
		defaultChild = ref4,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionRight = props.NextSelectionRight
	}
	local children = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 16)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 8),
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8)
		}),
		HeadRefinementEntryButton = React.createElement(focusable[headRefinementEntryButton], {
			isSelected = v21,
			onActivated = v13,
			buttonRef = ref4,
			NextSelectionDown = ref
		}),
		LCSort = 0,
		AccessoryAdjustment = 0,
		MakeupSort = 0,
		ColorAdjustment = 0
	}

	local createElement3 = React.createElement
	local v28 = {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		icon = if v19 then iconsmenuclothingclothing_on else iconsmenuclothingclothing_off,
		iconColor3 = 0,
		iconTransparency = 0,
		layoutOrder = 1,
		iconSize = 0,
		onActivated = 0,
		showBackground = true,
		buttonRef = 0,
		NextSelectionDown = 0,
		NextSelectionUp = 0
	}

	local v30 = if v19 then theme.IconEmphasis.Color else theme.IconDefault.Color
	v28.iconColor3 = v30

	local v31 = if v19 then theme.IconEmphasis.Transparency else theme.IconDefault.Transparency
	v28.iconTransparency = v31

	v28.iconSize = iconSize.Medium
	v28.onActivated = v11

	v28.buttonRef = ref
	v28.NextSelectionDown = ref2
	v28.NextSelectionUp = ref4
	children.LCSort = createElement3(iconButton, v28)

	children.AccessoryAdjustment = element2
	local createElement4 = React.createElement
	local v33 = {
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		icon = if v20 then iconsmenuclothingeyelash_on else iconsmenuclothingeyelash_off,
		iconColor3 = 0,
		iconTransparency = 0,
		layoutOrder = 2,
		iconSize = 0,
		onActivated = 0,
		showBackground = true,
		buttonRef = 0,
		NextSelectionDown = 0,
		NextSelectionUp = 0
	}

	local v35 = if v20 then theme.IconEmphasis.Color else theme.IconDefault.Color
	v33.iconColor3 = v35

	local v36 = if v20 then theme.IconEmphasis.Transparency else theme.IconDefault.Transparency
	v33.iconTransparency = v36

	v33.iconSize = iconSize.Medium
	v33.onActivated = v12

	v33.buttonRef = ref2
	v33.NextSelectionDown = ref3
	v33.NextSelectionUp = ref
	children.MakeupSort = createElement4(iconButton, v33)

	children.ColorAdjustment = element
	return createElement2(frame, defaultChildRefsByRef, children)
end

local v5 = withNavigationFocus((module3(RefinementEntryButton)))

return React.forwardRef(function(p2, p3)
	return React.createElement(v5, Cryo.Dictionary.join(p2, { defaultChildRef = p3 }))
end)
