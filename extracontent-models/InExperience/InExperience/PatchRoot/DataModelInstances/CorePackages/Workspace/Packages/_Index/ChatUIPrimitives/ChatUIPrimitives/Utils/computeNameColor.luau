local v = {
	Color3.new(253 / 255, 41 / 255, 67 / 255),
	Color3.new(1 / 255, 162 / 255, 1),
	Color3.new(2 / 255, 184 / 255, 87 / 255),
	BrickColor.new("Alder").Color,
	BrickColor.new("Bright orange").Color,
	BrickColor.new("Bright yellow").Color,
	BrickColor.new("Light reddish violet").Color,
	BrickColor.new("Brick yellow").Color
}

local function HashNameToColor(value: string)
	local total = 0

	for i = 1, #value do
		local v2 = string.byte((string.sub(value, i, i)))
		local v3 = #value - i + 1

		if #value % 2 == 1 then
			v3 -= 1
		end

		if v3 % 4 >= 2 then
			v2 = -v2
		end

		total += v2
	end

	return total
end

local function computeNameColor(p: string)
	return v[(HashNameToColor(p) + 0) % #v + 1]
end

return computeNameColor
