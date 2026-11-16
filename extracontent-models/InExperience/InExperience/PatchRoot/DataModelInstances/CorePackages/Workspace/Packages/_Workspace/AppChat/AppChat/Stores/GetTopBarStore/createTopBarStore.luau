local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

local function createTopBarStore()
	local signal, v = Signals.createSignal({})

	local v2 = {}

	return {
		getScreenTopBar = function(p: string)
			if v2[p] == nil then
				v2[p] = Signals.createComputed(function(p2)
					return signal(p2)[p] or {}
				end)
			end

			return v2[p]
		end,
		setScreenTopBar = function(p: string, p2)
			v(function(p3)
				local union = Cryo.Dictionary.union(p3[p] or {}, p2)
				return Cryo.Dictionary.union(p3, { [p] = union })
			end)
		end,
		clearScreenTopBar = function(p: string)
			v(function(p2)
				return Cryo.Dictionary.union(p2, { [p] = {} })
			end)
		end,
		resetStore = function()
			v({})
		end
	}
end

return createTopBarStore
