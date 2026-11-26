local Players = game:GetService("Players")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Signals")

local defineFastFlag = game:DefineFastFlag("AXSubscriptionSignalsPlayersServiceOverride", false)

local v5 = nil
local v6 = nil

local function getPlayersService()
	if defineFastFlag and v6 ~= nil then
		return v6
	end

	return Players
end

local function fn()
	local localPlayer = (if defineFastFlag and v6 ~= nil then v6 else Players).LocalPlayer
	local hasRobloxSubscription = localPlayer.HasRobloxSubscription == true
	local signal, v8 = Signals.createSignal(hasRobloxSubscription)
	local signal2, v9 = Signals.createSignal(false)

	local signal3, v10 = Signals.createSignal(false)

	local signal4, v11 = Signals.createSignal(false)

	local hasRobloxSubscriptionChangedConnection = localPlayer:GetPropertyChangedSignal("HasRobloxSubscription"):Connect(function()
		local hasRobloxSubscription2 = localPlayer.HasRobloxSubscription == true
		local v12 = signal()
		v8(hasRobloxSubscription2)

		if hasRobloxSubscription2 and not v12 then
			v9(true)
		end
	end)

	return {
		getHasRobloxSubscription = signal,
		getGainedRobloxSubscriptionThisSession = signal2,
		getHasRobloxSubscriptionUpgradedThisSession = signal3,
		setHasRobloxSubscriptionUpgradedThisSession = v10,
		getExistingSubscriptionUpgradedThisSession = signal4,
		setExistingSubscriptionUpgradedThisSession = v11,
		setHasRobloxSubscriptionForTesting = v8,
		setGainedRobloxSubscriptionThisSessionForTesting = v9,
		cleanup = function()
			if hasRobloxSubscriptionChangedConnection then
				hasRobloxSubscriptionChangedConnection:Disconnect()
			end
		end
	}
end

return {
	get = function()
		if v5 == nil then
			v5 = Signals.createComputed(fn)(false)
		end

		return v5
	end,
	setPlayersServiceForTesting = function(p2)
		if defineFastFlag then
			v6 = p2
		end
	end,
	cleanup = function()
		v5 = nil
		v6 = nil
	end
}
