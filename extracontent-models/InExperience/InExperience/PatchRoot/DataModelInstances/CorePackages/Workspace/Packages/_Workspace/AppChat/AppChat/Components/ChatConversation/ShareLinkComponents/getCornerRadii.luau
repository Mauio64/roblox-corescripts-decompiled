local function getCornerRadii(data, p: number)
	return {
		topLeft = not data.topLeft and 0 or p,
		topRight = not data.topRight and 0 or p,
		bottomLeft = not data.bottomLeft and 0 or p,
		bottomRight = not data.bottomRight and 0 or p
	}
end

return getCornerRadii
