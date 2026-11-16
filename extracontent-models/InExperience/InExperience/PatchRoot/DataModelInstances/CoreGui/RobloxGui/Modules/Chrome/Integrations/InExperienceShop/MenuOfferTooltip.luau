local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local InExperienceOffers = require(CorePackages.Workspace.Packages.InExperienceOffers)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local useMappedSignal = Chrome2.Hooks.useMappedSignal

local FFlagOfferNotifyOnGlobalIcon = SharedFlags.FFlagOfferNotifyOnGlobalIcon
local FFlagHideOfferNotificationsWhenShopEmpty = SharedFlags.FFlagHideOfferNotificationsWhenShopEmpty
local InExperienceShop, toggleInExperienceShopWindow

if FFlagOfferNotifyOnGlobalIcon then
	InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)

	local ShopWindowLayout = require(Chrome.Integrations.InExperienceShop.ShopWindowLayout)
	toggleInExperienceShopWindow = ShopWindowLayout.toggleInExperienceShopWindow
else
	toggleInExperienceShopWindow = nil
	InExperienceShop = nil
end

local Service = require(Chrome.Service)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local TooltipContext = require(Chrome.ChromeShared.Unibar.Tooltips.TooltipContext)
local useIsTooltipTurn = require(Chrome.ChromeShared.Unibar.Tooltips.useIsTooltipTurn)

local EducationalTooltip = Foundation.EducationalTooltip
local OverlayProvider = Foundation.OverlayProvider
local ButtonVariant = Foundation.Enums.ButtonVariant
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local FeatureKeys = InExperienceOffers.FeatureKeys
local getOffersStore = InExperienceOffers.getOffersStore
local isNotificationEligible = InExperienceOffers.Utils.isNotificationEligible
local selectActiveOffer = InExperienceOffers.Utils.selectActiveOffer
local useOffersForKey = InExperienceOffers.Hooks.useOffersForKey
local useShopHasItems = InExperienceOffers.Hooks.useShopHasItems
local useSignalState = SignalsReact.useSignalState

local defineFastInt = game:DefineFastInt("MenuOfferTooltipPriority", 1500)
local defineFastInt2 = game:DefineFastInt("MenuOfferTooltipShowDelayMs", 1500)
local defineFastInt3 = game:DefineFastInt("MenuOfferTooltipDismissDelayMs", 7000)

local function MenuOfferTooltipContent(p)
	local v = useOffersForKey(FeatureKeys.RobloxShop)

	local v2 = useSignalState(getOffersStore(false).getOfferExposureSnapshot)

	local v3 = React.useMemo(function()
		if v == nil or v2 == nil then
			return nil
		end

		local v3 = {}

		for _, v4 in v do
			if isNotificationEligible(v4, v2) then
				table.insert(v3, v4)
			end
		end

		return selectActiveOffer(v3, "tooltip")
	end, { v, v2 })

	local state, setState = React.useState(false)

	React.useEffect(function()
		setState(p.anchorRef ~= nil and p.anchorRef.current ~= nil)
	end, { p.anchorRef })

	local state2, setState2 = React.useState(false)

	local v4 = React.useCallback(function()
		setState2(true)
	end, {})

	local onActivated = React.useCallback(function()
		v4()
		local IN_EXPERIENCE_SHOP_ID = Constants.IN_EXPERIENCE_SHOP_ID

		if Service:isWindowOpen(IN_EXPERIENCE_SHOP_ID) then
			return
		end

		if Service:isIntegrationValid(IN_EXPERIENCE_SHOP_ID) then
			Service:activate(IN_EXPERIENCE_SHOP_ID)
		elseif
			toggleInExperienceShopWindow
			and getOffersStore(false).getIsInExperienceShopGlobalIconAvailable(false)
		then
			toggleInExperienceShopWindow()
		end
	end, { v4 })
	local tooltip

	if v3 ~= nil then
		tooltip = v3.presentationData.tooltip
	end

	local offerId

	if v3 ~= nil then
		offerId = v3.offerId
	end

	local current2 = React.useContext(TooltipContext)
	local v5 = useIsTooltipTurn("MENU_OFFER_TOOLTIP") or false

	local ref = React.useRef(current2)
	React.useEffect(function()
		ref.current = current2
	end, { current2 })

	local v6 = Service:integrations()[Constants.IN_EXPERIENCE_SHOP_ID]
	local v7

	if v6 then
		v7 = v6.availability
	end

	local v8 = useMappedSignal(v7) == Service.AvailabilitySignal.Available
	local v9

	if FFlagOfferNotifyOnGlobalIcon then
		v9 = useSignalState(getOffersStore(false).getHasInExperienceShopOpened)
	else
		v9 = false
	end

	local v10 = FFlagHideOfferNotificationsWhenShopEmpty and not useShopHasItems()
	local v11

	if tooltip == nil or p.visible ~= true then
		v11 = false
	else
		v11 = v8 and state and not state2
	end

	if FFlagOfferNotifyOnGlobalIcon then
		if tooltip == nil or p.visible ~= true then
			v11 = false
		else
			v11 = state and not (state2 or v9)
		end
	end

	if v10 then
		v11 = false
	end

	React.useEffect(function()
		local current = ref.current

		if not v11 or current == nil then
			return nil
		end

		current.registerTooltip("MENU_OFFER_TOOLTIP", defineFastInt, defineFastInt2, defineFastInt3)

		return function()
			current.unregisterTooltip("MENU_OFFER_TOOLTIP")
		end
	end, { v11, offerId })

	React.useEffect(function()
		if not v11 then
			return nil
		end

		local connection = Service:onIntegrationActivated():connect(function()
			v4()
		end)
		local menuOpenedConnection = GuiService.MenuOpened:Connect(function()
			v4()
		end)

		return function()
			connection:disconnect()
			menuOpenedConnection:Disconnect()
		end
	end, { v11, v4 })

	if tooltip == nil or not (v11 and v5) then
		return nil
	end

	local actions = {
		{ text = tooltip.buttonText, variant = ButtonVariant.Emphasis, onActivated = onActivated }
	}

	return React.createElement(OverlayProvider, nil, {
		Tooltip = React.createElement(EducationalTooltip, {
			anchorRef = p.anchorRef,
			title = tooltip.title .. string.rep(" ", 10),
			side = PopoverSide.Bottom,
			align = PopoverAlign.Start,
			isOpen = true,
			actions = actions,
			onClose = v4,
			onPressedOutside = v4,
			testId = "menu-offer-tooltip"
		})
	})
end

local function MenuOfferTooltip(p)
	if FFlagOfferNotifyOnGlobalIcon then
		local v = useSignalState(getOffersStore(false).getIsInExperienceShopGlobalIconAvailable)

		local v2 = Service:integrations()[Constants.IN_EXPERIENCE_SHOP_ID]
		local v3

		if v2 then
			v3 = v2.availability
		end

		local v4 = useMappedSignal(v3) == Service.AvailabilitySignal.Available

		local current = useSignalState(function(p2)
			local getShopGlobalIconStore = InExperienceShop.GetShopGlobalIconStore

			if getShopGlobalIconStore then
				return (getShopGlobalIconStore(p2).getIconInstance(p2))
			end

			return nil
		end)

		local ref = React.useRef(current)
		ref.current = current

		if v then
			if ref.current == nil then
				return nil
			end

			return React.createElement(MenuOfferTooltipContent, { anchorRef = ref, visible = true })
		elseif not v4 then
			return nil
		end
	end

	return React.createElement(MenuOfferTooltipContent, p)
end

return React.memo(MenuOfferTooltip)
