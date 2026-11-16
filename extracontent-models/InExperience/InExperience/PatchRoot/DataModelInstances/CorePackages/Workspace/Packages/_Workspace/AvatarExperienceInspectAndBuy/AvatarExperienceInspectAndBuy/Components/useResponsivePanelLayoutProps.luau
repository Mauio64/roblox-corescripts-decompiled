local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local MarketplaceService = game:GetService("MarketplaceService")

local parent = AvatarExperienceInspectAndBuy.Parent
local tutils = require(parent.tutils)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local VerifiedBadges = require(parent.VerifiedBadges)
local Localization = require(parent.Localization)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXInspectAndBuyAvatarBackground = AvatarExperienceFlags.FFlagAXInspectAndBuyAvatarBackground
local useLocalization = Localization.Hooks.useLocalization
local ItemSelectionStoreContext = require(AvatarExperienceInspectAndBuy.Contexts.ItemSelectionStoreContext)
local useItemSelectionStore = ItemSelectionStoreContext.useItemSelectionStore

require(AvatarExperienceInspectAndBuy.Components.Common.ResponsivePanelLayout)
local AvatarItemsViewLayout = require(AvatarExperienceInspectAndBuy.Components.ItemsView.AvatarItemsViewLayout)
local ItemDetailsLayout = require(AvatarExperienceInspectAndBuy.Components.ItemDetails.ItemDetailsLayout)
local ViewportLayout = require(AvatarExperienceInspectAndBuy.Components.ItemsView.ViewportLayout)
local ViewType = require(AvatarExperienceInspectAndBuy.Enums.ViewType)
require(AvatarExperienceInspectAndBuy.Types)
local useRemoteBulkPurchaseEvent = require(AvatarExperienceInspectAndBuy.Hooks.useRemoteBulkPurchaseEvent)
require(AvatarExperienceInspectAndBuy.Components.Common.BuyActionBar)
local getItemThumbnailUrl = require(AvatarExperienceInspectAndBuy.Utils.getItemThumbnailUrl)
local usePurchaseButtonProps = require(AvatarExperienceInspectAndBuy.Components.usePurchaseButtonProps)
local useInspectPlayer = require(AvatarExperienceInspectAndBuy.Hooks.useInspectPlayer)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local formatNumber = require(AvatarExperienceInspectAndBuy.Utils.formatNumber)

local function selectView(p)
	return p.view
end

local function selectInspectPreviewDetails(p)
	return p.avatarPreviewDetails
end

local function shouldRenderSecondPanel(p, state): boolean -- 1 equivalent call inferred from this helper
	return p == ViewType.WideLandscape or (p == ViewType.Wide or p == ViewType.Compact) and not state
end

local v = {
	[ViewType.WideLandscape] = {
		tag = "size-full row align-y-center align-x-center",
		layoutOrder = { first = 1, second = 2 },
		panelSizes = { first = UDim2.new(0.65, 0, 1, 0), second = UDim2.new(0.35, 0, 1, 0) },
		showRightBorder = true
	},
	[ViewType.Wide] = {
		tag = "size-full col align-y-center align-x-center",
		layoutOrder = { first = 2, second = 1 },
		panelSizes = { first = UDim2.new(1, 0, 0.65, 0), second = UDim2.new(1, 0, 0.35, 0) },
		showRightBorder = false
	},
	[ViewType.Compact] = {
		tag = "size-full col align-y-center align-x-center",
		layoutOrder = { first = 2, second = 1 },
		panelSizes = { first = UDim2.new(1, 0, 0.7, 0), second = UDim2.new(1, 0, 0.3, 0) },
		showRightBorder = false
	}
}

