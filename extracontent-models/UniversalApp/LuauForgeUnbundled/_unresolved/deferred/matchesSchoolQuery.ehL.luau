require("@luauforge/deferred/egX")

local function matchesSchoolQuery(data, value): boolean
	if value == "" then
		return true
	end

	local v5 = string.lower(value)

	if string.find(string.lower(data.name), v5, 1, true) then
		return true
	end

	if data.city and string.find(string.lower(data.city), v5, 1, true) then
		return true
	end

	if data.state and string.find(string.lower(data.state), v5, 1, true) then
		return true
	end

	return false
end

return matchesSchoolQuery
