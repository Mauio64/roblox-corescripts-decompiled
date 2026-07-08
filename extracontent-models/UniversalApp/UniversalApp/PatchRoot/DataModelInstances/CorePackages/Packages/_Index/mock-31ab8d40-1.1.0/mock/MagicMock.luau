local symbols = require(script.Parent.symbols)
local Spy = require(script.Parent.Spy)
local setReturnValue = require(script.Parent.setReturnValue)
local setSideEffect = require(script.Parent.setSideEffect)

local function isKeyInSpec(p1, p2) -- line: 8
	-- upvalues: symbols (copy)
	local v21 = p1[symbols.Spec]

	if v21 then
		local ok, result = pcall(function() -- line: 11
			-- upvalues: v21 (copy), p2 (copy)
			return v21[p2]
		end)

		return ok and result
	end

	return true
end

local t1 = {
	is = require(script.Parent.isAMagicMock)
}
local t3 = {
	__tostring = function(p3) -- line: 24
		-- upvalues: symbols (copy)
		local mt = getmetatable(p3)
		local t2 = { "id=" .. mt[symbols.Address] }
		local v27 = mt[symbols.Name]

		if v27 ~= nil and v27 ~= "mock" then
			table.insert(t2, "name=" .. v27)
		end

		return "<MagicMock " .. table.concat(t2, " ") .. ">"
	end,
	__index = function(p4, p5) -- line: 36
		-- upvalues: symbols (copy), t1 (copy)
		local mt = getmetatable(p4)
		local v31 = mt[symbols.Spec]
		local v34

		if v31 then
			local ok, result = pcall(function() -- line: 11
				-- upvalues: v31 (copy), p5 (copy)
				return v31[p5]
			end)

			v34 = ok and result
		else
			v34 = true
		end

		if not v34 then
			error(string.format("MagicMock Error: Cannot index key %q since it is out of spec.", (tostring(p5))))
		end

		local v35 = mt[symbols.Children][p5]

		if v35 == nil then
			local v36 = t1.new({
				name = mt[symbols.Name] .. "." .. tostring(p5)
			})

			mt[symbols.Children][p5] = v36

			return v36
		end

		if v35 == symbols.None then
			return nil
		end

		return v35
	end,
	__newindex = function(p6, p7, p8) -- line: 56
		-- upvalues: symbols (copy), Spy (copy)
		local mt = getmetatable(p6)
		local v41 = mt[symbols.Spec]
		local v44

		if v41 then
			local ok, result = pcall(function() -- line: 11
				-- upvalues: v41 (copy), p7 (copy)
				return v41[p7]
			end)

			v44 = ok and result
		else
			v44 = true
		end

		if not v44 then
			error(string.format("MagicMock Error: Cannot write key %q since it is out of spec", (tostring(p7))))
		end

		if type(p8) == "function" then
			local v45

			v45, p8 = Spy.new(p8)
		elseif p8 == nil then
			p8 = symbols.None
		end

		if p7 == symbols.ReturnValue then
			mt[symbols.ReturnValue] = {
				p8,
				n = 1
			}

			return
		end

		mt[symbols.Children][p7] = p8
	end
}

local function isTuple(p9) -- line: 78
	-- upvalues: symbols (copy), t1 (copy)
	if type(p9) == "table" and p9[symbols.isTuple] then
		return not t1.is(p9)
	end
end
local function getReturnValue(p10, ...) -- line: 84
	-- upvalues: symbols (copy), Spy (copy), t1 (copy)
	if p10[symbols.ReturnValue] then
		return p10[symbols.ReturnValue]
	end

	local v48 = p10[symbols.SideEffect]

	if v48 then
		v48.calls = v48.calls + 1

		if type(v48.value) == "function" or Spy.is(v48.value) then
			return { v48.value(...) }
		end

		if type(v48.value) == "table" then
			local calls = v48.calls
			local value = v48.value
			local v51 = if not if type(value) ~= "table" or not value[symbols.isTuple] then nil else not t1.is(value) then v48.value[calls] else v48.value.values[calls]

			if v51 then
				return { v51 }
			end

			error("MagicMock Error: SideEffect iteration reached")
		else
			error("MagicMock Error: Invalid SideEffect")
		end
	end

	return nil
