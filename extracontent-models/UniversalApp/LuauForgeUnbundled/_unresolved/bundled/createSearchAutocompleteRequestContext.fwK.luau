local module = require("@luauforge/bundled/fwB")

local function createSearchAutocompleteRequestContext(p2, p3, callback)
	local v5 = module(p2)
	local function isResponseCurrent()
		local v6, v7, v8 = callback()

		if v6 then
			v6 = v7 == p2 and v8 == p3 and module(p2) == v5
		end

		return v6
	end

	return v5, isResponseCurrent
end

return createSearchAutocompleteRequestContext
