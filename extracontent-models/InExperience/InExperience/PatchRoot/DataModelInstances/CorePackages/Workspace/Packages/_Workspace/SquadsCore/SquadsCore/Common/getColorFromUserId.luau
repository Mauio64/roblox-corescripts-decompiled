local v = {
	Color3.fromRGB(245, 190, 240),
	Color3.fromRGB(192, 206, 251),
	Color3.fromRGB(145, 223, 188),
	Color3.fromRGB(63, 64, 70),
	(Color3.fromRGB(250, 212, 106))
}

return function(p: number)
	return v[p % #v + 1]
end
