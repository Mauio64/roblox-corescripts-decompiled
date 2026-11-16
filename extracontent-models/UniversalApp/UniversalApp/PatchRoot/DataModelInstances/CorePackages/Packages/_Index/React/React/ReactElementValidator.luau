local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local Shared = require(parent.Shared)
local console = Shared.console
local inspect = LuauPolyfill.util.inspect

require(parent.Shared)

local Shared2 = require(parent.Shared)
local isValidElementType = Shared2.isValidElementType
local Shared3 = require(parent.Shared)
local getComponentName = Shared3.getComponentName
local Shared4 = require(parent.Shared)
local ReactSymbols = Shared4.ReactSymbols
local getIteratorFn = ReactSymbols.getIteratorFn
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE

local Shared5 = require(parent.Shared)
local warnAboutSpreadingKeyToJSX = Shared5.ReactFeatureFlags.warnAboutSpreadingKeyToJSX
local Shared6 = require(parent.Shared)
local checkPropTypes = Shared6.checkPropTypes
local Shared7 = require(parent.Shared)
local ReactCurrentOwner = Shared7.ReactSharedInternals.ReactCurrentOwner

local ReactElement = require(script.Parent.ReactElement)
local isValidElement = ReactElement.isValidElement
local createElement = ReactElement.createElement
local cloneElement = ReactElement.cloneElement
local jsxDEV = ReactElement.jsxDEV

local Shared8 = require(parent.Shared)
local setExtraStackFrame = Shared8.ReactSharedInternals.ReactDebugCurrentFrame.setExtraStackFrame

local Shared9 = require(parent.Shared)
local describeUnknownElementTypeFrameInDEV = Shared9.ReactComponentStackFrame.describeUnknownElementTypeFrameInDEV

local function setCurrentlyValidatingElement(data)
	if ReactGlobals.__DEV__ then
		if data then
			local owner = data._owner
			local v

			if owner then
				v = owner.type
			end

			setExtraStackFrame((describeUnknownElementTypeFrameInDEV(data.type, data._source, v)))
		else
			setExtraStackFrame(nil)
		end
	end
end

local v

if ReactGlobals.__DEV__ then
	v = false
else
	v = nil
end

local function hasOwnProperty(p, p2): boolean
	return p[p2] ~= nil
end

local function getDeclarationErrorAddendum()
	local v2 = ReactCurrentOwner.current and getComponentName(ReactCurrentOwner.current.type)

	if v2 then
		return "\n\nCheck the render method of `" .. v2 .. "`."
	end

	return ""
end

local function getSourceInfoErrorAddendum(p)
	if p == nil then
		return ""
	end

	return "\n\nCheck your code at " .. string.gsub(p.fileName, "^.*[\\/]", "") .. ":" .. p.lineNumber .. "."
end

local function getSourceInfoErrorAddendumForProps(p)
	if p == nil then
		return ""
	end

	local __source = p.__source

	if __source == nil then
		return ""
	end

	return "\n\nCheck your code at " .. string.gsub(__source.fileName, "^.*[\\/]", "") .. ":" .. __source.lineNumber .. "."
end

local currentComponentErrorInfoSet = {}

local function getCurrentComponentErrorInfo(value)
	local v2 = ReactCurrentOwner.current and getComponentName(ReactCurrentOwner.current.type)

	local currentComponentErrorInfo = not v2 and "" or "\n\nCheck the render method of `" .. v2 .. "`."

	if Boolean.toJSBoolean(currentComponentErrorInfo) then
		return currentComponentErrorInfo
	end

	local v3

	if typeof(value) == "string" then
		v3 = value
	elseif typeof(value) == "table" then
		v3 = value.displayName or value.name
	end

	if not v3 and typeof(value) == "function" then
		v3 = debug.info(value, "n")

		if v3 == "" then
			v3 = nil
		end
	end

	if v3 then
		currentComponentErrorInfo = string.format("\n\nCheck the top-level render call using <%s>.", v3)
	end

	return currentComponentErrorInfo
end

