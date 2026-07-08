local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local React = require(CorePackages.Packages.React)
local Service = require(Chrome.Service)
local WindowSizeSignal = require(Chrome.ChromeShared.Service.WindowSizeSignal)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local ShopChromeWrapper = require(Chrome.Integrations.InExperienceShop.ShopChromeWrapper)
local ShopWindowLayout = require(Chrome.Integrations.InExperienceShop.ShopWindowLayout)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal
local InExperienceShop = require(CorePackages.Workspace.Packages.InExperienceShop)
local FFlagEnableShopPrefetch = InExperienceShop.FFlagEnableShopPrefetch
local FFlagHideShopMenuOnFailure = InExperienceShop.FFlagHideShopMenuOnFailure
local FFlagCenterInExperienceShopWindow = InExperienceShop.FFlagCenterInExperienceShopWindow
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local FFlagEnableMenuTrailingBadge = SharedFlags.FFlagEnableMenuTrailingBadge
local FFlagExperienceShopNewIconography = InExperienceShop.FFlagExperienceShopNewIconography
local EngineFeature = game:GetEngineFeature("ShopCoreGuiToggleSupported")
local EngineFeature2 = game:GetEngineFeature("EnableOpenShopSignal")
local v25 = MappedSignal.new(Service:onIntegrationStatusChanged(), function() -- line: 30
	-- upvalues: Service (copy), Constants (copy)
	return Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID)
end)
local MAX_WINDOW_WIDTH = ShopWindowLayout.MAX_WINDOW_WIDTH
local MAX_WINDOW_HEIGHT = ShopWindowLayout.MAX_WINDOW_HEIGHT
local v28 = WindowSizeSignal.new(MAX_WINDOW_WIDTH, MAX_WINDOW_HEIGHT, false, true)
local v29 = game:DefineFastString("InExperienceShopNewBadgeStorageKey", "InExperienceShopNewBadgeStorageKey")
local v30 = game:DefineFastInt("NewBadgeDismissalMaxCountInExperienceShop", 5)
local v31 = game:DefineFastFlag("EnableNewBadgeInExperienceShop", false) and FFlagEnableMenuTrailingBadge
local u32 = not not EngineFeature and (StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All) or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.ExperienceShop))
local u33 = true

local function getInitialAvailability() -- line: 66
	-- upvalues: u32 (ref), FFlagHideShopMenuOnFailure (copy), u33 (ref), Service (copy)
	if not u32 or FFlagHideShopMenuOnFailure then
		u33 = false

		return Service.AvailabilitySignal.Unavailable
	end

	return Service.AvailabilitySignal.Available
end
local function toggleShopWindow() -- line: 74
	-- upvalues: FFlagCenterInExperienceShopWindow (copy), ShopWindowLayout (copy), Service (copy), Constants (copy)
	if FFlagCenterInExperienceShopWindow then
		ShopWindowLayout.toggleInExperienceShopWindow()

		return
	end

	Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
end

local t1 = {
	label = "Feature.Avatar.Action.Shop",
	cachePosition = true,
	draggable = true
}
local Unavailable

if not u32 or FFlagHideShopMenuOnFailure then
	u33 = false
	Unavailable = Service.AvailabilitySignal.Unavailable
else
	Unavailable = Service.AvailabilitySignal.Available
end

t1.initialAvailability = Unavailable
t1.id = Constants.IN_EXPERIENCE_SHOP_ID
t1.windowSize = v28
t1.startingWindowPosition = ShopWindowLayout.getStartingWindowPosition()

function t1.activated(_) -- line: 91
	-- upvalues: FFlagCenterInExperienceShopWindow (copy), ShopWindowLayout (copy), Service (copy), Constants (copy)
	if FFlagCenterInExperienceShopWindow then
		ShopWindowLayout.toggleInExperienceShopWindow()

		return
	end

	Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
end

t1.menuTrailingBadgeConfig = if not v31 then nil else {
	localStorageKey = v29,
	maxViewCount = v30
}
t1.isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 102
	-- upvalues: v25 (copy)
	return v25:get()
end or v25
t1.components = {
	Icon = function() -- line: 106
		-- upvalues: CommonIcon (copy), FFlagExperienceShopNewIconography (copy), v25 (copy)
		return CommonIcon(not FFlagExperienceShopNewIconography and "BuildingStore" or "ShoppingBasket", nil, v25)
	end,
	Window = function() -- line: 113
		-- upvalues: React (copy), ShopChromeWrapper (copy), v28 (copy), MAX_WINDOW_WIDTH (copy), MAX_WINDOW_HEIGHT (copy)
		return React.createElement(ShopChromeWrapper, {
			windowSize = v28,
			maxWindowWidth = MAX_WINDOW_WIDTH,
			maxWindowHeight = MAX_WINDOW_HEIGHT
		})
	end
}

local v38 = Service:register(t1)

if FFlagEnableShopPrefetch then
	local prefetchShopDataOnGameJoin = require(CorePackages.Workspace.Packages.InExperienceShop.prefetchShopDataOnGameJoin)

	if FFlagHideShopMenuOnFailure then
		task.spawn(prefetchShopDataOnGameJoin, function(b1: boolean) -- line: 131
			-- upvalues: u33 (ref), u32 (ref), v38 (copy)
			if not b1 then
				return
			end

			u33 = true

			if u32 then
				v38.availability:available()
			end
		end)
	else
		task.spawn(prefetchShopDataOnGameJoin)
	end
end

if EngineFeature2 then
	MarketplaceService.OpenShopRequested:Connect(function(p2) -- line: 155
		-- upvalues: Players (copy), FFlagHideShopMenuOnFailure (copy), u33 (ref), Service (copy), Constants (copy), FFlagCenterInExperienceShopWindow (copy), ShopWindowLayout (copy)
		if p2 == Players.LocalPlayer then
			if FFlagHideShopMenuOnFailure and not u33 then
				return
			end

			if not Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) then
				if FFlagCenterInExperienceShopWindow then
					ShopWindowLayout.toggleInExperienceShopWindow()

					return
				end

				Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
			end
		end
	end)
end

if EngineFeature then
	local function updateShopAvailability() -- line: 173
		-- upvalues: u32 (ref), FFlagHideShopMenuOnFailure (copy), u33 (ref), v38 (copy), Service (copy), Constants (copy)
		if u32 and (not FFlagHideShopMenuOnFailure or u33) then
			v38.availability:available()

			return
		end

		if Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) then
			Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
		end

		v38.availability:unavailable()
	end

	ChromeUtils.setCoreGuiAvailability(v38, Enum.CoreGuiType.ExperienceShop, function(p3) -- line: 185
		-- upvalues: u32 (ref), FFlagHideShopMenuOnFailure (copy), u33 (ref), v38 (copy), Service (copy), Constants (copy)
		u32 = p3

		if u32 and (not FFlagHideShopMenuOnFailure or u33) then
			v38.availability:available()

			return
		end

		if Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) then
			Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
		end

		v38.availability:unavailable()
	end)
end

return v38
