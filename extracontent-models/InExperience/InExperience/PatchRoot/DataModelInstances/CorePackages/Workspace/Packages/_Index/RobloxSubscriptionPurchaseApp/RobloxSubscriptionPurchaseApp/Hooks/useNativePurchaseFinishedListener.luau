local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent
local React = require(parent.React)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)

local FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableNativePurchaseFinishedV2Signals = SharedFlags.FFlagLuaAppEnableNativePurchaseFinishedV2Signals

local function useNativePurchaseFinishedListenerLegacy(callback, callback2, callback3, callback4)
	local v = RobloxSubscriptionStore.get()
	local ref = React.useRef(v)

	local v2 = React.useMemo(function()
		if callback then
			return callback
		end

		return function()
			local MarketplaceService = game:GetService("MarketplaceService")
			return MarketplaceService.NativePurchaseFinishedWithLocalPlayer
		end
	end, { callback })

	local v3 = React.useMemo(function()
		if callback2 then
			return callback2
		end

		return function()
			local MarketplaceService = game:GetService("MarketplaceService")
			return MarketplaceService.NativePurchaseFinished
		end
	end, { callback2 })

	React.useEffect(function()
		local connection = v2():Connect(function(_, p)
			local current = ref.current

			if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
				if p then
					current.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()
				else
					current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
				end
			end
		end)

		local connection2 = v3():Connect(function(_, _, p)
			local current = ref.current

			if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
				if p then
					current.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()
				else
					current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
				end
			end
		end)
		local connection3, connection4

		if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			local v4

			if callback3 then
				v4 = callback3()
			else
				local MarketplaceService = game:GetService("MarketplaceService")
				v4 = MarketplaceService.NativePurchaseFinishedWithLocalPlayerV2
			end

			connection3 = v4:Connect(function(_, p, _)
				local current = ref.current

				if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
					if p then
						current.setDidTryPurchasing(true)
						completeRobloxSubscriptionUpsellFlow()
					else
						current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
					end
				end
			end)
			local v5

			if callback4 then
				v5 = callback4()
			else
				local MarketplaceService = game:GetService("MarketplaceService")
				v5 = MarketplaceService.NativePurchaseFinishedV2
			end

			connection4 = v5:Connect(function(_, _, p, _)
				local current = ref.current

				if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
					if p then
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
	end, { v2, v3, callback3, callback4 })
end

local function useNativePurchaseFinishedListenerWithCancelCallback(callback, callback2, current, callback3, callback4)
	local v = RobloxSubscriptionStore.get()
	local ref = React.useRef(v)
	local ref2 = React.useRef(current)
	ref2.current = current

	local v2 = React.useMemo(function()
		if callback then
			return callback
		end

		return function()
			local MarketplaceService = game:GetService("MarketplaceService")
			return MarketplaceService.NativePurchaseFinishedWithLocalPlayer
		end
	end, { callback })

	local v3 = React.useMemo(function()
		if callback2 then
			return callback2
		end

		return function()
			local MarketplaceService = game:GetService("MarketplaceService")
			return MarketplaceService.NativePurchaseFinished
		end
	end, { callback2 })

	local function onNativePurchaseFinished(_: string, flag: boolean)
		local current2 = ref.current

		if current2.getPromptState() ~= PromptState.SubscriptionPurchaseInProgress then
			return
		end

		if flag then
			current2.setDidTryPurchasing(true)
			completeRobloxSubscriptionUpsellFlow()
		elseif ref2.current then
			ref2.current()
		else
			current2.setPromptState(PromptState.SubscriptionPurchaseUIReady)
		end
	end

	React.useEffect(function()
		local connection = v2():Connect(function(p, p2)
			onNativePurchaseFinished(p, p2)
		end)

		local connection2 = v3():Connect(function(_, p, p2)
			onNativePurchaseFinished(p, p2)
		end)
		local connection3, connection4

		if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			local v4

			if callback3 then
				v4 = callback3()
			else
				local MarketplaceService = game:GetService("MarketplaceService")
				v4 = MarketplaceService.NativePurchaseFinishedWithLocalPlayerV2
			end

			connection3 = v4:Connect(function(p, p2, _)
				onNativePurchaseFinished(p, p2)
			end)
			local v5

			if callback4 then
				v5 = callback4()
			else
				local MarketplaceService = game:GetService("MarketplaceService")
				v5 = MarketplaceService.NativePurchaseFinishedV2
			end

			connection4 = v5:Connect(function(_, p, p2, _)
				onNativePurchaseFinished(p, p2)
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
	end, { v2, v3, callback3, callback4 })
end

local function useNativePurchaseFinishedListener(callback, callback2, current, callback3, callback4)
	if FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback then
		useNativePurchaseFinishedListenerWithCancelCallback(callback, callback2, current, callback3, callback4)
	else
		useNativePurchaseFinishedListenerLegacy(callback, callback2, callback3, callback4)
	end
end

return useNativePurchaseFinishedListener
