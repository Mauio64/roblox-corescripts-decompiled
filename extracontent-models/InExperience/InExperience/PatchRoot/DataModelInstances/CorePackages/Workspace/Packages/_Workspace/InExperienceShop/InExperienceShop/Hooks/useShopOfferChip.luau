local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SharedFlags = require(parent.SharedFlags)
local FFlagHideOfferNotificationsWhenShopEmpty = SharedFlags.FFlagHideOfferNotificationsWhenShopEmpty

local InExperienceOffers = require(parent.InExperienceOffers)
local useOffersForKey = InExperienceOffers.Hooks.useOffersForKey
local selectActiveOffer = InExperienceOffers.Utils.selectActiveOffer
local useRemainingTimeText = InExperienceOffers.Hooks.useRemainingTimeText
local useShopHasItems = InExperienceOffers.Hooks.useShopHasItems
local OfferDialogState = require(InExperienceShop.Components.OfferDialogs.OfferDialogState)
local useCloseOnCoreMenu = require(InExperienceShop.Hooks.useCloseOnCoreMenu)
local useOfferModalText = require(InExperienceShop.Hooks.useOfferModalText)
local FFlagShopCloseOfferDialogOnCoreMenu = require(InExperienceShop.Flags.FFlagShopCloseOfferDialogOnCoreMenu)
local FFlagShowLargerOfferBannerOnDesktop2 = require(InExperienceShop.Flags.FFlagShowLargerOfferBannerOnDesktop2)

local function useShopOfferChip(p: string, flag: boolean?)
	local v = useOffersForKey(p)
	local v2 = React.useMemo(function()
		return selectActiveOffer(v, "banner")
	end, { v })
	local banner

	if v2 ~= nil then
		banner = v2.presentationData.banner
	end

	local v3

	if v2 then
		v3 = v2.expirationTimeInUTC or nil
	end

	local v4 = useRemainingTimeText(v3)

	local v5 = FFlagHideOfferNotificationsWhenShopEmpty and not useShopHasItems()
	local showOfferChip

	if v2 == nil then
		showOfferChip = false
	else
		showOfferChip = v4 ~= nil
	end

	if v5 then
		showOfferChip = false
	end

	local v6 = useLocalization({
		offerEndTime = {
			"Feature.InExperienceShop.Label.OfferEndTime",
			offer = banner == nil and "" or banner.title,
			timeRemaining = v4 or ""
		}
	})
	local offerChipText, icon

	if showOfferChip and banner ~= nil then
		offerChipText = if flag then banner.title else v6.offerEndTime
		icon = banner.icon
	end

	local modal

	if banner ~= nil then
		modal = banner.modal
	end

	local expirationTimeInUTC

	if v2 ~= nil then
		expirationTimeInUTC = v2.expirationTimeInUTC
	end

	local v7

	if FFlagShowLargerOfferBannerOnDesktop2 then
		local v8 = not modal and "" or modal.body

		if not modal then
			v4 = nil
		end

		v7 = useOfferModalText(v8, v4)
	else
		v7 = {
			bodyText = not modal and "" or modal.body,
			viewTermsText = ""
		}
	end

	local state, setState = React.useState(OfferDialogState.None)

	local onOfferChipActivated = React.useCallback(function()
		setState(OfferDialogState.Details)
	end, {})
	local onOfferViewTerms = React.useCallback(function()
		setState(OfferDialogState.Terms)
	end, {})

	local v8 = React.useCallback(function()
		setState(OfferDialogState.None)
	end, {})

	if FFlagShopCloseOfferDialogOnCoreMenu then
		useCloseOnCoreMenu(v8)
	end

	return {
		showOfferChip = showOfferChip,
		offerChipText = offerChipText,
		offerChipIcon = icon,
		offerModal = modal,
		offerExpirationTimeInUTC = expirationTimeInUTC,
		offerBodyText = v7.bodyText,
		offerViewTermsText = v7.viewTermsText,
		offerDialog = state,
		onOfferChipActivated = onOfferChipActivated,
		onOfferViewTerms = onOfferViewTerms,
		onOfferShopNow = v8,
		onOfferDetailsClose = v8,
		onOfferTermsClose = v8
	}
end

return useShopOfferChip
