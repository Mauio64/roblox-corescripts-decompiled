local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local console = require(ParentParent.Shared).console
local inspect = LuauPolyfill.util.inspect

require(ParentParent.Shared)

local isValidElementType = require(ParentParent.Shared).isValidElementType
local getComponentName = require(ParentParent.Shared).getComponentName
local ReactSymbols = require(ParentParent.Shared).ReactSymbols
local getIteratorFn = ReactSymbols.getIteratorFn
local _ = ReactSymbols.REACT_FORWARD_REF_TYPE
local _ = ReactSymbols.REACT_MEMO_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
local REACT_ELEMENT_TYPE = ReactSymbols.REACT_ELEMENT_TYPE
local warnAboutSpreadingKeyToJSX = require(ParentParent.Shared).ReactFeatureFlags.warnAboutSpreadingKeyToJSX
local checkPropTypes = require(ParentParent.Shared).checkPropTypes
local ReactCurrentOwner = require(ParentParent.Shared).ReactSharedInternals.ReactCurrentOwner
local ReactElement = require(script.Parent.ReactElement)
local isValidElement = ReactElement.isValidElement
local createElement = ReactElement.createElement
local cloneElement = ReactElement.cloneElement
local jsxDEV = ReactElement.jsxDEV
local setExtraStackFrame = require(ParentParent.Shared).ReactSharedInternals.ReactDebugCurrentFrame.setExtraStackFrame
local describeUnknownElementTypeFrameInDEV = require(ParentParent.Shared).ReactComponentStackFrame.describeUnknownElementTypeFrameInDEV
local t1 = {}

local function setCurrentlyValidatingElement(p1) -- line: 64
	-- upvalues: ReactGlobals (copy), describeUnknownElementTypeFrameInDEV (copy), setExtraStackFrame (copy)
	if ReactGlobals.__DEV__ then
		if p1 then
			local _owner = p1._owner
			local type = nil

			if _owner then
				type = _owner.type
			end

			local v44 = describeUnknownElementTypeFrameInDEV(p1.type, p1._source, type)

			setExtraStackFrame(v44)

			return
		end

		setExtraStackFrame(nil)
	end
end

local u29 = nil

if ReactGlobals.__DEV__ then
	u29 = false
end

local function hasOwnProperty(p2, p3) -- line: 92
	return p2[p3] ~= nil
end
local function getDeclarationErrorAddendum() -- line: 96
	-- upvalues: ReactCurrentOwner (copy), getComponentName (copy)
	if ReactCurrentOwner.current then
		local v47 = getComponentName(ReactCurrentOwner.current.type)

		if v47 then
			return "\n\nCheck the render method of `" .. v47 .. "`."
		end
	end

	return ""
end
local function getSourceInfoErrorAddendum(p4) -- line: 107
	if p4 ~= nil then
		return "\n\nCheck your code at " .. string.gsub(p4.fileName, "^.*[\\/]", "") .. ":" .. p4.lineNumber .. "."
	end

	return ""
end
local function getSourceInfoErrorAddendumForProps(p5) -- line: 117
	if p5 ~= nil then
		local __source = p5.__source

		if __source ~= nil then
			return "\n\nCheck your code at " .. string.gsub(__source.fileName, "^.*[\\/]", "") .. ":" .. __source.lineNumber .. "."
		end

		return ""
	end

	return ""
end

local t2 = {}

local function getCurrentComponentErrorInfo(p6) -- line: 134
	-- upvalues: ReactCurrentOwner (copy), getComponentName (copy), Boolean (copy)
	local g52 = nil
	local v53 = nil
	local v54 = nil

	repeat
		if g52 or ReactCurrentOwner.current then
			if not g52 then
				v53 = getComponentName(ReactCurrentOwner.current.type)
			end

			if g52 or v53 then
				if not g52 then
					v54 = "\n\nCheck the render method of `" .. v53 .. "`."
				end

				g52 = false

				if not Boolean.toJSBoolean(v54) then
					local v55 = if typeof(p6) ~= "string" then if typeof(p6) ~= "table" then nil else p6.displayName or p6.name else p6

					if not v55 and typeof(p6) == "function" then
						local v56 = debug.info(p6, "n")

						v55 = if v56 == "" then nil else v56
					end

					if v55 then
						v54 = string.format("\n\nCheck the top-level render call using <%s>.", v55)
					end
				end

				return v54
			end
		end

		v54 = ""
		g52 = true
	until not g52
