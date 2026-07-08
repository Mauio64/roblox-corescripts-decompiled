local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local Error = require(ParentParent.LuauPolyfill).Error
local __DEV__ = ReactGlobals.__DEV__
local console = require(ParentParent.Shared).console

require(ParentParent.Shared)
require(script.Parent.ReactLazy)

local getComponentName = require(ParentParent.Shared).getComponentName
local REACT_ELEMENT_TYPE = require(ParentParent.Shared).ReactSymbols.REACT_ELEMENT_TYPE
local ReactCurrentOwner = require(ParentParent.Shared).ReactSharedInternals.ReactCurrentOwner
local t1 = {
	key = true,
	ref = true,
	__self = true,
	__source = true
}
local u10 = nil
local u11 = nil
local t2 = nil

if __DEV__ then
	t2 = {}
end

local t3 = {}

local function hasValidRef(p1) -- line: 60
	-- upvalues: __DEV__ (copy)
	if __DEV__ and (p1.ref ~= nil and type(p1.ref) == "table" and p1.ref.isReactWarning) then
		return false
	end

	return p1.ref ~= nil
end
local function hasValidKey(p2) -- line: 74
	-- upvalues: __DEV__ (copy)
	if __DEV__ and (p2.key ~= nil and type(p2.key) == "table" and p2.key.isReactWarning) then
		return false
	end

	return p2.key ~= nil
end

local t4 = {
	isReactWarning = true
}

local function defineKeyPropWarningGetter(p3, s1: string) -- line: 93
	-- upvalues: __DEV__ (copy), u10 (ref), console (copy), t4 (copy)
	p3.key = nil
	setmetatable(p3, {
		__index = function(_, p5) -- line: 113
			-- upvalues: __DEV__ (copy), u10 (ref), console (copy), s1 (copy), t4 (copy)
			if p5 == "key" then
				if __DEV__ and not u10 then
					u10 = true
					console.error("%s: `key` is not a prop. Trying to access it will result in `nil` being returned. If you need to access the same value within the child component, you should pass it as a different prop. (https://reactjs.org/link/special-props)", s1)
				end

				return t4
			end

			return nil
		end
	})
end
local function defineRefPropWarningGetter(p6, s2: string) -- line: 125
	-- upvalues: __DEV__ (copy), u11 (ref), console (copy), t4 (copy)
	p6.ref = nil
	setmetatable(p6, {
		__index = function(_, p8) -- line: 147
			-- upvalues: __DEV__ (copy), u11 (ref), console (copy), s2 (copy), t4 (copy)
			if p8 == "ref" then
				if __DEV__ and not u11 then
					u11 = true
					console.error("%s: `ref` is not a prop. Trying to access it will result in `nil` being returned. If you need to access the same value within the child component, you should pass it as a different prop. (https://reactjs.org/link/special-props)", s2)
				end

				return t4
			end

			return nil
		end
	})
end
local function warnIfStringRefCannotBeAutoConverted(p9) -- line: 159
	-- upvalues: __DEV__ (copy), ReactCurrentOwner (copy), getComponentName (copy), t2 (ref)
	if __DEV__ and (type(p9.ref) == "string" and ReactCurrentOwner.current) then
		local v28 = getComponentName(ReactCurrentOwner.current.type)

		if not t2[v28] then
			error(string.format("Component \"%s\" contains the string ref \"%s\". Support for string refs has been removed. We recommend using useRef() or createRef() instead. Learn more about using refs safely here: https://reactjs.org/link/strict-mode-string-ref", v28 or "Unknown", p9.ref))
		end
	end
end
local function ReactElement(p10, p11, p12, p13, p14, p15, p16) -- line: 210
	-- upvalues: REACT_ELEMENT_TYPE (copy), __DEV__ (copy)
	local t5 = {
		type = p10,
		key = p11,
		ref = p12,
		props = p16,
		_owner = p15,
		["$$typeof"] = REACT_ELEMENT_TYPE
	}

	if __DEV__ then
		local t6 = {
			validated = false
		}

		t5._store = setmetatable({}, {
			__index = t6,
			__newindex = function(p17, p18, p19) -- line: 247
				-- upvalues: t6 (copy)
				if p18 == "validated" then
					t6.validated = p19

					return
				end

				rawset(p17, p18, p19)
			end
		})
		setmetatable(t5, {
			__index = {
				_self = p13,
				_source = p14
			}
		})
	end

	return t5
end

function t3.jsx(_, _, _) -- line: 278
	error("JSX is currently unsupported")
end
function t3.jsxDEV(_, _, _, _, _) -- line: 333
	error("JSX is currently unsupported")

	return nil
