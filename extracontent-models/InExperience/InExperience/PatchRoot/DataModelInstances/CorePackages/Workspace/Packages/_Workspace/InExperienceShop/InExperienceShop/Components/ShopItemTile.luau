local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local SessionService = game:GetService("SessionService")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local Badge = Foundation.Badge
local useTokens = Foundation.Hooks.useTokens

local IconSize = Enums.IconSize

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ShopItemFooter = require(InExperienceShop.Components.ShopItemFooter)
local useGamePassTrialRedemption = require(InExperienceShop.Hooks.useGamePassTrialRedemption)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local toUnifiedCategoryId = require(InExperienceShop.Analytics.toUnifiedCategoryId)
local computeShopRowTileWidths = require(InExperienceShop.Components.computeShopRowTileWidths)
local SHOP_ITEM_MEDIA_HEIGHT_SCALE = computeShopRowTileWidths.SHOP_ITEM_MEDIA_HEIGHT_SCALE
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local FFlagEnableCategoryLoggingInShop = require(InExperienceShop.Flags.FFlagEnableCategoryLoggingInShop)
local FFlagCategoryLoggingInShopPurchase = require(InExperienceShop.Flags.FFlagCategoryLoggingInShopPurchase)
local FFlagFixThumbnailBackgroundInExperienceShop = require(InExperienceShop.Flags.FFlagFixThumbnailBackgroundInExperienceShop)
local FFlagEnableDiscountOnInShopTile = require(InExperienceShop.Flags.FFlagEnableDiscountOnInShopTile)
local FFlagLuaAppEnableGamePassFreeTrials = require(InExperienceShop.Flags.FFlagLuaAppEnableGamePassFreeTrials)
local FFlagEnableGamePassTrialUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableGamePassTrialUnifiedLogging)
local getIconRichText = Foundation.Utility.getIconRichText
local formatPrice

if FFlagEnableDiscountOnInShopTile then
	formatPrice = require(InExperienceShop.Utils.formatPrice)
else
	formatPrice = nil
end

require(InExperienceShop.Types)

local Constants = require(InExperienceShop.Constants)

local v = {
	freeTrial = "Feature.InExperienceShop.Label.FreeTrial",
	trial = "Feature.InExperienceShop.Label.Trial",
	active = "Feature.InExperienceShop.Label.Active",
	trialed = "Feature.InExperienceShop.Label.Trialed"
}

local function TrialBadge(p)
	local v2 = useLocalization(v)
	local v3 = useTokens()
	local text

	if p.freeTrialStatus == "active" then
		text = v2.active
	elseif p.freeTrialStatus == "redeemed" then
		text = v2.trialed
	else
		text = v2.trial
	end

	local variant

	if p.freeTrialStatus == "active" then
		variant = Enums.BadgeVariant.Emphasis
	else
		variant = Enums.BadgeVariant.OverMedia
	end

	return React.createElement(Badge, {
		text = text,
		variant = variant,
		size = Enums.BadgeSize.Small,
		Position = UDim2.fromOffset(v3.Gap.Small, v3.Gap.Small),
		testId = "ShopItemTile-TrialBadge"
	})
end

local function FreeTrialLabel(p)
	local v2 = useLocalization(v)
	local v3 = useTokens()

	return React.createElement(Text, {
		tag = "auto-xy",
		fontStyle = v3.Typography.BodyMedium,
		Text = v2.freeTrial,
		LayoutOrder = p.LayoutOrder
	})
end

