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
local FFlagAXFixBulkPurchaseFreeItems = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXFixBulkPurchaseFreeItems
local formatNumber = require(AvatarExperienceInspectAndBuy.Utils.formatNumber)

local function selectView(p1) -- line: 55
	return p1.view
end
local function selectInspectPreviewDetails(p2) -- line: 59
	return p2.avatarPreviewDetails
end
local function shouldRenderSecondPanel(p3, p4) -- line: 70
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

return function(t2: {[any]: any}) -- line: 132
	-- upvalues: useSelector (copy), selectView (copy), tutils (copy), ViewType (copy), React (copy), selectInspectPreviewDetails (copy), useRemoteBulkPurchaseEvent (copy), useInspectPlayer (copy), formatNumber (copy), useTokens (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), useItemSelectionStore (copy), useLocalization (copy), VerifiedBadges (copy), usePurchaseButtonProps (copy), FFlagAXFixBulkPurchaseFreeItems (copy), useEventConnection (copy), MarketplaceService (copy), ItemDetailsLayout (copy), AvatarItemsViewLayout (copy), ViewportLayout (copy), getItemThumbnailUrl (copy), t1 (copy)
	local v33 = useSelector(selectView, tutils.deepEqual)
	local v34 = v33 == ViewType.WideLandscape
	local v35, v36 = React.useState(nil)
	local v37, v38 = React.useState({
		isTryOnEnabled = false,
		tryOnItem = {}
	})
	local items = useSelector(selectInspectPreviewDetails, tutils.deepEqual).items
	local v40, v41, v42 = useRemoteBulkPurchaseEvent(items, t2.analytics)
	local v43 = useInspectPlayer()
	local v44 = formatNumber(v42)
	local v45 = useTokens()
	local v46 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else useItemSelectionStore()
	local v47 = React.useRef(nil)
	local v48 = React.useRef(0)
	local v49 = useLocalization({
		bulkPurchaseButtonText = "Feature.Catalog.Label.BuyItems",
		total = "Feature.Catalog.Label.TotalUnformatted",
		headerText = if not v43.hasVerifiedBadge then {
			"InGame.InspectMenu.Label.Avatar",
			PLAYER_NAME = v43.playerName
		} else {
			"InGame.InspectMenu.Label.VerifiedAvatar",
			PLAYER_NAME = v43.playerName,
			VERIFIED_BADGE = VerifiedBadges.emoji.verified
		},
		totalItems = if not items then nil else {
			"Feature.Catalog.Feature.Catalog.Label.TotalItemsParenthesis",
			itemCount = #items
		}
	})
	local v50 = React.useCallback(function(p5) -- line: 178
		-- upvalues: v38 (copy), t2 (copy)
		v38(function(p6) -- line: 179
			-- upvalues: p5 (copy), t2 (copy)
			local v55 = p5
			local v56 = not p6.isTryOnEnabled

			if v56 then
				t2.analytics.reportTryOnButtonClicked(p5.itemType, p5.itemId)
			end

			if not v56 then
				v55 = {}
			end

			return {
				isTryOnEnabled = v56,
				tryOnItem = v55
			}
		end)
	end, { t2.analytics })
	local v51 = usePurchaseButtonProps({
		purchaseButtonText = v49.bulkPurchaseButtonText,
		onBulkPurchase = v40,
		isDisabled = if not FFlagAXFixBulkPurchaseFreeItems then items == nil or (v42 == 0 or not v41) else not v41,
		selectedItem = v35,
		localizedStrings = v49,
		formattedTotalPrice = v44,
		onPromptPurchase = t2.onPromptPurchase
	})

	useEventConnection(MarketplaceService.PromptBulkPurchaseFinished, t2.onBulkPurchaseFinished)
	React.useEffect(function() -- line: 220
		-- upvalues: v47 (copy), v48 (copy)
		if v47.current then
			v47.current.CanvasPosition = Vector2.new(0, v48.current)
		end
	end, { v35 })
	React.useEffect(function() -- line: 227
		-- upvalues: v35 (copy), t2 (copy)
		if v35 then
			t2.onItemDetailsOpened(v35)
		end
	end, {
		v35,
		t2.onItemDetailsOpened
	})

	local v52 = if not FFlagAXEnableIaBTimedOptionsBulkPurchase then nil else React.useCallback(function() -- line: 234
		-- upvalues: v46 (copy), t2 (copy)
		v46.clearAll()
		t2.onInspectMenuClosed()
	end, {
		v46,
		t2.onInspectMenuClosed
	})

	return {
		view = v33,
		renderFirstPanel = function() -- line: 241
			-- upvalues: v35 (copy), React (copy), ItemDetailsLayout (copy), v33 (copy), v36 (copy), v38 (copy), t2 (copy), ViewType (copy), v51 (copy), v50 (copy), v37 (copy), formatNumber (copy), AvatarItemsViewLayout (copy), items (copy), v49 (copy), FFlagAXEnableIaBTimedOptionsBulkPurchase (copy), v52 (copy), v47 (copy), v48 (copy), v44 (copy)
			if v35 then
				return (React.createElement(ItemDetailsLayout, {
					itemDetailsViewProps = {
						view = v33,
						item = v35,
						onItemDetailsClosed = function() -- line: 247
							-- upvalues: v36 (copy), v38 (copy)
							v36(nil)
							v38({
								isTryOnEnabled = false,
								tryOnItem = {}
							})
						end,
						onToggleFavorite = t2.onToggleFavorite,
						openAttributionOverlay = t2.openAttributionOverlay,
						purchaseButtonProps = if v33 ~= ViewType.Wide then nil else v51.purchaseButtonProps,
						onToggleTryOn = v50,
						renderTryOnViewport = t2.renderTryOnViewport,
						tryOnState = v37,
						localPlayerModel = t2.localPlayerModel,
						formatNumber = formatNumber
					},
					buyActionBarProps = v51,
					view = v33
				}))
			end

			return (React.createElement(AvatarItemsViewLayout, {
				view = v33,
				items = items,
				headerText = v49.headerText,
				onInspectMenuClosed = if not FFlagAXEnableIaBTimedOptionsBulkPurchase or not v52 then t2.onInspectMenuClosed else v52,
				onItemCardActivated = function(p7) -- line: 275
					-- upvalues: v47 (copy), v48 (copy), v36 (copy)
					if v47.current then
						v48.current = v47.current.CanvasPosition.Y
					end

					v36(p7)
				end,
				subheaderText = {
					leftSlotLabel = v49.totalItems or "",
					rightSlotPrice = v44
				},
				buyActionBarProps = v51,
				ref = v47
			}))
		end,
		renderSecondPanel = if not (v33 == ViewType.WideLandscape or (v33 == ViewType.Wide or v33 == ViewType.Compact) and not v35) then nil else function() -- line: 291
			-- upvalues: React (copy), ViewportLayout (copy), v33 (copy), v35 (copy), getItemThumbnailUrl (copy), v43 (copy), v36 (copy), t2 (copy), v34 (copy), v51 (copy), v37 (copy), v45 (copy)
			return React.createElement(ViewportLayout, {
				view = v33,
				thumbnailUrl = if not v35 then "rbxthumb://type=Avatar&id=" .. tostring(v43.playerId) .. "&w=420&h=420" else getItemThumbnailUrl(v35) or "",
				backButtonProps = {
					onBackButtonClick = if not v35 then t2.onInspectMenuClosed else function() -- line: 299
						-- upvalues: v36 (copy)
						v36(nil)
					end
				},
				viewportProps = {
					AspectRatio = 1,
					ScaleType = Enum.ScaleType.Crop,
					Size = if not v34 then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, 0)
				},
				buyActionBarProps = v51,
				Size = UDim2.new(1, 0, 1, 0),
				renderTryOnViewport = t2.renderTryOnViewport,
				tryOnState = v37,
				thumbnailPadding = if not v35 then nil else {
					left = UDim.new(0, v45.Padding.XXLarge),
					right = UDim.new(0, v45.Padding.XXLarge),
					top = UDim.new(0, v45.Padding.XXLarge),
					bottom = UDim.new(0, v45.Padding.XXLarge)
				}
			})
		end,
		panelConfig = t1[v33] or t1[ViewType.Wide]
	}
end
