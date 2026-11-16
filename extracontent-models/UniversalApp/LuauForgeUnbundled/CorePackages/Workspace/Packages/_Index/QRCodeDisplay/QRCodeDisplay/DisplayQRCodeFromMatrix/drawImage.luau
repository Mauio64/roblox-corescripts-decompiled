return function(object, p2, list, data, p3)
	local r = data.R
	local g = data.G
	local b = data.B
	local v5 = 1 - p3

	local buf = buffer.create(p2 * p2 * 4)
	local total = 0

	for i = 1, p2 do
		for j = 1, p2 do
			local v6 = math.floor((j - 1) / p2 * #list) + 1

			if list[math.floor((i - 1) / p2 * #list) + 1][v6] > 0 then
				buffer.writeu8(buf, total, r * 255)
				buffer.writeu8(buf, total + 1, g * 255)
				buffer.writeu8(buf, total + 2, b * 255)
				buffer.writeu8(buf, total + 3, v5 * 255)
			else
				buffer.writeu8(buf, total, 255)
				buffer.writeu8(buf, total + 1, 255)
				buffer.writeu8(buf, total + 2, 255)
				buffer.writeu8(buf, total + 3, 0)
			end

			total += 4
		end
	end

	object:WritePixelsBuffer(Vector2.new(0, 0), Vector2.new(p2, p2), buf)

	return buf
end
