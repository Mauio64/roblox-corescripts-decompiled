local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local view = Foundation.View
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local module = require("@luauforge/deferred/hiB")
local module2 = require("@luauforge/deferred/hiK")
local module3 = require("@luauforge/bundled/gTf")
local module4 = require("@luauforge/bundled/fvR")
local module5 = require("@luauforge/deferred/gTm")
local module6 = require("@luauforge/deferred/gLv")
local module7 = require("@luauforge/deferred/hhY")
local module8 = require("@luauforge/deferred/hic")
local module9 = require("@luauforge/deferred/gTx")
local module10 = require("@luauforge/bundled/ehL")
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module10.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module11 = require("@luauforge/bundled/dRs")

local module12 = require("@luauforge/deferred/hiQ")

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
	local v11 = useTableWrappedCallbackRef((useFocusNavigationBindings(ref, onGoBack, v9)))

	local v12 = not (#props.equippedLayeredMakeupAssetIdsOrdered > 0)
		and #props.equippedLayeredMakeupAssetIdsOrdered == 0

	local createElement = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 1, -props.topBarHeight),
		Position = UDim2.fromOffset(0, props.topBarHeight),
		BackgroundTransparency = 1,
		ZIndex = 2
	}

	local v15 = {
		SceneInteractionFrame = React.createElement(module3),
		VerticalClothingList = not v12 and React.createElement(RoactGamepad.Focusable[module], {
			lastInputIsGamepad = props.isGamepad,
			topBarRef = ref2,
			onDragChange = props.onDragChange
		}),
		ResetButton = not v12 and React.createElement(module2, {
			lastInputIsGamepad = props.isGamepad,
			isDragging = props.isDragging
		}),
		VRAvatarRotateHandler = 0,
		NoItemsMessage = 0
	}

	local v16 = if props.isSpatial then React.createElement(module5) else nil
	v15.VRAvatarRotateHandler = v16

	if v12 then
		local createElement2 = React.createElement
		local v18 = {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, module6.NoItem.BottomPadding),
			Size = 0,
			BackgroundColor3 = 0,
			BackgroundTransparency = 0
		}
		local v19 = if props.isSpatial then UDim2.new(1, 0, 0, 50) else UDim2.new(1, 0, 0, 100)
		v18.Size = v19
		v18.BackgroundColor3 = v6.Theme.BackgroundDefault.Color
		v18.BackgroundTransparency = props.isSpatial and 0 or 1

		local v21 = if props.isSpatial then React.createElement("UICorner", {
			CornerRadius = udim
		}) else nil

		local v22 = if module12 then React.createElement(
			view,
			{
				tag = "row align-x-center align-y-center gap-xxsmall size-full",
				BackgroundTransparency = 1
			},
			{
				NoItemsIcon = React.createElement(imageSetLabel, {
					Image = iconsmenuabout_large,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.fromOffset(module6.NoItem.IconSize, module6.NoItem.IconSize),
					ImageColor3 = v6.Theme.IconEmphasis.Color
				}),
				NoItemsTextLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					LayoutOrder = 2,
					Size = UDim2.fromScale(0, 0),
					Text = props.localized.noItemText,
					FontFace = normalizeFontFace(v7.Typography.CaptionLarge.Font),
					TextSize = v7.Typography.BodyMedium.FontSize,
					TextColor3 = v6.Theme.IconEmphasis.Color,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}
		) else nil

		local v23 = if not module12 then React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0, 0),
			Text = props.localized.noItemText,
			FontFace = normalizeFontFace(v7.Typography.CaptionLarge.Font),
			TextSize = v7.Typography.BodyMedium.FontSize,
			TextColor3 = v6.Theme.IconEmphasis.Color,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left
		}, {
			NoItemsIcon = React.createElement(imageSetLabel, {
				Image = iconsmenuabout_large,
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, -2, 0.5, 0),
				Size = UDim2.fromOffset(module6.NoItem.IconSize, module6.NoItem.IconSize),
				ImageColor3 = v6.Theme.IconEmphasis.Color
			})
		}) else nil
		v12 = createElement2("Frame", v18, {
			UICorner = v21,
			NoItemsContent = v22,
			NoItemsTextLabel = v23
		})
	end

	v15.NoItemsMessage = v12
	local element = createElement("Frame", v14, v15)

	if props.isSpatial then
		return element
	end

	local createElement2 = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v17 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ref = v11 }

	local createElement3 = React.createElement
	local v21 = {
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

	local v22 = if module11() then React.createElement(module8, { hideUndoRedo = true }) else nil
	v21.RefinementControlBar = v22

	local v23 = if not module11() then React.createElement(module7) else nil
	v21.RefinementNavBar = v23

	v21.LayeredMakeupSortPageFrame = element
	return createElement2(frame, v17, {
		SceneGamepadHandler = createElement3(module9, nil, v21)
	})
end
