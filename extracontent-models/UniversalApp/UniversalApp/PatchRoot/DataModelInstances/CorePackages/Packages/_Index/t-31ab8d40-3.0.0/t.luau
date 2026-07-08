local t1 = {
	type = function(p1) -- line: 5
		return function(p2) -- line: 6
			-- upvalues: p1 (copy)
			local v72 = type(p2)

			if v72 == p1 then
				return true
			end

			return false, string.format("%s expected, got %s", p1, v72)
		end
	end,
	typeof = function(p3) -- line: 16
		return function(p4) -- line: 17
			-- upvalues: p3 (copy)
			local v74 = typeof(p4)

			if v74 == p3 then
				return true
			end

			return false, string.format("%s expected, got %s", p3, v74)
		end
	end,
	any = function(p5) -- line: 34
		if p5 ~= nil then
			return true
		end

		return false, "any expected, got nil"
	end
}

t1.boolean = t1.typeof("boolean")
t1.thread = t1.typeof("thread")
t1.callback = t1.typeof("function")
t1["function"] = t1.callback
t1.none = t1.typeof("nil")
t1["nil"] = t1.none
t1.string = t1.typeof("string")
t1.table = t1.typeof("table")
t1.userdata = t1.type("userdata")

function t1.number(p6) -- line: 116
	local v11 = typeof(p6)

	if v11 == "number" then
		if p6 == p6 then
			return true
		end

		return false, "unexpected NaN value"
	end

	return false, string.format("number expected, got %s", v11)
end
function t1.nan(p7) -- line: 136
	local v13 = typeof(p7)

	if v13 == "number" then
		if p7 ~= p7 then
			return true
		end

		return false, "unexpected non-NaN value"
	end

	return false, string.format("number expected, got %s", v13)
end

t1.Axes = t1.typeof("Axes")
t1.BrickColor = t1.typeof("BrickColor")
t1.CatalogSearchParams = t1.typeof("CatalogSearchParams")
t1.CFrame = t1.typeof("CFrame")
t1.Color3 = t1.typeof("Color3")
t1.ColorSequence = t1.typeof("ColorSequence")
t1.ColorSequenceKeypoint = t1.typeof("ColorSequenceKeypoint")
t1.DateTime = t1.typeof("DateTime")
t1.DockWidgetPluginGuiInfo = t1.typeof("DockWidgetPluginGuiInfo")
t1.Enum = t1.typeof("Enum")
t1.EnumItem = t1.typeof("EnumItem")
t1.Enums = t1.typeof("Enums")
t1.Faces = t1.typeof("Faces")
t1.Instance = t1.typeof("Instance")
t1.NumberRange = t1.typeof("NumberRange")
t1.NumberSequence = t1.typeof("NumberSequence")
t1.NumberSequenceKeypoint = t1.typeof("NumberSequenceKeypoint")
t1.PathWaypoint = t1.typeof("PathWaypoint")
t1.PhysicalProperties = t1.typeof("PhysicalProperties")
t1.Random = t1.typeof("Random")
t1.Ray = t1.typeof("Ray")
t1.RaycastParams = t1.typeof("RaycastParams")
t1.RaycastResult = t1.typeof("RaycastResult")
t1.RBXScriptConnection = t1.typeof("RBXScriptConnection")
t1.RBXScriptSignal = t1.typeof("RBXScriptSignal")
t1.Rect = t1.typeof("Rect")
t1.Region3 = t1.typeof("Region3")
t1.Region3int16 = t1.typeof("Region3int16")
t1.TweenInfo = t1.typeof("TweenInfo")
t1.UDim = t1.typeof("UDim")
t1.UDim2 = t1.typeof("UDim2")
t1.Vector2 = t1.typeof("Vector2")
t1.Vector2int16 = t1.typeof("Vector2int16")
t1.Vector3 = t1.typeof("Vector3")
t1.Vector3int16 = t1.typeof("Vector3int16")

function t1.literal(...) -- line: 473
	-- upvalues: t1 (copy)
	local v14 = select("#", ...)

	if v14 == 1 then
		local v15 = ...

		return function(p8) -- line: 477
			-- upvalues: v15 (copy)
			if p8 ~= v15 then
				return false, string.format("expected %s, got %s", tostring(v15), (tostring(p8)))
			end

			return true
		end
	end

	local t2 = {}

	for i = 1, v14 do
		local v18 = select(i, ...)

		t2[i] = t1.literal(v18)
	end

	return t1.union(table.unpack(t2, 1, v14))
end

t1.exactly = t1.literal

