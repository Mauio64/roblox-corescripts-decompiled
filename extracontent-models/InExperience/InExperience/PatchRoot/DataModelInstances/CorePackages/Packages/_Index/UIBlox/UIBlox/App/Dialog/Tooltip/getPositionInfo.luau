local TooltipOrientation = require(script.Parent.Enum.TooltipOrientation)

return function(p, p2, updatedOrientation, p3, p4, p5, p6)
	local v = {}

	local v2 = p3 + p4 * 0.5
	local v3 = p3 + p4

	local v4 = 0
	local v5 = 0
	local v6, v7, v8, v9

	if updatedOrientation == TooltipOrientation.Bottom or updatedOrientation == TooltipOrientation.Top then
		if not p6 and p2 + 8 + 12 > p5.Y - v3.Y then
			updatedOrientation = TooltipOrientation.Top
		end

		local v10 = p5.X - 12 - p
		v6 = math.clamp(v2.X - p * 0.5, 12, v10)

		v7 = v6 - p3.X

		local v11 = p - 12 - 16

		if p < 40 then
			v.caretPosition = UDim2.fromScale(0.5, 0)
		elseif p6 then
			local v12 = math.clamp(p4.X * 0.5 + math.abs(p4.X * p6.X.Scale + p6.X.Offset), 12, v11)
			v.caretPosition = UDim2.fromOffset(v12, 0)
		elseif v2.X - p * 0.5 >= 12 and v2.X + p * 0.5 <= p5.X - 12 then
			v.caretPosition = UDim2.fromScale(0.5, 0)
		else
			local v12 = math.clamp(v2.X - v6, 12, v11)
			v.caretPosition = UDim2.fromOffset(v12, 0)
		end

		v.caretFrameSize = UDim2.fromOffset(p, 8)
		v.caretImageSize = UDim2.fromOffset(16, 8)
		v.caretAnchorPoint = Vector2.new(0.5, 0)
		v.fillDirection = Enum.FillDirection.Vertical

		if updatedOrientation == TooltipOrientation.Bottom then
			v8 = p3.Y + p4.Y
			v9 = p4.Y
			v.caretLayoutOrder = 1
			v.contentLayoutOrder = 2
			v5 = 4
		else
			v8 = p3.Y - p2 - 8
			v9 = -(p2 + 8)
			v.caretLayoutOrder = 2
			v.contentLayoutOrder = 1
			v5 = -4
		end
	else
		local v10 = p5.Y - 12 - p2
		v8 = math.clamp(v2.Y - p2 * 0.5, 12, v10)
		v9 = v8 - p3.Y

		local v11 = p2 - 12 - 16

		if p6 then
			local v12 = math.clamp(p4.Y * 0.5 + math.abs(p4.Y * p6.Y.Scale + p6.Y.Offset), 12, v11)
			v.caretPosition = UDim2.fromOffset(0, v12)
		elseif v2.Y - p2 * 0.5 >= 12 and v2.Y + p2 * 0.5 <= p5.Y - 12 or p2 <= 40 then
			v.caretPosition = UDim2.fromScale(0, 0.5)
		else
			local v12 = p2 - 12 - 16
			local v13 = math.clamp(v2.Y - v8, 12, v12)
			v.caretPosition = UDim2.fromOffset(0, v13)
		end

		v.caretFrameSize = UDim2.fromOffset(8, p2)
		v.caretImageSize = UDim2.fromOffset(8, 16)
		v.caretAnchorPoint = Vector2.new(0, 0.5)
		v.fillDirection = Enum.FillDirection.Horizontal

		if updatedOrientation == TooltipOrientation.Right then
			v6 = v3.X
			v7 = p4.X
			v.caretLayoutOrder = 1
			v.contentLayoutOrder = 2
			v4 = 4
		else
			v6 = p3.X - p - 8
			v7 = -(p - 8)
			v.caretLayoutOrder = 2
			v.contentLayoutOrder = 1
			v4 = -4
		end
	end

	v.absolutePosition = UDim2.fromOffset(v6, v8)
	v.position = UDim2.fromOffset(v7, v9)
	v.animatedDistance = UDim2.fromOffset(v4, v5)
	v.updatedOrientation = updatedOrientation
	return v
end