end

function t3.__call(p11, ...) -- line: 117
	-- upvalues: getReturnValue (copy), t1 (copy), symbols (copy)
	local mt = getmetatable(p11)
	local t4 = {
		args = table.pack(...),
		result = getReturnValue(mt, ...)
	}

	if t4.result == nil then
		t4.result = {
			t1.new({
				name = mt[symbols.Name] .. "()"
			}),
			n = 1
		}
		mt[symbols.ReturnValue] = t4.result
	elseif t4.result == symbols.None then
		t4.result = {
			n = 1
		}
	else
		local v55 = t4.result[1]

		if if type(v55) ~= "table" or not v55[symbols.isTuple] then nil else not t1.is(v55) then
			t4.result = t4.result[1].values
		end
	end

	table.insert(mt[symbols.Calls], t4)

	return table.unpack(t4.result)
end

local function operation(p12) -- line: 144
	-- upvalues: symbols (copy), t1 (copy)
	return function(p13, p14) -- line: 145
		-- upvalues: p12 (copy), symbols (copy), t1 (copy)
		local mt, v118

		if type(p13) ~= "string" and getmetatable(p13) then
			mt = getmetatable(p13)
			v118 = string.format("__%s()", p12)
		else
			mt = getmetatable(p14)
			v118 = string.format("__r_%s()", p12)
		end

		local v119 = mt[symbols.Operations][v118]

		if v119 == nil then
			local v120 = t1.new({
				name = mt[symbols.Name] .. "." .. v118
			})

			mt[symbols.Operations][v118] = v120

			return v120
		end

		return v119
	end
end

local s1 = "add"

function t3.__add(p15, p16) -- line: 145
	-- upvalues: s1 (copy), symbols (copy), t1 (copy)
	local mt, v60

	if type(p15) ~= "string" and getmetatable(p15) then
		mt = getmetatable(p15)
		v60 = string.format("__%s()", s1)
	else
		mt = getmetatable(p16)
		v60 = string.format("__r_%s()", s1)
	end

	local v61 = mt[symbols.Operations][v60]

	if v61 == nil then
		local v62 = t1.new({
			name = mt[symbols.Name] .. "." .. v60
		})

		mt[symbols.Operations][v60] = v62

		return v62
	end

	return v61
end

local s2 = "sub"

function t3.__sub(p17, p18) -- line: 145
	-- upvalues: s2 (copy), symbols (copy), t1 (copy)
	local mt, v66

	if type(p17) ~= "string" and getmetatable(p17) then
		mt = getmetatable(p17)
		v66 = string.format("__%s()", s2)
	else
		mt = getmetatable(p18)
		v66 = string.format("__r_%s()", s2)
	end

	local v67 = mt[symbols.Operations][v66]

	if v67 == nil then
		local v68 = t1.new({
			name = mt[symbols.Name] .. "." .. v66
		})

		mt[symbols.Operations][v66] = v68

		return v68
	end

	return v67
end

local s3 = "div"

function t3.__div(p19, p20) -- line: 145
	-- upvalues: s3 (copy), symbols (copy), t1 (copy)
	local mt, v72

	if type(p19) ~= "string" and getmetatable(p19) then
		mt = getmetatable(p19)
		v72 = string.format("__%s()", s3)
	else
		mt = getmetatable(p20)
		v72 = string.format("__r_%s()", s3)
	end

	local v73 = mt[symbols.Operations][v72]

	if v73 == nil then
		local v74 = t1.new({
			name = mt[symbols.Name] .. "." .. v72
		})

		mt[symbols.Operations][v72] = v74

		return v74
	end

	return v73
end

local s4 = "mul"

function t3.__mul(p21, p22) -- line: 145
	-- upvalues: s4 (copy), symbols (copy), t1 (copy)
	local mt, v78

	if type(p21) ~= "string" and getmetatable(p21) then
		mt = getmetatable(p21)
		v78 = string.format("__%s()", s4)
	else
		mt = getmetatable(p22)
		v78 = string.format("__r_%s()", s4)
	end

	local v79 = mt[symbols.Operations][v78]

	if v79 == nil then
		local v80 = t1.new({
			name = mt[symbols.Name] .. "." .. v78
		})

		mt[symbols.Operations][v78] = v80

		return v80
	end

	return v79
