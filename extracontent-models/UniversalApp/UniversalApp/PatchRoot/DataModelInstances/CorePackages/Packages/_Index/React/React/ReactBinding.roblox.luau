local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local ReactSymbols = require(ParentParent.Shared).ReactSymbols

require(ParentParent.Shared)

local Symbol = LuauPolyfill.Symbol
local lib = require(script.Parent["createSignal.roblox"])
local v7 = Symbol("BindingImpl")
local t1 = {}
local t4 = {
	__index = {
		getValue = function(t2: {[any]: any}) -- line: 48
			-- upvalues: t1 (copy)
			return t1.getValue(t2)
		end,
		map = function(t3: {[any]: any}, p1: ((...any) -> ...any)) -- line: 52
			-- upvalues: t1 (copy)
			return t1.map(t3, p1)
		end
	},
	__tostring = function(p2) -- line: 61
		return string.format("RoactBinding(%s)", (tostring(p2:getValue())))
	end
}

function t1.update(p3, p4) -- line: 66
	-- upvalues: v7 (copy)
	return p3[v7].update(p4)
end
function t1.subscribe(p5, p6: ((...any) -> ...any)) -- line: 70
	-- upvalues: v7 (copy)
	return p5[v7].subscribe(p6)
end
function t1.getValue(p7) -- line: 74
	-- upvalues: v7 (copy)
	return p7[v7]:getValue()
end
function t1.create(p8) -- line: 78
	-- upvalues: lib (copy), ReactGlobals (copy), ReactSymbols (copy), v7 (copy), t4 (copy)
	local v20, v21 = lib()
	local t5 = {
		value = p8,
		subscribe = v20
	}

	function t5.update(p9) -- line: 85
		-- upvalues: t5 (copy), v21 (copy)
		t5.value = p9
		v21(p9)
	end
	function t5.getValue() -- line: 90
		-- upvalues: t5 (copy)
		return t5.value
	end

	local trace = nil

	if ReactGlobals.__DEV__ then
		trace = debug.traceback("Binding created at:", 3)
	end

	return setmetatable({
		["$$typeof"] = ReactSymbols.REACT_BINDING_TYPE,
		[v7] = t5,
		_source = trace
	}, t4), t5.update
end
function t1.map(t6: {[any]: any}, p10: ((...any) -> ...any)) -- line: 108
	-- upvalues: ReactGlobals (copy), ReactSymbols (copy), t1 (copy), v7 (copy), t4 (copy)
	if ReactGlobals.__DEV__ then
		assert(typeof(t6) == "table" and t6["$$typeof"] == ReactSymbols.REACT_BINDING_TYPE, "Expected `self` to be a binding")
		assert(typeof(p10) == "function", "Expected arg #1 to be a function")
	end

	local t7 = {
		subscribe = function(p11) -- line: 124
			-- upvalues: t1 (copy), t6 (copy), p10 (copy)
			return t1.subscribe(t6, function(p12) -- line: 125
				-- upvalues: p11 (copy), p10 (copy)
				p11(p10(p12))
			end)
		end,
		update = function(_) -- line: 130
			error("Bindings created by Binding:map(fn) cannot be updated directly", 2)
		end,
		getValue = function() -- line: 134
			-- upvalues: p10 (copy), t6 (copy)
			return p10(t6:getValue())
		end
	}
	local trace = nil

	if ReactGlobals.__DEV__ then
		trace = debug.traceback("Mapped binding created at:", 3)
	end

	return (setmetatable({
		["$$typeof"] = ReactSymbols.REACT_BINDING_TYPE,
		[v7] = t7,
		_source = trace
	}, t4))
end
function t1.join(t8: {[any]: any}) -- line: 155
	-- upvalues: ReactGlobals (copy), ReactSymbols (copy), t1 (copy), v7 (copy), t4 (copy)
	if ReactGlobals.__DEV__ then
		assert(typeof(t8) == "table", "Expected arg #1 to be of type table")

		for v29, v30 in t8 do
			if typeof(v30) ~= "table" or v30["$$typeof"] ~= ReactSymbols.REACT_BINDING_TYPE then
				local v31 = ("Expected arg #1 to contain only bindings, but key %q had a non-binding value"):format((tostring(v29)))

				error(v31, 2)
			end
		end
	end

	local t9 = {}

	local function getValue() -- line: 176
		-- upvalues: t8 (copy)
		local t10 = {}

		for k, v in pairs(t8) do
			t10[k] = v:getValue()
		end

		return t10
	end

	function t9.subscribe(p14) -- line: 187
		-- upvalues: t8 (copy), t1 (copy), getValue (copy)
		local t11 = {}

		for v43, v44 in t8 do
			t11[v43] = t1.subscribe(v44, function(_) -- line: 192
				-- upvalues: p14 (copy), getValue (copy)
				p14((getValue()))
			end)
		end

		return function() -- line: 197
			-- upvalues: t11 (ref)
			if t11 == nil then
				return
			end

			for _, v49 in t11 do
				v49()
			end

			t11 = nil
		end
	end
	function t9.update(_) -- line: 210
		error("Bindings created by joinBindings(...) cannot be updated directly", 2)
	end
	function t9.getValue() -- line: 214
		-- upvalues: getValue (copy)
		return (getValue())
	end

	local trace = nil

	if ReactGlobals.__DEV__ then
		trace = debug.traceback("Joined binding created at:", 2)
	end

	return (setmetatable({
		["$$typeof"] = ReactSymbols.REACT_BINDING_TYPE,
		[v7] = t9,
		_source = trace
	}, t4))
end

return t1
