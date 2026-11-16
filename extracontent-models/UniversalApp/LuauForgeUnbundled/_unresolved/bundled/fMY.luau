local authFormInteraction = require("@luauforge/bundled/fsz").Events.authFormInteraction

return function(p2, p3, p4, p5, p6, p7)
	authFormInteraction(p3, p4, p5, p6, p7)
end
