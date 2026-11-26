local logger = require("@luauforge/bundled/irI").Logger

return function(p2)
	return logger:new("ReadAloud." .. p2)
end
