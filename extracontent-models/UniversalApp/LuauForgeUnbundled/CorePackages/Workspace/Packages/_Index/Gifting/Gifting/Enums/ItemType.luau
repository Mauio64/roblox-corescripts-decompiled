local v5 = { Invalid = "Invalid", CollectibleItem = "CollectibleItem" }

local set = {}

for k, v6 in pairs(v5) do
	set[v6] = true
end

function v5.fromValue(p2)
	if p2 == nil or not set[p2] then
		return nil
	end

	return p2
end

return v5