end
local function validateExplicitKey(p7, p8, p9) -- line: 176
	-- upvalues: getCurrentComponentErrorInfo (copy), t2 (copy), ReactCurrentOwner (copy), getComponentName (copy), ReactGlobals (copy), describeUnknownElementTypeFrameInDEV (copy), setExtraStackFrame (copy), console (copy)
	if p7._store == nil or p7._store.validated then
		return
	end

	p7._store.validated = true

	if p7.key ~= nil ~= (p9 ~= nil) then
		return
	end

	local v60 = getCurrentComponentErrorInfo(p8)

	if t2[v60] then
		return
	end

	t2[v60] = true

	local s1 = ""

	if p7 and p7._owner and p7._owner ~= ReactCurrentOwner.current then
		s1 = string.format(" It was passed a child from %s.", (tostring(getComponentName(p7._owner.type))))
	end

	if ReactGlobals.__DEV__ then
		if ReactGlobals.__DEV__ then
			if p7 then
				local _owner = p7._owner
				local type = nil

				if _owner then
					type = _owner.type
				end

				local v64 = describeUnknownElementTypeFrameInDEV(p7.type, p7._source, type)

				setExtraStackFrame(v64)
			else
				setExtraStackFrame(nil)
			end
		end

		if p7.key ~= nil and p9 ~= nil then
			console.error("Child element received a \"key\" prop (\"%s\") in addition to a key in the \"children\" table of its parent (\"%s\"). Please provide only one key definition. When both are present, the \"key\" prop will take precedence.%s%s See https://reactjs.org/link/warning-keys for more information.", tostring(p7.key), tostring(p9), v60, s1)
		else
			console.error("Each child in a list should have a unique \"key\" prop.%s%s See https://reactjs.org/link/warning-keys for more information.", v60, s1)
		end

		if ReactGlobals.__DEV__ then
			setExtraStackFrame(nil)
		end
	end
end
local function validateChildKeys(p10, p11) -- line: 251
	-- upvalues: Array (copy), isValidElement (copy), validateExplicitKey (copy), getIteratorFn (copy)
	if typeof(p10) ~= "table" then
		return
	end

	if Array.isArray(p10) then
		for i = 1, #p10 do
			local v68 = p10[i]

			if isValidElement(v68) then
				validateExplicitKey(v68, p11)
			end
		end

		return
	end

	if isValidElement(p10) then
		if p10._store then
			p10._store.validated = true

			return
		end
	elseif p10 then
		local v69 = getIteratorFn(p10)

		if typeof(v69) == "function" and v69 ~= p10.entries then
			local v70 = v69(p10)
			local v71 = v70.next()

			while not v71.done do
				if isValidElement(v71.value) then
					validateExplicitKey(v71.value, p11, v71.key)
				end

				v71 = v70.next()
			end
		end
	end
end
local function validatePropTypes(p12) -- line: 294
	-- upvalues: ReactGlobals (copy), getComponentName (copy), checkPropTypes (copy), u29 (ref), console (copy)
	if ReactGlobals.__DEV__ or ReactGlobals.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		local type = p12.type

		if type == nil or typeof(type) == "string" then
			return
		end

		if typeof(type) == "function" then
			return
		end

		if typeof(type) ~= "table" then
			return
		end

		local propTypes = type.propTypes
		local validateProps = type.validateProps

		if propTypes or validateProps then
			local v76 = getComponentName(type)

			checkPropTypes(propTypes, validateProps, p12.props, "prop", v76, p12)
		elseif type.PropTypes ~= nil and not u29 then
			u29 = true

			local v77 = getComponentName(type)

			console.error("Component %s declared `PropTypes` instead of `propTypes`. Did you misspell the property assignment?", v77 or "Unknown")
		end

		if type.getDefaultProps ~= nil then
			console.error("getDefaultProps is only used on classic React.createClass definitions. Use a static property named `defaultProps` instead.")
		end
	end
