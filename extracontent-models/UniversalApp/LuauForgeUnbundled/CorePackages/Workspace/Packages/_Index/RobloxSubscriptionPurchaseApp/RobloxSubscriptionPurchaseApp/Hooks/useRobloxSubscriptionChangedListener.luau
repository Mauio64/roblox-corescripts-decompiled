local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")

local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local finalizeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/finalizeRobloxSubscriptionUpsellFlow")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")

local function useRobloxSubscriptionChangedListener(p2)
	local v5 = RobloxSubscriptionStore.get()
	local ref = React.useRef(v5)

	local v6 = React.useMemo(function()
		if p2 then
			return p2
		end

		return function()
			return Players.LocalPlayer
		end
	end, { p2 })

	React.useEffect(function()
		local v7 = v6()

		if not v7 then
			return nil
		end

		local function onHasRobloxSubscriptionChanged()
			if v7.HasRobloxSubscription ~= true then
				return
			end

			if ref.current.getPromptState() == PromptState.SubscriptionStatusPolling then
				finalizeRobloxSubscriptionUpsellFlow(true)
			end
		end

		local hasRobloxSubscriptionChangedConnection = v7:GetPropertyChangedSignal("HasRobloxSubscription"):Connect(onHasRobloxSubscriptionChanged)

		return function()
			if hasRobloxSubscriptionChangedConnection then
				hasRobloxSubscriptionChangedConnection:Disconnect()
			end
		end
	end, { v6 })
end

return useRobloxSubscriptionChangedListener
