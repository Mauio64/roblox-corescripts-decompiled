local module = require("@luauforge/bundled/dAK")

return function(value, p2)
	if p2.type == module.name then
		return p2.signupUsername
	end

	return value or ""
end