end
local function validateFragmentProps(p13) -- line: 347
	-- upvalues: ReactGlobals (copy), Object (copy), describeUnknownElementTypeFrameInDEV (copy), setExtraStackFrame (copy), console (copy)
	if ReactGlobals.__DEV__ then
		local v79 = Object.keys(p13.props)

		for i = 1, #v79 do
			local v81 = v79[i]

			if v81 ~= "children" and v81 ~= "key" then
				if ReactGlobals.__DEV__ then
					if p13 then
						local _owner = p13._owner
						local type = nil

						if _owner then
							type = _owner.type
						end

						local v84 = describeUnknownElementTypeFrameInDEV(p13.type, p13._source, type)

						setExtraStackFrame(v84)
					else
						setExtraStackFrame(nil)
					end
				end

				console.error("Invalid prop `%s` supplied to `React.Fragment`. React.Fragment can only have `key` and `children` props.", v81)

				if not ReactGlobals.__DEV__ then
					break
				end

				setExtraStackFrame(nil)

				break
			end
		end

		if p13.ref ~= nil then
			if ReactGlobals.__DEV__ then
				if p13 then
					local _owner = p13._owner
					local type = nil

					if _owner then
						type = _owner.type
					end

					local v87 = describeUnknownElementTypeFrameInDEV(p13.type, p13._source, type)

					setExtraStackFrame(v87)
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
local function jsxWithValidation(p14, p15, p16, p17, p18, p19) -- line: 373
	-- upvalues: isValidElementType (copy), Object (copy), ReactCurrentOwner (copy), getComponentName (copy), Array (copy), REACT_ELEMENT_TYPE (copy), inspect (copy), ReactGlobals (copy), console (copy), jsxDEV (copy), validateChildKeys (copy), warnAboutSpreadingKeyToJSX (copy), REACT_FRAGMENT_TYPE (copy), validateFragmentProps (copy), validatePropTypes (copy)
	local v94 = isValidElementType(p14)
	local g95 = nil
	local g102 = nil
	local g103 = nil
	local v104 = nil
	local v105 = nil
	local v101 = nil

	repeat
		if g95 or v94 then
			g95 = false

			local v96 = jsxDEV(p14, p15, p16, p18, p19)

			if v96 == nil then
				return v96
			end

			if v94 then
				local children = p15.children

				if children ~= nil then
					if p17 then
						if Array.isArray(children) then
							for i = 1, #children do
								validateChildKeys(children[i], p14)
							end

							Object.freeze(children)
						elseif ReactGlobals.__DEV__ then
							console.error("React.jsx: Static children should always be an array. You are likely explicitly calling React.jsxs or React.jsxDEV. Use the Babel transform instead.")
						end
					else
						validateChildKeys(children, p14)
					end
				end
			end

			if ReactGlobals.__DEV__ and warnAboutSpreadingKeyToJSX and p15.key ~= nil then
				console.error("React.jsx: Spreading a key to JSX is a deprecated pattern. Explicitly pass a key after spreading props in your JSX call. E.g. <%s {...props} key={key} />", getComponentName(p14) or "ComponentName")
			end

			if p14 == REACT_FRAGMENT_TYPE then
				validateFragmentProps(v96)

				return v96
			end

			validatePropTypes(v96)

			return v96
		end

		local s2 = ""

		if p14 == nil or typeof(p14) == "table" and #Object.keys(p14) == 0 then
			s2 ..= " You likely forgot to export your component from the file it's defined in, or you might have mixed up default and named imports."
		end

		local v100 = p18 == nil and "" or "\n\nCheck your code at " .. string.gsub(p18.fileName, "^.*[\\/]", "") .. ":" .. p18.lineNumber .. "."

		if v100 then
			v101 = s2 .. v100
			g102 = true
		end

		repeat
			if g102 or (g103 or ReactCurrentOwner.current) then
				if not g102 then
					if not g103 then
						v104 = getComponentName(ReactCurrentOwner.current.type)
					end
				end

				if g102 or (g103 or v104) then
					if not g102 then
						if not g103 then
							v105 = "\n\nCheck the render method of `" .. v104 .. "`."
						end

						g103 = false
						v101 = s2 .. v105
					end

					g102 = false

					local s3

					if p14 == nil then
						s3 = "nil"
					elseif Array.isArray(p14) then
						s3 = "array"
					elseif typeof(p14) == "table" and p14["$$typeof"] == REACT_ELEMENT_TYPE then
						s3 = string.format("<%s />", getComponentName(p14.type) or "Unknown")
						v101 ..= " Did you accidentally export a JSX literal or Element instead of a component?"
					else
						s3 = typeof(p14)
						v101 ..= "\n" .. inspect(p14)
					end

					if ReactGlobals.__DEV__ then
						console.error("React.jsx: type is invalid -- expected a string (for built-in components) or a class/function (for composite components) but got: %s.%s", s3, v101)
					end

					g95 = true
				end
			end

			if g95 then
				break
			end

			v105 = ""
			g103 = true
		until not g103
	until not g95
