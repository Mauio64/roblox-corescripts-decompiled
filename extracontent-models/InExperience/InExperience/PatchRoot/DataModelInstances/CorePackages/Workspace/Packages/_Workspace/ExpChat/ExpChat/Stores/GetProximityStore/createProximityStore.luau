local Parent = script:FindFirstAncestor("ExpChat").Parent
local createSignal = require(Parent.Signals).createSignal

local function createProximityStore() -- line: 26
	-- upvalues: createSignal (copy)
	local t1 = {}
	local t2 = {
		isInsideRenderDistance = false,
		isInsideMaximizeDistance = false
	}

	local function getKey(p1) -- line: 38
		return (tostring(p1))
	end

	return {
		getUserProximityState = function(p2) -- line: 42
			-- upvalues: t1 (copy), createSignal (copy), t2 (copy)
			local str = tostring(p2)

			if not t1[str] then
				local v10, v11 = createSignal(t2)

				t1[str] = {
					getter = v10,
					setter = v11
				}
			end

			return t1[str].getter
		end,
		updateProximity = function(p3, b1: boolean, b2: boolean) -- line: 51
			-- upvalues: t1 (copy), createSignal (copy), t2 (copy)
			local str = tostring(p3)

			if not t1[str] then
				local str2 = tostring(p3)

				if not t1[str2] then
					local v17, v18 = createSignal(t2)

					t1[str2] = {
						getter = v17,
						setter = v18
					}
				end

				local _ = t1[str2].getter
			end

			t1[str].setter({
				isInsideRenderDistance = b1,
				isInsideMaximizeDistance = b2
			})
		end,
		removeUser = function(p4) -- line: 67
			-- upvalues: t1 (copy), t2 (copy)
			local str = tostring(p4)

			if t1[str] then
				t1[str].setter(t2)
				t1[str] = nil
			end
		end
	}
end

return createProximityStore
