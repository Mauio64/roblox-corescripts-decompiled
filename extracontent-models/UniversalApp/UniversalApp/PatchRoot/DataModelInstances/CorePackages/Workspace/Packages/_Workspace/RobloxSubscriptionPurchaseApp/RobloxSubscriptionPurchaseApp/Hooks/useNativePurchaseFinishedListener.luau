local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)

local function useNativePurchaseFinishedListener(p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 13
	-- upvalues: RobloxSubscriptionStore (copy), React (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
	local v10 = RobloxSubscriptionStore.get()
	local v11 = React.useRef(v10)
	local v12 = React.useMemo(function() -- line: 20
		-- upvalues: p1 (copy)
		if p1 then
			return p1
		end

		return function() -- line: 24
			return game:GetService("MarketplaceService").NativePurchaseFinishedWithLocalPlayer
		end
	end, { p1 })
	local v13 = React.useMemo(function() -- line: 30
		-- upvalues: p2 (copy)
		if p2 then
			return p2
		end

		return function() -- line: 34
			return game:GetService("MarketplaceService").NativePurchaseFinished
		end
	end, { p2 })

	React.useEffect(function() -- line: 40
		-- upvalues: v12 (copy), v11 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy), v13 (copy)
		local connection = v12():Connect(function(_, p4) -- line: 42
			-- upvalues: v11 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
			local current = v11.current

			if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
				if p4 then
					current.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()

					return
				end

				current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
			end
		end)
		local connection2 = v13():Connect(function(_, _, p7) -- line: 57
			-- upvalues: v11 (copy), PromptState (copy), completeRobloxSubscriptionUpsellFlow (copy)
			local current = v11.current

			if current.getPromptState() == PromptState.SubscriptionPurchaseInProgress then
				if p7 then
					current.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()

					return
				end

				current.setPromptState(PromptState.SubscriptionPurchaseUIReady)
			end
		end)

		return function() -- line: 71
			-- upvalues: connection (copy), connection2 (copy)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end
		end
	end, {
		v12,
		v13
	})
end

return useNativePurchaseFinishedListener
