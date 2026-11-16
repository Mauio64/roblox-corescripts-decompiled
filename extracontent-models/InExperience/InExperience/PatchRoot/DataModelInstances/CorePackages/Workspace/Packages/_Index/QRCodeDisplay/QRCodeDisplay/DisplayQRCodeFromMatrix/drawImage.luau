return function(object, p: number, list, color: Color3, p2: number)
	local r = color.R
	local g = color.G
	local b = color.B
	local v = 1 - p2

	local buf = buffer.create(p * p * 4)
	local total = 0

	for i = 1, p do
		for j = 1, p do
			local v2 = math.floor((j - 1) / p * #list) + 1

			if list[math.floor((i - 1) / p * #list) + 1][v2] > 0 then
				buffer.writeu8(buf, total, r * 255)
				buffer.writeu8(buf, total + 1, g * 255)
				buffer.writeu8(buf, total + 2, b * 255)
				buffer.writeu8(buf, total + 3, v * 255)
			else
				buffer.writeu8(buf, total, 255)
				buffer.writeu8(buf, total + 1, 255)
				buffer.writeu8(buf, total + 2, 255)
				buffer.writeu8(buf, total + 3, 0)
			end

			total += 4
		end
	end

	object:WritePixelsBuffer(Vector2.new(0, 0), Vector2.new(p, p), buf)

	return buf
end
