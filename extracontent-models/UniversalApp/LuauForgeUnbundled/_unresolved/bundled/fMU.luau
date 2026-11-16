local authModalShown = require("@luauforge/bundled/fsz").Events.authModalShown

return function(p2, p3, p4)
	authModalShown(p3, p4)
end
