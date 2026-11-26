local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Cryo")

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local v5 = { shareCount = 0, hasShared = false }

local function createShareCountsStore()
	local signal, v6 = createSignal({})

	local v7 = {}

	return {
		getShareInfoByMomentId = signal,
		getShareInfo = function(p2)
			if v7[p2] == nil then
				v7[p2] = createComputed(function(p3)
					return signal(p3)[p2] or v5
				end)
			end

			return v7[p2]
		end,
		setBatchShareCounts = function(items)
			v6(function(p2)
				local clone = table.clone(p2)

				for k, item in items do
					local v8 = p2[k]

					if v8 == nil or not v8.hasShared or item.hasShared then
						clone[k] = item
					else
						clone[k] = {
							shareCount = math.max(v8.shareCount, item.shareCount),
							hasShared = true
						}
					end
				end

				return clone
			end)
		end,
		setShareCount = function(p2, p3, p4)
			v6(function(p5)
				return Cryo.Dictionary.union(p5, {
					[p2] = { shareCount = p3, hasShared = p4 }
				})
			end)
		end,
		markShared = function(p2)
			local v8 = signal(false)
			local v9 = v8[p2] or v5

			if v9.hasShared then
				return
			end

			v6(Cryo.Dictionary.union(v8, {
				[p2] = {
					shareCount = v9.shareCount + 1,
					hasShared = true
				}
			}))
		end,
		clear = function()
			v6({})
			table.clear(v7)
		end
	}
end

return createShareCountsStore
