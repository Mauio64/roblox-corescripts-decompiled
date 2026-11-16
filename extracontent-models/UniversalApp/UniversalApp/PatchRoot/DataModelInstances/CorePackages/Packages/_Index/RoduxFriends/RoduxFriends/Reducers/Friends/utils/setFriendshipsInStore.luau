local parent = script:FindFirstAncestor("RoduxFriends").Parent
local llama = require(parent.llama)
local addUser = require(script.Parent.addUser)
local removeUser = require(script.Parent.removeUser)

function difference(items, items2)
	local v = {}

	for _, item in pairs(items) do
		v[item] = true
	end

	for _, item in pairs(items2) do
		v[item] = nil
	end

	local count = 0
	local result = {}

	for _, item in pairs(items) do
		if not v[item] then
			continue
		end

		count += 1
		result[count] = item
	end

	return result
end

return function(items, p)
	local users = tostring(p.namedIds.users)
	local v = items[users] or {}

	local mapped = llama.List.map(llama.Dictionary.values(p.responseBody.data), function(p2)
		return (tostring(p2.id))
	end)

	local v2 = difference(mapped, v)
	local v3 = difference(v, mapped)

	for _, v4 in pairs(v2) do
		items = llama.Dictionary.join(items, {
			[users] = addUser(items[users], v4),
			[v4] = addUser(items[v4], users)
		})
	end

	for _, v4 in pairs(v3) do
		items = llama.Dictionary.join(items, {
			[users] = removeUser(items[users], v4),
			[v4] = removeUser(items[v4], users)
		})
	end

	for k, item in pairs(items) do
		if llama.isEmpty(item) then
			items[k] = nil
		end
	end

	return items
end