function t1.keyOf(p9) -- line: 508
	-- upvalues: t1 (copy)
	local t3 = {}
	local n1 = 0

	for k in pairs(p9) do
		n1 += 1
		t3[n1] = k
	end

	return t1.literal(table.unpack(t3, 1, n1))
end
function t1.valueOf(p10) -- line: 526
	-- upvalues: t1 (copy)
	local t4 = {}
	local n2 = 0

	for _, v in pairs(p10) do
		n2 += 1
		t4[n2] = v
	end

	return t1.literal(table.unpack(t4, 1, n2))
end
function t1.integer(p11) -- line: 544
	-- upvalues: t1 (copy)
	local v29, v30 = t1.number(p11)

	if not v29 then
		return false, v30 or ""
	end

	if p11 % 1 == 0 then
		return true
	end

	return false, string.format("integer expected, got %s", p11)
end
function t1.numberMin(p12) -- line: 564
	-- upvalues: t1 (copy)
	return function(p13) -- line: 565
		-- upvalues: t1 (copy), p12 (copy)
		local v77, v78 = t1.number(p13)

		if not v77 then
			return false, v78 or ""
		end

		if p13 >= p12 then
			return true
		end

		return false, string.format("number >= %s expected, got %s", p12, p13)
	end
end
function t1.numberMax(p14) -- line: 586
	-- upvalues: t1 (copy)
	return function(p15) -- line: 587
		-- upvalues: t1 (copy), p14 (copy)
		local v80, v81 = t1.number(p15)

		if not v80 then
			return false, v81
		end

		if p15 <= p14 then
			return true
		end

		return false, string.format("number <= %s expected, got %s", p14, p15)
	end
end
function t1.numberMinExclusive(p16) -- line: 608
	-- upvalues: t1 (copy)
	return function(p17) -- line: 609
		-- upvalues: t1 (copy), p16 (copy)
		local v83, v84 = t1.number(p17)

		if not v83 then
			return false, v84 or ""
		end

		if p17 > p16 then
			return true
		end

		return false, string.format("number > %s expected, got %s", p16, p17)
	end
end
function t1.numberMaxExclusive(p18) -- line: 630
	-- upvalues: t1 (copy)
	return function(p19) -- line: 631
		-- upvalues: t1 (copy), p18 (copy)
		local v86, v87 = t1.number(p19)

		if not v86 then
			return false, v87 or ""
		end

		if p19 < p18 then
			return true
		end

		return false, string.format("number < %s expected, got %s", p18, p19)
	end
end

t1.numberPositive = t1.numberMinExclusive(0)
t1.numberNegative = t1.numberMaxExclusive(0)

function t1.numberConstrained(p20, p21) -- line: 667
	-- upvalues: t1 (copy)
	assert(t1.number(p20))
	assert(t1.number(p21))

	local v37 = t1.numberMin(p20)
	local v38 = t1.numberMax(p21)

	return function(p22) -- line: 673
		-- upvalues: v37 (copy), v38 (copy)
		local v89, v90 = v37(p22)

		if not v89 then
			return false, v90 or ""
		end

		local v91, v92 = v38(p22)

		if not v91 then
			return false, v92 or ""
		end

		return true
	end
end
function t1.numberConstrainedExclusive(p23, p24) -- line: 696
	-- upvalues: t1 (copy)
	assert(t1.number(p23))
	assert(t1.number(p24))

	local v41 = t1.numberMinExclusive(p23)
	local v42 = t1.numberMaxExclusive(p24)

	return function(p25) -- line: 702
		-- upvalues: v41 (copy), v42 (copy)
		local v94, v95 = v41(p25)

		if not v94 then
			return false, v95 or ""
		end

		local v96, v97 = v42(p25)

		if not v96 then
			return false, v97 or ""
		end

		return true
	end
end
function t1.match(p26) -- line: 724
	-- upvalues: t1 (copy)
	assert(t1.string(p26))

	return function(p27) -- line: 726
		-- upvalues: t1 (copy), p26 (copy)
		local v99, v100 = t1.string(p27)

		if not v99 then
			return false, v100
		end

		if string.match(p27, p26) == nil then
			return false, string.format("%q failed to match pattern %q", p27, p26)
		end

		return true
	end
end
function t1.optional(p28) -- line: 747
	-- upvalues: t1 (copy)
	assert(t1.callback(p28))

	return function(p29) -- line: 749
		-- upvalues: p28 (copy)
		if p29 == nil then
			return true
		end

		local v102, v103 = p28(p29)

		if v102 then
			return true
		end

		return false, string.format("(optional) %s", v103 or "")
	end
