local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)
local FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback)
local FFlagLuaAppEnableNativePurchaseFinishedV2Signals = require(RobloxSubscriptionPurchaseAppParent.SharedFlags).FFlagLuaAppEnableNativePurchaseFinishedV2Signals

local function useNativePurchaseFinishedListenerLegacy(p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?, p3: ((...any) -> ...any)?, p4: ((...any) -> ...any)?) -- line: 16
	-- upvalues: RobloxSubscriptionStore (copy), React (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy), FFlagLuaAppEnableNativePurchaseFinishedV2Signals (copy)
	local v16 = RobloxSubscriptionStore.get()
	local v17 = React.useRef(v16)
	local v18 = React.useMemo(function() -- line: 25
		-- upvalues: p1 (copy)
		if p1 then
			return p1
		end

		return function() -- line: 29
			return game:GetService("MarketplaceService").NativePurchaseFinishedWithLocalPlayer
		end
	end, { p1 })
	local v19 = React.useMemo(function() -- line: 35
		-- upvalues: p2 (copy)
		if p2 then
			return p2
		end

		return function() -- line: 39
			return game:GetService("MarketplaceService").NativePurchaseFinished
		end
	end, { p2 })

	React.useEffect(function() -- line: 46
		-- upvalues: v18 (copy), v17 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy), v19 (copy), FFlagLuaAppEnableNativePurchaseFinishedV2Signals (copy), p3 (copy), p4 (copy)
		local connection = v18():Connect(function(_, p6) -- line: 48
			-- upvalues: v17 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
			local current = v17.current

			if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
				if p6 then
					current.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()

					return
				end

				current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
			end
		end)
		local connection2 = v19():Connect(function(_, _, p9) -- line: 63
			-- upvalues: v17 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
			local current = v17.current

			if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
				if p9 then
					current.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()

					return
				end

				current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
			end
		end)
		local connection3 = nil
		local connection4 = nil

		if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			connection3 = ((if not p3 then game:GetService("MarketplaceService").NativePurchaseFinishedWithLocalPlayerV2 else p3())):Connect(function(_, p11, _) -- line: 85
				-- upvalues: v17 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
				local current = v17.current

				if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
					if p11 then
						current.setDidTryPurchasing(true)
						completeRobloxSubscriptionUpsellFlow()

						return
					end

					current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
				end
			end)
			connection4 = ((if not p4 then game:GetService("MarketplaceService").NativePurchaseFinishedV2 else p4())):Connect(function(_, _, p15, _) -- line: 102
				-- upvalues: v17 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
				local current = v17.current

				if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
					if p15 then
						current.setDidTryPurchasing(true)
						completeRobloxSubscriptionUpsellFlow()

						return
					end

					current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
				end
			end)
		end

		return function() -- line: 116
			-- upvalues: connection (copy), connection2 (copy), connection3 (ref), connection4 (ref)
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
	end, {
		v18,
		v19,
		p3,
		p4
	})
end
local function useNativePurchaseFinishedListenerWithCancelCallback(p17: ((...any) -> ...any)?, p18: ((...any) -> ...any)?, p19: ((...any) -> ...any)?, p20: ((...any) -> ...any)?, p21: ((...any) -> ...any)?) -- line: 141
	-- upvalues: RobloxSubscriptionStore (copy), React (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy), FFlagLuaAppEnableNativePurchaseFinishedV2Signals (copy)
	local v25 = RobloxSubscriptionStore.get()
	local v26 = React.useRef(v25)
	local v27 = React.useRef(p19)

	v27.current = p19

	local v28 = React.useMemo(function() -- line: 153
		-- upvalues: p17 (copy)
		if p17 then
			return p17
		end

		return function() -- line: 157
			return game:GetService("MarketplaceService").NativePurchaseFinishedWithLocalPlayer
		end
	end, { p17 })
	local v29 = React.useMemo(function() -- line: 163
		-- upvalues: p18 (copy)
		if p18 then
			return p18
		end

		return function() -- line: 167
			return game:GetService("MarketplaceService").NativePurchaseFinished
		end
	end, { p18 })

	local function onNativePurchaseFinished(_: string, b1: boolean) -- line: 173
		-- upvalues: v26 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy), v27 (copy)
		local current = v26.current

		if current.getPromptState() ~= PromptState.SubscriptionPurchaseInProgress then
			return
		end

		if b1 then
			current.setDidTryPurchasing(true)
			completeRobloxSubscriptionUpsellFlow()

			return
		end

		if v27.current then
			v27.current()

			return
		end

		current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
	end

	React.useEffect(function() -- line: 191
		-- upvalues: v28 (copy), onNativePurchaseFinished (copy), v29 (copy), FFlagLuaAppEnableNativePurchaseFinishedV2Signals (copy), p20 (copy), p21 (copy)
		local connection = v28():Connect(function(p22, p23) -- line: 193
			-- upvalues: onNativePurchaseFinished (copy)
			onNativePurchaseFinished(p22, p23)
		end)
		local connection5 = v29():Connect(function(_, p25, p26) -- line: 199
			-- upvalues: onNativePurchaseFinished (copy)
			onNativePurchaseFinished(p25, p26)
		end)
		local connection6 = nil
		local connection7 = nil

		if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			connection6 = ((if not p20 then game:GetService("MarketplaceService").NativePurchaseFinishedWithLocalPlayerV2 else p20())):Connect(function(p27, p28, _) -- line: 212
				-- upvalues: onNativePurchaseFinished (copy)
				onNativePurchaseFinished(p27, p28)
			end)
			connection7 = ((if not p21 then game:GetService("MarketplaceService").NativePurchaseFinishedV2 else p21())):Connect(function(_, p31, p32, _) -- line: 221
				-- upvalues: onNativePurchaseFinished (copy)
				onNativePurchaseFinished(p31, p32)
			end)
		end

		return function() -- line: 227
			-- upvalues: connection (copy), connection5 (copy), connection6 (ref), connection7 (ref)
			if connection then
				connection:Disconnect()
			end

			if connection5 then
				connection5:Disconnect()
			end

			if connection6 then
				connection6:Disconnect()
			end

			if connection7 then
				connection7:Disconnect()
			end
		end
	end, {
		v28,
		v29,
		p20,
		p21
	})
end
local function useNativePurchaseFinishedListener(p34: ((...any) -> ...any)?, p35: ((...any) -> ...any)?, p36: ((...any) -> ...any)?, p37: ((...any) -> ...any)?, p38: ((...any) -> ...any)?) -- line: 255
	-- upvalues: FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback (copy), useNativePurchaseFinishedListenerWithCancelCallback (copy), useNativePurchaseFinishedListenerLegacy (copy)
	if FFlagEnableHeadlessSubscriptionNativePurchaseCancelCallback then
		useNativePurchaseFinishedListenerWithCancelCallback(p34, p35, p36, p37, p38)

		return
	end

	useNativePurchaseFinishedListenerLegacy(p34, p35, p37, p38)
end

return useNativePurchaseFinishedListener
