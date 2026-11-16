local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Navigation2 = require(parent.Navigation)
local canGoBack = Navigation2.canGoBack
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AvatarExperienceRodux = require(parent.AvatarExperienceRodux)
local ClearTryOns = AvatarExperienceRodux.Actions.ClearTryOns

local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout

local function CheckoutPageHeader()
	local v

	if FFlagAXEnableExpiredUserLookCheckout then
		v = useDispatch()
	else
		v = nil
	end

	local v2 = useNavigation()
	local v3 = Foundation.Hooks.useTokens()
	local v4

	if FFlagAXEnableExpiredUserLookCheckout then
		v4 = useAvatarRoute()
	else
		v4 = nil
	end

	local v5 = useLocalization({ checkoutTitle = "Feature.Catalog.Header.Checkout" })

	local useCallback = React.useCallback
	local function fn()
		if
			FFlagAXEnableExpiredUserLookCheckout
			and (v4 and v4.current and v4.current.name) == AvatarScreen.ExpiredUserLookCheckout
		then
			v(ClearTryOns())
		end

		if canGoBack(v2) then
			v2.goBack()
		end
	end

	local v6

	if FFlagAXEnableExpiredUserLookCheckout then
		v6 = v4
	end

	local v7

	if FFlagAXEnableExpiredUserLookCheckout then
		v7 = v
	end

	local onActivated = useCallback(fn, { v2, v6, v7 })

	return React.createElement(
		Foundation.View,
		{
			tag = "auto-y size-full-0 bg-surface-0 row items-center padding-x-xlarge padding-y-medium gap-medium"
		},
		{
			BackButton = React.createElement(Foundation.IconButton, {
				onActivated = onActivated,
				size = Foundation.Enums.InputSize.Medium,
				icon = "chevron-large-left",
				tag = "content-emphasis"
			}),
			Title = React.createElement(Foundation.Text, {
				Text = v5.checkoutTitle,
				TextTruncate = Enum.TextTruncate.AtEnd,
				tag = "grow auto-y text-title-large content-emphasis"
			}),
			Spacer = React.createElement(Foundation.View, {
				Size = UDim2.fromOffset(v3.Size.Size_1000, 0)
			})
		}
	)
end

return React.memo(CheckoutPageHeader)