end
function t1.tuple(...) -- line: 770
	local t5 = { ... }

	return function(...) -- line: 772
		-- upvalues: t5 (copy)
		for i, v in ipairs(t5) do
			local v106, v107 = v(({ ... })[i])

			if v106 == false then
				return false, string.format("Bad tuple index #%s:\n\t%s", i, v107 or "")
			end
		end

		return true
	end
end
function t1.keys(p30) -- line: 792
	-- upvalues: t1 (copy)
	assert(t1.callback(p30))

	return function(p31) -- line: 794
		-- upvalues: t1 (copy), p30 (copy)
		local v109, v110 = t1.table(p31)

		if v109 == false then
			return false, v110 or ""
		end

		for k in pairs(p31) do
			local v112, v113 = p30(k)

			if v112 == false then
				return false, string.format("bad key %s:\n\t%s", tostring(k), v113 or "")
			end
		end

		return true
	end
end
function t1.values(p32) -- line: 818
	-- upvalues: t1 (copy)
	assert(t1.callback(p32))

	return function(p33) -- line: 820
		-- upvalues: t1 (copy), p32 (copy)
		local v115, v116 = t1.table(p33)

		if v115 == false then
			return false, v116 or ""
		end

		for k, v in pairs(p33) do
			local v119, v120 = p32(v)

			if v119 == false then
				return false, string.format("bad value for key %s:\n\t%s", tostring(k), v120 or "")
			end
		end

		return true
	end
end
function t1.map(p34, p35) -- line: 845
	-- upvalues: t1 (copy)
	assert(t1.callback(p34))
	assert(t1.callback(p35))

	local v50 = t1.keys(p34)
	local v51 = t1.values(p35)

	return function(p36) -- line: 851
		-- upvalues: v50 (copy), v51 (copy)
		local v122, v123 = v50(p36)

		if not v122 then
			return false, v123 or ""
		end

		local v124, v125 = v51(p36)

		if not v124 then
			return false, v125 or ""
		end

		return true
	end
end
function t1.set(p37) -- line: 873
	-- upvalues: t1 (copy)
	return t1.map(p37, t1.literal(true))
end

local v2 = t1.keys(t1.integer)

function t1.array(p38) -- line: 886
	-- upvalues: t1 (copy), v2 (copy)
	assert(t1.callback(p38))

	local v54 = t1.values(p38)

	return function(p39) -- line: 890
		-- upvalues: v2 (copy), v54 (copy)
		local v127, v128 = v2(p39)

		if v127 == false then
			return false, string.format("[array] %s", v128 or "")
		end

		local n3 = 0

		for _ in ipairs(p39) do
			n3 += 1
		end

		for k in pairs(p39) do
			if k < 1 or n3 < k then
				return false, string.format("[array] key %s must be sequential", (tostring(k)))
			end
		end

		local v132, v133 = v54(p39)

		if not v132 then
			return false, string.format("[array] %s", v133 or "")
		end

		return true
	end
