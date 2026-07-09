local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AvatarExperienceHeadRefinement = require(CorePackages.Workspace.Packages.AvatarExperienceHeadRefinement)
local Focusable = RoactGamepad.Focusable
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local withNavigationFocus = RoactNavigation.withNavigationFocus
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local ColorGradientCircle = AvatarExperienceCommon.Components.ColorGradientCircle
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local withAppRoute = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withAppRoute)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local Analytics = require(Modules.AvatarExperience.AccessoryAdjustment.Services.Analytics)
local SendRefinementAnalytics = require(Modules.AvatarExperience.AccessoryAdjustment.Thunks.SendRefinementAnalytics)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local FFlagAXCustomizeMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP
local HeadRefinementEntryButton = AvatarExperienceHeadRefinement.Components.HeadRefinementEntryButton
local IconSize = UIBlox.App.Constant.IconSize
local v32 = Images["icons/menu/clothing/hats_on"]
local v33 = Images["icons/menu/clothing/hats_off"]
local v34 = Images["icons/menu/transform-small"]
local v35 = Images["icons/menu/clothing/clothing_on"]
local v36 = Images["icons/menu/clothing/clothing_off"]
local v37 = if not FFlagAXCustomizeMakeupSupport then nil else Images["icons/menu/clothing/eyelash_on"]
local v38 = if not FFlagAXCustomizeMakeupSupport then nil else Images["icons/menu/clothing/eyelash_off"]

local function selectIsPortrait(p1) -- line: 71
	-- upvalues: DeviceOrientationMode (copy)
	return p1.DeviceOrientation == DeviceOrientationMode.Portrait
end
local function selectTopbarHeight(p2) -- line: 76
	return p2.TopBar.topBarHeight
