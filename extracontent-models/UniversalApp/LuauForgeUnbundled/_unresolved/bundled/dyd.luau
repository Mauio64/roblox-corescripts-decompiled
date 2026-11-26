local module = require("@luauforge/bundled/dwd")

return function(value, p2)
	return p2.type ~= module.name and (value or "") or p2.nextPageId
end
