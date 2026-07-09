local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local Signals = require(Parent.Signals)

local function createTopBarStore() -- line: 56
	-- upvalues: Signals (copy), Cryo (copy)
	local v5, v6 = Signals.createSignal({})
	local t1 = {}

	return {
		getScreenTopBar = function(s1: string) -- line: 61
			-- upvalues: t1 (copy), Signals (copy), v5 (copy)
			if t1[s1] == nil then
				t1[s1] = Signals.createComputed(function(p1) -- line: 63
					-- upvalues: v5 (copy), s1 (copy)
					return v5(p1)[s1] or {}
				end)
			end

			return t1[s1]
		end,
		setScreenTopBar = function(s2: string, t2: {[any]: any}) -- line: 71
			-- upvalues: v6 (copy), Cryo (copy)
			v6(function(p2) -- line: 72
				-- upvalues: Cryo (copy), s2 (copy), t2 (copy)
				local v14 = Cryo.Dictionary.union(p2[s2] or {}, t2)

				return Cryo.Dictionary.union(p2, {
					[s2] = v14
				})
			end)
		end,
		clearScreenTopBar = function(s3: string) -- line: 80
			-- upvalues: v6 (copy), Cryo (copy)
			v6(function(p3) -- line: 81
				-- upvalues: Cryo (copy), s3 (copy)
				return Cryo.Dictionary.union(p3, {
					[s3] = {}
				})
			end)
		end,
		resetStore = function() -- line: 88
			-- upvalues: v6 (copy)
			v6({})
		end
	}
end

return createTopBarStore
