local v1 = typeof or type

local function primitive(p1) -- line: 6
	-- upvalues: v1 (copy)
	return function(p2) -- line: 7
		-- upvalues: v1 (copy), p1 (copy)
		local v176 = v1(p2)

		if v176 == p1 then
			return true
		end

		return false, string.format("%s expected, got %s", p1, v176)
	end
end

local t1 = {
	any = function(p3) -- line: 26
		if p3 ~= nil then
			return true
		end

		return false, "any expected, got nil"
	end
}
local s1 = "boolean"

function t1.boolean(p4) -- line: 7
	-- upvalues: v1 (copy), s1 (copy)
	local v48 = v1(p4)

	if v48 == s1 then
		return true
	end

	return false, string.format("%s expected, got %s", s1, v48)
end

local s2 = "thread"

function t1.thread(p5) -- line: 7
	-- upvalues: v1 (copy), s2 (copy)
	local v50 = v1(p5)

	if v50 == s2 then
		return true
	end

	return false, string.format("%s expected, got %s", s2, v50)
end

local s3 = "function"

function t1.callback(p6) -- line: 7
	-- upvalues: v1 (copy), s3 (copy)
	local v52 = v1(p6)

	if v52 == s3 then
		return true
	end

	return false, string.format("%s expected, got %s", s3, v52)
end

local s4 = "nil"

function t1.none(p7) -- line: 7
	-- upvalues: v1 (copy), s4 (copy)
	local v54 = v1(p7)

	if v54 == s4 then
		return true
	end

	return false, string.format("%s expected, got %s", s4, v54)
end

local s5 = "string"

function t1.string(p8) -- line: 7
	-- upvalues: v1 (copy), s5 (copy)
	local v56 = v1(p8)

	if v56 == s5 then
		return true
	end

	return false, string.format("%s expected, got %s", s5, v56)
end

local s6 = "table"

function t1.table(p9) -- line: 7
	-- upvalues: v1 (copy), s6 (copy)
	local v58 = v1(p9)

	if v58 == s6 then
		return true
	end

	return false, string.format("%s expected, got %s", s6, v58)
end

local s7 = "userdata"

function t1.userdata(p10) -- line: 7
	-- upvalues: v1 (copy), s7 (copy)
	local v60 = v1(p10)

	if v60 == s7 then
		return true
	end

	return false, string.format("%s expected, got %s", s7, v60)
end
function t1.number(p11) -- line: 106
	-- upvalues: v1 (copy)
	local v62 = v1(p11)

	if v62 == "number" then
		if p11 == p11 then
			return true
		end

		return false, "unexpected NaN value"
	end

	return false, string.format("number expected, got %s", v62)
end
function t1.nan(p12) -- line: 126
	if p12 ~= p12 then
		return true
	end

	return false, "unexpected non-NaN value"
end

local s8 = "Axes"

function t1.Axes(p13) -- line: 7
	-- upvalues: v1 (copy), s8 (copy)
	local v65 = v1(p13)

	if v65 == s8 then
		return true
	end

	return false, string.format("%s expected, got %s", s8, v65)
end

local s9 = "BrickColor"

function t1.BrickColor(p14) -- line: 7
	-- upvalues: v1 (copy), s9 (copy)
	local v67 = v1(p14)

	if v67 == s9 then
		return true
	end

	return false, string.format("%s expected, got %s", s9, v67)
end

local s10 = "CFrame"

function t1.CFrame(p15) -- line: 7
	-- upvalues: v1 (copy), s10 (copy)
	local v69 = v1(p15)

	if v69 == s10 then
		return true
	end

	return false, string.format("%s expected, got %s", s10, v69)
end

local s11 = "Color3"

function t1.Color3(p16) -- line: 7
	-- upvalues: v1 (copy), s11 (copy)
	local v71 = v1(p16)

	if v71 == s11 then
		return true
	end

	return false, string.format("%s expected, got %s", s11, v71)
end

local s12 = "ColorSequence"

function t1.ColorSequence(p17) -- line: 7
	-- upvalues: v1 (copy), s12 (copy)
	local v73 = v1(p17)

	if v73 == s12 then
		return true
	end

	return false, string.format("%s expected, got %s", s12, v73)
