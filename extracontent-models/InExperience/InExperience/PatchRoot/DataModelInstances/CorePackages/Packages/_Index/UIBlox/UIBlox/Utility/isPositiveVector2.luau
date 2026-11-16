local parent = script.Parent.Parent

local t = require(parent.Parent.t)

return (t.intersection(t.Vector2, function(p)
	if p.X < 0 or p.Y < 0 then
		return false, ("each component of the Vector2 must be >= 0; component values are: %d, %d"):format(p.X, p.Y)
	end

	return true
end))
