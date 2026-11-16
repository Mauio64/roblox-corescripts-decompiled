local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local Service = require(Chrome.Service)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local WindowSizeSignal = require(Chrome.ChromeShared.Service.WindowSizeSignal)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local initializeShopMenuController = require(Chrome.Integrations.InExperienceShop.initializeShopMenuController)
local ShopChromeWrapper = require(Chrome.Integrations.InExperienceShop.ShopChromeWrapper)
local ShopWindowLayout = require(Chrome.Integrations.InExperienceShop.ShopWindowLayout)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local FFlagEnableFreeTrialBlueDot = InExperienceShop.FFlagEnableFreeTrialBlueDot
local FFlagEnableShopPrefetch = InExperienceShop.FFlagEnableShopPrefetch
local FFlagHideShopMenuOnFailure = InExperienceShop.FFlagHideShopMenuOnFailure
local FFlagCenterInExperienceShopWindow = InExperienceShop.FFlagCenterInExperienceShopWindow
local FFlagFixInExperienceShopCursorLock = InExperienceShop.FFlagFixInExperienceShopCursorLock
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableMenuTrailingBadge = SharedFlags.FFlagEnableMenuTrailingBadge
local FFlagShowOfferBadge = SharedFlags.FFlagShowOfferBadge
local FFlagExperienceShopNewIconography = InExperienceShop.FFlagExperienceShopNewIconography

local FFlagEnableAnyFreeTrialToolTip = require(CorePackages.Workspace.Packages.InExperienceShop.FFlagEnableAnyFreeTrialToolTip)
local FFlagEnableFreeTrialShopMenuBadge = InExperienceShop.FFlagEnableFreeTrialShopMenuBadge
local FFlagMenuBadgePreferFreeTrialOverOffer = InExperienceShop.FFlagMenuBadgePreferFreeTrialOverOffer

local engineFeature = game:GetEngineFeature("ShopCoreGuiToggleSupported")
local engineFeature2 = game:GetEngineFeature("EnableOpenShopSignal")

local isActivated = MappedSignal.new(Service:onIntegrationStatusChanged(), function()
	return Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID)
end)

local MAX_WINDOW_WIDTH = ShopWindowLayout.MAX_WINDOW_WIDTH
local MAX_WINDOW_HEIGHT = ShopWindowLayout.MAX_WINDOW_HEIGHT

local windowSize = WindowSizeSignal.new(MAX_WINDOW_WIDTH, MAX_WINDOW_HEIGHT, false, true)

local defineFastString = game:DefineFastString(
	"InExperienceShopNewBadgeStorageKey",
	"InExperienceShopNewBadgeStorageKey"
)

local defineFastInt = game:DefineFastInt("NewBadgeDismissalMaxCountInExperienceShop", 5)
local v = game:DefineFastFlag("EnableNewBadgeInExperienceShop", false) and FFlagEnableMenuTrailingBadge

local dismiss = nil
local v2, customText

if FFlagShowOfferBadge then
	local InExperienceOffers = require(CorePackages.Workspace.Packages.InExperienceOffers)

	v2 = InExperienceOffers.Utils.createOfferBadgeTextSignal(InExperienceOffers.FeatureKeys.RobloxShop)
	customText = v2
else
	v2 = nil
end

if FFlagEnableFreeTrialShopMenuBadge then
	local submitFreeTrialMenuBadge = require(CorePackages.Workspace.Packages.InExperienceShop.submitFreeTrialMenuBadge)
	local v3 = submitFreeTrialMenuBadge()

	customText = FFlagMenuBadgePreferFreeTrialOverOffer and v2 ~= nil and function(p)
		local v4 = v3(p)

		if v4 == nil then
			return v2(p)
		end

		return v4
	end or v2 ~= nil and function(p)
		local v4 = v2(p)

		if v4 == nil then
			return v3(p)
		end

		return v4
	end or v3

	dismiss = submitFreeTrialMenuBadge.dismiss

	local v4 = false
	local function reportTrialBadgeSeen()
		if
			v4
			or v3(false) == nil
			or not FFlagMenuBadgePreferFreeTrialOverOffer and v2 ~= nil and v2(false) ~= nil
			or not Service:withinCurrentSubmenu(Constants.IN_EXPERIENCE_SHOP_ID)
		then
			return
		end

		v4 = true
		submitFreeTrialMenuBadge.reportMounted()
		submitFreeTrialMenuBadge.reportViewed()
	end

	Service:currentSubMenu():connect(function()
		if Service:withinCurrentSubmenu(Constants.IN_EXPERIENCE_SHOP_ID) then
			reportTrialBadgeSeen()
		else
			v4 = false
		end
	end)

	Signals.createEffect(function(p)
		v3(p)

		if not FFlagMenuBadgePreferFreeTrialOverOffer then
			local v5 = v2

			if v5 ~= nil then
				v5(p)
			end
		end

		reportTrialBadgeSeen()
	end)
