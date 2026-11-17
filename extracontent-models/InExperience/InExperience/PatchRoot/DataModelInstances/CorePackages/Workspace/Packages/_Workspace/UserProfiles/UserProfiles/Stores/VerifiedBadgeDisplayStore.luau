local parent = script:FindFirstAncestor("UserProfiles").Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local UserProfileStore = require(script.Parent.UserProfileStore)

local v = {}
local v2 = UserProfileStore.get()

local function getOrCreateUserSignal(p: number) -- 3 equivalent calls inferred from this helper
	if not v[p] then
		local signal, setter = createSignal(false)
		v[p] = { getter = signal, setter = setter }
	end

	return v[p]
end

local function hasUserVerifiedBadge(p: number, p2)
	local success, result = pcall(v2.fetchNamesByUserIds({ (tostring(p)) }), p2)

	local v3 = not success and { status = "failed", data = {} } or result

	if v3.status == "success" and #v3.data > 0 and v3.data[1].getIsVerified then
		return v3.data[1].getIsVerified(p2)
	end

	return false
end

local v3 = {
	setBadgeVisibility = function(p: number, flag: boolean)
		getOrCreateUserSignal(p).setter(flag) -- inferred equivalent call
	end,
	getBadgeVisibilitySignal = function(p: number)
		local userSignal = getOrCreateUserSignal(p) -- inferred equivalent call
		return createComputed(function(p2)
			local userVerifiedBadge = hasUserVerifiedBadge(p, p2)
			local getter = userSignal.getter(p2)
			return userVerifiedBadge and getter
		end)
	end,
	isBadgeVisible = function(p: number)
		local userVerifiedBadge = hasUserVerifiedBadge(p, false)

		local getter = getOrCreateUserSignal(p).getter(false) -- inferred equivalent call

		return userVerifiedBadge and getter
	end,
	reset = function()
		v = {}
	end
}

return {
	get = function()
		return v3
	end
}
