local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Signals = require(scriptParentParent.Signals)

require(scriptParent.HttpStoreTypes)

local function createMockHttpStore() -- line: 20
	-- upvalues: Signals (copy)
	local t1 = {}

	local function getOrCreateResponse(s1: string, p1) -- line: 29
		-- upvalues: t1 (ref), Signals (copy)
		if not t1[s1] then
			local v9, v10 = Signals.createSignal({
				status = "NotStarted",
				config = p1
			})

			t1[s1] = {
				get = v9,
				set = v10
			}
		end

		return t1[s1]
	end

	return {
		fetch = function(s2: string?, p2) -- line: 40
			-- upvalues: getOrCreateResponse (copy)
			local v13 = s2 or p2.Url

			return getOrCreateResponse(v13, p2).get, function() -- line: 43
			end
		end,
		cancelAll = function() -- line: 46
		end,
		setResponse = function(s3: string, p3) -- line: 53
			-- upvalues: t1 (ref), Signals (copy)
			if t1[s3] then
				t1[s3].set(p3)

				return
			end

			local v16, v17 = Signals.createSignal(p3)

			t1[s3] = {
				get = v16,
				set = v17
			}
		end,
		reset = function() -- line: 63
			-- upvalues: t1 (ref)
			t1 = {}
		end
	}
end

return createMockHttpStore
