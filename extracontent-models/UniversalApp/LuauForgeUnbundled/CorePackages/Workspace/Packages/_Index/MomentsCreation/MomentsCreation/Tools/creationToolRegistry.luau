require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function createCreationToolRegistry(items)
	local v5 = {}
	local all = {}

	local function rebuildOrdered()
		all = {}

		for k, v6 in v5 do
			table.insert(all, v6)
		end

		table.sort(all, function(a, b): boolean
			return (a.cta.order or 0) < (b.cta.order or 0)
		end)
	end

	local function register(items2)
		for k, item in items2 do
			v5[item.kind] = item
		end

		rebuildOrdered()
	end

	local function get(p2)
		return v5[p2]
	end

	local function getAll()
		return all
	end

	if items ~= nil then
		for k, item in items do
			v5[item.kind] = item
		end

		rebuildOrdered()
	end

	return { register = register, get = get, getAll = getAll }
end

return createCreationToolRegistry
