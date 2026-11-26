local module = require("@luauforge/bundled/fJJ")

local module2 = require("@luauforge/bundled/fJK")

local signal, v5 = module.createSignal(0)

local signal2, v6 = module.createSignal({})
local v7, v8

if module2 then
	v7, v8 = module.createSignal(false)
else
	v7 = nil
	v8 = nil
end

local function swapLastSeenExistingSubscriptionUpgraded(p2)
	local v9 = v7(false)
	v8(p2)
	return v9
end

local v9 = {
	markAllStale = function()
		v5(signal(false) + 1)
	end,
	getGeneration = function()
		return signal(false)
	end,
	isStale = function(p2): boolean
		local v10 = signal2(false)[p2]
		return v10 ~= nil and v10 ~= signal(false)
	end,
	markFetched = function(p2, p3)
		local clone = table.clone(signal2(false))
		clone[p2] = p3
		v6(clone)
	end,
	swapLastSeenExistingSubscriptionUpgraded = 0
}

if not module2 then
	swapLastSeenExistingSubscriptionUpgraded = nil
end

v9.swapLastSeenExistingSubscriptionUpgraded = swapLastSeenExistingSubscriptionUpgraded
return v9
