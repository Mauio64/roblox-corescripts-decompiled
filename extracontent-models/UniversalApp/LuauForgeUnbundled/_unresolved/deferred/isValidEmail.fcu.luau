local module = require("@luauforge/deferred/fcv")

local v5 = { ["gmail.com"] = true, ["icloud.com"] = true }

local function isPersonalEmailDomain(value): boolean
	local v6 = string.match(value, "^[^@%s]+@([^@%s]+)$")
	return v6 ~= nil and v5[string.lower(v6)] == true
end

local function isValidEmail(value): boolean
	if value == nil or value == "" then
		return false
	end

	if module then
		local v6 = string.match(value, "^[^@%s]+@([^@%s]+)$")
		local v7 = not (v6 == nil) and v5[string.lower(v6)] == true

		if v7 then
			return false
		end
	end

	return string.match(value, "^[^@%s]+@[^@%s]+%.[^@%s]+$") ~= nil
end

return isValidEmail
