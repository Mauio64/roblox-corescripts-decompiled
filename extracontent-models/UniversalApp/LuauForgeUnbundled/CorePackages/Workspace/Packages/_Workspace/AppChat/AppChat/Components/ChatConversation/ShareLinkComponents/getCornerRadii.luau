local function getCornerRadii(data, p2)
	return {
		topLeft = not data.topLeft and 0 or p2,
		topRight = not data.topRight and 0 or p2,
		bottomLeft = not data.bottomLeft and 0 or p2,
		bottomRight = not data.bottomRight and 0 or p2
	}
end

return getCornerRadii
