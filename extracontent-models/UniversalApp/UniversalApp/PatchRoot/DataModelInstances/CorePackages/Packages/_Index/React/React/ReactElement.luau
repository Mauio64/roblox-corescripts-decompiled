local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Error = LuauPolyfill.Error

local __DEV__ = ReactGlobals.__DEV__

local Shared = require(parent.Shared)
local console = Shared.console
require(parent.Shared)

require(script.Parent.ReactLazy)

local Shared2 = require(parent.Shared)
local getComponentName = Shared2.getComponentName

local Shared3 = require(parent.Shared)
local REACT_ELEMENT_TYPE = Shared3.ReactSymbols.REACT_ELEMENT_TYPE
local Shared4 = require(parent.Shared)
local ReactCurrentOwner = Shared4.ReactSharedInternals.ReactCurrentOwner

local v = { key = true, ref = true, __self = true, __source = true }

local v2 = nil
local v3 = nil

local v4 = __DEV__ and {} or nil

local function hasValidRef(p): boolean
	return (not __DEV__ or p.ref == nil or type(p.ref) ~= "table" or not p.ref.isReactWarning) and p.ref ~= nil
end

local function hasValidKey(p): boolean
	return (not __DEV__ or p.key == nil or type(p.key) ~= "table" or not p.key.isReactWarning) and p.key ~= nil
end

local v5 = { isReactWarning = true }

local function defineKeyPropWarningGetter(p, p2: string)
	p.key = nil
	setmetatable(p, {
		__index = function(_, p3)
			if p3 ~= "key" then
				return nil
			end

			if __DEV__ and not v2 then
				v2 = true
				console.error(
					"%s: `key` is not a prop. Trying to access it will result in `nil` being returned. If you need to access the same value within the child component, you should pass it as a different prop. (https://reactjs.org/link/special-props)",
					p2
				)
			end

			return v5
		end
	})
end

local function defineRefPropWarningGetter(p, p2: string)
	p.ref = nil
	setmetatable(p, {
		__index = function(_, p3)
			if p3 ~= "ref" then
				return nil
			end

			if __DEV__ and not v3 then
				v3 = true
				console.error(
					"%s: `ref` is not a prop. Trying to access it will result in `nil` being returned. If you need to access the same value within the child component, you should pass it as a different prop. (https://reactjs.org/link/special-props)",
					p2
				)
			end

			return v5
		end
	})
end

local function warnIfStringRefCannotBeAutoConverted(data)
	if __DEV__ and type(data.ref) == "string" and ReactCurrentOwner.current then
		local componentName = getComponentName(ReactCurrentOwner.current.type)

		if not v4[componentName] then
			error(string.format(
				"Component \"%s\" contains the string ref \"%s\". Support for string refs has been removed. We recommend using useRef() or createRef() instead. Learn more about using refs safely here: https://reactjs.org/link/strict-mode-string-ref",
				componentName or "Unknown",
				data.ref
			))
		end
	end
end

local function ReactElement2(p, p2, ref, p3, source, owner, props)
	local v6 = {
		type = p,
		key = p2,
		ref = ref,
		props = props,
		_owner = owner
	}

	v6["$$typeof"] = REACT_ELEMENT_TYPE

	if __DEV__ then
		local v7 = { validated = false }

		v6._store = setmetatable({}, {
			__index = v7,
			__newindex = function(p4, p5, validated)
				if p5 == "validated" then
					v7.validated = validated
				else
					rawset(p4, p5, validated)
				end
			end
		})

		setmetatable(v6, {
			__index = { _self = p3, _source = source }
		})
	end

	return v6
end

local ReactElement = {}

function ReactElement.jsx(_, _, _)
	error("JSX is currently unsupported")
end

function ReactElement.jsxDEV(_, _, _, _, _): nil
	error("JSX is currently unsupported")

	return nil
end

