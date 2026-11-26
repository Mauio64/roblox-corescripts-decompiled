local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")
local addUser = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/utils/addUser")
local removeUser = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/utils/removeUser")

function LUAUFORGE_MODULE_GLOBALS_cgZ_difference(items, items2)
	local v5 = {}

	for k, item in pairs(items) do
		v5[item] = true
	end

	for k, item in pairs(items2) do
		v5[item] = nil
	end

	local count = 0
	local result = {}

	for k, item in pairs(items) do
		if not v5[item] then
			continue
		end

		count += 1
		result[count] = item
	end

	return result
end

return function(items, p2)
	local users = tostring(p2.namedIds.users)
	local v5 = items[users] or {}

	local mapped = llama.List.map(llama.Dictionary.values(p2.responseBody.data), function(p3)
		return (tostring(p3.id))
	end)

	local v6 = LUAUFORGE_MODULE_GLOBALS_cgZ_difference(mapped, v5)
	local v7 = LUAUFORGE_MODULE_GLOBALS_cgZ_difference(v5, mapped)

	for k, v8 in pairs(v6) do
		items = llama.Dictionary.join(items, {
			[users] = addUser(items[users], v8),
			[v8] = addUser(items[v8], users)
		})
	end

	for k, v8 in pairs(v7) do
		items = llama.Dictionary.join(items, {
			[users] = removeUser(items[users], v8),
			[v8] = removeUser(items[v8], users)
		})
	end

	for k, item in pairs(items) do
		if llama.isEmpty(item) then
			items[k] = nil
		end
	end

	return items
end
