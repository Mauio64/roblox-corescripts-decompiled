local module = require("@luauforge/deferred/dXH")

return function(p2): boolean
	if module[p2] then
		return true
	end

	return false
end
