local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)
local Cryo = require(parent.Cryo)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local v = { shareCount = 0, hasShared = false }

local function createShareCountsStore()
	local signal, v2 = createSignal({})

	local v3 = {}

	return {
		getShareInfoByMomentId = signal,
		getShareInfo = function(p: string)
			if v3[p] == nil then
				v3[p] = createComputed(function(p2)
					return signal(p2)[p] or v
				end)
			end

			return v3[p]
		end,
		setBatchShareCounts = function(items)
			v2(function(p)
				local clone = table.clone(p)

				for k, item in items do
					local v4 = p[k]

					if v4 == nil or not v4.hasShared or item.hasShared then
						clone[k] = item
					else
						clone[k] = {
							shareCount = math.max(v4.shareCount, item.shareCount),
							hasShared = true
						}
					end
				end

				return clone
			end)
		end,
		setShareCount = function(p: string, shareCount: number, hasShared: boolean)
			v2(function(p2)
				return (Cryo.Dictionary.union(p2, {
					[p] = { shareCount = shareCount, hasShared = hasShared }
				}))
			end)
		end,
		markShared = function(p: string)
			local v4 = signal(false)
			local v5 = v4[p] or v

			if v5.hasShared then
				return
			end

			v2((Cryo.Dictionary.union(v4, {
				[p] = {
					shareCount = v5.shareCount + 1,
					hasShared = true
				}
			})))
		end,
		clear = function()
			v2({})
			table.clear(v3)
		end
	}
end

return createShareCountsStore
