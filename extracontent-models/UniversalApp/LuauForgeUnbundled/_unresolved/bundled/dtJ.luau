local getSearchViewportSize = require("@luauforge/bundled/dqK").getSearchViewportSize

return function(p2, p3)
	if p2 and (p3 or p2.viewportSize ~= nil) then
		return p2.viewportSize
	end

	return getSearchViewportSize()
end
