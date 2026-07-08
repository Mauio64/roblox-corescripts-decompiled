return {
	Color3FromString = function(p1) -- line: 4
		local v2, v3, v4 = unpack(p1:split("/"))

		return (Color3.fromRGB(tonumber(v2), tonumber(v3), (tonumber(v4))))
	end
}
