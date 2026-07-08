local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

require(MomentsCommon.Media.MediaTypes)

local function createMediaNodeRegistry() -- line: 45
	local t1 = {}

	return {
		register = function(t2: {[any]: any}) -- line: 48
			-- upvalues: t1 (copy)
			assert(not t1[t2.kind], `mediaNodeRegistry: kind "{ t2.kind }" already registered`)
			t1[t2.kind] = t2
		end,
		getFactory = function(s1: string) -- line: 55
			-- upvalues: t1 (copy)
			return t1[s1]
		end,
		create = function(s2: string, t3: {[any]: any}, p1) -- line: 59
			-- upvalues: t1 (copy)
			local v9 = t1[s2]

			assert(v9, `mediaNodeRegistry: no factory registered for kind "{ s2 }"`)

			return v9.create(t3, p1)
		end,
		getKinds = function() -- line: 65
			-- upvalues: t1 (copy)
			local t4 = {}

			for v11 in t1 do
				table.insert(t4, v11)
			end

			table.sort(t4)

			return t4
		end
	}
end

return createMediaNodeRegistry
