local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local MarketplaceService = game:GetService("MarketplaceService")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local tutils = require(AvatarExperienceInspectAndBuyParent.tutils)
local React = require(AvatarExperienceInspectAndBuyParent.React)
local RoactUtils = require(AvatarExperienceInspectAndBuyParent.RoactUtils)
local useEventConnection = require(AvatarExperienceInspectAndBuyParent.ReactUtils).useEventConnection
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local VerifiedBadges = require(AvatarExperienceInspectAndBuyParent.VerifiedBadges)
local useLocalization = require(AvatarExperienceInspectAndBuyParent.Localization).Hooks.useLocalization
local useItemSelectionStore = require(AvatarExperienceInspectAndBuy.Contexts.ItemSelectionStoreContext).useItemSelectionStore

require(AvatarExperienceInspectAndBuy.Stores.createItemSelectionStore)

local FFlagAXEnableIaBTimedOptionsBulkPurchase = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXEnableIaBTimedOptionsBulkPurchase

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
local useTokens = require(AvatarExperienceInspectAndBuyParent.Foundation).Hooks.useTokens
local formatNumber = require(AvatarExperienceInspectAndBuy.Utils.formatNumber)

local function selectView(p1) -- line: 54
	return p1.view
end
local function selectInspectPreviewDetails(p2) -- line: 58
	return p2.avatarPreviewDetails
end
local function shouldRenderSecondPanel(p3, p4) -- line: 69
	-- upvalues: ViewType (copy)
	if p3 == ViewType.WideLandscape then
		return true
	end

	if p3 == ViewType.Wide or p3 == ViewType.Compact then
		return not p4
	end

	return false
end

local t1 = {
	[ViewType.WideLandscape] = {
		tag = "size-full row align-y-center align-x-center",
		showRightBorder = true,
		layoutOrder = {
			first = 1,
			second = 2
		},
		panelSizes = {
			first = UDim2.new(0.65, 0, 1, 0),
			second = UDim2.new(0.35, 0, 1, 0)
		}
	},
	[ViewType.Wide] = {
		tag = "size-full col align-y-center align-x-center",
		showRightBorder = false,
		layoutOrder = {
			first = 2,
			second = 1
		},
		panelSizes = {
			first = UDim2.new(1, 0, 0.65, 0),
			second = UDim2.new(1, 0, 0.35, 0)
		}
	},
	[ViewType.Compact] = {
		tag = "size-full col align-y-center align-x-center",
		showRightBorder = false,
		layoutOrder = {
			first = 2,
			second = 1
		},
		panelSizes = {
			first = UDim2.new(1, 0, 0.7, 0),
			second = UDim2.new(1, 0, 0.3, 0)
		}
	}
}

