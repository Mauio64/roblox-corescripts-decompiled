local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

require(MomentsCommon.Media.MediaTypes)

local function createMediaNodeRegistry()
	local v = {}

	return {
		register = function(p)
			assert(not v[p.kind], `mediaNodeRegistry: kind "{p.kind}" already registered`)
			v[p.kind] = p
		end,
		getFactory = function(p: string)
			return v[p]
		end,
		create = function(p: string, p2, p3)
			local v2 = v[p]
			assert(v2, `mediaNodeRegistry: no factory registered for kind "{p}"`)
			return v2.create(p2, p3)
		end,
		getKinds = function()
			local kinds = {}

			for k in v do
				table.insert(kinds, k)
			end

			table.sort(kinds)
			return kinds
		end
	}
end

return createMediaNodeRegistry
