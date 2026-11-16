local authPageload = require("@luauforge/bundled/fsz").Events.authPageload

return function(p2, p3, p4, p5, p6)
	authPageload(p3, p4, p5, p6)
end
