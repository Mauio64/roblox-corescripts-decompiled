local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local tutils = require(parent.tutils)
local Cryo = require(parent.Cryo)
local SharedFlags = require(parent.SharedFlags)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local Constants = AvatarExperienceCommon.Constants

local CheckoutRowItemCard = require(AvatarExperienceCatalog.Components.Checkout.CheckoutRowItemCard)
local CheckoutErrorBanner = require(AvatarExperienceCatalog.Components.Checkout.CheckoutErrorBanner)
local useTimedOptionsFtux = require(AvatarExperienceCatalog.Hooks.useTimedOptionsFtux)

local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option

local function filterCartItems(cartItems, fn)
	local count = 0
	local children = {}

	for _, item in cartItems do
		if not fn(item) then
			continue
		end

		count += 1
		children[`{getTryOnItemReducerKey(item.itemId, item.itemType)}`] = React.createElement(
			CheckoutRowItemCard,
			Cryo.Dictionary.join(item, { LayoutOrder = count })
		)
	end

	return children
end

local function CheckoutPageBody(p)
	local v

	if FFlagAXDurables2Option then
		v = useTokens()
	end

	local v2 = useLocalization({
		makeupTitle = "Feature.Catalog.Label.Makeup",
		makeupCartDescriptionText = "Feature.Catalog.Label.MakeupCartDescriptionText",
		rentalFtuxText = FFlagAXDurables2Option and "Feature.Catalog.Title.RentalFtuxText" or nil
	})

	local state = nil
	local v3 = nil
	local onActivated

	if FFlagAXDurables2Option then
		local v4 = useTimedOptionsFtux()
		local setState
		state, setState = React.useState(v4.shouldShow2OptionToolTipInCheckoutPage())
		v3 = setState

		onActivated = React.useCallback(function()
			v4.hide2OptionToolTipInCheckoutPage()
			v3(false)
		end, { v4 })
	end

	local v4 = React.useMemo(function()
		return filterCartItems(p.cartItems, function(p2): boolean
			return Constants.MAKEUP_LOOK_ASSET_TYPES[p2.itemSubType] ~= nil
		end)
	end, { p.cartItems })

	local v5 = React.useMemo(function()
		return filterCartItems(p.cartItems, function(p2): boolean
			return not Constants.MAKEUP_LOOK_ASSET_TYPES[p2.itemSubType]
		end)
	end, { p.cartItems })

	local v6 = tutils.fieldCount(v4) > 0
	local v7 = tutils.fieldCount(v5) > 0
	local v8 = React.useMemo(function(): boolean
		for _, cartItem in p.cartItems do
			if cartItem.timedOptions and (not cartItem.isOwned or cartItem.expirationTime ~= nil) then
				return true
			end
		end

		return false
	end, { p.cartItems })

	local createElement = React.createElement
	local view = Foundation.View
	local v9 = {
		tag = FFlagAXMISWithBlackbird and "col auto-y" or "col",
		Size = 0
	}
	local size

	if FFlagAXMISWithBlackbird then
		size = UDim2.fromScale(1, 0)
	else
		size = UDim2.fromScale(1, 1)
	end

	v9.Size = size
	local checkoutErrorBannerView

	if p.erroredItemCount and p.erroredItemCount > 0 then
		checkoutErrorBannerView = React.createElement(
			Foundation.View,
			{
				tag = "auto-xy padding-x-xxlarge padding-y-medium",
				Size = UDim2.fromScale(1, 0),
				LayoutOrder = 1
			},
			{
				CheckoutErrorBanner = React.createElement(CheckoutErrorBanner, {
					erroredItemCount = p.erroredItemCount
				})
			}
		)
	end

	local tooltip2OptionBanner

	if FFlagAXDurables2Option and state and v8 then
		tooltip2OptionBanner = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y padding-x-xxlarge",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, -v.Size.Size_1800)
		}, {
			Banner = React.createElement(
				Foundation.View,
				{
					tag = "row align-y-center gap-medium size-full-0 auto-y padding-left-xlarge padding-right-xsmall padding-y-xsmall radius-medium bg-surface-300"
				},
				{
					Description = React.createElement(Foundation.Text, {
						tag = "fill auto-y text-caption-large text-align-x-left text-truncate-end content-emphasis",
						Text = v2.rentalFtuxText,
						LayoutOrder = 1
					}),
					DismissIcon = React.createElement(Foundation.IconButton, {
						icon = "icons/navigation/close",
						size = Foundation.Enums.IconSize.Small,
						onActivated = onActivated,
						LayoutOrder = 2,
						testId = "Checkout2OptionFtuxDismiss"
					})
				}
			)
		})
	end

	local allItemsView

	if v7 then
		allItemsView = React.createElement(
			Foundation.View,
			{
				tag = "col auto-y gap-medium padding-x-xxlarge padding-y-medium",
				Size = UDim2.fromScale(1, 0),
				LayoutOrder = 2
			},
			v5
		)
	end

	local makeupText

	if v6 then
		makeupText = React.createElement(Foundation.Text, {
			tag = "auto-xy padding-x-xxlarge padding-top-medium text-title-medium content-emphasis",
			Text = v2.makeupTitle .. " (" .. tutils.fieldCount(v4) .. "/8)",
			LayoutOrder = 3
		})
	end

	local makeupDescriptionText

	if v6 then
		makeupDescriptionText = React.createElement(Foundation.Text, {
			tag = "auto-xy padding-x-xxlarge padding-top-xxsmall padding-bottom-medium text-body-small",
			Text = v2.makeupCartDescriptionText,
			LayoutOrder = 4
		})
	end

	local makeupItemsView

	if v6 then
		makeupItemsView = React.createElement(
			Foundation.View,
			{
				tag = "col auto-y gap-medium padding-x-xxlarge padding-y-medium",
				Size = UDim2.fromScale(1, 0),
				LayoutOrder = 5
			},
			v4
		)
	end

	return createElement(view, v9, {
		CheckoutErrorBannerView = checkoutErrorBannerView,
		Tooltip2OptionBanner = tooltip2OptionBanner,
		AllItemsView = allItemsView,
		MakeupText = makeupText,
		MakeupDescriptionText = makeupDescriptionText,
		MakeupItemsView = makeupItemsView
	})
end

return React.memo(CheckoutPageBody, tutils.deepEqual)
