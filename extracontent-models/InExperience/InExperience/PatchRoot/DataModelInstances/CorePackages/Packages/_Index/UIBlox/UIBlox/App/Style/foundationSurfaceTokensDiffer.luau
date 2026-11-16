require(script.Parent.StyleTypes)

return function(p, p2): boolean
	if p == nil or p2 == nil then
		return false
	end

	return p.Color.Surface.Surface_0.Color3 ~= p2.Color.Surface.Surface_0.Color3
		or p.Color.Surface.Surface_100.Color3 ~= p2.Color.Surface.Surface_100.Color3
		or p.Color.Surface.Surface_200.Color3 ~= p2.Color.Surface.Surface_200.Color3
		or p.Color.Surface.Surface_300.Color3 ~= p2.Color.Surface.Surface_300.Color3
end
