local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

return {
	calculateSVFromPosition = function(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2) -- line: 25
		local v7 = math.clamp(vector2.X - vector2_2.X, 0, vector2_3.X)
		local v8 = math.clamp(vector2.Y - vector2_2.Y, 0, vector2_3.Y)

		return v7 / vector2_3.X, 1 - v8 / vector2_3.Y
	end,
	createHSVUpdateHandler = function(p1, p2, p3, p4, p5) -- line: 39
		return function(n1: number, n2: number, n3: number) -- line: 46
			-- upvalues: p5 (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy)
			p5.current = true
			p1(n1)
			p2(n2)
			p3(n3)

			local color3 = Color3.fromHSV(n1, n2, n3)

			p4(color3)
			p5.current = false
		end
	end,
	createColorInputChangeHandler = function(p6, p7, p8, p9, p10) -- line: 60
		return function(color3: Color3) -- line: 67
			-- upvalues: p6 (copy), p7 (copy), p8 (copy), p9 (copy), p10 (copy)
			p6(color3)

			if not p7.current then
				local v24, v25, v26 = color3:ToHSV()

				p8(v24)
				p9(v25)
				p10(v26)
			end
		end
	end,
	isPartialHSV = function(p11) -- line: 17
		if typeof(p11) == "Color3" then
			return false
		end

		return p11.S == nil or p11.V == nil
	end,
	toColor3 = function(p12) -- line: 6
		if typeof(p12) == "Color3" then
			return p12
		end

		return Color3.fromHSV(p12.H / 360, (p12.S or 100) / 100, (p12.V or 100) / 100)
	end
}