function ReactElement.createElement(value, data, ...)
	local props = data == nil and {} or table.clone(data)

	local key = nil
	local ref = nil
	local v6

	if data ~= nil then
		local v7

		if __DEV__ and data.ref ~= nil and type(data.ref) == "table" and data.ref.isReactWarning then
			v7 = false
		else
			v7 = data.ref ~= nil
		end

		if v7 then
			ref = data.ref

			if __DEV__ then
				warnIfStringRefCannotBeAutoConverted(data)
			end
		end

		local v8

		if __DEV__ and data.key ~= nil and type(data.key) == "table" and data.key.isReactWarning then
			v8 = false
		else
			v8 = data.key ~= nil
		end

		if v8 then
			key = data.key

			if type(key) ~= "number" then
				key = tostring(key)
			end
		end

		if data.__source ~= nil then
			v6 = data.__source
		end

		if props.key ~= nil then
			props.key = nil
		end

		if props.ref ~= nil then
			props.ref = nil
		end

		if props.__self ~= nil then
			props.__self = nil
		end

		if props.__source ~= nil then
			props.__source = nil
		end
	end

	local v7 = select("#", ...)

	if v7 == 1 then
		props.children = select(1, ...)
	elseif v7 > 1 then
		local children = table.create(v7)

		for i = 1, v7 do
			table.insert(children, (select(i, ...)))
		end

		if __DEV__ then
			table.freeze(children)
		end

		props.children = children
	end

	if type(value) == "table" and value.defaultProps then
		local defaultProps = value.defaultProps

		for k, _ in defaultProps do
			if props[k] == nil then
				props[k] = defaultProps[k]
			end
		end
	end

	if __DEV__ then
		if key or ref then
			local v8

			if type(value) == "function" then
				v8 = debug.info(value, "n") or "<function>"
			else
				v8 = type(value) == "table" and (value.displayName or value.name or "Unknown") or value
			end

			if key then
				defineKeyPropWarningGetter(props, v8)
			end

			if ref then
				defineRefPropWarningGetter(props, v8)
			end
		end

		v6 = v6 == nil and { fileName = debug.info(3, "s"), lineNumber = debug.info(3, "l") } or v6
	end

	return ReactElement2(value, key, ref, nil, v6, ReactCurrentOwner.current, props)
end

function ReactElement:cloneAndReplaceKey(p)
	return ReactElement2(self.type, p, self.ref, self._self, self._source, self._owner, self.props)
end

function ReactElement:cloneElement(p, ...)
	if self == nil then
		error(Error.new("React.cloneElement(...): The argument must be a React element, but you passed " .. tostring(nil)))
	end

	local props = self.props
	local props2 = props == nil and {} or table.clone(props)

	local v6 = self.key
	local v7 = self.ref

	local source = self._source

	local v8 = self._owner

	if p ~= nil then
		local ref = p.ref

		if ref == nil then
			if not __DEV__ or p.ref == nil or type(p.ref) ~= "table" or not p.ref.isReactWarning then
				local _ = p.ref == nil
			end
		else
			v8 = ReactCurrentOwner.current
			v7 = ref
		end

		local key = p.key

		if key == nil then
			if not __DEV__ or p.key == nil or type(p.key) ~= "table" or not p.key.isReactWarning then
				local _ = p.key == nil
			end
		elseif type(key) == "number" then
			v6 = key
		else
			v6 = key or "nil"
		end
	end

	local kind = self.type
	local defaultProps

	if type(kind) == "table" then
		defaultProps = kind.defaultProps
	end

	if p ~= nil then
		for k, _ in p do
			if p[k] == nil or v[k] then
				continue
			end

			if p[k] == nil and defaultProps ~= nil then
				props2[k] = defaultProps[k]
			else
				props2[k] = p[k]
			end
		end
	end

	local v9 = select("#", ...)

	if v9 == 1 then
		props2.children = select(1, ...)
	elseif v9 > 1 then
		props2.children = { ... }
	end

	return ReactElement2(self.type, v6, v7, nil, source, v8, props2)
end

function ReactElement.isValidElement(p): boolean
	return type(p) == "table" and p["$$typeof"] == REACT_ELEMENT_TYPE
end

return ReactElement
