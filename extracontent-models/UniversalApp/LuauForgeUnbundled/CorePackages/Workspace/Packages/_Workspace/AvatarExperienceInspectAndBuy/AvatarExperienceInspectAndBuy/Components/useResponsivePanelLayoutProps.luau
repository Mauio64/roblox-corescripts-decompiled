local MarketplaceService = game:GetService("MarketplaceService")

local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/tutils")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/RoactUtils")
local useEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/ReactUtils").useEventConnection
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/VerifiedBadges")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Localization")

local fFlagAXInspectAndBuyAvatarBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXInspectAndBuyAvatarBackground
local useLocalization = Localization.Hooks.useLocalization
local useItemSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Contexts/ItemSelectionStoreContext").useItemSelectionStore

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/ResponsivePanelLayout")
local AvatarItemsViewLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemsView/AvatarItemsViewLayout")
local ItemDetailsLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemDetails/ItemDetailsLayout")
local ViewportLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/ItemsView/ViewportLayout")
local ViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/ViewType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local useRemoteBulkPurchaseEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Hooks/useRemoteBulkPurchaseEvent")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/Common/BuyActionBar")
local getItemThumbnailUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getItemThumbnailUrl")
local usePurchaseButtonProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Components/usePurchaseButtonProps")
local useInspectPlayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Hooks/useInspectPlayer")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation").Hooks.useTokens

local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/formatNumber")

local function selectView(p2)
	return p2.view
end

local function selectInspectPreviewDetails(p2)
	return p2.avatarPreviewDetails
end

local function shouldRenderSecondPanel(p2, p3): boolean
	if p2 == ViewType.WideLandscape then
		return true
	end

	if p2 == ViewType.Wide or p2 == ViewType.Compact then
		return not p3
	end

	return false
end

local v5 = {
	[ViewType.WideLandscape] = {
		tag = "size-full row align-y-center align-x-center",
		layoutOrder = { first = 1, second = 2 },
		panelSizes = {
			first = UDim2.new(0.65, 0, 1, 0),
			second = UDim2.new(0.35, 0, 1, 0)
		},
		showRightBorder = true
	},
	[ViewType.Wide] = {
		tag = "size-full col align-y-center align-x-center",
		layoutOrder = { first = 2, second = 1 },
		panelSizes = {
			first = UDim2.new(1, 0, 0.65, 0),
			second = UDim2.new(1, 0, 0.35, 0)
		},
		showRightBorder = false
	},
	[ViewType.Compact] = {
		tag = "size-full col align-y-center align-x-center",
		layoutOrder = { first = 2, second = 1 },
		panelSizes = {
			first = UDim2.new(1, 0, 0.7, 0),
			second = UDim2.new(1, 0, 0.3, 0)
		},
		showRightBorder = false
	}
}

