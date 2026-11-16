local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/Signals")
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local v5 = {}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Stores/UserProfileStore").get()

local function getOrCreateUserSignal(p2)
	if not v5[p2] then
		local signal, v7 = createSignal(false)
		v5[p2] = { getter = signal, setter = v7 }
	end

	return v5[p2]
end

local function hasUserVerifiedBadge(p2, p3)
	local namesByUserIds = v6.fetchNamesByUserIds({ (tostring(p2)) })
	local success, result = pcall(namesByUserIds, p3)

	local v7 = not success and { status = "failed", data = {} } or result

	if v7.status == "success" and #v7.data > 0 and v7.data[1].getIsVerified then
		return v7.data[1].getIsVerified(p3)
	end

	return false
end

local v7 = {
	setBadgeVisibility = function(p2, p3)
		if not v5[p2] then
			local signal, v8 = createSignal(false)
			v5[p2] = { getter = signal, setter = v8 }
		end

		v5[p2].setter(p3)
	end,
	getBadgeVisibilitySignal = function(p2)
		if not v5[p2] then
			local signal, v7 = createSignal(false)
			v5[p2] = { getter = signal, setter = v7 }
		end

		local v7 = v5[p2]

		return createComputed(function(p3)
			local userVerifiedBadge = hasUserVerifiedBadge(p2, p3)
			local getter = v7.getter(p3)
			return userVerifiedBadge and getter
		end)
	end,
	isBadgeVisible = function(p2)
		local userVerifiedBadge = hasUserVerifiedBadge(p2, false)

		if not v5[p2] then
			local signal, v7 = createSignal(false)
			v5[p2] = { getter = signal, setter = v7 }
		end

		local getter = v5[p2].getter(false)

		return userVerifiedBadge and getter
	end,
	reset = function()
		v5 = {}
	end
}

return {
	get = function()
		return v7
	end
}
