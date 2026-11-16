local v5 = { Unknown = "Unknown", PlusMembershipRequired = "PlusMembershipRequired" }

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

function v5.fromValues(items)
	if type(items) ~= "table" then
		return nil
	end

	local result = {}

	for k, item in items do
		local v6 = v5.fromValue(item)

		if v6 == nil then
			return nil
		end

		table.insert(result, v6)
	end

	return result
end

return v5
