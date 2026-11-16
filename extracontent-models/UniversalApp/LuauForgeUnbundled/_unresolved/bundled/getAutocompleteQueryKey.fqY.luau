local module = require("@luauforge/bundled/fqZ")

local function getAutocompleteQueryKey(value)
	local v5 = value:gsub("￼", "")
	return module.canonicalizeMarketplaceQuery(v5)
end

return getAutocompleteQueryKey