end

local s13 = "ColorSequenceKeypoint"

function t1.ColorSequenceKeypoint(p18) -- line: 7
	-- upvalues: v1 (copy), s13 (copy)
	local v75 = v1(p18)

	if v75 == s13 then
		return true
	end

	return false, string.format("%s expected, got %s", s13, v75)
end

local s14 = "DockWidgetPluginGuiInfo"

function t1.DockWidgetPluginGuiInfo(p19) -- line: 7
	-- upvalues: v1 (copy), s14 (copy)
	local v77 = v1(p19)

	if v77 == s14 then
		return true
	end

	return false, string.format("%s expected, got %s", s14, v77)
end

local s15 = "Faces"

function t1.Faces(p20) -- line: 7
	-- upvalues: v1 (copy), s15 (copy)
	local v79 = v1(p20)

	if v79 == s15 then
		return true
	end

	return false, string.format("%s expected, got %s", s15, v79)
end

local s16 = "Instance"

function t1.Instance(p21) -- line: 7
	-- upvalues: v1 (copy), s16 (copy)
	local v81 = v1(p21)

	if v81 == s16 then
		return true
	end

	return false, string.format("%s expected, got %s", s16, v81)
end

local s17 = "NumberRange"

function t1.NumberRange(p22) -- line: 7
	-- upvalues: v1 (copy), s17 (copy)
	local v83 = v1(p22)

	if v83 == s17 then
		return true
	end

	return false, string.format("%s expected, got %s", s17, v83)
end

local s18 = "NumberSequence"

function t1.NumberSequence(p23) -- line: 7
	-- upvalues: v1 (copy), s18 (copy)
	local v85 = v1(p23)

	if v85 == s18 then
		return true
	end

	return false, string.format("%s expected, got %s", s18, v85)
end

local s19 = "NumberSequenceKeypoint"

function t1.NumberSequenceKeypoint(p24) -- line: 7
	-- upvalues: v1 (copy), s19 (copy)
	local v87 = v1(p24)

	if v87 == s19 then
		return true
	end

	return false, string.format("%s expected, got %s", s19, v87)
end

local s20 = "PathWaypoint"

function t1.PathWaypoint(p25) -- line: 7
	-- upvalues: v1 (copy), s20 (copy)
	local v89 = v1(p25)

	if v89 == s20 then
		return true
	end

	return false, string.format("%s expected, got %s", s20, v89)
end

local s21 = "PhysicalProperties"

function t1.PhysicalProperties(p26) -- line: 7
	-- upvalues: v1 (copy), s21 (copy)
	local v91 = v1(p26)

	if v91 == s21 then
		return true
	end

	return false, string.format("%s expected, got %s", s21, v91)
end

local s22 = "Random"

function t1.Random(p27) -- line: 7
	-- upvalues: v1 (copy), s22 (copy)
	local v93 = v1(p27)

	if v93 == s22 then
		return true
	end

	return false, string.format("%s expected, got %s", s22, v93)
end

local s23 = "Ray"

function t1.Ray(p28) -- line: 7
	-- upvalues: v1 (copy), s23 (copy)
	local v95 = v1(p28)

	if v95 == s23 then
		return true
	end

	return false, string.format("%s expected, got %s", s23, v95)
end

local s24 = "Rect"

function t1.Rect(p29) -- line: 7
	-- upvalues: v1 (copy), s24 (copy)
	local v97 = v1(p29)

	if v97 == s24 then
		return true
	end

	return false, string.format("%s expected, got %s", s24, v97)
end

local s25 = "Region3"

function t1.Region3(p30) -- line: 7
	-- upvalues: v1 (copy), s25 (copy)
	local v99 = v1(p30)

	if v99 == s25 then
		return true
	end

	return false, string.format("%s expected, got %s", s25, v99)
end

local s26 = "Region3int16"

function t1.Region3int16(p31) -- line: 7
	-- upvalues: v1 (copy), s26 (copy)
	local v101 = v1(p31)

	if v101 == s26 then
		return true
	end

	return false, string.format("%s expected, got %s", s26, v101)
