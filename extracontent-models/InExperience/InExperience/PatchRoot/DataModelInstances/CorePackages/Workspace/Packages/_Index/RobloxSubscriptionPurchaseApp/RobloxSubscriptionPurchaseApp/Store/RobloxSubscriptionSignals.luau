local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local Players = game:GetService("Players")
local Signals = require(parent.Signals)

local defineFastFlag = game:DefineFastFlag("AXSubscriptionSignalsPlayersServiceOverride", false)

local v = nil
local v2 = nil

local function getPlayersService() -- 1 equivalent call inferred from this helper
	return if defineFastFlag and v2 ~= nil then v2 else Players
end

local function fn()
	local localPlayer = getPlayersService().LocalPlayer -- inferred equivalent call
	local hasRobloxSubscription = localPlayer.HasRobloxSubscription == true
	local signal, setHasRobloxSubscriptionForTesting = Signals.createSignal(hasRobloxSubscription)
	local signal2, setGainedRobloxSubscriptionThisSessionForTesting = Signals.createSignal(false)

	local hasRobloxSubscriptionChangedConnection = localPlayer:GetPropertyChangedSignal("HasRobloxSubscription"):Connect(function()
		local hasRobloxSubscription2 = localPlayer.HasRobloxSubscription == true
		local v3 = signal()
		setHasRobloxSubscriptionForTesting(hasRobloxSubscription2)

		if hasRobloxSubscription2 and not v3 then
			setGainedRobloxSubscriptionThisSessionForTesting(true)
		end
	end)

	return {
		getHasRobloxSubscription = signal,
		getGainedRobloxSubscriptionThisSession = signal2,
		setHasRobloxSubscriptionForTesting = setHasRobloxSubscriptionForTesting,
		setGainedRobloxSubscriptionThisSessionForTesting = setGainedRobloxSubscriptionThisSessionForTesting,
		cleanup = function()
			if hasRobloxSubscriptionChangedConnection then
				hasRobloxSubscriptionChangedConnection:Disconnect()
			end
		end
	}
end

local RobloxSubscriptionSignals = {}

function RobloxSubscriptionSignals.get()
	if v == nil then
		v = Signals.createComputed(fn)(false)
	end

	return v
end

function RobloxSubscriptionSignals.setPlayersServiceForTesting(p)
	if defineFastFlag then
		v2 = p
	end
end

function RobloxSubscriptionSignals.cleanup()
	v = nil
	v2 = nil
end

return RobloxSubscriptionSignals