return function(t2: {[any]: any}) -- line: 131
	-- upvalues: useSelector (copy), selectView (copy), tutils (copy), ViewType (copy), React (copy), selectInspectPreviewDetails (copy), useRemoteBulkPurchaseEvent (copy), useInspectPlayer (copy), formatNumber (copy), useTokens (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), useItemSelectionStore (copy), useLocalization (copy), VerifiedBadges (copy), usePurchaseButtonProps (copy), useEventConnection (copy), MarketplaceService (copy), ItemDetailsLayout (copy), AvatarItemsViewLayout (copy), ViewportLayout (copy), getItemThumbnailUrl (copy), t1 (copy)
	local v32 = useSelector(selectView, tutils.deepEqual)
	local v33 = v32 == ViewType.WideLandscape
	local v34, v35 = React.useState(nil)
	local v36, v37 = React.useState({
		isTryOnEnabled = false,
		tryOnItem = {}
	})
	local items = useSelector(selectInspectPreviewDetails, tutils.deepEqual).items
	local v39, v40, v41 = useRemoteBulkPurchaseEvent(items, t2.analytics)
	local v42 = useInspectPlayer()
	local v43 = formatNumber(v41)
	local v44 = useTokens()
	local v45 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useItemSelectionStore()
	local v46 = React.useRef(nil)
	local v47 = React.useRef(0)
	local v48 = useLocalization({
		bulkPurchaseButtonText = "Feature.Catalog.Label.BuyItems",
		total = "Feature.Catalog.Label.TotalUnformatted",
		headerText = if not v42.hasVerifiedBadge then {
			"InGame.InspectMenu.Label.Avatar",
			PLAYER_NAME = v42.playerName
		} else {
			"InGame.InspectMenu.Label.VerifiedAvatar",
			PLAYER_NAME = v42.playerName,
			VERIFIED_BADGE = VerifiedBadges.emoji.verified
		},
		totalItems = if not items then nil else {
			"Feature.Catalog.Feature.Catalog.Label.TotalItemsParenthesis",
			itemCount = #items
		}
	})
	local v49 = React.useCallback(function(p5) -- line: 177
		-- upvalues: v37 (copy), t2 (copy)
		v37(function(p6) -- line: 178
			-- upvalues: p5 (copy), t2 (copy)
			local v54 = p5
			local v55 = not p6.isTryOnEnabled

			if v55 then
				t2.analytics.reportTryOnButtonClicked(p5.itemType, p5.itemId)
			end

			if not v55 then
				v54 = {}
			end

			return {
				isTryOnEnabled = v55,
				tryOnItem = v54
			}
		end)
	end, { t2.analytics })
	local v50 = usePurchaseButtonProps({
		purchaseButtonText = v48.bulkPurchaseButtonText,
		onBulkPurchase = v39,
		isDisabled = not v40,
		selectedItem = v34,
		localizedStrings = v48,
		formattedTotalPrice = v43,
		onPromptPurchase = t2.onPromptPurchase
	})

	useEventConnection(MarketplaceService.PromptBulkPurchaseFinished, t2.onBulkPurchaseFinished)
	React.useEffect(function() -- line: 217
		-- upvalues: v46 (copy), v47 (copy)
		if v46.current then
			v46.current.CanvasPosition = Vector2.new(0, v47.current)
		end
	end, { v34 })
	React.useEffect(function() -- line: 224
		-- upvalues: v34 (copy), t2 (copy)
		if v34 then
			t2.onItemDetailsOpened(v34)
		end
	end, {
		v34,
		t2.onItemDetailsOpened
	})

	local v51 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else React.useCallback(function() -- line: 231
		-- upvalues: v45 (copy), t2 (copy)
		v45.clearAll()
		t2.onInspectMenuClosed()
	end, {
		v45,
		t2.onInspectMenuClosed
	})

	return {
		view = v32,
		renderFirstPanel = function() -- line: 238
			-- upvalues: v34 (copy), React (copy), ItemDetailsLayout (copy), v32 (copy), v35 (copy), v37 (copy), t2 (copy), ViewType (copy), v50 (copy), v49 (copy), v36 (copy), formatNumber (copy), AvatarItemsViewLayout (copy), items (copy), v48 (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v51 (copy), v46 (copy), v47 (copy), v43 (copy)
			if v34 then
				return (React.createElement(ItemDetailsLayout, {
					itemDetailsViewProps = {
						view = v32,
						item = v34,
						onItemDetailsClosed = function() -- line: 244
							-- upvalues: v35 (copy), v37 (copy)
							v35(nil)
							v37({
								isTryOnEnabled = false,
								tryOnItem = {}
							})
						end,
						onToggleFavorite = t2.onToggleFavorite,
						openAttributionOverlay = t2.openAttributionOverlay,
						purchaseButtonProps = if v32 ~= ViewType.Wide then nil else v50.purchaseButtonProps,
						onToggleTryOn = v49,
						renderTryOnViewport = t2.renderTryOnViewport,
						tryOnState = v36,
						localPlayerModel = t2.localPlayerModel,
						formatNumber = formatNumber
					},
					buyActionBarProps = v50,
					view = v32
				}))
			end

			return (React.createElement(AvatarItemsViewLayout, {
				view = v32,
				items = items,
				headerText = v48.headerText,
				onInspectMenuClosed = if not FFlagAXEnableIaBTimedOptionsBulkPurchase or not v51 then t2.onInspectMenuClosed else v51,
				onItemCardActivated = function(p7) -- line: 272
					-- upvalues: v46 (copy), v47 (copy), v35 (copy)
					if v46.current then
						v47.current = v46.current.CanvasPosition.Y
					end

					v35(p7)
				end,
				subheaderText = {
					leftSlotLabel = v48.totalItems or "",
					rightSlotPrice = v43
				},
				buyActionBarProps = v50,
				ref = v46
			}))
		end,
		renderSecondPanel = if not (v32 == ViewType.WideLandscape or (v32 == ViewType.Wide or v32 == ViewType.Compact) and not v34) then nil else function() -- line: 288
			-- upvalues: React (copy), ViewportLayout (copy), v32 (copy), v34 (copy), getItemThumbnailUrl (copy), v42 (copy), v35 (copy), t2 (copy), v33 (copy), v50 (copy), v36 (copy), v44 (copy)
			return React.createElement(ViewportLayout, {
				view = v32,
				thumbnailUrl = if not v34 then "rbxthumb://type=Avatar&id=" .. tostring(v42.playerId) .. "&w=420&h=420" else getItemThumbnailUrl(v34) or "",
				backButtonProps = {
					onBackButtonClick = if not v34 then t2.onInspectMenuClosed else function() -- line: 296
						-- upvalues: v35 (copy)
						v35(nil)
					end
				},
				viewportProps = {
					AspectRatio = 1,
					ScaleType = Enum.ScaleType.Crop,
					Size = if not v33 then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, 0)
				},
				buyActionBarProps = v50,
				Size = UDim2.new(1, 0, 1, 0),
				renderTryOnViewport = t2.renderTryOnViewport,
				tryOnState = v36,
				thumbnailPadding = if not v34 then nil else {
					left = UDim.new(0, v44.Padding.XXLarge),
					right = UDim.new(0, v44.Padding.XXLarge),
					top = UDim.new(0, v44.Padding.XXLarge),
					bottom = UDim.new(0, v44.Padding.XXLarge)
				}
			})
		end,
		panelConfig = t1[v32] or t1[ViewType.Wide]
	}
end
