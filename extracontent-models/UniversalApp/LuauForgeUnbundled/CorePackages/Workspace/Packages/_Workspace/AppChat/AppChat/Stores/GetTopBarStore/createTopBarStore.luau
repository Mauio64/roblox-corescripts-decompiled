local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local function createTopBarStore()
	local signal, v5 = Signals.createSignal({})

	local v6 = {}

	return {
		getScreenTopBar = function(p2)
			if v6[p2] == nil then
				v6[p2] = Signals.createComputed(function(p3)
					return signal(p3)[p2] or {}
				end)
			end

			return v6[p2]
		end,
		setScreenTopBar = function(p2, p3)
			v5(function(p4)
				local union = Cryo.Dictionary.union(p4[p2] or {}, p3)
				return Cryo.Dictionary.union(p4, { [p2] = union })
			end)
		end,
		clearScreenTopBar = function(p2)
			v5(function(p3)
				return Cryo.Dictionary.union(p3, { [p2] = {} })
			end)
		end,
		resetStore = function()
			v5({})
		end
	}
end

return createTopBarStore
