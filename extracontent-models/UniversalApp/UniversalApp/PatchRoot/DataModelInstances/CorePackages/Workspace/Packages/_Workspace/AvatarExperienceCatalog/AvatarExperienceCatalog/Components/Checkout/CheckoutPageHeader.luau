local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local AvatarExperienceNavigation = require(Parent.AvatarExperienceNavigation)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useNavigation = require(Parent.Navigation).useNavigation
local canGoBack = require(Parent.Navigation).canGoBack
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local ClearTryOns = require(Parent.AvatarExperienceRodux).Actions.ClearTryOns
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout

local function CheckoutPageHeader() -- line: 21
	-- upvalues: FFlagAXEnableExpiredUserLookCheckout (copy), useDispatch (copy), useNavigation (copy), Foundation (copy), useAvatarRoute (copy), useLocalization (copy), React (copy), AvatarScreen (copy), ClearTryOns (copy), canGoBack (copy)
	local v15 = if not FFlagAXEnableExpiredUserLookCheckout then nil else useDispatch()
	local v16 = useNavigation()
	local v17 = Foundation.Hooks.useTokens()
	local v18 = if not FFlagAXEnableExpiredUserLookCheckout then nil else useAvatarRoute()
	local v19 = useLocalization({
		checkoutTitle = "Feature.Catalog.Header.Checkout"
	})
	local v20 = React.useCallback(function() -- line: 31
		-- upvalues: FFlagAXEnableExpiredUserLookCheckout (copy), v18 (copy), AvatarScreen (copy), v15 (copy), ClearTryOns (copy), canGoBack (copy), v16 (copy)
		if FFlagAXEnableExpiredUserLookCheckout and (v18 and (v18.current and v18.current.name)) == AvatarScreen.ExpiredUserLookCheckout then
			v15(ClearTryOns())
		end

		if canGoBack(v16) then
			v16.goBack()
		end
	end, {
		v16,
		if not FFlagAXEnableExpiredUserLookCheckout then nil else v18,
		if not FFlagAXEnableExpiredUserLookCheckout then nil else v15
	})

	return React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 bg-surface-0 row items-center padding-x-xlarge padding-y-medium gap-medium"
	}, {
		BackButton = React.createElement(Foundation.IconButton, {
			icon = "chevron-large-left",
			tag = "content-emphasis",
			onActivated = v20,
			size = Foundation.Enums.InputSize.Medium
		}),
		Title = React.createElement(Foundation.Text, {
			tag = "grow auto-y text-title-large content-emphasis",
			Text = v19.checkoutTitle,
			TextTruncate = Enum.TextTruncate.AtEnd
		}),
		Spacer = React.createElement(Foundation.View, {
			Size = UDim2.fromOffset(v17.Size.Size_1000, 0)
		})
	})
end

return React.memo(CheckoutPageHeader)
