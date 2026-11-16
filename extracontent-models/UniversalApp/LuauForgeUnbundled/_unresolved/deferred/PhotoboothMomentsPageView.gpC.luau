local module = require("@luauforge/deferred/gpo")
local module2 = require("@luauforge/deferred/gpq")
require("@luauforge/deferred/gpD")
local module3 = require("@luauforge/deferred/gpE")
local module4 = require("@luauforge/deferred/gpF")

local fFlagAXPhotoboothMomentsCurrentAvatarTile = require("@luauforge/deferred/gps").FFlagAXPhotoboothMomentsCurrentAvatarTile

local module5 = require("@luauforge/deferred/gpG")

local useTokens = module2.Hooks.useTokens
local stateLayerAffordance = module2.Enums.StateLayerAffordance

local module6 = require("@luauforge/deferred/gpH")

require("@luauforge/deferred/gpL")

local module7 = require("@luauforge/deferred/gpQ")

require("@luauforge/deferred/gpR")

local module8 = require("@luauforge/deferred/gpS")

require("@luauforge/deferred/gpT")

local module9 = require("@luauforge/deferred/gpU")

local module10 = require("@luauforge/deferred/gpY")

local page = module5.Page

local v5 = { affordance = stateLayerAffordance.None }
local v6 = { Selectable = false }

local function swallowClick() end

local function getSnackbarPositionAboveContinueBar(p2)
	return UDim2.new(0.5, 0, 1, -(page.SnackbarBottomInset + p2))
end

