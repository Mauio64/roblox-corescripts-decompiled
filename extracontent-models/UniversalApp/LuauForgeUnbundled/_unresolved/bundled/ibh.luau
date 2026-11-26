local module = require("@luauforge/bundled/ibe")
local module2 = require("@luauforge/bundled/ibi")
local module3 = require("@luauforge/bundled/ibj")
local foundationProvider = module3.FoundationProvider
local view = module3.View
local button = module3.Button
local iconButton = module3.IconButton
local loading = module3.Loading
local usePreferences = module3.Hooks.usePreferences
local useTokens = module3.Hooks.useTokens
local iconName = module3.Enums.IconName
local iconSize = module3.Enums.IconSize
local inputSize = module3.Enums.InputSize
local buttonVariant = module3.Enums.ButtonVariant
local colorMode = module3.Enums.ColorMode

local useDeviceType = require("@luauforge/bundled/ibk").useDeviceType
local useDeviceInsets = module2.useDeviceInsets

local module4 = require("@luauforge/bundled/ibl")
local module5 = require("@luauforge/bundled/ibn")
local module6 = require("@luauforge/bundled/ibz")

local function EditAvatarButton(props)
	return module.createElement(button, {
		text = props.text,
		variant = buttonVariant.OverMedia,
		size = inputSize.Medium,
		onActivated = props.onActivated,
		LayoutOrder = props.layoutOrder
	})
end

local function SupportRegionAvatarOverlay(props)
	local v5 = useTokens()
	local v6 = useDeviceType()
	local v7 = useDeviceInsets()
	local v8 = usePreferences()

	local v9 = module.useMemo(function()
		return {
			preferredTextSize = v8.preferredTextSize,
			preferredTransparency = v8.preferredTransparency,
			reducedMotion = v8.reducedMotion
		}
	end, { v8 })

	local v10 = module.useMemo(function()
		return {
			right = UDim.new(0, -v5.Padding.Small)
		}
	end, { v5.Padding.Small })

	local ref = module.useRef(nil)

	local setEntryTarget = props.setEntryTarget

	module.useEffect(function()
		if ref.current ~= nil then
			setEntryTarget(ref.current)
		end

		return function()
			setEntryTarget(nil)
		end
	end, { setEntryTarget })

	local showSwitchOutfitControls = props.showSwitchOutfitControls
	local showEditAvatar = props.showEditAvatar
	local showCollapseButton = props.showCollapseButton
	local showTopEditAvatar = props.showTopEditAvatar

	local createElement = module.createElement
	local v12 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = -99,
		[module.Event.MouseEnter] = props.onOverlayMouseEnter,
		[module.Event.MouseLeave] = props.onOverlayMouseLeave
	}
	local v13 = {
		Vignette = module.createElement(view, {
			Position = UDim2.fromOffset(0, -v7.top),
			Size = UDim2.new(1, v7.right, 1, v7.top + v7.bottom),
			ZIndex = -98
		}, {
			TopScrim = module.createElement("Frame", {
				Position = UDim2.new(0, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				Size = UDim2.new(1, 0, 0, 158),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.1
			}, {
				Gradient = module.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			}),
			BottomScrim = module.createElement("Frame", {
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.new(1, 0, 0, 158),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.3
			}, {
				Gradient = module.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			})
		}),
		Content = 0
	}

	local createElement2 = module.createElement

	local createElement3 = module.createElement
	local v18 = { Size = UDim2.fromScale(1, 1) }

	local createElement4 = module.createElement
	local v21 = { colorMode = colorMode.Light, device = v6, preferences = v9 }

	local createElement5 = module.createElement
	local v24 = {
		tag = "row align-y-center anchor-top-center size-full-1200",
		Position = UDim2.new(0.5, 0, 0, props.topInset),
		padding = 0
	}

	if not showCollapseButton then
		v10 = nil
	end

	v24.padding = v10
	local v25 = {
		ProfileChip = module.createElement(module5, { layoutOrder = 1, ref = ref }),
		Spacer = module.createElement(view, { tag = "grow auto-y", LayoutOrder = 2 }),
		CollapseButtonScope = 0,
		EditAvatarButton = 0
	}

	local v26 = if showCollapseButton then module.createElement(
		view,
		{ AutomaticSize = Enum.AutomaticSize.XY, LayoutOrder = 3 },
		{
			DarkScope = module.createElement(
				foundationProvider,
				{ colorMode = colorMode.Dark, device = v6, preferences = v9 },
				{
					CollapseButton = module.createElement(iconButton, {
						icon = iconName.RectangleRightPaneChevronRight,
						variant = buttonVariant.Utility,
						size = inputSize.Medium,
						onActivated = props.onCollapseActivated
					})
				}
			)
		}
	) else nil
	v25.CollapseButtonScope = v26

	local v27 = if showTopEditAvatar then module.createElement(EditAvatarButton, {
		text = props.editAvatarButtonText,
		layoutOrder = 3,
		onActivated = props.onEditAvatarActivated
	}) else nil
	v25.EditAvatarButton = v27
	local v22 = {
		TopArea = createElement5(view, v24, v25),
		MiddleArea = 0,
		BottomArea = 0,
		LoadingSpinner = 0,
		ShortcutClusterContainer = 0
	}

	local v28 = if showSwitchOutfitControls then module.createElement(
		view,
		{ tag = "row position-center-center anchor-center-center size-full-1000" },
		{
			OutfitNavigationControls = module.createElement(module4, {
				showLeftChevron = props.showLeftChevron,
				showRightChevron = props.showRightChevron,
				onLeftChevronActivated = props.onLeftChevronActivated,
				onRightChevronActivated = props.onRightChevronActivated,
				hasNextOutfit = props.hasNextOutfit,
				hasNoAdditionalAvatars = props.hasNoAdditionalAvatars,
				isSwitchingOutfit = props.isSwitchingOutfit
			})
		}
	) else nil
	v22.MiddleArea = v28

	local v29 = if showEditAvatar then module.createElement(
		view,
		{
			tag = "row align-x-center position-bottom-center anchor-bottom-center size-full-1200 padding-bottom-small",
			GroupTransparency = props.editAvatarTransparency,
			Visible = props.isEditAvatarVisible
		},
		{
			EditAvatarButton = module.createElement(EditAvatarButton, {
				text = props.editAvatarButtonText,
				onActivated = props.onEditAvatarActivated
			})
		}
	) else nil
	v22.BottomArea = v29

	local v30 = if props.isSwitchingOutfit then module.createElement(
		view,
		{ tag = "position-center-center anchor-center-center auto-xy" },
		{
			Spinner = module.createElement(loading, { size = iconSize.Large })
		}
	) else nil
	v22.LoadingSpinner = v30

	local v31 = if props.showShortcutCluster and props.shortcuts ~= nil then module.createElement(
		view,
		{
			tag = "position-bottom-right anchor-bottom-right auto-xy padding-bottom-large"
		},
		{
			ShortcutCluster = module.createElement(module6, {
				shortcuts = props.shortcuts
			})
		}
	) else nil
	v22.ShortcutClusterContainer = v31
	v13.Content = createElement2(
		view,
		{ tag = "size-full-full margin-x-medium padding-y-small", ZIndex = -97 },
		{
			OverMediaScope = createElement3(view, v18, {
				OverMediaProvider = createElement4(foundationProvider, v21, v22)
			})
		}
	)
	return createElement("Frame", v12, v13)
end

return module.memo(SupportRegionAvatarOverlay)