return function(data)
	local v6 = useSelector(selectView, tutils.deepEqual)
	local v7 = v6 == ViewType.WideLandscape
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState({
		isTryOnEnabled = false,
		tryOnItem = {}
	})

	local items = useSelector(selectInspectPreviewDetails, tutils.deepEqual).items
	local v8, v9, v10 = useRemoteBulkPurchaseEvent(items, data.analytics)
	local v11 = useInspectPlayer()
	local v12 = module14(v10)
	local v13 = useTokens()

	local v14 = useItemSelectionStore()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(0)

	local v17 = if v11.hasVerifiedBadge then {
		"InGame.InspectMenu.Label.VerifiedAvatar",
		PLAYER_NAME = v11.playerName,
		VERIFIED_BADGE = VerifiedBadges.emoji.verified
	} else {
		"InGame.InspectMenu.Label.Avatar",
		PLAYER_NAME = v11.playerName
	}
	local v18 = useLocalization({
		bulkPurchaseButtonText = "Feature.Catalog.Label.BuyItems",
		headerText = v17,
		totalItems = items and {
			"Feature.Catalog.Feature.Catalog.Label.TotalItemsParenthesis",
			itemCount = #items
		} or nil,
		total = "Feature.Catalog.Label.TotalUnformatted"
	})

	local v19 = React.useCallback(function(p2)
		setState2(function(p3)
			local v21 = not p3.isTryOnEnabled

			if v21 then
				data.analytics.reportTryOnButtonClicked(p2.itemType, p2.itemId)
			end

			return {
				isTryOnEnabled = v21,
				tryOnItem = not v21 and {} or p2
			}
		end)
	end, { data.analytics })

	local v20 = usePurchaseButtonProps({
		purchaseButtonText = v18.bulkPurchaseButtonText,
		onBulkPurchase = v8,
		isDisabled = not v9,
		selectedItem = state,
		localizedStrings = v18,
		formattedTotalPrice = v12,
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

	local v21 = React.useCallback(function()
		v14.clearAll()
		data.onInspectMenuClosed()
	end, { v14, data.onInspectMenuClosed })

	local function fn()
		if not state then
			return React.createElement(AvatarItemsViewLayout, {
				view = v6,
				items = items,
				headerText = v18.headerText,
				onInspectMenuClosed = v21,
				onItemCardActivated = function(p2)
					if ref.current then
						ref2.current = ref.current.CanvasPosition.Y
					end

					setState(p2)
				end,
				subheaderText = {
					leftSlotLabel = v18.totalItems or "",
					rightSlotPrice = v12
				},
				buyActionBarProps = v20,
				ref = ref
			})
		end

		local createElement = React.createElement
		local v24 = {
			view = v6,
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
		local v25 = if v6 == ViewType.Wide then v20.purchaseButtonProps else nil
		v24.purchaseButtonProps = v25
		v24.onToggleTryOn = v19
		v24.renderTryOnViewport = data.renderTryOnViewport
		v24.tryOnState = state2
		v24.localPlayerModel = data.localPlayerModel
		v24.formatNumber = module14
		return createElement(ItemDetailsLayout, {
			itemDetailsViewProps = v24,
			buyActionBarProps = v20,
			view = v6
		})
	end

	local avatarBackgroundImageUrl

	if fFlagAXInspectAndBuyAvatarBackground and not state then
		avatarBackgroundImageUrl = data.avatarBackgroundImageUrl
	else
		avatarBackgroundImageUrl = nil
	end

	local function fn2()
		local createElement = React.createElement
		local v23 = {
			view = v6,
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

		local v24 = if state then getItemThumbnailUrl(state) or "" else "rbxthumb://type=Avatar&id=" .. tostring(v11.playerId) .. "&w=420&h=420"
		v23.thumbnailUrl = v24
		local v26

		if state then
			v26 = function()
				setState(nil)
			end
		else
			v26 = data.onInspectMenuClosed
		end

		v23.backButtonProps = { onBackButtonClick = v26 }

		local v27 = { ScaleType = Enum.ScaleType.Crop, Size = 0, AspectRatio = 1 }
		local v28 = if v7 then UDim2.new(1, 0, 0, 0) else UDim2.new(1, 0, 1, 0)
		v27.Size = v28
		v23.viewportProps = v27

		v23.buyActionBarProps = v20
		v23.Size = UDim2.new(1, 0, 1, 0)
		v23.renderTryOnViewport = data.renderTryOnViewport
		v23.tryOnState = state2
		v23.backgroundImageUrl = avatarBackgroundImageUrl

		local v29 = if state then {
			left = UDim.new(0, v13.Padding.XXLarge),
			right = UDim.new(0, v13.Padding.XXLarge),
			top = UDim.new(0, v13.Padding.XXLarge),
			bottom = UDim.new(0, v13.Padding.XXLarge)
		} else avatarBackgroundImageUrl and {
			top = UDim.new(0, v13.Padding.Medium)
		} or nil
		v23.thumbnailPadding = v29
		return createElement(ViewportLayout, v23)
	end

	local v22 = {
		view = v6,
		renderFirstPanel = fn,
		renderSecondPanel = 0,
		panelConfig = 0
	}
	local v23 = v6 == ViewType.WideLandscape or (v6 == ViewType.Wide or v6 == ViewType.Compact) and not state

	if not v23 then
		fn2 = nil
	end

	v22.renderSecondPanel = fn2
	v22.panelConfig = v5[v6] or v5[ViewType.Wide]
	return v22
end
