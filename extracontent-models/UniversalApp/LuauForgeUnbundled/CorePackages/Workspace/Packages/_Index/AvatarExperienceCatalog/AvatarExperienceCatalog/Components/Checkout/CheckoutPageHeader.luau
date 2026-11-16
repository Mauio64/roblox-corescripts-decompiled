local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Navigation").useNavigation
local canGoBack = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Navigation").canGoBack
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useDispatch
local clearTryOns = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceRodux").Actions.ClearTryOns

local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local fFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout

local function CheckoutPageHeader()
	local v5 = if fFlagAXEnableExpiredUserLookCheckout then useDispatch() else nil
	local v6 = useNavigation()
	local v7 = Foundation.Hooks.useTokens()
	local v8 = if fFlagAXEnableExpiredUserLookCheckout then useAvatarRoute() else nil

	local v9 = useLocalization({ checkoutTitle = "Feature.Catalog.Header.Checkout" })

	local useCallback = React.useCallback
	local function fn()
		if
			fFlagAXEnableExpiredUserLookCheckout
			and (v8 and v8.current and v8.current.name) == avatarScreen.ExpiredUserLookCheckout
		then
			v5(clearTryOns())
		end

		if canGoBack(v6) then
			v6.goBack()
		end
	end

	local v11 = if fFlagAXEnableExpiredUserLookCheckout then v8 else nil
	local v13 = useCallback(fn, { v6, v11, if fFlagAXEnableExpiredUserLookCheckout then v5 else nil })

	return React.createElement(
		Foundation.View,
		{
			tag = "auto-y size-full-0 bg-surface-0 row items-center padding-x-xlarge padding-y-medium gap-medium"
		},
		{
			BackButton = React.createElement(Foundation.IconButton, {
				onActivated = v13,
				size = Foundation.Enums.InputSize.Medium,
				icon = "chevron-large-left",
				tag = "content-emphasis"
			}),
			Title = React.createElement(Foundation.Text, {
				Text = v9.checkoutTitle,
				TextTruncate = Enum.TextTruncate.AtEnd,
				tag = "grow auto-y text-title-large content-emphasis"
			}),
			Spacer = React.createElement(Foundation.View, {
				Size = UDim2.fromOffset(v7.Size.Size_1000, 0)
			})
		}
	)
end

return React.memo(CheckoutPageHeader)
