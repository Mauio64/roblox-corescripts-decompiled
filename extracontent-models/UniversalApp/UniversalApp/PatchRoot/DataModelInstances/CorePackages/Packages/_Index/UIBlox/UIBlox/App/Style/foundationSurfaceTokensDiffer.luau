require(script.Parent.StyleTypes)

return function(p1, p2) -- line: 5
	if p1 == nil or p2 == nil then
		return false
	end

	return p1.Color.Surface.Surface_0.Color3 ~= p2.Color.Surface.Surface_0.Color3 or (p1.Color.Surface.Surface_100.Color3 ~= p2.Color.Surface.Surface_100.Color3 or (p1.Color.Surface.Surface_200.Color3 ~= p2.Color.Surface.Surface_200.Color3 or p1.Color.Surface.Surface_300.Color3 ~= p2.Color.Surface.Surface_300.Color3))
end
