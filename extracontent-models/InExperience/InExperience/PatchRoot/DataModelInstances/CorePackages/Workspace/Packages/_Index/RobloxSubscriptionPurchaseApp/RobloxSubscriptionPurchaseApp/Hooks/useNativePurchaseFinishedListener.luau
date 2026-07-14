local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)
local FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback)

local function useNativePurchaseFinishedListenerLegacy(p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 14
	-- upvalues: RobloxSubscriptionStore (copy), React (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
	local v13 = RobloxSubscriptionStore.get()
	local v14 = React.useRef(v13)
	local v15 = React.useMemo(function() -- line: 21
		-- upvalues: p1 (copy)
		if p1 then
			return p1
		end

		return function() -- line: 25
			return game:GetService("MarketplaceService").NativePurchaseFinishedWithLocalPlayer
		end
	end, { p1 })
	local v16 = React.useMemo(function() -- line: 31
		-- upvalues: p2 (copy)
		if p2 then
			return p2
		end

		return function() -- line: 35
			return game:GetService("MarketplaceService").NativePurchaseFinished
		end
	end, { p2 })

	React.useEffect(function() -- line: 41
		-- upvalues: v15 (copy), v14 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy), v16 (copy)
		local connection = v15():Connect(function(_, p4) -- line: 43
			-- upvalues: v14 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
			local current = v14.current

			if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
				if p4 then
					current.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()

					return
				end

				current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
			end
		end)
		local connection2 = v16():Connect(function(_, _, p7) -- line: 58
			-- upvalues: v14 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
			local current = v14.current

			if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
				if p7 then
					current.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()

					return
				end

				current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
			end
		end)

		return function() -- line: 72
			-- upvalues: connection (copy), connection2 (copy)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end
		end
	end, {
		v15,
		v16
	})
end
local function useNativePurchaseFinishedListenerWithCancelCallback(p8: ((...any) -> ...any)?, p9: ((...any) -> ...any)?, p10: ((...any) -> ...any)?) -- line: 84
	-- upvalues: RobloxSubscriptionStore (copy), React (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
	local v20 = RobloxSubscriptionStore.get()
	local v21 = React.useRef(v20)
	local v22 = React.useRef(p10)

	v22.current = p10

	local v23 = React.useMemo(function() -- line: 94
		-- upvalues: p8 (copy)
		if p8 then
			return p8
		end

		return function() -- line: 98
			return game:GetService("MarketplaceService").NativePurchaseFinishedWithLocalPlayer
		end
	end, { p8 })
	local v24 = React.useMemo(function() -- line: 104
		-- upvalues: p9 (copy)
		if p9 then
			return p9
		end

		return function() -- line: 108
			return game:GetService("MarketplaceService").NativePurchaseFinished
		end
	end, { p9 })

	local function onNativePurchaseFinished(_: string, b1: boolean) -- line: 114
		-- upvalues: v21 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy), v22 (copy)
		local current = v21.current

		if current.getPromptState() ~= PromptState.SubscriptionPurchaseInProgress then
			return
		end

		if b1 then
			current.setDidTryPurchasing(true)
			completeRobloxSubscriptionUpsellFlow()

			return
		end

		if v22.current then
			v22.current()

			return
		end

		current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
	end

	React.useEffect(function() -- line: 131
		-- upvalues: v23 (copy), onNativePurchaseFinished (copy), v24 (copy)
		local connection = v23():Connect(function(p11, p12) -- line: 133
			-- upvalues: onNativePurchaseFinished (copy)
			onNativePurchaseFinished(p11, p12)
		end)
		local connection3 = v24():Connect(function(_, p14, p15) -- line: 139
			-- upvalues: onNativePurchaseFinished (copy)
			onNativePurchaseFinished(p14, p15)
		end)

		return function() -- line: 144
			-- upvalues: connection (copy), connection3 (copy)
			if connection then
				connection:Disconnect()
			end

			if connection3 then
				connection3:Disconnect()
			end
		end
	end, {
		v23,
		v24
	})
end
local function useNativePurchaseFinishedListener(p16: ((...any) -> ...any)?, p17: ((...any) -> ...any)?, p18: ((...any) -> ...any)?) -- line: 159
	-- upvalues: FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback (copy), useNativePurchaseFinishedListenerWithCancelCallback (copy), useNativePurchaseFinishedListenerLegacy (copy)
	if FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback then
		useNativePurchaseFinishedListenerWithCancelCallback(p16, p17, p18)

		return
	end

	useNativePurchaseFinishedListenerLegacy(p16, p17)
end

return useNativePurchaseFinishedListener