end

local s5 = "mod"

function t3.__mod(p23, p24) -- line: 145
	-- upvalues: s5 (copy), symbols (copy), t1 (copy)
	local mt, v84

	if type(p23) ~= "string" and getmetatable(p23) then
		mt = getmetatable(p23)
		v84 = string.format("__%s()", s5)
	else
		mt = getmetatable(p24)
		v84 = string.format("__r_%s()", s5)
	end

	local v85 = mt[symbols.Operations][v84]

	if v85 == nil then
		local v86 = t1.new({
			name = mt[symbols.Name] .. "." .. v84
		})

		mt[symbols.Operations][v84] = v86

		return v86
	end

	return v85
end

local s6 = "pow"

function t3.__pow(p25, p26) -- line: 145
	-- upvalues: s6 (copy), symbols (copy), t1 (copy)
	local mt, v90

	if type(p25) ~= "string" and getmetatable(p25) then
		mt = getmetatable(p25)
		v90 = string.format("__%s()", s6)
	else
		mt = getmetatable(p26)
		v90 = string.format("__r_%s()", s6)
	end

	local v91 = mt[symbols.Operations][v90]

	if v91 == nil then
		local v92 = t1.new({
			name = mt[symbols.Name] .. "." .. v90
		})

		mt[symbols.Operations][v90] = v92

		return v92
	end

	return v91
end

local s7 = "neg"

function t3.__unm(p27, p28) -- line: 145
	-- upvalues: s7 (copy), symbols (copy), t1 (copy)
	local mt, v96

	if type(p27) ~= "string" and getmetatable(p27) then
		mt = getmetatable(p27)
		v96 = string.format("__%s()", s7)
	else
		mt = getmetatable(p28)
		v96 = string.format("__r_%s()", s7)
	end

	local v97 = mt[symbols.Operations][v96]

	if v97 == nil then
		local v98 = t1.new({
			name = mt[symbols.Name] .. "." .. v96
		})

		mt[symbols.Operations][v96] = v98

		return v98
	end

	return v97
end

local s8 = "concat"

function t3.__concat(p29, p30) -- line: 145
	-- upvalues: s8 (copy), symbols (copy), t1 (copy)
	local mt, v102

	if type(p29) ~= "string" and getmetatable(p29) then
		mt = getmetatable(p29)
		v102 = string.format("__%s()", s8)
	else
		mt = getmetatable(p30)
		v102 = string.format("__r_%s()", s8)
	end

	local v103 = mt[symbols.Operations][v102]

	if v103 == nil then
		local v104 = t1.new({
			name = mt[symbols.Name] .. "." .. v102
		})

		mt[symbols.Operations][v102] = v104

		return v104
	end

	return v103
end
function t1.new(p31) -- line: 176
	-- upvalues: symbols (copy), t3 (copy), setReturnValue (copy), setSideEffect (copy)
	local u106 = p31 or {}

	local function getName() -- line: 179
		-- upvalues: u106 (ref)
		if u106.name then
			return u106.name
		end

		if u106.spec then
			return (tostring(u106.spec))
		end

		return "mock"
	end

	local t5 = {}
	local t6 = {
		[symbols.isMagicMock] = true,
		[symbols.Address] = tostring(t5),
		[symbols.Name] = if not u106.name then not u106.spec and "mock" or tostring(u106.spec) else u106.name,
		[symbols.Operations] = {},
		[symbols.Calls] = {},
		[symbols.Children] = {},
		[symbols.Spec] = u106.spec or nil,
		[symbols.ReturnValue] = nil,
		[symbols.SideEffect] = nil
	}

	for k, v in pairs(t3) do
		t6[k] = v
	end

	local v112 = setmetatable(t5, t6)

	if u106.returnValue then
		setReturnValue(v112, u106.returnValue)
	end

	if u106.sideEffect then
		setSideEffect(v112, u106.sideEffect)
	end

	return v112
end
function t1.is(p32) -- line: 218
	-- upvalues: symbols (copy)
	local mt = getmetatable(p32)

	if mt then
		return mt[symbols.isMagicMock] ~= nil
	end

	return false
end

return t1
