local Foundation = script:FindFirstAncestor("Foundation")
require(Foundation.Components.Types)
local ColorUtils = {}

function ColorUtils.calculateSVFromPosition(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2)
	local v = math.clamp(vector2.X - vector2_2.X, 0, vector2_3.X)
	local v2 = math.clamp(vector2.Y - vector2_2.Y, 0, vector2_3.Y)

	return v / vector2_3.X, 1 - v2 / vector2_3.Y
end

function ColorUtils.createHSVUpdateHandler(callback, callback2, callback3, callback4, p)
	return function(p2: number, p3: number, p4: number)
		p.current = true
		callback(p2)
		callback2(p3)
		callback3(p4)

		callback4((Color3.fromHSV(p2, p3, p4)))

		p.current = false
	end
end

function ColorUtils.createColorInputChangeHandler(callback, p, callback2, callback3, callback4)
	return function(color: Color3)
		callback(color)

		if not p.current then
			local hsv, v, v2 = color:ToHSV()
			callback2(hsv)
			callback3(v)
			callback4(v2)
		end
	end
end

function ColorUtils.isPartialHSV(p): boolean
	return typeof(p) ~= "Color3" and (p.S == nil or p.V == nil)
end

function ColorUtils.toColor3(data)
	if typeof(data) == "Color3" then
		return data
	end

	return Color3.fromHSV(data.H / 360, (data.S or 100) / 100, (data.V or 100) / 100)
end

return ColorUtils
