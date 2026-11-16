local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local module = require("@luauforge/deferred/gWq")
local module2 = require("@luauforge/deferred/gWz")
local module3 = require("@luauforge/bundled/goB")
local module4 = require("@luauforge/bundled/fox")
local module5 = require("@luauforge/deferred/goI")
local module6 = require("@luauforge/deferred/ggP")
local module7 = require("@luauforge/deferred/gVR")
local module8 = require("@luauforge/deferred/gVV")
local module9 = require("@luauforge/deferred/goU")
local module10 = require("@luauforge/bundled/eeo")
local compositionTags = require("@luauforge/bundled/gns").CompositionTags
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module10.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module11 = require("@luauforge/bundled/dOc")

local v5 = {
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.OpenLayeredMakeupSortResetPrompt
}

local function useFocusNavigationBindings(p2, callback, p3)
	local v6 = ReactFocusNavigation.useEventMap(v5, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4)
					p4.cancelled = true
					callback()
				end)
			},
			[focusNavigationEventNameEnum.OpenLayeredMakeupSortResetPrompt] = p3 and {
				handler = InputHandlers.onRelease(p3)
			} or nil
		}
	end, { callback, p3 })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

local iconsmenuabout_large = images["icons/menu/about_large"]

local udim = UDim.new(0, 10)

return function(props)
	local v6 = useStyle()
	local v7 = useTokens()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local onGoBack = props.onGoBack
	local v9 = if #props.equippedLayeredMakeupAssetIdsOrdered > 0 then props.onOpenResetPrompt else nil
	local v10 = useTableWrappedCallbackRef((useFocusNavigationBindings(ref, onGoBack, v9)))

	local v11 = not (#props.equippedLayeredMakeupAssetIdsOrdered > 0)
		and #props.equippedLayeredMakeupAssetIdsOrdered == 0

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.new(1, 0, 1, -props.topBarHeight),
		Position = UDim2.fromOffset(0, props.topBarHeight),
		BackgroundTransparency = 1,
		ZIndex = 2
	}

	local v14 = {
		SceneInteractionFrame = React.createElement(module3),
		VerticalClothingList = not v11 and React.createElement(RoactGamepad.Focusable[module], {
			lastInputIsGamepad = props.isGamepad,
			topBarRef = ref2,
			onDragChange = props.onDragChange
		}),
		ResetButton = not v11 and React.createElement(module2, {
			lastInputIsGamepad = props.isGamepad,
			isDragging = props.isDragging
		}),
		VRAvatarRotateHandler = 0,
		NoItemsMessage = 0
	}

	local v15 = if props.isSpatial then React.createElement(module5) else nil
	v14.VRAvatarRotateHandler = v15

	if v11 then
		local createElement2 = React.createElement
		local v17 = {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, module6.NoItem.BottomPadding),
			Size = 0,
			BackgroundColor3 = 0,
			BackgroundTransparency = 0
		}
		local v18 = if props.isSpatial then UDim2.new(1, 0, 0, 50) else UDim2.new(1, 0, 0, 100)
		v17.Size = v18
		v17.BackgroundColor3 = v6.Theme.BackgroundDefault.Color
		v17.BackgroundTransparency = props.isSpatial and 0 or 1

		local v20 = if props.isSpatial then React.createElement("UICorner", {
			CornerRadius = udim
		}) else nil

		local createElement3 = React.createElement
		local v22 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0, 0),
			Text = props.localized.noItemText,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextWrapped = true,
			TextXAlignment = 0
		}
		local v23 = if not foundationFontFaceMigration then v6.Font.CaptionHeader.Font else nil
		v22.Font = v23

		local v24 = if foundationFontFaceMigration then normalizeFontFace(v7.Typography.CaptionLarge.Font) else nil
		v22.FontFace = v24

		v22.TextSize = v7.Typography.BodyMedium.FontSize
		v22.TextColor3 = v6.Theme.IconEmphasis.Color

		v22.TextXAlignment = Enum.TextXAlignment.Left
		v11 = createElement2("Frame", v17, {
			UICorner = v20,
			NoItemsTextLabel = createElement3("TextLabel", v22, {
				NoItemsIcon = React.createElement(imageSetLabel, {
					Image = iconsmenuabout_large,
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, -2, 0.5, 0),
					Size = UDim2.fromOffset(module6.NoItem.IconSize, module6.NoItem.IconSize),
					ImageColor3 = v6.Theme.IconEmphasis.Color
				})
			})
		})
	end

	v14.NoItemsMessage = v11
	local element = createElement("Frame", v13, v14)

	if props.isSpatial then
		return element
	end

	local createElement2 = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v16 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ref = v10 }

	local createElement3 = React.createElement
	local v20 = {
		TopBar = React.createElement(module4.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = props.localized.makeupSorting,
			transparentBackground = true,
			hideSiteMessageBanner = props.isPortrait,
			leftItem = props.backButton,
			ZIndex = 1,
			ref = ref2
		}),
		RefinementControlBar = 0,
		RefinementNavBar = 0,
		LayeredMakeupSortPageFrame = 0
	}

	local v21 = if module11() then React.createElement(module8, { hideUndoRedo = true }) else nil
	v20.RefinementControlBar = v21

	local v22 = if not module11() then React.createElement(module7) else nil
	v20.RefinementNavBar = v22

	v20.LayeredMakeupSortPageFrame = element
	return createElement2(frame, v16, {
		SceneGamepadHandler = createElement3(module9, nil, v20)
	})
end