local function validateExplicitKey(data, p, p2)
	if data._store == nil or data._store.validated then
		return
	end

	data._store.validated = true

	if (data.key ~= nil) ~= (p2 ~= nil) then
		return
	end

	local currentComponentErrorInfo = getCurrentComponentErrorInfo(p)

	if currentComponentErrorInfoSet[currentComponentErrorInfo] then
		return
	end

	currentComponentErrorInfoSet[currentComponentErrorInfo] = true

	local v2 = (not data or not data._owner or data._owner == ReactCurrentOwner.current) and ""
		or string.format(" It was passed a child from %s.", (tostring(getComponentName(data._owner.type))))

	if ReactGlobals.__DEV__ then
		if ReactGlobals.__DEV__ then
			if data then
				local owner = data._owner
				local v3

				if owner then
					v3 = owner.type
				end

				setExtraStackFrame((describeUnknownElementTypeFrameInDEV(data.type, data._source, v3)))
			else
				setExtraStackFrame(nil)
			end
		end

		if data.key == nil or p2 == nil then
			console.error(
				"Each child in a list should have a unique \"key\" prop.%s%s See https://reactjs.org/link/warning-keys for more information.",
				currentComponentErrorInfo,
				v2
			)
		else
			console.error(
				"Child element received a \"key\" prop (\"%s\") in addition to a key in the \"children\" table of its parent (\"%s\"). Please provide only one key definition. When both are present, the \"key\" prop will take precedence.%s%s See https://reactjs.org/link/warning-keys for more information.",
				tostring(data.key),
				tostring(p2),
				currentComponentErrorInfo,
				v2
			)
		end

		if ReactGlobals.__DEV__ then
			setExtraStackFrame(nil)
		end
	end
end

local function validateChildKeys(p, p2)
	if typeof(p) ~= "table" then
		return
	end

	if Array.isArray(p) then
		for i = 1, #p do
			local v2 = p[i]

			if isValidElement(v2) then
				validateExplicitKey(v2, p2)
			end
		end
	elseif isValidElement(p) then
		if p._store then
			p._store.validated = true
		end
	elseif p then
		local iteratorFn = getIteratorFn(p)

		if typeof(iteratorFn) == "function" and iteratorFn ~= p.entries then
			local v2 = iteratorFn(p)
			local v3 = v2.next()

			while not v3.done do
				if isValidElement(v3.value) then
					validateExplicitKey(v3.value, p2, v3.key)
				end

				v3 = v2.next()
			end
		end
	end
end

local function validatePropTypes(p)
	if ReactGlobals.__DEV__ or ReactGlobals.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		local kind = p.type

		if kind == nil or typeof(kind) == "string" or typeof(kind) == "function" or typeof(kind) ~= "table" then
			return
		end

		local propTypes = kind.propTypes
		local validateProps = kind.validateProps

		if propTypes or validateProps then
			local componentName = getComponentName(kind)

			checkPropTypes(propTypes, validateProps, p.props, "prop", componentName, p)
		elseif kind.PropTypes ~= nil and not v then
			v = true

			local componentName = getComponentName(kind)
			console.error(
				"Component %s declared `PropTypes` instead of `propTypes`. Did you misspell the property assignment?",
				componentName or "Unknown"
			)
		end

		if kind.getDefaultProps ~= nil then
			console.error("getDefaultProps is only used on classic React.createClass definitions. Use a static property named `defaultProps` instead.")
		end
	end
end

local function validateFragmentProps(data)
	if ReactGlobals.__DEV__ then
		local keys = Object.keys(data.props)

		for i = 1, #keys do
			local key = keys[i]

			if key ~= "children" and key ~= "key" then
				if ReactGlobals.__DEV__ then
					if data then
						local owner = data._owner
						local v2

						if owner then
							v2 = owner.type
						end

						setExtraStackFrame((describeUnknownElementTypeFrameInDEV(data.type, data._source, v2)))
					else
						setExtraStackFrame(nil)
					end
				end

				console.error(
					"Invalid prop `%s` supplied to `React.Fragment`. React.Fragment can only have `key` and `children` props.",
					key
				)

				if not ReactGlobals.__DEV__ then
					break
				end

				setExtraStackFrame(nil)
				break
			end
		end

		if data.ref ~= nil then
			if ReactGlobals.__DEV__ then
				if data then
					local owner = data._owner
					local v2

					if owner then
						v2 = owner.type
					end

					setExtraStackFrame((describeUnknownElementTypeFrameInDEV(data.type, data._source, v2)))
				else
					setExtraStackFrame(nil)
				end
			end

			console.error("Invalid attribute `ref` supplied to `React.Fragment`.")

			if ReactGlobals.__DEV__ then
				setExtraStackFrame(nil)
			end
		end
	end
end

