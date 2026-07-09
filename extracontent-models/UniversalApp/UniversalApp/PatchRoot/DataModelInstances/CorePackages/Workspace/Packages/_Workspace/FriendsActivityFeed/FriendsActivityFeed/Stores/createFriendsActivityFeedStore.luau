local FriendsActivityFeed = script:FindFirstAncestor("FriendsActivityFeed")
local FriendsActivityFeedParent = FriendsActivityFeed.Parent
local Signals = require(FriendsActivityFeedParent.Signals)

require(FriendsActivityFeed.Common.ActivityFeedTypes)

local createSignal = Signals.createSignal

local function createFriendsActivityFeedStore(p1) -- line: 41
	-- upvalues: createSignal (copy)
	local v7, v8 = createSignal({})
	local v9, v10 = createSignal("Loading")
	local v11, v12 = createSignal(nil)
	local u13 = false
	local n1 = 0

	local function runFetch() -- line: 51
		-- upvalues: u13 (ref), n1 (ref), v12 (copy), v10 (copy), p1 (copy), v8 (copy)
		if u13 then
			return
		end

		n1 += 1

		local v16 = n1

		v12(nil)
		v10("Loading")
		task.spawn(function() -- line: 61
			-- upvalues: p1 (copy), u13 (ref), v16 (copy), n1 (ref), v8 (copy), v10 (copy), v12 (copy)
			local ok, result = pcall(p1.fetchAsync, nil)

			if u13 or v16 ~= n1 then
				return
			end

			local v19 = if not ok or (type(result) ~= "table" or type(result.items) ~= "table") then nil else result

			if v19 ~= nil then
				v8(v19.items)
				v10(#v19.items ~= 0 and "Loaded" or "Empty")

				return
			end

			v8({})
			v12(if not ok then tostring(result) else "Malformed feed batch")
			v10("Failed")
		end)
	end

	return {
		getItems = v7,
		getStatus = v9,
		getError = v11,
		loadInitial = runFetch,
		refresh = runFetch,
		dispose = function() -- line: 84
			-- upvalues: u13 (ref), p1 (copy)
			u13 = true

			if p1.dispose then
				p1.dispose()
			end
		end
	}
end

return createFriendsActivityFeedStore