local function ShopItemTile(props)
	local v2 = SignalsReact.useSignalState(getInExperienceShopStore)
	local ref = React.useRef(nil)

	local isOwned = SignalsReact.useSignalState(function(p)
		return v2.getOwnership(p)[props.itemId]
	end)

	React.useEffect(function()
		if props.itemType == "GamePass" then
			v2.fetchGamePassOwnership(props.itemId)
		end
	end, { props.itemId, props.itemType, v2.fetchGamePassOwnership })

	local showTry = SignalsReact.useSignalState(function(p): boolean
		local available = v2.getTrialAvailabilities(p).available

		if FFlagLuaAppEnableGamePassFreeTrials and props.itemType == "GamePass" then
			return available[props.itemId] == true
		end

		return false
	end)
	local v3 = FFlagLuaAppEnableGamePassFreeTrials and showTry and not isOwned
	local v4

	if FFlagLuaAppEnableGamePassFreeTrials then
		v4 = SignalsReact.useSignalState(function(p): boolean
			local active = v2.getTrialAvailabilities(p).active
			return props.itemType == "GamePass" and active[props.itemId] == true
		end)
	else
		v4 = false
	end

	local v5

	if FFlagLuaAppEnableGamePassFreeTrials then
		v5 = SignalsReact.useSignalState(function(p): boolean
			local redeemed = v2.getTrialAvailabilities(p).redeemed
			return props.itemType == "GamePass" and redeemed ~= nil and redeemed[props.itemId] ~= nil
		end)
	else
		v5 = false
	end

	local freeTrialStatus = v3 and "available" or v4 and not isOwned and "active" or v5 and "redeemed" or nil
	local trialStatus = FFlagEnableGamePassTrialUnifiedLogging
		and props.itemType == "GamePass"
		and (freeTrialStatus == "available" and "available" or freeTrialStatus == "active" and "Active" or freeTrialStatus == "redeemed" and "Redeemed" or "unavailable")
		or nil

	local v6 = not FFlagEnableGamePassTrialUnifiedLogging and "settled" or SignalsReact.useSignalState(function(p)
		local trialAvailabilityPhase = v2.getTrialAvailabilityPhase(p)

		if props.itemType == "GamePass" then
			return trialAvailabilityPhase
		end

		return "settled"
	end)
	local v7

	if trialStatus ~= nil then
		v7 = { shopPageType = props.shopPageType, universeId = 0, trialStatus = 0 }
		local universeId

		if props.universeId ~= nil then
			universeId = tonumber(props.universeId)
		end

		v7.universeId = universeId
		v7.trialStatus = trialStatus
	end

	local useEffect = React.useEffect
	local function fn()
		if
			not FFlagEnableInExperienceShopUnifiedLogging
			or FFlagEnableGamePassTrialUnifiedLogging and props.itemType == "GamePass" and v6 ~= "settled"
		then
			return
		end

		task.defer(function()
			local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
			local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
			local mapShopItemTypeToUnifiedItemType = require(InExperienceShop.Utils.mapShopItemTypeToUnifiedItemType)
			local itemType = mapShopItemTypeToUnifiedItemType(props.itemType)

			if itemType == nil then
				return
			end

			local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventStrictPayloads
			local universeId

			if props.universeId == nil then
				universeId = game.GameId
			else
				universeId = tonumber(props.universeId)
			end

			local v8 = {
				universeId = universeId,
				itemId = props.itemId,
				itemType = itemType,
				categoryId = 0,
				gridPositionRow = 0,
				gridPositionColumn = 0,
				categoryType = 0,
				stableCategoryId = 0,
				categoryGroup = 0,
				categoryName = 0
			}
			local categoryId

			if fFlagAXUnifiedEventStrictPayloads then
				categoryId = toUnifiedCategoryId(props.categoryId)
			else
				categoryId = props.categoryId
			end

			v8.categoryId = categoryId

			v8.gridPositionRow = props.gridPositionRow
			v8.gridPositionColumn = props.gridPositionColumn
			local categoryType

			if FFlagEnableCategoryLoggingInShop then
				categoryType = props.categoryType
			end

			v8.categoryType = categoryType
			local stableCategoryId

			if FFlagEnableCategoryLoggingInShop then
				stableCategoryId = props.stableCategoryId
			end

			v8.stableCategoryId = stableCategoryId
			local categoryGroup

			if FFlagEnableCategoryLoggingInShop then
				categoryGroup = props.categoryGroup
			end

			v8.categoryGroup = categoryGroup
			local categoryName

			if FFlagEnableCategoryLoggingInShop then
				categoryName = props.categoryName
			end

			v8.categoryName = categoryName

			if FFlagEnableGamePassTrialUnifiedLogging and props.itemType == "GamePass" then
				v8.trialStatus = trialStatus
				local elementsShown

				if trialStatus == "available" then
					elementsShown = "try_button,trial_badge,free_trial_text"
				elseif trialStatus == "Redeemed" then
					elementsShown = props.price == nil and "trialed_badge" or "trialed_badge,price"
				else
					elementsShown = trialStatus == "Active"
						and (props.price == nil and "active_badge" or "active_badge,price")
						or nil
				end

				if elementsShown == nil then
					if ref.current ~= nil then
						local unifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
						ref.current:SetAttribute(unifiedEventLogConstants.ATTRIBUTE_PREFIX .. "elementMetadata", nil)
					end
				else
					local HttpService = game:GetService("HttpService")
					v8.elementMetadata = HttpService:JSONEncode({ elementsShown = elementsShown })
				end
			end

			addUnifiedEventLogging(ref, v8, {
				sessionTagName = SessionService:GetSessionTag("level2a")
			})
		end)
	end

	local itemId = props.itemId
	local itemType = props.itemType
	local universeId = props.universeId
	local categoryId = props.categoryId
	local gridPositionRow = props.gridPositionRow
	local gridPositionColumn = props.gridPositionColumn
	local categoryType

	if FFlagEnableCategoryLoggingInShop then
		categoryType = props.categoryType
	end

	local stableCategoryId

	if FFlagEnableCategoryLoggingInShop then
		stableCategoryId = props.stableCategoryId
	end

	local categoryGroup

	if FFlagEnableCategoryLoggingInShop then
		categoryGroup = props.categoryGroup
	end

	local categoryName

	if FFlagEnableCategoryLoggingInShop then
		categoryName = props.categoryName
	end

	local v8

	if FFlagEnableGamePassTrialUnifiedLogging then
		v8 = v6
	end

	local v9

	if FFlagEnableGamePassTrialUnifiedLogging then
		v9 = trialStatus
	end

	local v10

	if FFlagEnableGamePassTrialUnifiedLogging then
		v10 = props.price
	end

	useEffect(fn, {
		itemId,
		itemType,
		universeId,
		categoryId,
		gridPositionRow,
		gridPositionColumn,
		categoryType,
		stableCategoryId,
		categoryGroup,
		categoryName,
		v8,
		v9,
		v10
	})

	local onItemActivated = props.onItemActivated

	local itemType2 = props.itemType
	local onActivated = React.useCallback(function()
		if onItemActivated then
			onItemActivated(props.itemId, itemType2)
		end
	end, { props.itemId, itemType2, onItemActivated })

	local v11 = nil

	if FFlagCategoryLoggingInShopPurchase then
		local v12 = {
			categoryGroup = props.categoryGroup,
			categoryPosition = props.categoryId,
			gridPositionRow = props.gridPositionRow,
			gridPositionColumn = props.gridPositionColumn,
			categoryName = props.categoryName,
			stableCategoryId = props.stableCategoryId
		}

		if
			v12.categoryGroup ~= nil
			or v12.categoryPosition ~= nil
			or v12.gridPositionRow ~= nil
			or v12.gridPositionColumn ~= nil
			or v12.categoryName ~= nil
			or v12.stableCategoryId ~= nil
		then
			v11 = v12
		end
	end

	local itemId2 = props.itemId
	local v12 = {
		shopPageType = props.shopPageType,
		categoryLocation = v11,
		universeId = 0,
		trialStatus = 0
	}
	local universeId2

	if v7 ~= nil then
		universeId2 = v7.universeId
	end

	v12.universeId = universeId2
	local trialStatus2

	if v7 ~= nil then
		trialStatus2 = v7.trialStatus
	end

	v12.trialStatus = trialStatus2
	local v13 = useGamePassTrialRedemption(itemId2, v12)

	local v14 = FFlagEnableDiscountOnInShopTile

	if v14 then
		if props.userBasePriceInRobux == nil or props.price == nil then
			v14 = false
		else
			v14 = props.userBasePriceInRobux > props.price
		end
	end

	local v15

	if v14 and formatPrice then
		v15 = formatPrice(props.userBasePriceInRobux)
	end

	local v16

	if v14 and formatPrice then
		v16 = formatPrice(props.price)
	end

	if FFlagEnableGamePassTrialUnifiedLogging and props.itemType == "GamePass" and v6 ~= "settled" then
		return React.createElement(
			View,
			{
				tag = "col fill size-full-0 auto-y radius-medium clip bg-shift-200",
				LayoutOrder = props.LayoutOrder,
				testId = "ShopItemTile-TrialLoading"
			},
			{
				Media = React.createElement(View, {
					tag = "radius-medium bg-shift-200",
					Size = UDim2.fromScale(1, SHOP_ITEM_MEDIA_HEIGHT_SCALE),
					SizeConstraint = Enum.SizeConstraint.RelativeXX,
					LayoutOrder = 1
				}),
				TileContent = React.createElement(
					View,
					{ tag = "col gap-medium size-full-0 auto-y padding-medium", LayoutOrder = 2 },
					{
						Title = React.createElement(View, {
							tag = "radius-small bg-shift-200",
							Size = UDim2.new(1, 0, 0, 16),
							LayoutOrder = 1
						}),
						Price = React.createElement(View, {
							tag = "radius-small bg-shift-200",
							Size = UDim2.new(0.4, 0, 0, 12),
							LayoutOrder = 2
						}),
						Button = React.createElement(View, {
							tag = "radius-small bg-shift-200",
							Size = UDim2.new(1, 0, 0, 28),
							LayoutOrder = 3
						})
					}
				)
			}
		)
	end

	local createElement = React.createElement
	local v17 = {
		tag = "col fill size-full-0 auto-y radius-medium clip bg-shift-200",
		LayoutOrder = props.LayoutOrder,
		onActivated = 0,
		ref = 0
	}

	if not onItemActivated then
		onActivated = nil
	end

	v17.onActivated = onActivated
	local ref2

	if FFlagEnableInExperienceShopUnifiedLogging then
		ref2 = ref
	end

	v17.ref = ref2

	local createElement2 = React.createElement
	local v18 = {
		tag = {
			["radius-medium bg-shift-200"] = FFlagFixThumbnailBackgroundInExperienceShop,
			["radius-medium"] = not FFlagFixThumbnailBackgroundInExperienceShop
		},
		Size = UDim2.fromScale(1, SHOP_ITEM_MEDIA_HEIGHT_SCALE),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		Image = props.thumbnail,
		ScaleType = Enum.ScaleType.Fit,
		LayoutOrder = 1
	}
	local trialBadge

	if freeTrialStatus ~= nil then
		trialBadge = React.createElement(TrialBadge, { freeTrialStatus = freeTrialStatus })
	end

	local children = {
		Media = createElement2(Image, v18, { TrialBadge = trialBadge }),
		TileContent = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local v19 = {
		Title = React.createElement(Text, {
			tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis",
			Text = props.name,
			LayoutOrder = 1
		}),
		FreeTrialLabel = 0,
		Metadata = 0
	}
	local freeTrialLabel

	if v3 then
		freeTrialLabel = React.createElement(FreeTrialLabel, { LayoutOrder = 2 })
	end

	v19.FreeTrialLabel = freeTrialLabel
	local metadata

	if props.price and not v3 then
		if FFlagEnableDiscountOnInShopTile then
			local createElement5 = React.createElement

			local v20 = {
				SalePrice = React.createElement(
					View,
					{ tag = "row align-y-center gap-xsmall auto-xy", LayoutOrder = 1 },
					{
						SaleRobuxIcon = React.createElement(Icon, {
							name = Constants.ROBUX_ICON,
							size = IconSize.Small,
							LayoutOrder = 1
						}),
						SalePriceLabel = React.createElement(Text, {
							tag = "auto-xy text-body-medium text-truncate-end content-emphasis",
							Text = v16 or tostring(props.price),
							LayoutOrder = 2
						})
					}
				),
				OriginalPrice = 0
			}
			local originalPrice

			if v14 and v15 then
				originalPrice = React.createElement(Text, {
					tag = "auto-xy text-body-small text-truncate-end content-default",
					Text = "<s>" .. getIconRichText(Enums.IconName.Robux) .. " " .. v15 .. "</s>",
					RichText = true,
					LayoutOrder = 2
				})
			end

			v20.OriginalPrice = originalPrice
			metadata = createElement5(View, {
				tag = "row align-y-center gap-xsmall auto-xy",
				LayoutOrder = 2
			}, v20)
		else
			metadata = React.createElement(View, {
				tag = "row align-y-center gap-xsmall auto-xy",
				LayoutOrder = 2
			}, {
				RobuxIcon = React.createElement(Icon, {
					name = Constants.ROBUX_ICON,
					size = IconSize.Small,
					LayoutOrder = 1
				}),
				PriceLabel = React.createElement(Text, {
					tag = "auto-xy text-body-medium text-truncate-end content-default",
					Text = tostring(props.price),
					LayoutOrder = 2
				})
			})
		end
	end

	v19.Metadata = metadata
	children.TileContent = createElement3(
		View,
		{ tag = "col gap-medium size-full-0 auto-y padding-medium", LayoutOrder = 2 },
		{
			ContentHeader = createElement4(View, { tag = "col size-full-0 auto-y", LayoutOrder = 1 }, v19),
			Footer = React.createElement(ShopItemFooter, {
				itemId = props.itemId,
				itemType = props.itemType,
				isOwned = isOwned,
				showTry = showTry,
				isActionLoading = v13.isActionLoading,
				isActionDisabled = v13.isActionDisabled,
				onTryActivated = v13.onTryActivated,
				price = props.price,
				shopPageType = props.shopPageType,
				purchaseCategoryLocation = v11,
				LayoutOrder = 2
			})
		}
	)
	return createElement(View, v17, children)
end

return React.memo(ShopItemTile)
