local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local Foundation = require(AvatarExperienceCatalogParent.Foundation)
local tutils = require(AvatarExperienceCatalogParent.tutils)
local Cryo = require(AvatarExperienceCatalogParent.Cryo)
local SharedFlags = require(AvatarExperienceCatalogParent.SharedFlags)
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local Constants = AvatarExperienceCommon.Constants
local CheckoutRowItemCard = require(AvatarExperienceCatalog.Components.Checkout.CheckoutRowItemCard)
local CheckoutErrorBanner = require(AvatarExperienceCatalog.Components.Checkout.CheckoutErrorBanner)
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local function filterCartItems(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 26
	-- upvalues: getTryOnItemReducerKey (copy), React (copy), CheckoutRowItemCard (copy), Cryo (copy)
	local t2 = {}
	local n1 = 0

	for _, v22 in t1 do
		if p1(v22) then
			n1 += 1
			t2[`{ getTryOnItemReducerKey(v22.itemId, v22.itemType) }`] = React.createElement(CheckoutRowItemCard, Cryo.Dictionary.join(v22, {
				LayoutOrder = n1
			}))
		end
	end

	return t2
end
local function CheckoutPageBody(t3: {[any]: any}) -- line: 46
	-- upvalues: useLocalization (copy), React (copy), filterCartItems (copy), Constants (copy), tutils (copy), Foundation (copy), FFlagAXMISWithBlackbird (copy), CheckoutErrorBanner (copy)
	local v24 = useLocalization({
		makeupTitle = "Feature.Catalog.Label.Makeup",
		makeupCartDescriptionText = "Feature.Catalog.Label.MakeupCartDescriptionText"
	})
	local v25 = React.useMemo(function() -- line: 52
		-- upvalues: filterCartItems (copy), t3 (copy), Constants (copy)
		return (filterCartItems(t3.cartItems, function(p2) -- line: 53
			-- upvalues: Constants (copy)
			return Constants.MAKEUP_LOOK_ASSET_TYPES[p2.itemSubType] ~= nil
		end))
	end, { t3.cartItems })
	local v26 = React.useMemo(function() -- line: 58
		-- upvalues: filterCartItems (copy), t3 (copy), Constants (copy)
		return (filterCartItems(t3.cartItems, function(p3) -- line: 59
			-- upvalues: Constants (copy)
			return not Constants.MAKEUP_LOOK_ASSET_TYPES[p3.itemSubType]
		end))
	end, { t3.cartItems })
	local v27 = tutils.fieldCount(v25) > 0
	local v28 = tutils.fieldCount(v26) > 0

	return React.createElement(Foundation.View, {
		tag = not FFlagAXMISWithBlackbird and "col" or "col auto-y",
		Size = if not FFlagAXMISWithBlackbird then UDim2.fromScale(1, 1) else UDim2.fromScale(1, 0)
	}, {
		CheckoutErrorBannerView = if not t3.erroredItemCount or not (t3.erroredItemCount > 0) then nil else React.createElement(Foundation.View, {
			tag = "auto-xy padding-x-xxlarge padding-y-medium",
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0)
		}, {
			CheckoutErrorBanner = React.createElement(CheckoutErrorBanner, {
				erroredItemCount = t3.erroredItemCount
			})
		}),
		AllItemsView = if not v28 then nil else React.createElement(Foundation.View, {
			tag = "col auto-y gap-medium padding-x-xxlarge padding-y-medium",
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0)
		}, v26),
		MakeupText = if not v27 then nil else React.createElement(Foundation.Text, {
			tag = "auto-xy padding-x-xxlarge padding-top-medium text-title-medium content-emphasis",
			LayoutOrder = 3,
			Text = v24.makeupTitle .. " (" .. tutils.fieldCount(v25) .. "/8)"
		}),
		MakeupDescriptionText = if not v27 then nil else React.createElement(Foundation.Text, {
			tag = "auto-xy padding-x-xxlarge padding-top-xxsmall padding-bottom-medium text-body-small",
			LayoutOrder = 4,
			Text = v24.makeupCartDescriptionText
		}),
		MakeupItemsView = if not v27 then nil else React.createElement(Foundation.View, {
			tag = "col auto-y gap-medium padding-x-xxlarge padding-y-medium",
			LayoutOrder = 5,
			Size = UDim2.fromScale(1, 0)
		}, v25)
	})
end

return React.memo(CheckoutPageBody, tutils.deepEqual)