end

local s27 = "TweenInfo"

function t1.TweenInfo(p32) -- line: 7
	-- upvalues: v1 (copy), s27 (copy)
	local v103 = v1(p32)

	if v103 == s27 then
		return true
	end

	return false, string.format("%s expected, got %s", s27, v103)
end

local s28 = "UDim"

function t1.UDim(p33) -- line: 7
	-- upvalues: v1 (copy), s28 (copy)
	local v105 = v1(p33)

	if v105 == s28 then
		return true
	end

	return false, string.format("%s expected, got %s", s28, v105)
end

local s29 = "UDim2"

function t1.UDim2(p34) -- line: 7
	-- upvalues: v1 (copy), s29 (copy)
	local v107 = v1(p34)

	if v107 == s29 then
		return true
	end

	return false, string.format("%s expected, got %s", s29, v107)
end

local s30 = "Vector2"

function t1.Vector2(p35) -- line: 7
	-- upvalues: v1 (copy), s30 (copy)
	local v109 = v1(p35)

	if v109 == s30 then
		return true
	end

	return false, string.format("%s expected, got %s", s30, v109)
end

local s31 = "Vector3"

function t1.Vector3(p36) -- line: 7
	-- upvalues: v1 (copy), s31 (copy)
	local v111 = v1(p36)

	if v111 == s31 then
		return true
	end

	return false, string.format("%s expected, got %s", s31, v111)
end

local s32 = "Vector3int16"

function t1.Vector3int16(p37) -- line: 7
	-- upvalues: v1 (copy), s32 (copy)
	local v113 = v1(p37)

	if v113 == s32 then
		return true
	end

	return false, string.format("%s expected, got %s", s32, v113)
end

local s33 = "Enum"

function t1.Enum(p38) -- line: 7
	-- upvalues: v1 (copy), s33 (copy)
	local v115 = v1(p38)

	if v115 == s33 then
		return true
	end

	return false, string.format("%s expected, got %s", s33, v115)
end

local s34 = "EnumItem"

function t1.EnumItem(p39) -- line: 7
	-- upvalues: v1 (copy), s34 (copy)
	local v117 = v1(p39)

	if v117 == s34 then
		return true
	end

	return false, string.format("%s expected, got %s", s34, v117)
end

local s35 = "RBXScriptSignal"

function t1.RBXScriptSignal(p40) -- line: 7
	-- upvalues: v1 (copy), s35 (copy)
	local v119 = v1(p40)

	if v119 == s35 then
		return true
	end

	return false, string.format("%s expected, got %s", s35, v119)
end

local s36 = "RBXScriptConnection"

function t1.RBXScriptConnection(p41) -- line: 7
	-- upvalues: v1 (copy), s36 (copy)
	local v121 = v1(p41)

	if v121 == s36 then
		return true
	end

	return false, string.format("%s expected, got %s", s36, v121)
end
function t1.literal(...) -- line: 406
	-- upvalues: t1 (copy)
	local v122 = select("#", ...)

	if v122 == 1 then
		local v123 = ...

		return function(p42) -- line: 410
			-- upvalues: v123 (copy)
			if p42 ~= v123 then
				return false, string.format("expected %s, got %s", tostring(v123), (tostring(p42)))
			end

			return true
		end
	end

	local t2 = {}

	for i = 1, v122 do
		local v126 = select(i, ...)

		t2[i] = t1.literal(v126)
	end

	return t1.union(unpack(t2))
end

t1.exactly = t1.literal

