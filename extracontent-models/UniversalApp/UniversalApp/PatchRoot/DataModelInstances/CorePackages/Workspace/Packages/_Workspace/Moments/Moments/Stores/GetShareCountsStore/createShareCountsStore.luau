local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local Cryo = require(Parent.Cryo)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local t1 = {
	shareCount = 0,
	hasShared = false
}

local function createShareCountsStore() -- line: 29
	-- upvalues: createSignal (copy), createComputed (copy), t1 (copy), Cryo (copy)
	local v8, v9 = createSignal({})
	local t2 = {}

	return {
		getShareInfoByMomentId = v8,
		getShareInfo = function(s1: string) -- line: 34
			-- upvalues: t2 (copy), createComputed (copy), v8 (copy), t1 (copy)
			if t2[s1] == nil then
				t2[s1] = createComputed(function(p1) -- line: 36
					-- upvalues: v8 (copy), s1 (copy), t1 (copy)
					return v8(p1)[s1] or t1
				end)
			end

			return t2[s1]
		end,
		setBatchShareCounts = function(t3: {[any]: any}) -- line: 43
			-- upvalues: v9 (copy)
			v9(function(p2) -- line: 44
				-- upvalues: t3 (copy)
				local v21 = table.clone(p2)

				for v22, v23 in t3 do
					local v24 = p2[v22]

					if v24 ~= nil and v24.hasShared and not v23.hasShared then
						v21[v22] = {
							hasShared = true,
							shareCount = math.max(v24.shareCount, v23.shareCount)
						}
					else
						v21[v22] = v23
					end
				end

				return v21
			end)
		end,
		setShareCount = function(s2: string, n1: number, b1: boolean) -- line: 61
			-- upvalues: v9 (copy), Cryo (copy)
			v9(function(p3) -- line: 62
				-- upvalues: Cryo (copy), s2 (copy), n1 (copy), b1 (copy)
				return (Cryo.Dictionary.union(p3, {
					[s2] = {
						shareCount = n1,
						hasShared = b1
					}
				}))
			end)
		end,
		markShared = function(s3: string) -- line: 72
			-- upvalues: v8 (copy), t1 (copy), v9 (copy), Cryo (copy)
			local v17 = v8(false)
			local v18 = v17[s3] or t1

			if v18.hasShared then
				return
			end

			v9((Cryo.Dictionary.union(v17, {
				[s3] = {
					hasShared = true,
					shareCount = v18.shareCount + 1
				}
			})))
		end,
		clear = function() -- line: 86
			-- upvalues: v9 (copy), t2 (copy)
			v9({})
			table.clear(t2)
		end
	}
end

return createShareCountsStore
