require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")

local function createMediaNodeRegistry()
	local v5 = {}

	return {
		register = function(p2)
			assert(not v5[p2.kind], `mediaNodeRegistry: kind "{p2.kind}" already registered`)
			v5[p2.kind] = p2
		end,
		getFactory = function(p2)
			return v5[p2]
		end,
		create = function(p2, p3, p4)
			local v6 = v5[p2]
			assert(v6, `mediaNodeRegistry: no factory registered for kind "{p2}"`)
			return v6.create(p3, p4)
		end,
		getKinds = function()
			local kinds = {}

			for k in v5 do
				table.insert(kinds, k)
			end

			table.sort(kinds)
			return kinds
		end
	}
end

return createMediaNodeRegistry