end
function t1.strictArray(...) -- line: 926
	-- upvalues: t1 (copy), v2 (copy)
	local t6 = { ... }

	assert(t1.array(t1.callback)(t6))

	return function(p40) -- line: 930
		-- upvalues: v2 (copy), t6 (copy)
		local v135, v136 = v2(p40)

		if v135 == false then
			return false, string.format("[strictArray] %s", v136 or "")
		end

		if #t6 < #p40 then
			return false, string.format("[strictArray] Array size exceeds limit of %d", #t6)
		end

		for k, v in pairs(t6) do
			local v139, v140 = v(p40[k])

			if not v139 then
				return false, string.format("[strictArray] Array index #%d - %s", k, v140)
			end
		end

		return true
	end
end

local v3 = t1.array(t1.callback)

function t1.union(...) -- line: 962
	-- upvalues: v3 (copy)
	local t7 = { ... }

	assert(v3(t7))

	return function(p41) -- line: 966
		-- upvalues: t7 (copy)
		for _, v in ipairs(t7) do
			if v(p41) then
				return true
			end
		end

		return false, "bad type for union"
	end
end

t1.some = t1.union

function t1.intersection(...) -- line: 989
	-- upvalues: v3 (copy)
	local t8 = { ... }

	assert(v3(t8))

	return function(p42) -- line: 993
		-- upvalues: t8 (copy)
		for _, v in ipairs(t8) do
			local v147, v148 = v(p42)

			if not v147 then
				return false, v148 or ""
			end
		end

		return true
	end
end

t1.every = t1.intersection

local v4 = t1.map(t1.any, t1.callback)

function t1.interface(p43) -- line: 1020
	-- upvalues: v4 (copy), t1 (copy)
	assert(v4(p43))

	return function(p44) -- line: 1022
		-- upvalues: t1 (copy), p43 (copy)
		local v150, v151 = t1.table(p44)

		if v150 == false then
			return false, v151 or ""
		end

		for k, v in pairs(p43) do
			local v154, v155 = v(p44[k])

			if v154 == false then
				return false, string.format("[interface] bad value for %s:\n\t%s", tostring(k), v155 or "")
			end
		end

		return true
	end
end
function t1.strictInterface(p45) -- line: 1046
	-- upvalues: v4 (copy), t1 (copy)
	assert(v4(p45))

	return function(p46) -- line: 1048
		-- upvalues: t1 (copy), p45 (copy)
		local v157, v158 = t1.table(p46)

		if v157 == false then
			return false, v158 or ""
		end

		for k, v in pairs(p45) do
			local v161, v162 = v(p46[k])

			if v161 == false then
				return false, string.format("[interface] bad value for %s:\n\t%s", tostring(k), v162 or "")
			end
		end

		for k in pairs(p46) do
			if not p45[k] then
				return false, string.format("[interface] unexpected field %q", (tostring(k)))
			end
		end

		return true
	end
end
function t1.instanceOf(p47, p48) -- line: 1079
	-- upvalues: t1 (copy)
	assert(t1.string(p47))

	local u62 = nil

	if p48 ~= nil then
		u62 = t1.children(p48)
	end

	return function(p49) -- line: 1087
		-- upvalues: t1 (copy), p47 (copy), u62 (ref)
		local v165, v166 = t1.Instance(p49)

		if not v165 then
			return false, v166 or ""
		end

		if p49.ClassName ~= p47 then
			return false, string.format("%s expected, got %s", p47, p49.ClassName)
		end

		if u62 then
			local v167, v168 = u62(p49)

			if not v167 then
				return false, v168
			end
		end

		return true
	end
end

t1.instance = t1.instanceOf

function t1.instanceIsA(p50, p51) -- line: 1117
	-- upvalues: t1 (copy)
	assert(t1.string(p50))

	local u65 = nil

	if p51 ~= nil then
		u65 = t1.children(p51)
	end

	return function(p52) -- line: 1125
		-- upvalues: t1 (copy), p50 (copy), u65 (ref)
		local v170, v171 = t1.Instance(p52)

		if not v170 then
			return false, v171 or ""
		end

		if not p52:IsA(p50) then
			return false, string.format("%s expected, got %s", p50, p52.ClassName)
		end

		if u65 then
			local v172, v173 = u65(p52)

			if not v172 then
				return false, v173
			end
		end

		return true
	end
end
function t1.enum(p53) -- line: 1153
	-- upvalues: t1 (copy)
	assert(t1.Enum(p53))

	return function(p54) -- line: 1155
		-- upvalues: t1 (copy), p53 (copy)
		local v175, v176 = t1.EnumItem(p54)

		if not v175 then
			return false, v176
		end

		if p54.EnumType == p53 then
			return true
		end

		return false, string.format("enum of %s expected, got enum of %s", tostring(p53), (tostring(p54.EnumType)))
	end
end

local v5 = t1.tuple(t1.callback, t1.callback)

function t1.wrap(p55, p56) -- line: 1180
	-- upvalues: v5 (copy)
	assert(v5(p55, p56))

	return function(...) -- line: 1182
		-- upvalues: p56 (copy), p55 (copy)
		assert(p56(...))

		return p55(...)
	end
end
function t1.strict(p57) -- line: 1196
	return function(...) -- line: 1197
		-- upvalues: p57 (copy)
		assert(p57(...))
	end
end

local v6 = t1.map(t1.string, t1.callback)

function t1.children(p58) -- line: 1216
	-- upvalues: v6 (copy), t1 (copy)
	assert(v6(p58))

	return function(p59) -- line: 1219
		-- upvalues: t1 (copy), p58 (copy)
		local v178, v179 = t1.Instance(p59)

		if not v178 then
			return false, v179 or ""
		end

		local t9 = {}

		for _, child in ipairs(p59:GetChildren()) do
			local childName = child.Name

			if not p58[childName] then
				continue
			end

			if t9[childName] then
				return false, string.format("Cannot process multiple children with the same name %q", childName)
			end

			t9[childName] = child
		end

		for k, v in pairs(p58) do
			local v186, v187 = v(t9[k])

			if not v186 then
				return false, string.format("[%s.%s] %s", p59:GetFullName(), k, v187 or "")
			end
		end

		return true
	end
end

return t1
