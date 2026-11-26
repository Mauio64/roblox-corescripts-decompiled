local authModalShown = require("@luauforge/bundled/fzT").Events.authModalShown

return function(p2, p3, p4)
	authModalShown(p3, p4)
end
