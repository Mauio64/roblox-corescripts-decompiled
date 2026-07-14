local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local React = require(CorePackages.Packages.React)
local Service = require(Chrome.Service)
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local WindowSizeSignal = require(Chrome.ChromeShared.Service.WindowSizeSignal)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local ShopChromeWrapper = require(Chrome.Integrations.InExperienceShop.ShopChromeWrapper)
local ShopWindowLayout = require(Chrome.Integrations.InExperienceShop.ShopWindowLayout)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement
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
local v27 = MappedSignal.new(Service:onIntegrationStatusChanged(), function() -- line: 32
	-- upvalues: Service (copy), Constants (copy)
	return Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID)
end)
local MAX_WINDOW_WIDTH = ShopWindowLayout.MAX_WINDOW_WIDTH
local MAX_WINDOW_HEIGHT = ShopWindowLayout.MAX_WINDOW_HEIGHT
local v30 = WindowSizeSignal.new(MAX_WINDOW_WIDTH, MAX_WINDOW_HEIGHT, false, true)
local v31 = game:DefineFastString("InExperienceShopNewBadgeStorageKey", "InExperienceShopNewBadgeStorageKey")
local v32 = game:DefineFastInt("NewBadgeDismissalMaxCountInExperienceShop", 5)
local v33 = game:DefineFastFlag("EnableNewBadgeInExperienceShop", false) and FFlagEnableMenuTrailingBadge
local u34 = not not EngineFeature and (StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All) or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.ExperienceShop))
local u35 = true

local function getInitialAvailability() -- line: 68
	-- upvalues: u34 (ref), FFlagHideShopMenuOnFailure (copy), u35 (ref), Service (copy)
	if not u34 or FFlagHideShopMenuOnFailure then
		u35 = false

		return Service.AvailabilitySignal.Unavailable
	end

	return Service.AvailabilitySignal.Available
end
local function toggleShopWindow() -- line: 76
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

if not u34 or FFlagHideShopMenuOnFailure then
	u35 = false
	Unavailable = Service.AvailabilitySignal.Unavailable
else
	Unavailable = Service.AvailabilitySignal.Available
end

t1.initialAvailability = Unavailable
t1.id = Constants.IN_EXPERIENCE_SHOP_ID
t1.sideSheetPlacement = SideSheetPlacement.Page
t1.windowSize = v30
t1.startingWindowPosition = ShopWindowLayout.getStartingWindowPosition()

function t1.activated(_) -- line: 94
	-- upvalues: FFlagCenterInExperienceShopWindow (copy), ShopWindowLayout (copy), Service (copy), Constants (copy)
	if FFlagCenterInExperienceShopWindow then
		ShopWindowLayout.toggleInExperienceShopWindow()

		return
	end

	Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
end

t1.menuTrailingBadgeConfig = if not v33 then nil else {
	localStorageKey = v31,
	maxViewCount = v32
}
t1.isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 105
	-- upvalues: v27 (copy)
	return v27:get()
end or v27
t1.components = {
	Icon = function() -- line: 109
		-- upvalues: CommonIcon (copy), FFlagExperienceShopNewIconography (copy), v27 (copy)
		return CommonIcon(not FFlagExperienceShopNewIconography and "BuildingStore" or "ShoppingBasket", nil, v27)
	end,
	Window = function() -- line: 116
		-- upvalues: React (copy), ShopChromeWrapper (copy), v30 (copy), MAX_WINDOW_WIDTH (copy), MAX_WINDOW_HEIGHT (copy)
		return React.createElement(ShopChromeWrapper, {
			windowSize = v30,
			maxWindowWidth = MAX_WINDOW_WIDTH,
			maxWindowHeight = MAX_WINDOW_HEIGHT
		})
	end
}

local v40 = Service:register(t1)

if FFlagEnableShopPrefetch then
	local prefetchShopDataOnGameJoin = require(CorePackages.Workspace.Packages.InExperienceShop.prefetchShopDataOnGameJoin)

	if FFlagHideShopMenuOnFailure then
		task.spawn(prefetchShopDataOnGameJoin, function(b1: boolean) -- line: 134
			-- upvalues: u35 (ref), u34 (ref), v40 (copy)
			if not b1 then
				return
			end

			u35 = true

			if u34 then
				v40.availability:available()
			end
		end)
	else
		task.spawn(prefetchShopDataOnGameJoin)
	end
end

if EngineFeature2 then
	MarketplaceService.OpenShopRequested:Connect(function(p2) -- line: 158
		-- upvalues: Players (copy), FFlagHideShopMenuOnFailure (copy), u35 (ref), Service (copy), Constants (copy), FFlagCenterInExperienceShopWindow (copy), ShopWindowLayout (copy)
		if p2 == Players.LocalPlayer then
			if FFlagHideShopMenuOnFailure and not u35 then
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
	local function updateShopAvailability() -- line: 176
		-- upvalues: u34 (ref), FFlagHideShopMenuOnFailure (copy), u35 (ref), v40 (copy), Service (copy), Constants (copy)
		if u34 and (not FFlagHideShopMenuOnFailure or u35) then
			v40.availability:available()

			return
		end

		if Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) then
			Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
		end

		v40.availability:unavailable()
	end

	ChromeUtils.setCoreGuiAvailability(v40, Enum.CoreGuiType.ExperienceShop, function(p3) -- line: 188
		-- upvalues: u34 (ref), FFlagHideShopMenuOnFailure (copy), u35 (ref), v40 (copy), Service (copy), Constants (copy)
		u34 = p3

		if u34 and (not FFlagHideShopMenuOnFailure or u35) then
			v40.availability:available()

			return
		end

		if Service:isWindowOpen(Constants.IN_EXPERIENCE_SHOP_ID) then
			Service:toggleWindow(Constants.IN_EXPERIENCE_SHOP_ID)
		end

		v40.availability:unavailable()
	end)
end

return v40
