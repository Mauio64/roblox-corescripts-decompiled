local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local FFlagEnableShopPrefetch = require(InExperienceShop.Flags.FFlagEnableShopPrefetch)
local FFlagEnableFreeTrialBlueDot = require(InExperienceShop.Flags.FFlagEnableFreeTrialBlueDot)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local logCounter = require(InExperienceShop.Internal.logCounter)
local ShopDebugLogger = require(InExperienceShop.Internal.ShopDebugLogger)
local FirstOpenCounter = require(InExperienceShop.Events.FirstOpenCounter)
local FirstOpenPrefetchHitCounter = require(InExperienceShop.Events.FirstOpenPrefetchHitCounter)
local OpenCounter = require(InExperienceShop.Events.OpenCounter)
local ShopView = require(script.Parent.ShopView)
local useShopViewModel = require(script.Parent.useShopViewModel)

local v = false

local function ShopContainer(p)
	local v2 = SignalsReact.useSignalState(getInExperienceShopStore)

	React.useEffect(function()
		local v3 = FFlagEnableShopPrefetch and not v
		ShopDebugLogger.logLazy(function()
			return "ShopContainer: mount isFirstOpen=" .. tostring(v3)
		end)

		logCounter(OpenCounter)

		if v3 then
			v = true
			logCounter(FirstOpenCounter)

			local v4 = #v2.getCategories(false) > 0
			ShopDebugLogger.logLazy(function()
				return "ShopContainer: prefetch cache hit=" .. tostring(v4)
			end)

			if v4 then
				logCounter(FirstOpenPrefetchHitCounter)
			end
		end

		if FFlagEnableFreeTrialBlueDot then
			local submitFreeTrialBlueDot = require(InExperienceShop.submitFreeTrialBlueDot)
			submitFreeTrialBlueDot.dismiss()
		end

		local NotificationsOrchestrator = require(parent.NotificationsOrchestrator)
		NotificationsOrchestrator.setInExperienceShopOpen(true)
		task.spawn(function()
			ShopDebugLogger.log("ShopContainer: calling onShopOpened")
			v2.onShopOpened()
		end)
		return function()
			NotificationsOrchestrator.setInExperienceShopOpen(false)
		end
	end, { v2.onShopOpened, v2.getCategories })

	local v3 = useShopViewModel(p)
	return React.createElement(ShopView, v3)
end

return ShopContainer