function t1.keyOf(p43) -- line: 439
	-- upvalues: t1 (copy)
	local t3 = {}

	for k in pairs(p43) do
		t3[#t3 + 1] = k
	end

	return t1.literal(unpack(t3))
end
function t1.valueOf(p44) -- line: 454
	-- upvalues: t1 (copy)
	local t4 = {}

	for _, v in pairs(p44) do
		t4[#t4 + 1] = v
	end

	return t1.literal(unpack(t4))
end
function t1.integer(p45) -- line: 469
	-- upvalues: t1 (copy)
	local v135, v136 = t1.number(p45)

	if not v135 then
		return false, v136 or ""
	end

	if p45 % 1 == 0 then
		return true
	end

	return false, string.format("integer expected, got %s", p45)
end
function t1.numberMin(p46) -- line: 488
	-- upvalues: t1 (copy)
	return function(p47) -- line: 489
		-- upvalues: t1 (copy), p46 (copy)
		local v179, v180 = t1.number(p47)

		if not v179 then
			return false, v180 or ""
		end

		if p47 >= p46 then
			return true
		end

		return false, string.format("number >= %s expected, got %s", p46, p47)
	end
end
function t1.numberMax(p48) -- line: 509
	-- upvalues: t1 (copy)
	return function(p49) -- line: 510
		-- upvalues: t1 (copy), p48 (copy)
		local v182, v183 = t1.number(p49)

		if not v182 then
			return false, v183
		end

		if p49 <= p48 then
			return true
		end

		return false, string.format("number <= %s expected, got %s", p48, p49)
	end
end
function t1.numberMinExclusive(p50) -- line: 530
	-- upvalues: t1 (copy)
	return function(p51) -- line: 531
		-- upvalues: t1 (copy), p50 (copy)
		local v185, v186 = t1.number(p51)

		if not v185 then
			return false, v186 or ""
		end

		if p51 > p50 then
			return true
		end

		return false, string.format("number > %s expected, got %s", p50, p51)
	end
end
function t1.numberMaxExclusive(p52) -- line: 551
	-- upvalues: t1 (copy)
	return function(p53) -- line: 552
		-- upvalues: t1 (copy), p52 (copy)
		local v188, v189 = t1.number(p53)

		if not v188 then
			return false, v189 or ""
		end

		if p53 < p52 then
			return true
		end

		return false, string.format("number < %s expected, got %s", p52, p53)
	end
end

t1.numberPositive = t1.numberMinExclusive(0)
t1.numberNegative = t1.numberMaxExclusive(0)

function t1.numberConstrained(p54, p55) -- line: 587
	-- upvalues: t1 (copy)
	assert(t1.number(p54) and t1.number(p55))

	local v143 = t1.numberMin(p54)
	local v144 = t1.numberMax(p55)

	return function(p56) -- line: 591
		-- upvalues: v143 (copy), v144 (copy)
		local v191, v192 = v143(p56)

		if not v191 then
			return false, v192 or ""
		end

		local v193, v194 = v144(p56)

		if not v193 then
			return false, v194 or ""
		end

		return true
	end
end
function t1.numberConstrainedExclusive(p57, p58) -- line: 614
	-- upvalues: t1 (copy)
	assert(t1.number(p57) and t1.number(p58))

	local v147 = t1.numberMinExclusive(p57)
	local v148 = t1.numberMaxExclusive(p58)

	return function(p59) -- line: 618
		-- upvalues: v147 (copy), v148 (copy)
		local v196, v197 = v147(p59)

		if not v196 then
			return false, v197 or ""
		end

		local v198, v199 = v148(p59)

		if not v198 then
			return false, v199 or ""
		end

		return true
	end
end
function t1.match(p60) -- line: 640
	-- upvalues: t1 (copy)
	assert(t1.string(p60))

	return function(p61) -- line: 642
		-- upvalues: t1 (copy), p60 (copy)
		local v201, v202 = t1.string(p61)

		if not v201 then
			return false, v202
		end

		if string.match(p61, p60) == nil then
			return false, string.format("\"%s\" failed to match pattern \"%s\"", p61, p60)
		end

		return true
	end
end
function t1.optional(p62) -- line: 663
	-- upvalues: t1 (copy)
	assert(t1.callback(p62))

	return function(p63) -- line: 665
		-- upvalues: p62 (copy)
		if p63 == nil then
			return true
		end

		local v204, v205 = p62(p63)

		if v204 then
			return true
		end

		return false, string.format("(optional) %s", v205 or "")
	end
end
function t1.tuple(...) -- line: 685
	local t5 = { ... }

	return function(...) -- line: 687
		-- upvalues: t5 (copy)
		for i = 1, #t5 do
			local v207, v208 = t5[i](({ ... })[i])

			if v207 == false then
				return false, string.format("Bad tuple index #%s:\n\t%s", i, v208 or "")
			end
		end

		return true
	end
end
function t1.keys(p64) -- line: 706
	-- upvalues: t1 (copy)
	assert(t1.callback(p64))

	return function(p65) -- line: 708
		-- upvalues: t1 (copy), p64 (copy)
		local v210, v211 = t1.table(p65)

		if v210 == false then
			return false, v211 or ""
		end

		for k in pairs(p65) do
			local v213, v214 = p64(k)

			if v213 == false then
				return false, string.format("bad key %s:\n\t%s", tostring(k), v214 or "")
			end
		end

		return true
	end
end
function t1.values(p66) -- line: 732
	-- upvalues: t1 (copy)
	assert(t1.callback(p66))

	return function(p67) -- line: 734
		-- upvalues: t1 (copy), p66 (copy)
		local v216, v217 = t1.table(p67)

		if v216 == false then
			return false, v217 or ""
		end

		for k, v in pairs(p67) do
			local v220, v221 = p66(v)

			if v220 == false then
				return false, string.format("bad value for key %s:\n\t%s", tostring(k), v221 or "")
			end
		end

		return true
	end
end
function t1.map(p68, p69) -- line: 759
	-- upvalues: t1 (copy)
	assert(t1.callback(p68), t1.callback(p69))

	local v156 = t1.keys(p68)
	local v157 = t1.values(p69)

	return function(p70) -- line: 763
		-- upvalues: v156 (copy), v157 (copy)
		local v223, v224 = v156(p70)

		if not v223 then
			return false, v224 or ""
		end

		local v225, v226 = v157(p70)

		if not v225 then
			return false, v226 or ""
		end

		return true
	end
end

local v40 = t1.keys(t1.integer)

function t1.array(p71) -- line: 787
	-- upvalues: t1 (copy), v40 (copy)
	assert(t1.callback(p71))

	local v159 = t1.values(p71)

	return function(p72) -- line: 790
		-- upvalues: v40 (copy), v159 (copy)
		local v228, v229 = v40(p72)

		if v228 == false then
			return false, string.format("[array] %s", v229 or "")
		end

		local n1 = 0

		for _, _ in ipairs(p72) do
			n1 += 1
		end

		for k in pairs(p72) do
			if k < 1 or n1 < k then
				return false, string.format("[array] key %s must be sequential", (tostring(k)))
			end
		end

		local v234, v235 = v159(p72)

		if not v234 then
			return false, string.format("[array] %s", v235 or "")
		end

		return true
	end
end

local v41 = t1.array(t1.callback)

function t1.union(...) -- line: 829
	-- upvalues: v41 (copy)
	local t6 = { ... }

	assert(v41(t6))

	return function(p73) -- line: 832
		-- upvalues: t6 (copy)
		for _, v in pairs(t6) do
			if v(p73) then
				return true
			end
		end

		return false, "bad type for union"
	end
end

t1.some = t1.union

function t1.intersection(...) -- line: 854
	-- upvalues: v41 (copy)
	local t7 = { ... }

	assert(v41(t7))

	return function(p74) -- line: 857
		-- upvalues: t7 (copy)
		for _, v in pairs(t7) do
			local v242, v243 = v(p74)

			if not v242 then
				return false, v243 or ""
			end
		end

		return true
	end
end

t1.every = t1.intersection

local v42 = t1.map(t1.any, t1.callback)

function t1.interface(p75) -- line: 883
	-- upvalues: v42 (copy), t1 (copy)
	assert(v42(p75))

	return function(p76) -- line: 885
		-- upvalues: t1 (copy), p75 (copy)
		local v245, v246 = t1.table(p76)

		if v245 == false then
			return false, v246 or ""
		end

		for k, v in pairs(p75) do
			local v249, v250 = v(p76[k])

			if v249 == false then
				return false, string.format("[interface] bad value for %s:\n\t%s", tostring(k), v250 or "")
			end
		end

		return true
	end
end
function t1.strictInterface(p77) -- line: 908
	-- upvalues: v42 (copy), t1 (copy)
	assert(v42(p77))

	return function(p78) -- line: 910
		-- upvalues: t1 (copy), p77 (copy)
		local v252, v253 = t1.table(p78)

		if v252 == false then
			return false, v253 or ""
		end

		for k, v in pairs(p77) do
			local v256, v257 = v(p78[k])

			if v256 == false then
				return false, string.format("[interface] bad value for %s:\n\t%s", tostring(k), v257 or "")
			end
		end

		for k in pairs(p78) do
			if not p77[k] then
				return false, string.format("[interface] unexpected field '%s'", (tostring(k)))
			end
		end

		return true
	end
end
function t1.instanceOf(p79, p80) -- line: 941
	-- upvalues: t1 (copy)
	assert(t1.string(p79))

	local u166 = nil

	if p80 ~= nil then
		u166 = t1.children(p80)
	end

	return function(p81) -- line: 949
		-- upvalues: t1 (copy), p79 (copy), u166 (ref)
		local v260, v261 = t1.Instance(p81)

		if not v260 then
			return false, v261 or ""
		end

		if p81.ClassName ~= p79 then
			return false, string.format("%s expected, got %s", p79, p81.ClassName)
		end

		if u166 then
			local v262, v263 = u166(p81)

			if not v262 then
				return false, v263
			end
		end

		return true
	end
end

t1.instance = t1.instanceOf

function t1.instanceIsA(p82, p83) -- line: 978
	-- upvalues: t1 (copy)
	assert(t1.string(p82))

	local u169 = nil

	if p83 ~= nil then
		u169 = t1.children(p83)
	end

	return function(p84) -- line: 986
		-- upvalues: t1 (copy), p82 (copy), u169 (ref)
		local v265, v266 = t1.Instance(p84)

		if not v265 then
			return false, v266 or ""
		end

		if not p84:IsA(p82) then
			return false, string.format("%s expected, got %s", p82, p84.ClassName)
		end

		if u169 then
			local v267, v268 = u169(p84)

			if not v267 then
				return false, v268
			end
		end

		return true
	end
end
function t1.enum(p85) -- line: 1014
	-- upvalues: t1 (copy)
	assert(t1.Enum(p85))

	return function(p86) -- line: 1016
		-- upvalues: t1 (copy), p85 (copy)
		local v270, v271 = t1.EnumItem(p86)

		if not v270 then
			return false, v271
		end

		if p86.EnumType == p85 then
			return true
		end

		return false, string.format("enum of %s expected, got enum of %s", tostring(p85), (tostring(p86.EnumType)))
	end
end

local v43 = t1.tuple(t1.callback, t1.callback)

function t1.wrap(p87, p88) -- line: 1041
	-- upvalues: v43 (copy)
	assert(v43(p87, p88))

	return function(...) -- line: 1043
		-- upvalues: p88 (copy), p87 (copy)
		assert(p88(...))

		return p87(...)
	end
end
function t1.strict(p89) -- line: 1057
	return function(...) -- line: 1058
		-- upvalues: p89 (copy)
		assert(p89(...))
	end
end

local v44 = t1.map(t1.string, t1.callback)

function t1.children(p90) -- line: 1077
	-- upvalues: v44 (copy), t1 (copy)
	assert(v44(p90))

	return function(p91) -- line: 1080
		-- upvalues: t1 (copy), p90 (copy)
		local v273, v274 = t1.Instance(p91)

		if not v273 then
			return false, v274 or ""
		end

		local t8 = {}

		for _, child in pairs(p91:GetChildren()) do
			local childName = child.Name

			if not p90[childName] then
				continue
			end

			if t8[childName] then
				return false, string.format("Cannot process multiple children with the same name \"%s\"", childName)
			end

			t8[childName] = child
		end

		for k, v in pairs(p90) do
			local v281, v282 = v(t8[k])

			if not v281 then
				return false, string.format("[%s.%s] %s", p91:GetFullName(), k, v282 or "")
			end
		end

		return true
	end
end

return t1
