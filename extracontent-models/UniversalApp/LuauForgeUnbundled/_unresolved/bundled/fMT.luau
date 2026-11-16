local authClientError = require("@luauforge/bundled/fsz").Events.authClientError

return function(p2, p3, p4, p5, p6)
	if p6 == nil then
		authClientError(p3, p4, p5)
	else
		authClientError(p3, p4, p5, p6)
	end
end
