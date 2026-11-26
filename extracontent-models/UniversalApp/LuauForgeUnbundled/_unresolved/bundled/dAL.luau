local module = require("@luauforge/bundled/dAM")

return function(value, p2)
	if p2.type == module.name then
		return p2.signupPassword
	end

	return value or ""
end