return function(data)
	local view = useSelector(selectView, tutils.deepEqual)
	local v2 = view == ViewType.WideLandscape
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState({ isTryOnEnabled = false, tryOnItem = {} })

	local items = useSelector(selectInspectPreviewDetails, tutils.deepEqual).items
	local onBulkPurchase, v3, v4 = useRemoteBulkPurchaseEvent(items, data.analytics)
	local v5 = useInspectPlayer()
	local v6 = formatNumber(v4)
	local v7 = useTokens()

	local v8 = useItemSelectionStore()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(0)
	local headerText

	if v5.hasVerifiedBadge then
		headerText = {
			"InGame.InspectMenu.Label.VerifiedAvatar",
			PLAYER_NAME = v5.playerName,
			VERIFIED_BADGE = VerifiedBadges.emoji.verified
		}
	else
		headerText = {
			"InGame.InspectMenu.Label.Avatar",
			PLAYER_NAME = v5.playerName
		}
	end

	local localizedStrings = useLocalization({
		bulkPurchaseButtonText = "Feature.Catalog.Label.BuyItems",
		headerText = headerText,
		totalItems = items and {
			"Feature.Catalog.Feature.Catalog.Label.TotalItemsParenthesis",
			itemCount = #items
		} or nil,
		total = "Feature.Catalog.Label.TotalUnformatted"
	})

	local onToggleTryOn = React.useCallback(function(p)
		setState2(function(p2)
			local isTryOnEnabled = not p2.isTryOnEnabled

			if isTryOnEnabled then
				data.analytics.reportTryOnButtonClicked(p.itemType, p.itemId)
			end

			return {
				isTryOnEnabled = isTryOnEnabled,
				tryOnItem = not isTryOnEnabled and {} or p
			}
		end)
	end, { data.analytics })

	local buyActionBarProps = usePurchaseButtonProps({
		purchaseButtonText = localizedStrings.bulkPurchaseButtonText,
		onBulkPurchase = onBulkPurchase,
		isDisabled = not v3,
		selectedItem = state,
		localizedStrings = localizedStrings,
		formattedTotalPrice = v6,
		onPromptPurchase = data.onPromptPurchase
	})

	useEventConnection(MarketplaceService.PromptBulkPurchaseFinished, data.onBulkPurchaseFinished)

	React.useEffect(function()
		if ref.current then
			ref.current.CanvasPosition = Vector2.new(0, ref2.current)
		end
	end, { state })

	React.useEffect(function()
		if state then
			data.onItemDetailsOpened(state)
		end
	end, { state, data.onItemDetailsOpened })

	local onInspectMenuClosed = React.useCallback(function()
		v8.clearAll()
		data.onInspectMenuClosed()
	end, { v8, data.onInspectMenuClosed })

	local function fn()
		if not state then
			return (React.createElement(AvatarItemsViewLayout, {
				view = view,
				items = items,
				headerText = localizedStrings.headerText,
				onInspectMenuClosed = onInspectMenuClosed,
				onItemCardActivated = function(p)
					if ref.current then
						ref2.current = ref.current.CanvasPosition.Y
					end

					setState(p)
				end,
				subheaderText = {
					leftSlotLabel = localizedStrings.totalItems or "",
					rightSlotPrice = v6
				},
				buyActionBarProps = buyActionBarProps,
				ref = ref
			}))
		end

		local createElement = React.createElement
		local itemDetailsViewProps = {
			view = view,
			item = state,
			onItemDetailsClosed = function()
				setState(nil)
				setState2({ isTryOnEnabled = false, tryOnItem = {} })
			end,
			onToggleFavorite = data.onToggleFavorite,
			openAttributionOverlay = data.openAttributionOverlay,
			purchaseButtonProps = 0,
			onToggleTryOn = 0,
			renderTryOnViewport = 0,
			tryOnState = 0,
			localPlayerModel = 0,
			formatNumber = 0
		}
		local purchaseButtonProps

		if view == ViewType.Wide then
			purchaseButtonProps = buyActionBarProps.purchaseButtonProps
		end

		itemDetailsViewProps.purchaseButtonProps = purchaseButtonProps
		itemDetailsViewProps.onToggleTryOn = onToggleTryOn
		itemDetailsViewProps.renderTryOnViewport = data.renderTryOnViewport
		itemDetailsViewProps.tryOnState = state2
		itemDetailsViewProps.localPlayerModel = data.localPlayerModel
		itemDetailsViewProps.formatNumber = formatNumber
		return (createElement(ItemDetailsLayout, {
			itemDetailsViewProps = itemDetailsViewProps,
			buyActionBarProps = buyActionBarProps,
			view = view
		}))
	end

	local avatarBackgroundImageUrl

	if FFlagAXInspectAndBuyAvatarBackground and not state then
		avatarBackgroundImageUrl = data.avatarBackgroundImageUrl
	else
		avatarBackgroundImageUrl = nil
	end

	local function fn2()
		local createElement = React.createElement
		local v9 = {
			view = view,
			thumbnailUrl = 0,
			backButtonProps = 0,
			viewportProps = 0,
			buyActionBarProps = 0,
			Size = 0,
			renderTryOnViewport = 0,
			tryOnState = 0,
			backgroundImageUrl = 0,
			thumbnailPadding = 0
		}
		local thumbnailUrl

		if state then
			thumbnailUrl = getItemThumbnailUrl(state) or ""
		else
			thumbnailUrl = "rbxthumb://type=Avatar&id=" .. tostring(v5.playerId) .. "&w=420&h=420"
		end

		v9.thumbnailUrl = thumbnailUrl
		local onBackButtonClick

		if state then
			onBackButtonClick = function()
				setState(nil)
			end
		else
			onBackButtonClick = data.onInspectMenuClosed
		end

		v9.backButtonProps = { onBackButtonClick = onBackButtonClick }

		local viewportProps = { ScaleType = Enum.ScaleType.Crop, Size = 0, AspectRatio = 1 }
		local size

		if v2 then
			size = UDim2.new(1, 0, 0, 0)
		else
			size = UDim2.new(1, 0, 1, 0)
		end

		viewportProps.Size = size
		v9.viewportProps = viewportProps

		v9.buyActionBarProps = buyActionBarProps
		v9.Size = UDim2.new(1, 0, 1, 0)
		v9.renderTryOnViewport = data.renderTryOnViewport
		v9.tryOnState = state2
		v9.backgroundImageUrl = avatarBackgroundImageUrl
		local thumbnailPadding

		if state then
			thumbnailPadding = {
				left = UDim.new(0, v7.Padding.XXLarge),
				right = UDim.new(0, v7.Padding.XXLarge),
				top = UDim.new(0, v7.Padding.XXLarge),
				bottom = UDim.new(0, v7.Padding.XXLarge)
			}
		else
			thumbnailPadding = avatarBackgroundImageUrl and { top = UDim.new(0, v7.Padding.Medium) } or nil
		end

		v9.thumbnailPadding = thumbnailPadding
		return createElement(ViewportLayout, v9)
	end

	local v9 = { view = view, renderFirstPanel = fn, renderSecondPanel = 0, panelConfig = 0 }

	if not shouldRenderSecondPanel(view, state) then -- inferred equivalent call
		fn2 = nil
	end

	v9.renderSecondPanel = fn2
	v9.panelConfig = v[view] or v[ViewType.Wide]
	return v9
end
