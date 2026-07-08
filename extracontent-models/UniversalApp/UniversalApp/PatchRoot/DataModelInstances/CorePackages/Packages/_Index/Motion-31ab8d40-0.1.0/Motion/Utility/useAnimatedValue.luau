local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local React = require(scriptParentParentParent.React)
local ReactOtter = require(scriptParentParentParent.ReactOtter)
local v6 = require(scriptParent.TimingConfigs).presets[require(scriptParentParent.Enums.TransitionPreset).Default]

require(scriptParentParent.Types)

local function validateNumber(p1, n1: number?) -- line: 54
	if type(p1) == "number" then
		return p1
	end

	return n1 or 0
end
local function useAnimatedValue(p2) -- line: 63
	-- upvalues: React (copy), ReactOtter (copy), v6 (copy)
	local v12 = React.useRef(nil)
	local v13 = React.useCallback(function(...) -- line: 66
		-- upvalues: v12 (copy)
		if v12.current ~= nil then
			if type(v12.current) == "function" then
				v12.current(...)

				return
			end

			if v12.current._isMockFunction then
				v12.current(...)
			end
		end
	end, { v12 })

	if typeof(p2) == "table" and (p2.Color3 and p2.Transparency) then
		local useAnimatedBinding = ReactOtter.useAnimatedBinding
		local t1 = {}
		local R = p2.Color3.R

		t1.r = type(R) ~= "number" and 0 or R

		local G = p2.Color3.G

		t1.g = type(G) ~= "number" and 0 or G

		local B = p2.Color3.B

		t1.b = type(B) ~= "number" and 0 or B

		local p2Transparency = p2.Transparency

		t1.Transparency = type(p2Transparency) ~= "number" and 0 or p2Transparency

		local v20, v21 = useAnimatedBinding(t1, v13)

		return v20:map(function(t2: {[any]: any}) -- line: 85
			return {
				Color3 = Color3.new(t2.r, t2.g, t2.b),
				Transparency = t2.Transparency
			}
		end), function(p3, p4) -- line: 92
			-- upvalues: v12 (copy), v6 (copy), v21 (copy), ReactOtter (copy)
			if typeof(p3) ~= "table" or (not p3.Color3 or p3.Transparency == nil) then
				warn("Expected target to be a table with Color3 and Transparency fields")

				return
			end

			v12.current = p4 and p4.onComplete or nil

			local v54 = if not p4 then nil else {
				duration = p4.duration or v6.duration,
				easingStyle = p4.easingStyle
			}
			local v55 = v21
			local t3 = {}
			local ease = ReactOtter.ease
			local R2 = p3.Color3.R

			t3.r = ease(type(R2) ~= "number" and 0 or R2, v54)

			local ease2 = ReactOtter.ease
			local G2 = p3.Color3.G

			t3.g = ease2(type(G2) ~= "number" and 0 or G2, v54)

			local ease3 = ReactOtter.ease
			local B2 = p3.Color3.B

			t3.b = ease3(type(B2) ~= "number" and 0 or B2, v54)

			local ease4 = ReactOtter.ease
			local p3Transparency = p3.Transparency

			t3.Transparency = ease4(type(p3Transparency) ~= "number" and 0 or p3Transparency, v54)
			v55(t3)
		end
	end

	if typeof(p2) == "UDim" then
		local useAnimatedBinding = ReactOtter.useAnimatedBinding
		local t4 = {}
		local p2Scale = p2.Scale

		t4.scale = type(p2Scale) ~= "number" and 0 or p2Scale

		local p2Offset = p2.Offset

		t4.offset = type(p2Offset) ~= "number" and 0 or p2Offset

		local v26, v27 = useAnimatedBinding(t4, v13)

		return v26:map(function(t5: {[any]: any}) -- line: 125
			return UDim.new(t5.scale, t5.offset)
		end), function(p5, p6) -- line: 129
			-- upvalues: v12 (copy), v6 (copy), v27 (copy), ReactOtter (copy)
			if not p5 then
				return
			end

			if typeof(p5) ~= "UDim" then
				warn("Expected UDim target but got", (typeof(p5)))

				return
			end

			v12.current = p6 and p6.onComplete or nil

			local v68 = if not p6 then nil else {
				duration = p6.duration or v6.duration,
				easingStyle = p6.easingStyle
			}
			local v69 = v27
			local t6 = {}
			local ease = ReactOtter.ease
			local p5Scale = p5.Scale

			t6.scale = ease(type(p5Scale) ~= "number" and 0 or p5Scale, v68)

			local ease5 = ReactOtter.ease
			local p5Offset = p5.Offset

			t6.offset = ease5(type(p5Offset) ~= "number" and 0 or p5Offset, v68)
			v69(t6)
		end
	end

	if typeof(p2) == "UDim2" then
		local useAnimatedBinding = ReactOtter.useAnimatedBinding
		local t7 = {}
		local XScale = p2.X.Scale

		t7.xScale = type(XScale) ~= "number" and 0 or XScale

		local XOffset = p2.X.Offset

		t7.xOffset = type(XOffset) ~= "number" and 0 or XOffset

		local YScale = p2.Y.Scale

		t7.yScale = type(YScale) ~= "number" and 0 or YScale

		local YOffset = p2.Y.Offset

		t7.yOffset = type(YOffset) ~= "number" and 0 or YOffset

		local v34, v35 = useAnimatedBinding(t7, v13)

		return v34:map(function(t8: {[any]: any}) -- line: 166
			return UDim2.new(t8.xScale, t8.xOffset, t8.yScale, t8.yOffset)
		end), function(p7, p8) -- line: 170
			-- upvalues: v12 (copy), v6 (copy), v35 (copy), ReactOtter (copy)
			if not p7 then
				return
			end

			if typeof(p7) ~= "UDim2" then
				warn("Expected UDim2 target but got", (typeof(p7)))

				return
			end

			v12.current = p8 and p8.onComplete or nil

			local v78 = if not p8 then nil else {
				duration = p8.duration or v6.duration,
				easingStyle = p8.easingStyle
			}
			local v79 = v35
			local t9 = {}
			local ease = ReactOtter.ease
			local XScale2 = p7.X.Scale

			t9.xScale = ease(type(XScale2) ~= "number" and 0 or XScale2, v78)

			local ease6 = ReactOtter.ease
			local XOffset2 = p7.X.Offset

			t9.xOffset = ease6(type(XOffset2) ~= "number" and 0 or XOffset2, v78)

			local ease7 = ReactOtter.ease
			local YScale2 = p7.Y.Scale

			t9.yScale = ease7(type(YScale2) ~= "number" and 0 or YScale2, v78)

			local ease8 = ReactOtter.ease
			local YOffset2 = p7.Y.Offset

			t9.yOffset = ease8(type(YOffset2) ~= "number" and 0 or YOffset2, v78)
			v79(t9)
		end
	end

	if typeof(p2) == "Vector2" then
		local useAnimatedBinding = ReactOtter.useAnimatedBinding
		local t10 = {}
		local p2X = p2.X

		t10.x = type(p2X) ~= "number" and 0 or p2X

		local p2Y = p2.Y

		t10.y = type(p2Y) ~= "number" and 0 or p2Y

		local v40, v41 = useAnimatedBinding(t10, v13)

		return v40:map(function(t11: {[any]: any}) -- line: 205
			return Vector2.new(t11.x, t11.y)
		end), function(p9, p10) -- line: 209
			-- upvalues: v12 (copy), v6 (copy), v41 (copy), ReactOtter (copy)
			if not p9 then
				return
			end

			if typeof(p9) ~= "Vector2" then
				warn("Expected Vector2 target but got", (typeof(p9)))

				return
			end

			v12.current = p10 and p10.onComplete or nil

			local v92 = if not p10 then nil else {
				duration = p10.duration or v6.duration,
				easingStyle = p10.easingStyle
			}
			local v93 = v41
			local t12 = {}
			local ease = ReactOtter.ease
			local p9X = p9.X

			t12.x = ease(type(p9X) ~= "number" and 0 or p9X, v92)

			local ease9 = ReactOtter.ease
			local p9Y = p9.Y

			t12.y = ease9(type(p9Y) ~= "number" and 0 or p9Y, v92)
			v93(t12)
		end
	end

	if typeof(p2) == "Color3" then
		local useAnimatedBinding = ReactOtter.useAnimatedBinding
		local t13 = {}
		local R = p2.R

		t13.r = type(R) ~= "number" and 0 or R

		local G = p2.G

		t13.g = type(G) ~= "number" and 0 or G

		local B = p2.B

		t13.b = type(B) ~= "number" and 0 or B

		local v47, v48 = useAnimatedBinding(t13, v13)

		return v47:map(function(t14: {[any]: any}) -- line: 244
			return Color3.new(t14.r, t14.g, t14.b)
		end), function(p11, p12) -- line: 248
			-- upvalues: v12 (copy), v6 (copy), v48 (copy), ReactOtter (copy)
			if not p11 then
				return
			end

			if typeof(p11) ~= "Color3" then
				warn("Expected Color3 target but got", (typeof(p11)))

				return
			end

			v12.current = p12 and p12.onComplete or nil

			local v102 = if not p12 then nil else {
				duration = p12.duration or v6.duration,
				easingStyle = p12.easingStyle
			}
			local v103 = v48
			local t15 = {}
			local ease = ReactOtter.ease
			local R3 = p11.R

			t15.r = ease(type(R3) ~= "number" and 0 or R3, v102)

			local ease10 = ReactOtter.ease
			local G3 = p11.G

			t15.g = ease10(type(G3) ~= "number" and 0 or G3, v102)

			local ease11 = ReactOtter.ease
			local B3 = p11.B

			t15.b = ease11(type(B3) ~= "number" and 0 or B3, v102)
			v103(t15)
		end
	end

	if typeof(p2) == "number" then
		local v49, v50 = ReactOtter.useAnimatedBinding(type(p2) ~= "number" and 0 or p2, v13)

		return v49:map(function(n2: number) -- line: 280
			return n2
		end), function(p13, p14) -- line: 284
			-- upvalues: v12 (copy), v6 (copy), v50 (copy), ReactOtter (copy)
			if typeof(p13) ~= "number" then
				return
			end

			v12.current = p14 and p14.onComplete or nil

			local v114 = if not p14 then nil else {
				duration = p14.duration or v6.duration,
				easingStyle = p14.easingStyle
			}

			v50(ReactOtter.ease(p13, v114))
		end
	end

	warn("Unsupported type for animated value:", (typeof(p2)))

	return React.createBinding(p2), function() -- line: 304
	end
end

return useAnimatedValue