end

t1.jsxWithValidation = jsxWithValidation

function t1.jsxWithValidationStatic(p20, p21, p22) -- line: 495
	-- upvalues: jsxWithValidation (copy)
	return (jsxWithValidation(p20, p21, p22, true))
end
function t1.jsxWithValidationDynamic(p23, p24, p25) -- line: 499
	-- upvalues: jsxWithValidation (copy)
	return (jsxWithValidation(p23, p24, p25, false))
end
function t1.createElementWithValidation(p26, p27, ...) -- line: 504
	-- upvalues: isValidElementType (copy), Object (copy), ReactCurrentOwner (copy), getComponentName (copy), Array (copy), REACT_ELEMENT_TYPE (copy), inspect (copy), ReactGlobals (copy), console (copy), createElement (copy), validateChildKeys (copy), REACT_FRAGMENT_TYPE (copy), validateFragmentProps (copy), validatePropTypes (copy)
	local v115 = isValidElementType(p26)
	local g116 = nil
	local g123 = nil
	local g124 = nil
	local v125 = nil
	local v126 = nil
	local v122 = nil

	repeat
		if g116 or v115 then
			g116 = false

			local v117 = createElement(p26, p27, ...)

			if v117 == nil then
				return v117
			end

			if v115 then
				for i = 1, select("#", ...) do
					validateChildKeys(select(i, ...), p26)
				end
			end

			if p26 == REACT_FRAGMENT_TYPE then
				validateFragmentProps(v117)

				return v117
			end

			validatePropTypes(v117)

			return v117
		end

		local s4 = ""

		if p26 == nil or typeof(p26) == "table" and #Object.keys(p26) == 0 then
			s4 ..= " You likely forgot to export your component from the file it's defined in, or you might have mixed up default and named imports."
		end

		local v121

		if p27 ~= nil then
			local __source = p27.__source

			v121 = __source == nil and "" or "\n\nCheck your code at " .. string.gsub(__source.fileName, "^.*[\\/]", "") .. ":" .. __source.lineNumber .. "."
		else
			v121 = ""
		end

		if v121 then
			v122 = s4 .. v121
			g123 = true
		end

		repeat
			if g123 or (g124 or ReactCurrentOwner.current) then
				if not g123 then
					if not g124 then
						v125 = getComponentName(ReactCurrentOwner.current.type)
					end
				end

				if g123 or (g124 or v125) then
					if not g123 then
						if not g124 then
							v126 = "\n\nCheck the render method of `" .. v125 .. "`."
						end

						g124 = false
						v122 = s4 .. v126
					end

					g123 = false

					local s5

					if p26 == nil then
						s5 = "nil"
					elseif Array.isArray(p26) then
						s5 = "array"
					elseif p26 ~= nil and typeof(p26) == "table" and p26["$$typeof"] == REACT_ELEMENT_TYPE then
						s5 = string.format("<%s />", getComponentName(p26.type) or "Unknown")
						v122 ..= " Did you accidentally export a JSX literal or Element instead of a component?"
					else
						s5 = typeof(p26)

						if p26 ~= nil then
							v122 ..= "\n" .. inspect(p26)
						end
					end

					if ReactGlobals.__DEV__ then
						console.error("React.createElement: type is invalid -- expected a string (for built-in components) or a class/function (for composite components) but got: %s.%s", s5, v122)
					end

					g116 = true
				end
			end

			if g116 then
				break
			end

			v126 = ""
			g124 = true
		until not g124
	until not g116
end
function t1.cloneElementWithValidation(p28, p29, ...) -- line: 637
	-- upvalues: cloneElement (copy), validateChildKeys (copy), validatePropTypes (copy)
	local t3 = {
		p28,
		p29,
		...
	}
	local v131 = cloneElement(p28, p29, ...)

	for i = 3, #t3 do
		validateChildKeys(t3[i], v131.type)
	end

	validatePropTypes(v131)

	return v131
end

return t1
