local getSafeAreaSize = require("@luauforge/bundled/fCf").getSafeAreaSize

return function(p2, p3)
	return (math.min(getSafeAreaSize(p2, p3).X.Offset, 640))
end
