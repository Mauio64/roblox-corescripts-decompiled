local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent
local React = require(parent.React)
local tutils = require(parent.tutils)

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local useMultiItemShoppingFtux = require(AvatarExperienceCatalog.Hooks.useMultiItemShoppingFtux)
require(AvatarExperienceCatalog.Components.Checkout.CheckoutActionBar)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarExperienceRodux = require(parent.AvatarExperienceRodux)
local ClearTryOns = AvatarExperienceRodux.Actions.ClearTryOns

local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local defineFastInt = game:DefineFastInt("AXCheckoutButtonTooltipFtuxDelay", 500)
local defineFastInt2 = game:DefineFastInt("AXCheckoutButtonTooltipExpireTime", 5000)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoactUtils2 = require(parent.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local SharedFlags = require(parent.SharedFlags)
local FFlagStackedBottomNavMarketplaceCTA = SharedFlags.FFlagStackedBottomNavMarketplaceCTA

local function selectTryOnItems(p)
	return p.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function useCheckoutActionBarProps(data, ref2)
	local v = useNavigation()
	local v2 = useDispatch()

	local v3 = useMultiItemShoppingFtux()
	local v4 = useAvatarRoute()
	local name = v4 and v4.opaque and v4.opaque.name
	local routeName = v.state.routeName

	local state, setState = React.useState(false)

	local ref = React.useRef(nil)

	local v5 = useSelector(selectTryOnItems, tutils.deepEqual)

	local fieldCount = tutils.fieldCount(v5)

	local onClearButtonActivated = React.useCallback(function()
		if data.onClearButtonActivated then
			data.onClearButtonActivated()
		end

		if v3.shouldShowClearAllItemsPrompt() then
			v.navigate(AvatarScreen.ClearAllItemsOnAvatarPrompt, {
				onConfirm = function(p)
					v2(ClearTryOns())

					if p then
						v3.hideClearAllItemsPrompt()
					end
				end
			})
		else
			v2(ClearTryOns())
		end
	end, { data.onClearButtonActivated, v, v3, v2 })

	local onCheckoutButtonActivated = React.useCallback(function()
		v.navigate("Checkout")

		if data.onCheckoutButtonActivated then
			data.onCheckoutButtonActivated()
		end

		v3.setSeenTooltipOnCheckoutButton()

		if ref.current then
			task.cancel(ref.current)
		end

		setState(false)
	end, { data.onCheckoutButtonActivated, setState, v, v3 })

	local onTooltipButtonActivated = React.useCallback(function()
		v3.setSeenTooltipOnCheckoutButton()

		if ref.current then
			task.cancel(ref.current)
		end

		setState(false)
	end, {})

	local v6 = React.useCallback(function()
		return task.delay(defineFastInt / 1000, function()
			setState(true)

			task.delay(defineFastInt2 / 1000, function()
				v3.setSeenTooltipOnCheckoutButton()
				setState(false)
			end)
		end)
	end, { v3 })

	React.useEffect(function()
		if
			v3.shouldShowTooltipOnCheckoutButton()
			and v4.isVisible
			and (name == AvatarScreen.Catalog or name == AvatarScreen.CatalogSearch)
			and routeName == name
		then
			ref.current = v6()
		end
	end, { v3, name, routeName, v4 })

	React.useEffect(function()
		if not data.Visible or routeName ~= name or not v4.isVisible then
			setState(false)
		end
	end, { data.Visible, setState, v4, routeName, name })

	local v7 = {
		onCheckoutButtonActivated = onCheckoutButtonActivated,
		onClearButtonActivated = onClearButtonActivated,
		itemCount = fieldCount,
		ref = ref2,
		Visible = data.Visible,
		showCheckoutButtonTooltip = state,
		onTooltipButtonActivated = onTooltipButtonActivated,
		onAbsoluteSizeChanged = data.onAbsoluteSizeChanged,
		footerVisibilityBinding = 0
	}
	local footerVisibilityBinding

	if FFlagStackedBottomNavMarketplaceCTA then
		footerVisibilityBinding = data.footerVisibilityBinding
	end

	v7.footerVisibilityBinding = footerVisibilityBinding
	return v7
end

return useCheckoutActionBarProps
