local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local ReactOtter = require(ParentParentParent.ReactOtter)

require(ParentParent.Types)

local function validateNumber(p1, n1: number?) -- line: 40
	if type(p1) == "number" then
		return p1
	end

	return n1 or 0
end
local function useAnimatedValue(p2) -- line: 49
	-- upvalues: React (copy), ReactOtter (copy)
	local v10 = React.useRef(nil)
	local v11 = React.useCallback(function(...) -- line: 52
		-- upvalues: v10 (copy)
		if v10.current ~= nil then
			if type(v10.current) == "function" then
				v10.current(...)

				return
			end

			if v10.current._isMockFunction then
				v10.current(...)
			end
		end
	end, { v10 })

	if typeof(p2) == "UDim" then
		local useAnimatedBinding = ReactOtter.useAnimatedBinding
		local t1 = {}
		local p2Scale = p2.Scale

		t1.scale = type(p2Scale) ~= "number" and 0 or p2Scale

		local p2Offset = p2.Offset

		t1.offset = type(p2Offset) ~= "number" and 0 or p2Offset

		local v16, v17 = useAnimatedBinding(t1, v11)

		return v16:map(function(t2: {[any]: any}) -- line: 69
			return UDim.new(t2.scale, t2.offset)
		end), function(p3, p4) -- line: 73
			-- upvalues: v10 (copy), v17 (copy), ReactOtter (copy)
			if not p3 then
				return
			end

			if typeof(p3) ~= "UDim" then
				warn("Expected UDim target but got", (typeof(p3)))

				return
			end

			v10.current = p4 and p4.onComplete or nil

			local v44 = if not p4 then nil else {
				duration = p4.duration or 0.3,
				easingStyle = p4.easingStyle
			}
			local v45 = v17
			local t3 = {}
			local ease = ReactOtter.ease
			local p3Scale = p3.Scale

			t3.scale = ease(type(p3Scale) ~= "number" and 0 or p3Scale, v44)

			local ease2 = ReactOtter.ease
			local p3Offset = p3.Offset

			t3.offset = ease2(type(p3Offset) ~= "number" and 0 or p3Offset, v44)
			v45(t3)
		end
	end

	if typeof(p2) == "UDim2" then
		local useAnimatedBinding = ReactOtter.useAnimatedBinding
		local t4 = {}
		local XScale = p2.X.Scale

		t4.xScale = type(XScale) ~= "number" and 0 or XScale

		local XOffset = p2.X.Offset

		t4.xOffset = type(XOffset) ~= "number" and 0 or XOffset

		local YScale = p2.Y.Scale

		t4.yScale = type(YScale) ~= "number" and 0 or YScale

		local YOffset = p2.Y.Offset

		t4.yOffset = type(YOffset) ~= "number" and 0 or YOffset

		local v24, v25 = useAnimatedBinding(t4, v11)

		return v24:map(function(t5: {[any]: any}) -- line: 110
			return UDim2.new(t5.xScale, t5.xOffset, t5.yScale, t5.yOffset)
		end), function(p5, p6) -- line: 114
			-- upvalues: v10 (copy), v25 (copy), ReactOtter (copy)
			if not p5 then
				return
			end

			if typeof(p5) ~= "UDim2" then
				warn("Expected UDim2 target but got", (typeof(p5)))

				return
			end

			v10.current = p6 and p6.onComplete or nil

			local v54 = if not p6 then nil else {
				duration = p6.duration or 0.3,
				easingStyle = p6.easingStyle
			}
			local v55 = v25
			local t6 = {}
			local ease = ReactOtter.ease
			local XScale2 = p5.X.Scale

			t6.xScale = ease(type(XScale2) ~= "number" and 0 or XScale2, v54)

			local ease3 = ReactOtter.ease
			local XOffset2 = p5.X.Offset

			t6.xOffset = ease3(type(XOffset2) ~= "number" and 0 or XOffset2, v54)

			local ease4 = ReactOtter.ease
			local YScale2 = p5.Y.Scale

			t6.yScale = ease4(type(YScale2) ~= "number" and 0 or YScale2, v54)

			local ease5 = ReactOtter.ease
			local YOffset2 = p5.Y.Offset

			t6.yOffset = ease5(type(YOffset2) ~= "number" and 0 or YOffset2, v54)
			v55(t6)
		end
	end

	if typeof(p2) == "Vector2" then
		local useAnimatedBinding = ReactOtter.useAnimatedBinding
		local t7 = {}
		local p2X = p2.X

		t7.x = type(p2X) ~= "number" and 0 or p2X

		local p2Y = p2.Y

		t7.y = type(p2Y) ~= "number" and 0 or p2Y

		local v30, v31 = useAnimatedBinding(t7, v11)

		return v30:map(function(t8: {[any]: any}) -- line: 149
			return Vector2.new(t8.x, t8.y)
		end), function(p7, p8) -- line: 153
			-- upvalues: v10 (copy), v31 (copy), ReactOtter (copy)
			if not p7 then
				return
			end

			if typeof(p7) ~= "Vector2" then
				warn("Expected Vector2 target but got", (typeof(p7)))

				return
			end

			v10.current = p8 and p8.onComplete or nil

			local v68 = if not p8 then nil else {
				duration = p8.duration or 0.3,
				easingStyle = p8.easingStyle
			}
			local v69 = v31
			local t9 = {}
			local ease = ReactOtter.ease
			local p7X = p7.X

			t9.x = ease(type(p7X) ~= "number" and 0 or p7X, v68)

			local ease6 = ReactOtter.ease
			local p7Y = p7.Y

			t9.y = ease6(type(p7Y) ~= "number" and 0 or p7Y, v68)
			v69(t9)
		end
	end

	if typeof(p2) == "Color3" then
		local useAnimatedBinding = ReactOtter.useAnimatedBinding
		local t10 = {}
		local R = p2.R

		t10.r = type(R) ~= "number" and 0 or R

		local G = p2.G

		t10.g = type(G) ~= "number" and 0 or G

		local B = p2.B

		t10.b = type(B) ~= "number" and 0 or B

		local v37, v38 = useAnimatedBinding(t10, v11)

		return v37:map(function(t11: {[any]: any}) -- line: 188
			return Color3.new(t11.r, t11.g, t11.b)
		end), function(p9, p10) -- line: 192
			-- upvalues: v10 (copy), v38 (copy), ReactOtter (copy)
			if not p9 then
				return
			end

			if typeof(p9) ~= "Color3" then
				warn("Expected Color3 target but got", (typeof(p9)))

				return
			end

			v10.current = p10 and p10.onComplete or nil

			local v78 = if not p10 then nil else {
				duration = p10.duration or 0.3,
				easingStyle = p10.easingStyle
			}
			local v79 = v38
			local t12 = {}
			local ease = ReactOtter.ease
			local R2 = p9.R

			t12.r = ease(type(R2) ~= "number" and 0 or R2, v78)

			local ease7 = ReactOtter.ease
			local G2 = p9.G

			t12.g = ease7(type(G2) ~= "number" and 0 or G2, v78)

			local ease8 = ReactOtter.ease
			local B2 = p9.B

			t12.b = ease8(type(B2) ~= "number" and 0 or B2, v78)
			v79(t12)
		end
	end

	if typeof(p2) == "number" then
		local v39, v40 = ReactOtter.useAnimatedBinding(type(p2) ~= "number" and 0 or p2, v11)

		return v39:map(function(n2: number) -- line: 224
			return n2
		end), function(p11, p12) -- line: 228
			-- upvalues: v10 (copy), v40 (copy), ReactOtter (copy)
			if typeof(p11) ~= "number" then
				return
			end

			v10.current = p12 and p12.onComplete or nil

			local v90 = if not p12 then nil else {
				duration = p12.duration or 0.3,
				easingStyle = p12.easingStyle
			}

			v40(ReactOtter.ease(p11, v90))
		end
	end

	warn("Unsupported type for animated value:", (typeof(p2)))

	return React.createBinding(p2), function() -- line: 248
	end
end

return useAnimatedValue
