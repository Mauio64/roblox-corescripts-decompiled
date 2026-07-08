local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local WeakMap = LuauPolyfill.WeakMap
local t1 = {
	memoize1 = function(p1) -- line: 13
		-- upvalues: WeakMap (copy)
		local v8 = WeakMap.new()

		return function(p2) -- line: 18
			-- upvalues: v8 (copy), p1 (copy)
			local v19 = v8:get(p2)

			if v19 == nil then
				local v20 = p1(p2)

				v8:set(p2, v20)

				return v20
			end

			return v19
		end
	end,
	memoize2 = function(p3) -- line: 37
		-- upvalues: WeakMap (copy), Boolean (copy)
		local v10 = WeakMap.new()

		return function(p4, p5) -- line: 42
			-- upvalues: v10 (copy), Boolean (copy), WeakMap (copy), p3 (copy)
			local v23 = v10:get(p4)

			if not Boolean.toJSBoolean(v23) then
				local v24 = WeakMap.new()

				v10:set(p4, v24)

				local v25 = p3(p4, p5)

				v24:set(p5, v25)

				return v25
			end

			local v26 = v23:get(p5)

			if v26 == nil then
				local v27 = p3(p4, p5)

				v23:set(p5, v27)

				return v27
			end

			return v26
		end
	end,
	memoize3 = function(p6) -- line: 72
		-- upvalues: WeakMap (copy), Boolean (copy)
		local v12 = WeakMap.new()

		return function(p7, p8, p9) -- line: 77
			-- upvalues: v12 (copy), Boolean (copy), WeakMap (copy), p6 (copy)
			local v31 = v12:get(p7)

			if not Boolean.toJSBoolean(v31) then
				local v32 = WeakMap.new()

				v12:set(p7, v32)

				local v33 = WeakMap.new()

				v32:set(p8, v33)

				local v34 = p6(p7, p8, p9)

				v33:set(p9, v34)

				return v34
			end

			local v35 = v31:get(p8)

			if not Boolean.toJSBoolean(v35) then
				local v36 = WeakMap.new()

				v31:set(p8, v36)

				local v37 = p6(p7, p8, p9)

				v36:set(p9, v37)

				return v37
			end

			local v38 = v35:get(p9)

			if v38 == nil then
				local v39 = p6(p7, p8, p9)

				v35:set(p9, v39)

				return v39
			end

			return v38
		end
	end,
	memoize4 = function(p10) -- line: 120
		-- upvalues: WeakMap (copy), Boolean (copy)
		local v14 = WeakMap.new()

		return function(p11, p12, p13, p14) -- line: 125
			-- upvalues: v14 (copy), Boolean (copy), WeakMap (copy), p10 (copy)
			local v44 = v14:get(p11)

			if not Boolean.toJSBoolean(v44) then
				local v45 = WeakMap.new()

				v14:set(p11, v45)

				local v46 = WeakMap.new()

				v45:set(p12, v46)

				local v47 = WeakMap.new()

				v46:set(p13, v47)

				local v48 = p10(p11, p12, p13, p14)

				v47:set(p14, v48)

				return v48
			end

			local v49 = v44:get(p12)

			if not Boolean.toJSBoolean(v49) then
				local v50 = WeakMap.new()

				v44:set(p12, v50)

				local v51 = WeakMap.new()

				v50:set(p13, v51)

				local v52 = p10(p11, p12, p13, p14)

				v51:set(p14, v52)

				return v52
			end

			local v53 = v49:get(p13)

			if not Boolean.toJSBoolean(v53) then
				local v54 = WeakMap.new()

				v49:set(p13, v54)

				local v55 = p10(p11, p12, p13, p14)

				v54:set(p14, v55)

				return v55
			end

			local v56 = v53:get(p14)

			if v56 == nil then
				local v57 = p10(p11, p12, p13, p14)

				v53:set(p14, v57)

				return v57
			end

			return v56
		end
	end,
	memoize5 = function(p15) -- line: 186
		-- upvalues: WeakMap (copy), Boolean (copy)
		local v16 = WeakMap.new()

		return function(p16, p17, p18, p19, p20) -- line: 191
			-- upvalues: v16 (copy), Boolean (copy), WeakMap (copy), p15 (copy)
			local v63 = v16:get(p16)

			if not Boolean.toJSBoolean(v63) then
				local v64 = WeakMap.new()

				v16:set(p16, v64)

				local v65 = WeakMap.new()

				v64:set(p17, v65)

				local v66 = WeakMap.new()

				v65:set(p18, v66)

				local v67 = WeakMap.new()

				v66:set(p19, v67)

				local v68 = p15(p16, p17, p18, p19, p20)

				v67:set(p20, v68)

				return v68
			end

			local v69 = v63:get(p17)

			if not Boolean.toJSBoolean(v69) then
				local v70 = WeakMap.new()

				v63:set(p17, v70)

				local v71 = WeakMap.new()

				v70:set(p18, v71)

				local v72 = WeakMap.new()

				v71:set(p19, v72)

				local v73 = p15(p16, p17, p18, p19, p20)

				v72:set(p20, v73)

				return v73
			end

			local v74 = v69:get(p18)

			if not Boolean.toJSBoolean(v74) then
				local v75 = WeakMap.new()

				v69:set(p18, v75)

				local v76 = WeakMap.new()

				v75:set(p19, v76)

				local v77 = p15(p16, p17, p18, p19, p20)

				v76:set(p20, v77)

				return v77
			end

			local v78 = v74:get(p19)

			if not Boolean.toJSBoolean(v78) then
				local v79 = WeakMap.new()

				v74:set(p19, v79)

				local v80 = p15(p16, p17, p18, p19, p20)

				v79:set(p20, v80)

				return v80
			end

			local v81 = v78:get(p20)

			if v81 == nil then
				local v82 = p15(p16, p17, p18, p19, p20)

				v78:set(p20, v82)

				return v82
			end

			return v81
		end
	end
}
local v6 = WeakMap.new()

function t1.memoize2of4(p21) -- line: 267
	-- upvalues: v6 (copy), Boolean (copy), WeakMap (copy)
	return function(p22, p23, p24, p25) -- line: 271
		-- upvalues: v6 (copy), Boolean (copy), WeakMap (copy), p21 (copy)
		local v87 = v6:get(p22)

		if not Boolean.toJSBoolean(v87) then
			local v88 = WeakMap.new()

			v6:set(p22, v88)

			local v89 = p21(p22, p23, p24, p25)

			v88:set(p23, v89)

			return v89
		end

		local v90 = v87:get(p23)

		if v90 == nil then
			local v91 = p21(p22, p23, p24, p25)

			v87:set(p23, v91)

			return v91
		end

		return v90
	end
end

return t1
