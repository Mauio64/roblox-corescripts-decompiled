local MomentsCreation = script:FindFirstAncestor("MomentsCreation")

require(MomentsCreation.Types.CreationFlowTypes)

local function createCreationToolRegistry(items)
	local v = {}
	local all = {}

	local function rebuildOrdered()
		all = {}

		for _, v2 in v do
			table.insert(all, v2)
		end

		table.sort(all, function(a, b): boolean
			return (a.cta.order or 0) < (b.cta.order or 0)
		end)
	end

	local function register(items2) -- 1 equivalent call inferred from this helper
		for _, item in items2 do
			v[item.kind] = item
		end

		rebuildOrdered()
	end

	local function get(p: string)
		return v[p]
	end

	local function getAll()
		return all
	end

	if items ~= nil then
		register(items) -- inferred equivalent call
	end

	return { register = register, get = get, getAll = getAll }
end

return createCreationToolRegistry
