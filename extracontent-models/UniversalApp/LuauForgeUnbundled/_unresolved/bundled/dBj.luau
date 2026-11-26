local immutable = require("@luauforge/bundled/dBk").Immutable
local module = require("@luauforge/bundled/dBh")

return function(options, p2)
	local v5 = options or {}
	assert(v5, "")

	if p2.type ~= module.name then
		return v5
	end

	local urls = {}

	for k, thumbnail in pairs(p2.thumbnails) do
		urls[k] = thumbnail.url
	end

	v5 = immutable.JoinDictionaries(v5, urls)

	return v5
end
