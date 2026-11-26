local module = require("@luauforge/bundled/egs")

return function(p2, p3)
	return function(p4)
		if p4 == p3 then
			return module.resolve(nil)
		end

		return module.resolve(p2)
	end
end