local function jsxWithValidation(p, p2, p3, p4, p5, p6)
	local validElementType = isValidElementType(p)

	if not validElementType then
		local v2 = ""

		if p == nil or typeof(p) == "table" and #Object.keys(p) == 0 then
			v2 ..= " You likely forgot to export your component from the file it's defined in, or you might have mixed up default and named imports."
		end

		local v3 = p5 == nil and ""
			or "\n\nCheck your code at " .. string.gsub(p5.fileName, "^.*[\\/]", "") .. ":" .. p5.lineNumber .. "."
		local v4

		if v3 then
			v4 = v2 .. v3
		else
			local v5 = ReactCurrentOwner.current and getComponentName(ReactCurrentOwner.current.type)

			v4 = v2 .. (not v5 and "" or "\n\nCheck the render method of `" .. v5 .. "`.")
		end

		local v5

		if p == nil then
			v5 = "nil"
		elseif Array.isArray(p) then
			v5 = "array"
		elseif typeof(p) == "table" and p["$$typeof"] == REACT_ELEMENT_TYPE then
			v5 = string.format("<%s />", getComponentName(p.type) or "Unknown")
			v4 ..= " Did you accidentally export a JSX literal or Element instead of a component?"
		else
			v5 = typeof(p)
			v4 ..= "\n" .. inspect(p)
		end

		if ReactGlobals.__DEV__ then
			console.error(
				"React.jsx: type is invalid -- expected a string (for built-in components) or a class/function (for composite components) but got: %s.%s",
				v5,
				v4
			)
		end
	end

	local v2 = jsxDEV(p, p2, p3, p5, p6)

	if v2 == nil then
		return nil
	end

	if validElementType then
		local children = p2.children

		if children ~= nil then
			if p4 then
				if Array.isArray(children) then
					for i = 1, #children do
						validateChildKeys(children[i], p)
					end

					Object.freeze(children)
				elseif ReactGlobals.__DEV__ then
					console.error("React.jsx: Static children should always be an array. You are likely explicitly calling React.jsxs or React.jsxDEV. Use the Babel transform instead.")
				end
			else
				validateChildKeys(children, p)
			end
		end
	end

	if ReactGlobals.__DEV__ and warnAboutSpreadingKeyToJSX and p2.key ~= nil then
		console.error(
			"React.jsx: Spreading a key to JSX is a deprecated pattern. Explicitly pass a key after spreading props in your JSX call. E.g. <%s {...props} key={key} />",
			getComponentName(p) or "ComponentName"
		)
	end

	if p == REACT_FRAGMENT_TYPE then
		validateFragmentProps(v2)
		return v2
	end

	validatePropTypes(v2)

	return v2
end

local ReactElementValidator = {}
ReactElementValidator.jsxWithValidation = jsxWithValidation

function ReactElementValidator.jsxWithValidationStatic(p, p2, p3)
	return jsxWithValidation(p, p2, p3, true)
end

function ReactElementValidator.jsxWithValidationDynamic(p, p2, p3)
	return jsxWithValidation(p, p2, p3, false)
end

function ReactElementValidator.createElementWithValidation(p, p2, ...)
	local validElementType = isValidElementType(p)

	if not validElementType then
		local v2 = ""

		if p == nil or typeof(p) == "table" and #Object.keys(p) == 0 then
			v2 ..= " You likely forgot to export your component from the file it's defined in, or you might have mixed up default and named imports."
		end

		local v3

		if p2 == nil then
			v3 = ""
		else
			local __source = p2.__source
			v3 = __source == nil and ""
				or "\n\nCheck your code at " .. string.gsub(__source.fileName, "^.*[\\/]", "") .. ":" .. __source.lineNumber .. "."
		end

		local v4

		if v3 then
			v4 = v2 .. v3
		else
			local v5 = ReactCurrentOwner.current and getComponentName(ReactCurrentOwner.current.type)

			v4 = v2 .. (not v5 and "" or "\n\nCheck the render method of `" .. v5 .. "`.")
		end

		local v5

		if p == nil then
			v5 = "nil"
		elseif Array.isArray(p) then
			v5 = "array"
		elseif p == nil or typeof(p) ~= "table" or p["$$typeof"] ~= REACT_ELEMENT_TYPE then
			v5 = typeof(p)

			if p ~= nil then
				v4 ..= "\n" .. inspect(p)
			end
		else
			v5 = string.format("<%s />", getComponentName(p.type) or "Unknown")

			v4 ..= " Did you accidentally export a JSX literal or Element instead of a component?"
		end

		if ReactGlobals.__DEV__ then
			console.error(
				"React.createElement: type is invalid -- expected a string (for built-in components) or a class/function (for composite components) but got: %s.%s",
				v5,
				v4
			)
		end
	end

	local element = createElement(p, p2, ...)

	if element == nil then
		return nil
	end

	if validElementType then
		for i = 1, select("#", ...) do
			validateChildKeys(select(i, ...), p)
		end
	end

	if p == REACT_FRAGMENT_TYPE then
		validateFragmentProps(element)
		return element
	end

	validatePropTypes(element)

	return element
end

function ReactElementValidator.cloneElementWithValidation(p, p2, ...)
	local v2 = { p, p2, ... }
	local element = cloneElement(p, p2, ...)

	for i = 3, #v2 do
		validateChildKeys(v2[i], element.type)
	end

	validatePropTypes(element)
	return element
end

return ReactElementValidator
