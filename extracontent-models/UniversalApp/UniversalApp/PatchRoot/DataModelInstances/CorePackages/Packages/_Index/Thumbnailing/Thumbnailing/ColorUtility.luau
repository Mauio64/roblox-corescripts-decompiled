return {
	Color3FromString = function(value)
		local v, v2, v3 = unpack(value:split("/"))
		return (Color3.fromRGB(tonumber(v), tonumber(v2), (tonumber(v3))))
	end
}
