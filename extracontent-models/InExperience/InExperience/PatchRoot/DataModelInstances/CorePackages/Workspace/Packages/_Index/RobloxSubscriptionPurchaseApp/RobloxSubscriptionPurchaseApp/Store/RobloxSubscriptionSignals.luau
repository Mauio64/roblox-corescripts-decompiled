local Parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local Players = game:GetService("Players")
local Signals = require(Parent.Signals)
local v4 = game:DefineFastFlag("AXSubscriptionSignalsPlayersServiceOverride", false)
local u5 = nil
local u6 = nil

local function getPlayersService() -- line: 28
	-- upvalues: v4 (copy), u6 (ref), Players (copy)
	if v4 and u6 ~= nil then
		return u6
	end

	return Players
end
local function v8() -- line: 35
	-- upvalues: v4 (copy), u6 (ref), Players (copy), Signals (copy)
	local LocalPlayer = ((if not v4 or u6 == nil then Players else u6)).LocalPlayer
	local v10 = LocalPlayer.HasRobloxSubscription == true
	local v11, v12 = Signals.createSignal(v10)
	local v13, v14 = Signals.createSignal(false)
	local connection = LocalPlayer:GetPropertyChangedSignal("HasRobloxSubscription"):Connect(function() -- line: 43
		-- upvalues: LocalPlayer (copy), v11 (copy), v12 (copy), v14 (copy)
		local v17 = LocalPlayer.HasRobloxSubscription == true
		local v18 = v11()

		v12(v17)

		if v17 and not v18 then
			v14(true)
		end
	end)

	return {
		getHasRobloxSubscription = v11,
		getGainedRobloxSubscriptionThisSession = v13,
		setHasRobloxSubscriptionForTesting = v12,
		setGainedRobloxSubscriptionThisSessionForTesting = v14,
		cleanup = function() -- line: 61
			-- upvalues: connection (copy)
			if connection then
				connection:Disconnect()
			end
		end
	}
end

return {
	get = function() -- line: 71
		-- upvalues: u5 (ref), Signals (copy), v8 (copy)
		if u5 == nil then
			u5 = Signals.createComputed(v8)(false)
		end

		return u5
	end,
	setPlayersServiceForTesting = function(p1) -- line: 78
		-- upvalues: v4 (copy), u6 (ref)
		if v4 then
			u6 = p1
		end
	end,
	cleanup = function() -- line: 84
		-- upvalues: u5 (ref), u6 (ref)
		u5 = nil
		u6 = nil
	end
}
