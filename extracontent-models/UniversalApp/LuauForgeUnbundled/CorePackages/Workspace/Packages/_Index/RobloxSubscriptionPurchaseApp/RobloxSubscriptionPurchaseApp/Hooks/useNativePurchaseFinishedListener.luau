local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
local completeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/completeRobloxSubscriptionUpsellFlow")

local FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback")

local fFlagLuaAppEnableNativePurchaseFinishedV2Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagLuaAppEnableNativePurchaseFinishedV2Signals

local function useNativePurchaseFinishedListenerLegacy(p2, p3, callback, callback2)
	local v5 = RobloxSubscriptionStore.get()
	local ref = React.useRef(v5)

	local v6 = React.useMemo(function()
		if p2 then
			return p2
		end

		return function()
			local MarketplaceService = game:GetService("MarketplaceService")
			return MarketplaceService.NativePurchaseFinishedWithLocalPlayer
		end
	end, { p2 })

	local v7 = React.useMemo(function()
		if p3 then
			return p3
		end

		return function()
			local MarketplaceService = game:GetService("MarketplaceService")
			return MarketplaceService.NativePurchaseFinished
		end
	end, { p3 })

	React.useEffect(function()
		local connection = v6():Connect(function(p4, p5)
			local current = ref.current

			if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
				if p5 then
					current.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()
				else
					current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
				end
			end
		end)

		local connection2 = v7():Connect(function(p4, p5, p6)
			local current = ref.current

			if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
				if p6 then
					current.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()
				else
					current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
				end
			end
		end)
		local connection3, connection4

		if fFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			local v8

			if callback then
				v8 = callback()
			else
				local MarketplaceService = game:GetService("MarketplaceService")
				v8 = MarketplaceService.NativePurchaseFinishedWithLocalPlayerV2
			end

			connection3 = v8:Connect(function(p4, p5, p6)
				local current = ref.current

				if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
					if p5 then
						current.setDidTryPurchasing(true)
						completeRobloxSubscriptionUpsellFlow()
					else
						current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
					end
				end
			end)
			local v9

			if callback2 then
				v9 = callback2()
			else
				local MarketplaceService = game:GetService("MarketplaceService")
				v9 = MarketplaceService.NativePurchaseFinishedV2
			end

			connection4 = v9:Connect(function(p4, p5, p6, p7)
				local current = ref.current

				if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
					if p6 then
						current.setDidTryPurchasing(true)
						completeRobloxSubscriptionUpsellFlow()
					else
						current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
					end
				end
			end)
		else
			connection3 = nil
			connection4 = nil
		end

		return function()
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end

			if connection3 then
				connection3:Disconnect()
			end

			if connection4 then
				connection4:Disconnect()
			end
		end
	end, { v6, v7, callback, callback2 })
end

local function useNativePurchaseFinishedListenerWithCancelCallback(p2, p3, current, callback, callback2)
	local v5 = RobloxSubscriptionStore.get()
	local ref = React.useRef(v5)
	local ref2 = React.useRef(current)
	ref2.current = current

	local v6 = React.useMemo(function()
		if p2 then
			return p2
		end

		return function()
			local MarketplaceService = game:GetService("MarketplaceService")
			return MarketplaceService.NativePurchaseFinishedWithLocalPlayer
		end
	end, { p2 })

	local v7 = React.useMemo(function()
		if p3 then
			return p3
		end

		return function()
			local MarketplaceService = game:GetService("MarketplaceService")
			return MarketplaceService.NativePurchaseFinished
		end
	end, { p3 })

	local function onNativePurchaseFinished(p4, p5)
		local current2 = ref.current

		if current2.getPromptState() ~= PromptState.SubscriptionPurchaseInProgress then
			return
		end

		if p5 then
			current2.setDidTryPurchasing(true)
			completeRobloxSubscriptionUpsellFlow()
		elseif ref2.current then
			ref2.current()
		else
			current2.setPromptState(PromptState.SubscriptionPurchaseUIReady)
		end
	end

	React.useEffect(function()
		local connection = v6():Connect(function(p4, p5)
			onNativePurchaseFinished(p4, p5)
		end)

		local connection2 = v7():Connect(function(p4, p5, p6)
			onNativePurchaseFinished(p5, p6)
		end)
		local connection3, connection4

		if fFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			local v8

			if callback then
				v8 = callback()
			else
				local MarketplaceService = game:GetService("MarketplaceService")
				v8 = MarketplaceService.NativePurchaseFinishedWithLocalPlayerV2
			end

			connection3 = v8:Connect(function(p4, p5, p6)
				onNativePurchaseFinished(p4, p5)
			end)
			local v9

			if callback2 then
				v9 = callback2()
			else
				local MarketplaceService = game:GetService("MarketplaceService")
				v9 = MarketplaceService.NativePurchaseFinishedV2
			end

			connection4 = v9:Connect(function(p4, p5, p6, p7)
				onNativePurchaseFinished(p5, p6)
			end)
		else
			connection3 = nil
			connection4 = nil
		end

		return function()
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end

			if connection3 then
				connection3:Disconnect()
			end

			if connection4 then
				connection4:Disconnect()
			end
		end
	end, { v6, v7, callback, callback2 })
end

local function useNativePurchaseFinishedListener(p2, p3, p4, p5, p6)
	if FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback then
		useNativePurchaseFinishedListenerWithCancelCallback(p2, p3, p4, p5, p6)
	else
		useNativePurchaseFinishedListenerLegacy(p2, p3, p5, p6)
	end
end

return useNativePurchaseFinishedListener
