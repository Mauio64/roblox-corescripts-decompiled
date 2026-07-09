local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local Style = require(ParentParent.Style)

return function(p1, p2) -- line: 7
	-- upvalues: Roact (copy), Style (copy)
	local v6 = p2 or {}

	return Roact.createElement(Style.DesignTokenProvider, {
		tokenMappers = v6
	}, {
		Element = p1
	})
end
