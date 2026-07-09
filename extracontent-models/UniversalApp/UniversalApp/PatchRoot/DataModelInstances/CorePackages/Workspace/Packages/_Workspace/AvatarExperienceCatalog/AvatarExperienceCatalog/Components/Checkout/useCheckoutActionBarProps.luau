local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local tutils = require(AvatarExperienceCatalogParent.tutils)
local useNavigation = require(AvatarExperienceCatalogParent.Navigation).useNavigation
local useMultiItemShoppingFtux = require(AvatarExperienceCatalog.Hooks.useMultiItemShoppingFtux)

require(AvatarExperienceCatalog.Components.Checkout.CheckoutActionBar)

local AvatarExperienceNavigation = require(AvatarExperienceCatalogParent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local ClearTryOns = require(AvatarExperienceCatalogParent.AvatarExperienceRodux).Actions.ClearTryOns
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local v11 = game:DefineFastInt("AXCheckoutButtonTooltipFtuxDelay", 500)
local v12 = game:DefineFastInt("AXCheckoutButtonTooltipExpireTime", 5000)
local useSelector = require(AvatarExperienceCatalogParent.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(AvatarExperienceCatalogParent.RoactUtils).Hooks.RoactRodux.useDispatch
local FFlagStackedBottomNavMarketplaceCTA = require(AvatarExperienceCatalogParent.SharedFlags).FFlagStackedBottomNavMarketplaceCTA

local function selectTryOnItems(p1) -- line: 30
	return p1.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end
local function useCheckoutActionBarProps(t1: {[any]: any}, p2) -- line: 34
	-- upvalues: useNavigation (copy), useDispatch (copy), useMultiItemShoppingFtux (copy), useAvatarRoute (copy), React (copy), useSelector (copy), selectTryOnItems (copy), tutils (copy), AvatarScreen (copy), ClearTryOns (copy), v11 (copy), v12 (copy), FFlagStackedBottomNavMarketplaceCTA (copy)
	local v21 = useNavigation()
	local v22 = useDispatch()
	local v23 = useMultiItemShoppingFtux()
	local v24 = useAvatarRoute()
	local v25 = v24 and (v24.opaque and v24.opaque.name)
	local routeName = v21.state.routeName
	local v27, v28 = React.useState(false)
	local v29 = React.useRef(nil)
	local v30 = useSelector(selectTryOnItems, tutils.deepEqual)
	local v31 = tutils.fieldCount(v30)
	local v32 = React.useCallback(function() -- line: 51
		-- upvalues: t1 (copy), v23 (copy), v21 (copy), AvatarScreen (copy), v22 (copy), ClearTryOns (copy)
		if t1.onClearButtonActivated then
			t1.onClearButtonActivated()
		end

		if v23.shouldShowClearAllItemsPrompt() then
			v21.navigate(AvatarScreen.ClearAllItemsOnAvatarPrompt, {
				onConfirm = function(p3) -- line: 58
					-- upvalues: v22 (copy), ClearTryOns (copy), v23 (copy)
					v22(ClearTryOns())

					if p3 then
						v23.hideClearAllItemsPrompt()
					end
				end
			})

			return
		end

		v22(ClearTryOns())
	end, {
		t1.onClearButtonActivated,
		v21,
		v23,
		v22
	})
	local v33 = React.useCallback(function() -- line: 72
		-- upvalues: v21 (copy), t1 (copy), v23 (copy), v29 (copy), v28 (copy)
		v21.navigate("Checkout")

		if t1.onCheckoutButtonActivated then
			t1.onCheckoutButtonActivated()
		end

		v23.setSeenTooltipOnCheckoutButton()

		if v29.current then
			task.cancel(v29.current)
		end

		v28(false)
	end, {
		t1.onCheckoutButtonActivated,
		v28,
		v21,
		v23
	})
	local v34 = React.useCallback(function() -- line: 88
		-- upvalues: v23 (copy), v29 (copy), v28 (copy)
		v23.setSeenTooltipOnCheckoutButton()

		if v29.current then
			task.cancel(v29.current)
		end

		v28(false)
	end, {})
	local v35 = React.useCallback(function() -- line: 97
		-- upvalues: v11 (copy), v28 (copy), v12 (copy), v23 (copy)
		return task.delay(v11 / 1000, function() -- line: 98
			-- upvalues: v28 (copy), v12 (copy), v23 (copy)
			v28(true)
			task.delay(v12 / 1000, function() -- line: 101
				-- upvalues: v23 (copy), v28 (copy)
				v23.setSeenTooltipOnCheckoutButton()
				v28(false)
			end)
		end)
	end, { v23 })

	React.useEffect(function() -- line: 109
		-- upvalues: v23 (copy), v24 (copy), v25 (copy), AvatarScreen (copy), routeName (copy), v29 (copy), v35 (copy)
		if v23.shouldShowTooltipOnCheckoutButton() and v24.isVisible and ((v25 == AvatarScreen.Catalog or v25 == AvatarScreen.CatalogSearch) and routeName == v25) then
			v29.current = v35()
		end
	end, {
		v23,
		v25,
		routeName,
		v24
	})
	React.useEffect(function() -- line: 130
		-- upvalues: t1 (copy), routeName (copy), v25 (copy), v24 (copy), v28 (copy)
		if not t1.Visible or (routeName ~= v25 or not v24.isVisible) then
			v28(false)
		end
	end, {
		t1.Visible,
		v28,
		v24,
		routeName,
		v25
	})

	return {
		onCheckoutButtonActivated = v33,
		onClearButtonActivated = v32,
		itemCount = v31,
		ref = p2,
		Visible = t1.Visible,
		showCheckoutButtonTooltip = v27,
		onTooltipButtonActivated = v34,
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
		footerVisibilityBinding = if not FFlagStackedBottomNavMarketplaceCTA then nil else t1.footerVisibilityBinding
	}
end

return useCheckoutActionBarProps
