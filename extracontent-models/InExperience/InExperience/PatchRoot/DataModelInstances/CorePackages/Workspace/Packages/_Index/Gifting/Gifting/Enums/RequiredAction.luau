local RequiredAction = { Unknown = "Unknown", PlusMembershipRequired = "PlusMembershipRequired" }

local set = {}

for _, v in pairs(RequiredAction) do
	set[v] = true
end

function RequiredAction.fromValue(p: string?)
	return if not (p == nil or not set[p]) then p else nil
end

function RequiredAction.fromValues(items)
	if type(items) ~= "table" then
		return nil
	end

	local result = {}

	for _, item in items do
		local v = RequiredAction.fromValue(item)

		if v == nil then
			return nil
		end

		table.insert(result, v)
	end

	return result
end

return RequiredAction
