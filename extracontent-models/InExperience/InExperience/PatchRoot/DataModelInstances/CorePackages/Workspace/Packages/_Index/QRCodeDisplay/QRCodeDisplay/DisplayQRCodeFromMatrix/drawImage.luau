return function(p1, n1: number, t1: {[any]: any}, color3: Color3, n2: number) -- line: 1
	local R = color3.R
	local G = color3.G
	local B = color3.B
	local v9 = 1 - n2
	local buf = buffer.create(n1 * n1 * 4)
	local n3 = 0

	for i = 1, n1 do
		for j = 1, n1 do
			local v14 = math.floor((j - 1) / n1 * #t1) + 1

			if t1[math.floor((i - 1) / n1 * #t1) + 1][v14] > 0 then
				buffer.writeu8(buf, n3, R * 255)
				buffer.writeu8(buf, n3 + 1, G * 255)
				buffer.writeu8(buf, n3 + 2, B * 255)
				buffer.writeu8(buf, n3 + 3, v9 * 255)
			else
				buffer.writeu8(buf, n3, 255)
				buffer.writeu8(buf, n3 + 1, 255)
				buffer.writeu8(buf, n3 + 2, 255)
				buffer.writeu8(buf, n3 + 3, 0)
			end

			n3 += 4
		end
	end

	p1:WritePixelsBuffer(Vector2.new(0, 0), Vector2.new(n1, n1), buf)

	return buf
end
