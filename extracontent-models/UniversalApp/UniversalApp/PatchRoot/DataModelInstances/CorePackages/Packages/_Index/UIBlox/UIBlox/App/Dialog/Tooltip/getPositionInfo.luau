local TooltipOrientation = require(script.Parent.Enum.TooltipOrientation)

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 22
	-- upvalues: TooltipOrientation (copy)
	local t1 = {}
	local v10 = p4 + p5 * 0.5
	local v11 = p4 + p5
	local n1 = 0
	local n2 = 0
	local v15, v16, v20, p5Y

	if p3 == TooltipOrientation.Bottom or p3 == TooltipOrientation.Top then
		if not p7 and p2 + 8 + 12 > p6.Y - v11.Y then
			p3 = TooltipOrientation.Top
		end

		local v14 = p6.X - 12 - p1

		v15 = math.clamp(v10.X - p1 * 0.5, 12, v14)
		v16 = v15 - p4.X

		local v17 = p1 - 12 - 16

		if p1 < 40 then
			t1.caretPosition = UDim2.fromScale(0.5, 0)
		elseif p7 then
			local v18 = math.clamp(p5.X * 0.5 + math.abs(p5.X * p7.X.Scale + p7.X.Offset), 12, v17)

			t1.caretPosition = UDim2.fromOffset(v18, 0)
		elseif v10.X - p1 * 0.5 >= 12 and v10.X + p1 * 0.5 <= p6.X - 12 then
			t1.caretPosition = UDim2.fromScale(0.5, 0)
		else
			local v19 = math.clamp(v10.X - v15, 12, v17)

			t1.caretPosition = UDim2.fromOffset(v19, 0)
		end

		t1.caretFrameSize = UDim2.fromOffset(p1, 8)
		t1.caretImageSize = UDim2.fromOffset(16, 8)
		t1.caretAnchorPoint = Vector2.new(0.5, 0)
		t1.fillDirection = Enum.FillDirection.Vertical

		if p3 == TooltipOrientation.Bottom then
			v20 = p4.Y + p5.Y
			p5Y = p5.Y
			t1.caretLayoutOrder = 1
			t1.contentLayoutOrder = 2
			n2 = 4
		else
			v20 = p4.Y - p2 - 8
			p5Y = -(p2 + 8)
			t1.caretLayoutOrder = 2
			t1.contentLayoutOrder = 1
			n2 = -4
		end
	else
		local v22 = p6.Y - 12 - p2

		v20 = math.clamp(v10.Y - p2 * 0.5, 12, v22)
		p5Y = v20 - p4.Y

		local v23 = p2 - 12 - 16

		if p7 then
			local v24 = math.clamp(p5.Y * 0.5 + math.abs(p5.Y * p7.Y.Scale + p7.Y.Offset), 12, v23)

			t1.caretPosition = UDim2.fromOffset(0, v24)
		elseif v10.Y - p2 * 0.5 >= 12 and v10.Y + p2 * 0.5 <= p6.Y - 12 or p2 <= 40 then
			t1.caretPosition = UDim2.fromScale(0, 0.5)
		else
			local v25 = p2 - 12 - 16
			local v26 = math.clamp(v10.Y - v20, 12, v25)

			t1.caretPosition = UDim2.fromOffset(0, v26)
		end

		t1.caretFrameSize = UDim2.fromOffset(8, p2)
		t1.caretImageSize = UDim2.fromOffset(8, 16)
		t1.caretAnchorPoint = Vector2.new(0, 0.5)
		t1.fillDirection = Enum.FillDirection.Horizontal

		if p3 == TooltipOrientation.Right then
			v15 = v11.X
			v16 = p5.X
			t1.caretLayoutOrder = 1
			t1.contentLayoutOrder = 2
			n1 = 4
		else
			v15 = p4.X - p1 - 8
			v16 = -(p1 - 8)
			t1.caretLayoutOrder = 2
			t1.contentLayoutOrder = 1
			n1 = -4
		end
	end

	t1.absolutePosition = UDim2.fromOffset(v15, v20)
	t1.position = UDim2.fromOffset(v16, p5Y)
	t1.animatedDistance = UDim2.fromOffset(n1, n2)
	t1.updatedOrientation = p3

	return t1
end
