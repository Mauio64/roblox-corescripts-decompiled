local module = require("@luauforge/bundled/dBL")
local module2 = require("@luauforge/bundled/dBR")
require("@luauforge/bundled/dBl")
local module3 = require("@luauforge/bundled/dBK")

return module.createReducer({}, {
	[module3.name] = function(p2, p3)
		return module2.Dictionary.join(p2, { [p3.universeId] = p3.communityLink })
	end
})
