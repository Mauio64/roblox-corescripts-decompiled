local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local Players = game:GetService("Players")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local finalizeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.finalizeRobloxSubscriptionUpsellFlow)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)

local function useRobloxSubscriptionChangedListener(p1: ((...any) -> ...any)?) -- line: 18
	-- upvalues: RobloxSubscriptionStore (copy), React (copy), Players (copy), PromptState (copy), finalizeRobloxSubscriptionUpsellFlow (copy)
	local v10 = RobloxSubscriptionStore.get()
	local v11 = React.useRef(v10)
	local v12 = React.useMemo(function() -- line: 22
		-- upvalues: p1 (copy), Players (copy)
		if p1 then
			return p1
		end

		return function() -- line: 26
			-- upvalues: Players (copy)
			return Players.LocalPlayer
		end
	end, { p1 })

	React.useEffect(function() -- line: 31
		-- upvalues: v12 (copy), v11 (copy), PromptState (copy), finalizeRobloxSubscriptionUpsellFlow (copy)
		local v13 = v12()

		if not v13 then
			return nil
		end

		local function onHasRobloxSubscriptionChanged() -- line: 37
			-- upvalues: v13 (copy), v11 (copy), PromptState (copy), finalizeRobloxSubscriptionUpsellFlow (copy)
			if v13.HasRobloxSubscription ~= true then
				return
			end

			if v11.current.getPromptState() == PromptState.SubscriptionStatusPolling then
				finalizeRobloxSubscriptionUpsellFlow(true)
			end
		end

		local connection = v13:GetPropertyChangedSignal("HasRobloxSubscription"):Connect(onHasRobloxSubscriptionChanged)

		return function() -- line: 52
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	end, { v12 })
end

return useRobloxSubscriptionChangedListener