end
function t3.createElement(p28, p29, ...) -- line: 409
	-- upvalues: __DEV__ (copy), warnIfStringRefCannotBeAutoConverted (copy), defineKeyPropWarningGetter (copy), defineRefPropWarningGetter (copy), ReactElement (copy), ReactCurrentOwner (copy)
	local v48 = if p29 == nil then {} else table.clone(p29)
	local v49 = nil
	local ref = nil
	local v51 = nil

	if p29 ~= nil then
		if (not __DEV__ or (p29.ref == nil or (type(p29.ref) ~= "table" or not p29.ref.isReactWarning))) and p29.ref ~= nil then
			ref = p29.ref

			if __DEV__ then
				warnIfStringRefCannotBeAutoConverted(p29)
			end
		end

		if (not __DEV__ or (p29.key == nil or (type(p29.key) ~= "table" or not p29.key.isReactWarning))) and p29.key ~= nil then
			local key = p29.key

			v49 = if type(key) ~= "number" then tostring(key) else key
		end

		v51 = if p29.__source ~= nil then p29.__source else nil

		if v48.key ~= nil then
			v48.key = nil
		end

		if v48.ref ~= nil then
			v48.ref = nil
		end

		if v48.__self ~= nil then
			v48.__self = nil
		end

		if v48.__source ~= nil then
			v48.__source = nil
		end
	end

	local v53 = select("#", ...)

	if v53 == 1 then
		v48.children = select(1, ...)
	elseif v53 > 1 then
		local t7 = table.create(v53)

		for i = 1, v53 do
			table.insert(t7, (select(i, ...)))
		end

		if __DEV__ then
			table.freeze(t7)
		end

		v48.children = t7
	end

	if type(p28) == "table" and p28.defaultProps then
		local defaultProps = p28.defaultProps

		for v57, _ in defaultProps do
			if v48[v57] == nil then
				v48[v57] = defaultProps[v57]
			end
		end
	end

	if __DEV__ then
		if v49 or ref then
			local v59 = if type(p28) ~= "function" then if type(p28) ~= "table" then p28 else p28.displayName or (p28.name or "Unknown") else debug.info(p28, "n") or "<function>"

			if v49 then
				defineKeyPropWarningGetter(v48, v59)
			end

			if ref then
				defineRefPropWarningGetter(v48, v59)
			end
		end

		if v51 == nil then
			v51 = {
				fileName = debug.info(3, "s"),
				lineNumber = debug.info(3, "l")
			}
		end
	end

	return (ReactElement(p28, v49, ref, nil, v51, ReactCurrentOwner.current, v48))
end
function t3.cloneAndReplaceKey(p30, p31) -- line: 587
	-- upvalues: ReactElement (copy)
	return (ReactElement(p30.type, p31, p30.ref, p30._self, p30._source, p30._owner, p30.props))
end
function t3.cloneElement(p32, p33, ...) -- line: 608
	-- upvalues: Error (copy), ReactCurrentOwner (copy), __DEV__ (copy), t1 (copy), ReactElement (copy)
	if p32 == nil then
		error(Error.new("React.cloneElement(...): The argument must be a React element, but you passed " .. tostring(p32)))
	end

	local props = p32.props
	local v65 = if props == nil then {} else table.clone(props)
	local key = p32.key
	local ref = p32.ref
	local _source = p32._source
	local _owner = p32._owner

	if p33 ~= nil then
		local ref2 = p33.ref

		if ref2 ~= nil then
			ref = ref2
			_owner = ReactCurrentOwner.current
		elseif not __DEV__ or p33.ref == nil or type(p33.ref) ~= "table" or not p33.ref.isReactWarning then
			if p33.ref == nil then
			end
		end

		local key2 = p33.key

		if key2 ~= nil then
			key = if type(key2) ~= "number" then key2 or "nil" else key2
		elseif not __DEV__ or p33.key == nil or type(p33.key) ~= "table" or not p33.key.isReactWarning then
			if p33.key == nil then
			end
		end
	end

	local type2 = p32.type
	local v73 = if type(type2) ~= "table" then nil else type2.defaultProps

	if p33 ~= nil then
		for v74, _ in p33 do
			if p33[v74] ~= nil and not t1[v74] then
				if p33[v74] == nil and v73 ~= nil then
					v65[v74] = v73[v74]
				else
					v65[v74] = p33[v74]
				end
			end
		end
	end

	local v76 = select("#", ...)

	if v76 == 1 then
		v65.children = select(1, ...)
	elseif v76 > 1 then
		v65.children = { ... }
	end

	return (ReactElement(p32.type, key, ref, nil, _source, _owner, v65))
end
function t3.isValidElement(p34) -- line: 724
	-- upvalues: REACT_ELEMENT_TYPE (copy)
	return type(p34) == "table" and p34["$$typeof"] == REACT_ELEMENT_TYPE
end

return t3