end

local menuTrailingBadgeConfig = (v or customText ~= nil) and {
	localStorageKey = defineFastString,
	maxViewCount = not v and 0 or defineFastInt,
	customText = customText
} or nil
local v3

if engineFeature then
	v3 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All)
		or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.ExperienceShop)
else
	v3 = false
end

local v4 = true

local function getInitialAvailability() -- 1 equivalent call inferred from this helper
	if v3 and not FFlagHideShopMenuOnFailure then
		return Service.AvailabilitySignal.Available
	end

	v4 = false
	return Service.AvailabilitySignal.Unavailable
end

local function toggleShopWindow() -- 2 equivalent calls inferred from this helper
	if FFlagCenterInExperienceShopWindow then
		ShopWindowLayout.toggleInExperienceShopWindow()
	else
		Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
	end
end

local function dismissTrialBadgeIfShopIsClosed() -- 2 equivalent calls inferred from this helper
	if dismiss ~= nil and not Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) then
		dismiss()
	end
end

local v5 = Service:register({
	initialAvailability = getInitialAvailability(), -- inferred equivalent call
	id = Constants.IN_EXPERIENCE_SHOP_ID,
	sideSheetPlacement = SideSheetPlacement.AboveFold,
	label = "Feature.Avatar.Action.Shop",
	cachePosition = true,
	draggable = true,
	windowSize = windowSize,
	startingWindowPosition = ShopWindowLayout.getStartingWindowPosition(),
	activated = function(_)
		dismissTrialBadgeIfShopIsClosed() -- inferred equivalent call
		toggleShopWindow() -- inferred equivalent call
	end,
	menuTrailingBadgeConfig = menuTrailingBadgeConfig,
	isActivated = isActivated,
	components = {
		Icon = function()
			return CommonIcon(
				FFlagExperienceShopNewIconography and "ShoppingBasket" or "BuildingStore",
				nil,
				isActivated
			)
		end,
		Window = function()
			return React.createElement(ShopChromeWrapper, {
				windowSize = windowSize,
				maxWindowWidth = MAX_WINDOW_WIDTH,
				maxWindowHeight = MAX_WINDOW_HEIGHT
			})
		end
	}
})

if FFlagFixInExperienceShopCursorLock then
	initializeShopMenuController(GuiService, isActivated)
end

if FFlagEnableShopPrefetch then
	local prefetchShopDataOnGameJoin = require(CorePackages.Workspace.Packages.InExperienceShop.prefetchShopDataOnGameJoin)

	if FFlagHideShopMenuOnFailure then
		task.spawn(prefetchShopDataOnGameJoin, function(flag: boolean)
			if not flag then
				return
			end

			v4 = true

			if v3 then
				v5.availability:available()
			end
		end)
	else
		task.spawn(prefetchShopDataOnGameJoin)
	end
end

if FFlagEnableAnyFreeTrialToolTip then
	local submitFreeTrialTooltips = require(CorePackages.Workspace.Packages.InExperienceShop.submitFreeTrialTooltips)
	submitFreeTrialTooltips()
end

if FFlagEnableFreeTrialBlueDot then
	local submitFreeTrialBlueDot = require(CorePackages.Workspace.Packages.InExperienceShop.submitFreeTrialBlueDot)
	submitFreeTrialBlueDot()
end

if engineFeature2 then
	MarketplaceService.OpenShopRequested:Connect(function(p)
		if p == Players.LocalPlayer then
			if FFlagHideShopMenuOnFailure and not v4 then
				return
			end

			if not Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) then
				dismissTrialBadgeIfShopIsClosed() -- inferred equivalent call
				toggleShopWindow() -- inferred equivalent call
			end
		end
	end)
end

if engineFeature then
	local function updateShopAvailability() -- 1 equivalent call inferred from this helper
		if v3 and (not FFlagHideShopMenuOnFailure or v4) then
			v5.availability:available()
			return
		end

		if Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) then
			Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
		end

		v5.availability:unavailable()
	end

	ChromeUtils.setCoreGuiAvailability(v5, Enum.CoreGuiType.ExperienceShop, function(p)
		v3 = p
		updateShopAvailability() -- inferred equivalent call
	end)
end

return v5