end
local function RefinementEntryButton(p3) -- line: 80
	-- upvalues: React (copy), FFlagAXCustomizeMakeupSupport (copy), useStyle (copy), useTokens (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), SendRefinementAnalytics (copy), AvatarScreen (copy), useSelector (copy), selectIsPortrait (copy), selectTopbarHeight (copy), selectColorAdjustmentButtonColor (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), IxpUtils (copy), IconButton (copy), IconSize (copy), ColorGradientCircle (copy), v34 (copy), v32 (copy), v33 (copy), Focusable (copy), Roact (copy), HeadRefinementEntryButton (copy), v35 (copy), v36 (copy), v37 (copy), v38 (copy)
	local v46 = React.useRef(nil)
	local v47 = if not FFlagAXCustomizeMakeupSupport then nil else React.useRef(nil)
	local v48 = React.useRef(nil)
	local v49 = React.useRef(nil)
	local v50 = React.useRef(nil)
	local v51 = useStyle()
	local v52 = useTokens()
	local Theme = v51.Theme
	local v54 = useDispatch()
	local v55 = useRoactService(Analytics)
	local v56 = React.useCallback(function() -- line: 93
		-- upvalues: v54 (copy), SendRefinementAnalytics (copy), v55 (copy), p3 (copy), AvatarScreen (copy)
		v54(SendRefinementAnalytics(v55.avatarAARefineNavigationTap))
		p3.navigation.navigate(AvatarScreen.AccessoryAdjustment)
	end, {
		p3.navigation,
		v55
	})
	local v57 = React.useCallback(function() -- line: 98
		-- upvalues: p3 (copy), AvatarScreen (copy)
		p3.navigation.navigate(AvatarScreen.ColorAdjustment)
	end, { p3.navigation })
	local v58 = React.useCallback(function() -- line: 102
		-- upvalues: v54 (copy), SendRefinementAnalytics (copy), v55 (copy), p3 (copy), AvatarScreen (copy)
		v54(SendRefinementAnalytics(v55.avatarLCRefineNavigationTap))
		p3.navigation.navigate(AvatarScreen.LayeredClothingSort)
	end, {
		p3.navigation,
		v55
	})
	local v59 = if not FFlagAXCustomizeMakeupSupport then nil else React.useCallback(function() -- line: 108
		-- upvalues: v54 (copy), SendRefinementAnalytics (copy), v55 (copy), p3 (copy), AvatarScreen (copy)
		v54(SendRefinementAnalytics(v55.avatarLayeredMakeupNavigationTap))
		p3.navigation.navigate(AvatarScreen.LayeredMakeupSort)
	end, {
		p3.navigation,
		v55
	})
	local v60 = React.useCallback(function() -- line: 114
		-- upvalues: p3 (copy), AvatarScreen (copy)
		p3.navigation.navigate(AvatarScreen.HeadRefinement)
	end, { p3.navigation })
	local v61 = useSelector(selectIsPortrait)
	local v62 = useSelector(selectTopbarHeight)
	local v63 = useSelector(selectColorAdjustmentButtonColor)
	local v64 = not v61 and 88 or 24
	local v65 = p3.avatarRoute.opaque.name == AvatarScreen.AccessoryAdjustment
	local v66 = p3.avatarRoute.opaque.name == AvatarScreen.LayeredClothingSort
	local v67 = if not FFlagAXCustomizeMakeupSupport then nil else p3.avatarRoute.opaque.name == AvatarScreen.LayeredMakeupSort
	local v68 = p3.avatarRoute.opaque.name == AvatarScreen.HeadRefinement
	local v69 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser)
	local v70 = React.createElement(IconButton, {
		layoutOrder = 4,
		showBackground = true,
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		iconSize = IconSize.Medium,
		onActivated = v57,
		buttonRef = v50,
		NextSelectionUp = v48
	}, {
		Color = React.createElement(ColorGradientCircle, {
			Size = UDim2.fromOffset(v52.Size.Size_700, v52.Size.Size_700),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Colors = { v63 }
		})
	})
	local v71 = React.createElement(IconButton, {
		showBackground = true,
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		layoutOrder = not FFlagAXCustomizeMakeupSupport and 2 or 3,
		icon = if not v69 then if not v65 then v33 else v32 else v34,
		iconSize = IconSize.Medium,
		iconColor3 = if not v65 then Theme.IconDefault.Color else Theme.IconEmphasis.Color,
		iconTransparency = if not v65 then Theme.IconDefault.Transparency else Theme.IconEmphasis.Transparency,
		onActivated = v56,
		buttonRef = v48,
		NextSelectionUp = if not FFlagAXCustomizeMakeupSupport then v46 else v47,
		NextSelectionDown = v50
	})

	return React.createElement(Focusable.Frame, {
		AutomaticSize = Enum.AutomaticSize.XY,
		Position = UDim2.new(0, v64, 0, v62 + 4),
		BackgroundColor3 = Theme.BackgroundMuted.Color,
		BackgroundTransparency = Theme.BackgroundMuted.Transparency,
		ZIndex = 2,
		[Roact.Ref] = p3.defaultChildRef,
		defaultChild = v49,
		NextSelectionUp = p3.NextSelectionUp,
		NextSelectionRight = p3.NextSelectionRight
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
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
		HeadRefinementEntryButton = React.createElement(Focusable[HeadRefinementEntryButton], {
			isSelected = v68,
			onActivated = v60,
			buttonRef = v49,
			NextSelectionDown = v46
		}),
		LCSort = React.createElement(IconButton, {
			layoutOrder = 1,
			showBackground = true,
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			icon = if not v66 then v36 else v35,
			iconColor3 = if not v66 then Theme.IconDefault.Color else Theme.IconEmphasis.Color,
			iconTransparency = if not v66 then Theme.IconDefault.Transparency else Theme.IconEmphasis.Transparency,
			iconSize = IconSize.Medium,
			onActivated = v58,
			buttonRef = v46,
			NextSelectionDown = if not FFlagAXCustomizeMakeupSupport then v48 else v47,
			NextSelectionUp = v49
		}),
		AccessoryAdjustment = v71,
		MakeupSort = if not FFlagAXCustomizeMakeupSupport then nil else React.createElement(IconButton, {
			showBackground = true,
			position = UDim2.fromScale(0.5, 0.5),
			anchorPoint = Vector2.new(0.5, 0.5),
			icon = if not v67 then v38 else v37,
			iconColor3 = if not v67 then Theme.IconDefault.Color else Theme.IconEmphasis.Color,
			iconTransparency = if not v67 then Theme.IconDefault.Transparency else Theme.IconEmphasis.Transparency,
			layoutOrder = not FFlagAXCustomizeMakeupSupport and 3 or 2,
			iconSize = IconSize.Medium,
			onActivated = v59,
			buttonRef = v47,
			NextSelectionDown = v48,
			NextSelectionUp = if not FFlagAXCustomizeMakeupSupport then v49 else v46
		}),
		ColorAdjustment = v70
	})
end

local u42 = withNavigationFocus((withAppRoute(RefinementEntryButton)))

return React.forwardRef(function(p4, p5) -- line: 255
	-- upvalues: React (copy), u42 (ref), Cryo (copy)
	return React.createElement(u42, Cryo.Dictionary.join(p4, {
		defaultChildRef = p5
	}))
end)
