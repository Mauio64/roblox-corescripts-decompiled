local Parent = script:FindFirstAncestor("UserProfiles").Parent
local Signals = require(Parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local UserProfileStore = require(script.Parent.UserProfileStore)
local t1 = {}
local v7 = UserProfileStore.get()

local function getOrCreateUserSignal(n1: number) -- line: 22
	-- upvalues: t1 (ref), createSignal (copy)
	if not t1[n1] then
		local v12, v13 = createSignal(false)

		t1[n1] = {
			getter = v12,
			setter = v13
		}
	end

	return t1[n1]
end
local function hasUserVerifiedBadge(n2: number, p1) -- line: 35
	-- upvalues: v7 (copy)
	local v20 = v7.fetchNamesByUserIds({ (tostring(n2)) })
	local ok, result = pcall(v20, p1)

	if not ok then
		result = {
			status = "failed",
			data = {}
		}
	end

	if result.status == "success" and #result.data > 0 and result.data[1].getIsVerified then
		return result.data[1].getIsVerified(p1)
	end

	return false
end

local t2 = {
	setBadgeVisibility = function(n3: number, b1: boolean) -- line: 30
		-- upvalues: t1 (ref), createSignal (copy)
		if not t1[n3] then
			local v16, v17 = createSignal(false)

			t1[n3] = {
				getter = v16,
				setter = v17
			}
		end

		t1[n3].setter(b1)
	end,
	getBadgeVisibilitySignal = function(n4: number) -- line: 51
		-- upvalues: t1 (ref), createSignal (copy), createComputed (copy), hasUserVerifiedBadge (copy)
		if not t1[n4] then
			local v24, v25 = createSignal(false)

			t1[n4] = {
				getter = v24,
				setter = v25
			}
		end

		local v26 = t1[n4]

		return createComputed(function(p2) -- line: 54
			-- upvalues: hasUserVerifiedBadge (copy), n4 (copy), v26 (copy)
			local v33 = hasUserVerifiedBadge(n4, p2)
			local v34 = v26.getter(p2)

			return v33 and v34
		end)
	end,
	isBadgeVisible = function(n5: number) -- line: 61
		-- upvalues: hasUserVerifiedBadge (copy), t1 (ref), createSignal (copy)
		local v28 = hasUserVerifiedBadge(n5, false)

		if not t1[n5] then
			local v29, v30 = createSignal(false)

			t1[n5] = {
				getter = v29,
				setter = v30
			}
		end

		local v31 = t1[n5].getter(false)

		return v28 and v31
	end,
	reset = function() -- line: 69
		-- upvalues: t1 (ref)
		t1 = {}
	end
}

return {
	get = function() -- line: 81
		-- upvalues: t2 (copy)
		return t2
	end
}
