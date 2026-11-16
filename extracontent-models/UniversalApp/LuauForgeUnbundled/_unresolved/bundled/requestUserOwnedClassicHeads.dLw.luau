local module = require("@luauforge/bundled/dLu")

local function requestUserOwnedClassicHeads(callback, p2, value)
	return callback(
		string.format(
			"%sv2/users/%s/inventory?limit=100&sortOrder=Desc&assetTypes=Head&cursor=%s",
			module.Url.INVENTORY_URL,
			p2,
			value or ""
		),
		"GET"
	)
end

return requestUserOwnedClassicHeads
