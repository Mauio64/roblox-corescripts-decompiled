local Parent = script:FindFirstAncestor("SignalsUtils").Parent
local Signals = require(Parent.Signals)
local getCurrentUserId = require(Parent.UserLib).Stores.LocalUserIdStore.getCurrentUserId

local function createSessionScopedSignal(p1, p2) -- line: 19
	-- upvalues: Signals (copy), getCurrentUserId (copy)
	local v7 = Signals.createComputed(function(p3) -- line: 23
		-- upvalues: getCurrentUserId (copy), Signals (copy), p1 (copy), p2 (copy)
		getCurrentUserId(p3)

		local v11, v12 = Signals.createSignal(p1, p2)

		return {
			getter = v11,
			setter = v12
		}
	end)

	local function getter(p4) -- line: 30
		-- upvalues: v7 (copy)
		return v7(p4).getter(p4)
	end
	local function setter(p5) -- line: 33
		-- upvalues: v7 (copy)
		v7().setter(p5)
	end

	return getter, setter
end

return createSessionScopedSignal
