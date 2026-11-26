local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/tutils")

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Navigation").useNavigation
local useMultiItemShoppingFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Hooks/useMultiItemShoppingFtux")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutActionBar")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local clearTryOns = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceRodux").Actions.ClearTryOns

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local defineFastInt = game:DefineFastInt("AXCheckoutButtonTooltipFtuxDelay", 500)
local defineFastInt2 = game:DefineFastInt("AXCheckoutButtonTooltipExpireTime", 5000)
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useDispatch
local fFlagStackedBottomNavMarketplaceCTA = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SharedFlags").FFlagStackedBottomNavMarketplaceCTA

local function selectTryOnItems(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function useCheckoutActionBarProps(data, p2)
	local v5 = useNavigation()
	local v6 = useDispatch()

	local v7 = useMultiItemShoppingFtux()
	local v8 = useAvatarRoute()
	local name = v8 and v8.opaque and v8.opaque.name
	local routeName = v5.state.routeName

	local state, setState = React.useState(false)

	local ref = React.useRef(nil)

	local v9 = useSelector(selectTryOnItems, tutils.deepEqual)

	local fieldCount = tutils.fieldCount(v9)

	local v10 = React.useCallback(function()
		if data.onClearButtonActivated then
			data.onClearButtonActivated()
		end

		if v7.shouldShowClearAllItemsPrompt() then
			v5.navigate(avatarScreen.ClearAllItemsOnAvatarPrompt, {
				onConfirm = function(p3)
					v6(clearTryOns())

					if p3 then
						v7.hideClearAllItemsPrompt()
					end
				end
			})
		else
			v6(clearTryOns())
		end
	end, { data.onClearButtonActivated, v5, v7, v6 })

	local v11 = React.useCallback(function()
		v5.navigate("Checkout")

		if data.onCheckoutButtonActivated then
			data.onCheckoutButtonActivated()
		end

		v7.setSeenTooltipOnCheckoutButton()

		if ref.current then
			task.cancel(ref.current)
		end

		setState(false)
	end, { data.onCheckoutButtonActivated, setState, v5, v7 })

	local v12 = React.useCallback(function()
		v7.setSeenTooltipOnCheckoutButton()

		if ref.current then
			task.cancel(ref.current)
		end

		setState(false)
	end, {})

	local v13 = React.useCallback(function()
		return task.delay(defineFastInt / 1000, function()
			setState(true)

			task.delay(defineFastInt2 / 1000, function()
				v7.setSeenTooltipOnCheckoutButton()
				setState(false)
			end)
		end)
	end, { v7 })

	React.useEffect(function()
		if
			v7.shouldShowTooltipOnCheckoutButton()
			and v8.isVisible
			and (name == avatarScreen.Catalog or name == avatarScreen.CatalogSearch)
			and routeName == name
		then
			ref.current = v13()
		end
	end, { v7, name, routeName, v8 })

	React.useEffect(function()
		if not data.Visible or routeName ~= name or not v8.isVisible then
			setState(false)
		end
	end, { data.Visible, setState, v8, routeName, name })

	local v14 = {
		onCheckoutButtonActivated = v11,
		onClearButtonActivated = v10,
		itemCount = fieldCount,
		ref = p2,
		Visible = data.Visible,
		showCheckoutButtonTooltip = state,
		onTooltipButtonActivated = v12,
		onAbsoluteSizeChanged = data.onAbsoluteSizeChanged,
		footerVisibilityBinding = 0
	}
	local v15 = if fFlagStackedBottomNavMarketplaceCTA then data.footerVisibilityBinding else nil
	v14.footerVisibilityBinding = v15
	return v14
end

return useCheckoutActionBarProps