local function PhotoboothMomentsPageView(props)
	local v7 = useTokens()

	local v8 = v7.Size.Size_1000 + v7.Padding.Medium * 2

	local v9, v10 = module.useBinding(0)
	local v11 = module.useCallback(function(p2)
		v10(p2.AbsoluteSize.Y)
	end, {})

	local isLandscape = props.isLandscape or not props.isPanelVisible

	local v12 = if isLandscape then v9:map(getSnackbarPositionAboveContinueBar) else page.SnackbarPosition

	local v13 = module.useMemo(function()
		return {
			["col gap-small padding-x-large padding-y-medium radius-medium clip"] = true,
			["bg-over-media-0"] = props.isLandscape,
			["bg-surface-0"] = not props.isLandscape
		}
	end, { props.isLandscape })

	local v14 = module.useMemo(function()
		return { ["col size-full-full"] = true, ["gap-xlarge"] = props.isLandscape }
	end, { props.isLandscape })

	local v15 = module.useMemo(function()
		return { top = UDim.new(0, props.topInset) }
	end, { props.topInset })
	local v16

	if props.activeMenuItemId == module4.PhotoboothMoments.MyAvatars then
		local createElement = module.createElement
		local v18 = {
			avatars = props.avatars,
			hasMore = props.hasMoreAvatars,
			onEndReached = props.onAvatarsEndReached,
			currentAvatarThumbnailUrl = 0,
			onClose = 0
		}

		local v19 = if fFlagAXPhotoboothMomentsCurrentAvatarTile then props.currentAvatarThumbnailUrl else nil
		v18.currentAvatarThumbnailUrl = v19

		v18.onClose = props.onPanelClosed
		v16 = createElement(module6, v18)
	elseif props.activeMenuItemId == module4.PhotoboothMoments.Emotes then
		v16 = module.createElement(module7, {
			emotes = props.emotes,
			hasMore = props.hasMoreEmotes,
			onEndReached = props.onEmotesEndReached,
			onClose = props.onPanelClosed,
			isEmotesDisabled = props.isEmotesDisabled,
			onEmoteBlocked = props.onEmoteBlocked
		})
	elseif props.activeMenuItemId == module4.PhotoboothMoments.Backgrounds then
		v16 = module.createElement(module8, {
			backgrounds = props.backgrounds,
			hasMore = props.hasMoreBackgrounds,
			onEndReached = props.onBackgroundsEndReached,
			onClose = props.onPanelClosed
		})
	end

	local v17 = props.isPanelVisible and props.activeMenuItemId == module4.PhotoboothMoments.Backgrounds

	local v18 = if v17 then page.LandscapeBackgroundsPanelSize else page.LandscapePanelSize
	local v19

	if v17 then
		v19 = UDim2.new(1, 0, page.PortraitPanelHeightScale, -v8)
	else
		v19 = page.PortraitPanelSize
	end

	local v20

	if props.isPanelVisible then
		local createElement = module.createElement
		local view = module2.View

		if props.isLandscape then
			v19 = v18
		end

		local v22 = if not props.isLandscape then page.PortraitPanelPosition else nil
		local v23 = if not props.isLandscape then page.PortraitPanelAnchorPoint else nil
		v20 = createElement(view, {
			tag = v13,
			Size = v19,
			Position = v22,
			AnchorPoint = v23,
			LayoutOrder = 2,
			onActivated = swallowClick,
			stateLayer = v5,
			selection = v6,
			testId = "PhotoboothMomentsPageView_Panel"
		}, { Content = v16 })
	end

	local v21

	if props.isPanelVisible and not props.isLandscape then
		v21 = module.createElement(module2.View, {
			tag = "bg-surface-0",
			Size = UDim2.new(1, 0, 0, v7.Radius.Medium),
			Position = page.PortraitPanelPosition,
			AnchorPoint = page.PortraitPanelAnchorPoint,
			ZIndex = page.PortraitPanelFillZIndex,
			testId = "PhotoboothMomentsPageView_PanelBottomFill"
		})
	end

	local v22

	if v17 and not props.isLandscape then
		v22 = module.createElement(module2.View, {
			Size = UDim2.new(1, 0, 0, v7.Radius.Medium),
			Position = UDim2.new(0, 0, 1 - page.PortraitPanelHeightScale, v8),
			backgroundStyle = {
				Color3 = v7.Color.Extended.Black.Black_100.Color3,
				Transparency = module5.BackgroundSwatchesStrip.GradientBottomTransparency
			},
			ZIndex = page.PortraitPanelFillZIndex,
			testId = "PhotoboothMomentsPageView_PanelCornerFill"
		})
	end

	local v23

	if v17 then
		local createElement = module.createElement
		local view = module2.View
		local v24 = {
			Size = UDim2.new(1, 0, 0, v8),
			Position = 0,
			AnchorPoint = 0,
			onActivated = 0,
			stateLayer = 0,
			selection = 0,
			testId = "PhotoboothMomentsPageView_BackgroundSwatches"
		}
		local v25 = if props.isLandscape then UDim2.new(0, 0, 1, -v8) else page.PortraitSwatchesPosition
		v24.Position = v25

		local v26 = if props.isLandscape then page.LandscapeSwatchesAnchorPoint else page.PortraitSwatchesAnchorPoint
		v24.AnchorPoint = v26

		v24.onActivated = swallowClick
		v24.stateLayer = v5
		v24.selection = v6
		v23 = createElement(view, v24, { Swatches = module.createElement(module10) })
	end

	local createElement = module.createElement
	local view = module2.View

	local v26 = if props.isPanelVisible then module.createElement(module2.View, {
		tag = "size-full-full",
		ZIndex = page.DismissAreaZIndex,
		onActivated = props.onOutsideActivated,
		stateLayer = v5,
		selection = v6,
		testId = "PhotoboothMomentsPageView_DismissArea"
	}) else nil

	local createElement2 = module.createElement
	local view2 = module2.View

	local v28 = {
		TopBar = module.createElement(
			module2.View,
			{
				tag = "col size-full-0 auto-y",
				padding = v15,
				LayoutOrder = 1,
				testId = "PhotoboothMomentsPageView_TopBar"
			},
			{
				Bar = module.createElement(
					module2.View,
					{
						tag = "row align-y-center size-full-0 auto-y padding-x-xlarge padding-y-small",
						testId = "PhotoboothMomentsPageView_Bar"
					},
					{
						BackButton = module.createElement(module2.IconButton, {
							icon = module2.Enums.IconName.ChevronLargeLeft,
							onActivated = props.onBackButtonPressed,
							testId = "PhotoboothMomentsPageView_BackButton"
						})
					}
				)
			}
		),
		Menu = 0,
		ContinueBar = 0
	}

	local createElement3 = module.createElement
	local view3 = module2.View

	local v30 = {
		Rail = module.createElement(module3, {
			items = props.menuItems,
			direction = "vertical",
			activeItemId = props.activeMenuItemId,
			onItemActivated = props.onMenuItemActivated,
			LayoutOrder = 1
		}),
		Panel = 0
	}

	local v31 = if props.isLandscape then v20 else nil
	v30.Panel = v31
	v28.Menu = createElement3(
		view3,
		{
			tag = "row align-y-top grow gap-large size-full-0 padding-x-xlarge",
			LayoutOrder = 2,
			testId = "PhotoboothMomentsPageView_Menu"
		},
		v30
	)

	local v32 = if isLandscape then module.createElement(module2.View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = 3,
		onAbsoluteSizeChanged = v11,
		onActivated = swallowClick,
		stateLayer = v5,
		selection = v6,
		testId = "PhotoboothMomentsPageView_ContinueBar"
	}, {
		Bar = module.createElement(module9, {
			isLandscape = props.isLandscape,
			isEmotesDisabled = props.isEmotesDisabled,
			onContinue = props.onContinue
		})
	}) else nil
	v28.ContinueBar = v32
	local v25 = {
		DismissArea = v26,
		Content = createElement2(view2, {
			tag = v14,
			testId = "PhotoboothMomentsPageView_Content"
		}, v28),
		Panel = 0,
		PanelBottomFill = 0,
		PanelCornerFill = 0,
		BackgroundSwatches = 0,
		Snackbar = 0
	}

	if props.isLandscape then
		v20 = nil
	end

	v25.Panel = v20
	v25.PanelBottomFill = v21
	v25.PanelCornerFill = v22
	v25.BackgroundSwatches = v23
	local v33 = if props.snackbarText ~= "" then module.createElement(module2.Snackbar, {
		title = props.snackbarText,
		onClose = props.onSnackbarClosed,
		Position = v12,
		AnchorPoint = page.SnackbarAnchorPoint,
		ZIndex = page.SnackbarZIndex
	}) else nil
	v25.Snackbar = v33
	return createElement(view, {
		tag = "size-full-full",
		testId = "PhotoboothMomentsPageView"
	}, v25)
end

return PhotoboothMomentsPageView
