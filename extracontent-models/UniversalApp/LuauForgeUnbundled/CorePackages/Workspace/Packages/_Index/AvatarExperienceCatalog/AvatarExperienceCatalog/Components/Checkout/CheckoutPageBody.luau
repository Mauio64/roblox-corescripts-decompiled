local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/tutils")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local constants = AvatarExperienceCommon.Constants

local CheckoutRowItemCard = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutRowItemCard")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutErrorBanner")
local useTimedOptionsFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useTimedOptionsFtux")

local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option

local function filterCartItems(cartItems, fn)
	local count = 0
	local children = {}

	for k, item in cartItems do
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

local function CheckoutPageBody(p2)
	local v5 = if fFlagAXDurables2Option then useTokens() else nil
	local v6 = useLocalization({
		makeupTitle = "Feature.Catalog.Label.Makeup",
		makeupCartDescriptionText = "Feature.Catalog.Label.MakeupCartDescriptionText",
		rentalFtuxText = fFlagAXDurables2Option and "Feature.Catalog.Title.RentalFtuxText" or nil
	})

	local state = nil
	local v7 = nil
	local v8

	if fFlagAXDurables2Option then
		local v9 = useTimedOptionsFtux()
		local setState
		state, setState = React.useState(v9.shouldShow2OptionToolTipInCheckoutPage())
		v7 = setState

		v8 = React.useCallback(function()
			v9.hide2OptionToolTipInCheckoutPage()
			v7(false)
		end, { v9 })
	end

	local v9 = React.useMemo(function()
		return filterCartItems(p2.cartItems, function(p3): boolean
			return constants.MAKEUP_LOOK_ASSET_TYPES[p3.itemSubType] ~= nil
		end)
	end, { p2.cartItems })

	local v10 = React.useMemo(function()
		return filterCartItems(p2.cartItems, function(p3): boolean
			return not constants.MAKEUP_LOOK_ASSET_TYPES[p3.itemSubType]
		end)
	end, { p2.cartItems })

	local v11 = tutils.fieldCount(v9) > 0
	local v12 = tutils.fieldCount(v10) > 0
	local v13 = React.useMemo(function(): boolean
		for k, cartItem in p2.cartItems do
			if cartItem.timedOptions and (not cartItem.isOwned or cartItem.expirationTime ~= nil) then
				return true
			end
		end

		return false
	end, { p2.cartItems })

	local createElement = React.createElement
	local view = Foundation.View
	local v14 = {
		tag = fFlagAXMISWithBlackbird and "col auto-y" or "col",
		Size = 0
	}

	local v15 = if fFlagAXMISWithBlackbird then UDim2.fromScale(1, 0) else UDim2.fromScale(1, 1)
	v14.Size = v15

	local v17 = if p2.erroredItemCount and p2.erroredItemCount > 0 then React.createElement(
		Foundation.View,
		{
			tag = "auto-xy padding-x-xxlarge padding-y-medium",
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = 1
		},
		{
			CheckoutErrorBanner = React.createElement(module9, {
				erroredItemCount = p2.erroredItemCount
			})
		}
	) else nil

	local v18 = if fFlagAXDurables2Option and state and v13 then React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y padding-x-xxlarge",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, -v5.Size.Size_1800)
	}, {
		Banner = React.createElement(
			Foundation.View,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y padding-left-xlarge padding-right-xsmall padding-y-xsmall radius-medium bg-surface-300"
			},
			{
				Description = React.createElement(Foundation.Text, {
					tag = "fill auto-y text-caption-large text-align-x-left text-truncate-end content-emphasis",
					Text = v6.rentalFtuxText,
					LayoutOrder = 1
				}),
				DismissIcon = React.createElement(Foundation.IconButton, {
					icon = "icons/navigation/close",
					size = Foundation.Enums.IconSize.Small,
					onActivated = v8,
					LayoutOrder = 2,
					testId = "Checkout2OptionFtuxDismiss"
				})
			}
		)
	}) else nil

	local v19 = if v12 then React.createElement(
		Foundation.View,
		{
			tag = "col auto-y gap-medium padding-x-xxlarge padding-y-medium",
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = 2
		},
		v10
	) else nil

	local v20 = if v11 then React.createElement(Foundation.Text, {
		tag = "auto-xy padding-x-xxlarge padding-top-medium text-title-medium content-emphasis",
		Text = v6.makeupTitle .. " (" .. tutils.fieldCount(v9) .. "/8)",
		LayoutOrder = 3
	}) else nil

	local v21 = if v11 then React.createElement(Foundation.Text, {
		tag = "auto-xy padding-x-xxlarge padding-top-xxsmall padding-bottom-medium text-body-small",
		Text = v6.makeupCartDescriptionText,
		LayoutOrder = 4
	}) else nil

	local v22 = if v11 then React.createElement(
		Foundation.View,
		{
			tag = "col auto-y gap-medium padding-x-xxlarge padding-y-medium",
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = 5
		},
		v9
	) else nil
	return createElement(view, v14, {
		CheckoutErrorBannerView = v17,
		Tooltip2OptionBanner = v18,
		AllItemsView = v19,
		MakeupText = v20,
		MakeupDescriptionText = v21,
		MakeupItemsView = v22
	})
end

return React.memo(CheckoutPageBody, tutils.deepEqual)
