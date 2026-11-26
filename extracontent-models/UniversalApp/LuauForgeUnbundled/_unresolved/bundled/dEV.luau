local module = require("@luauforge/bundled/dEQ")
local module2 = require("@luauforge/bundled/dEW")
require("@luauforge/bundled/dEq")
local module3 = require("@luauforge/bundled/dEP")

return module.createReducer({}, {
	[module3.name] = function(p2, p3)
		return module2.Dictionary.join(p2, { [p3.universeId] = p3.communityLink })
	end
})
