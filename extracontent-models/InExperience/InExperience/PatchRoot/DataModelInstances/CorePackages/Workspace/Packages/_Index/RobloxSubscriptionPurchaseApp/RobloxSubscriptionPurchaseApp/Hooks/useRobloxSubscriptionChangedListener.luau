local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local Players = game:GetService("Players")

local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local finalizeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.finalizeRobloxSubscriptionUpsellFlow)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)

local function useRobloxSubscriptionChangedListener(callback)
	local v = RobloxSubscriptionStore.get()
	local ref = React.useRef(v)

	local v2 = React.useMemo(function()
		if callback then
			return callback
		end

		return function()
			return Players.LocalPlayer
		end
	end, { callback })

	React.useEffect(function()
		local v3 = v2()

		if not v3 then
			return nil
		end

		local function onHasRobloxSubscriptionChanged()
			if v3.HasRobloxSubscription ~= true then
				return
			end

			if ref.current.getPromptState() == PromptState.SubscriptionStatusPolling then
				finalizeRobloxSubscriptionUpsellFlow(true)
			end
		end

		local hasRobloxSubscriptionChangedConnection = v3:GetPropertyChangedSignal("HasRobloxSubscription"):Connect(onHasRobloxSubscriptionChanged)

		return function()
			if hasRobloxSubscriptionChangedConnection then
				hasRobloxSubscriptionChangedConnection:Disconnect()
			end
		end
	end, { v2 })
end

return useRobloxSubscriptionChangedListener
