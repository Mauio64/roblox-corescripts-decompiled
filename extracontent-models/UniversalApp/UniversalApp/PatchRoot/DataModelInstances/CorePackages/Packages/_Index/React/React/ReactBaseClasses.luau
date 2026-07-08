local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local Object = require(ParentParent.LuauPolyfill).Object
local console = require(ParentParent.Shared).console

require(ParentParent.Shared)

local ReactNoopUpdateQueue = require(script.Parent.ReactNoopUpdateQueue)
local t1 = {}
local __DEV__ = ReactGlobals.__DEV__
local __COMPAT_WARNINGS__ = ReactGlobals.__COMPAT_WARNINGS__

if __DEV__ then
	Object.freeze(t1)
end

local UninitializedState = require(ParentParent.Shared).UninitializedState
local t2 = {
	isReactComponent = true
}

local function trimPath(s1: string) -- line: 51
	local match = string.match(s1, "%.%u[%.%w]-$")

	if match then
		return string.gsub(match, "^%.", "")
	end

	return s1
end
local function warnAboutExistingLifecycle(p1, p2, p3) -- line: 65
	-- upvalues: console (copy)
	console.warn("%s already defined '%s', but it also defining the deprecated Roact method '%s'. %s should only implement one of these methods, preferably using the non-deprecated name.", p1, p3, p2, p1)
end
local function warnAboutDeprecatedLifecycleName(p4, p5, p6) -- line: 75
	-- upvalues: __DEV__ (copy), __COMPAT_WARNINGS__ (copy), console (copy)
	if __DEV__ and __COMPAT_WARNINGS__ then
		local v37, v38 = debug.info(3, "sln")
		local warn = console.warn
		local match = string.match(v37, "%.%u[%.%w]-$")

		warn("%s is using method '%s', which is no longer supported and should be updated to '%s'\nFile: %s:%s", p4, p5, p6, if not match then v37 else string.gsub(match, "^%.", ""), (tostring(v38)))
	end
end

local t3 = {
	didMount = "componentDidMount",
	shouldUpdate = "shouldComponentUpdate",
	willUpdate = "UNSAFE_componentWillUpdate",
	didUpdate = "componentDidUpdate",
	willUnmount = "componentWillUnmount"
}

local function handleNewLifecycle(p7, p8, p9) -- line: 97
	-- upvalues: t3 (copy), console (copy), __DEV__ (copy), __COMPAT_WARNINGS__ (copy)
	if t3[p8] ~= nil then
		if p7[t3[p8]] ~= nil then
			local __componentName = p7.__componentName
			local v45 = t3[p8]

			console.warn("%s already defined '%s', but it also defining the deprecated Roact method '%s'. %s should only implement one of these methods, preferably using the non-deprecated name.", __componentName, v45, p8, __componentName)
		elseif p8 == "willUpdate" and p7.componentWillUpdate then
			local __componentName = p7.__componentName

			console.warn("%s already defined '%s', but it also defining the deprecated Roact method '%s'. %s should only implement one of these methods, preferably using the non-deprecated name.", __componentName, "UNSAFE_componentWillUpdate", p8, __componentName)
		else
			local __componentName = p7.__componentName
			local v48 = t3[p8]

			if __DEV__ and __COMPAT_WARNINGS__ then
				local v49, v50 = debug.info(3, "sln")
				local warn = console.warn
				local match = string.match(v49, "%.%u[%.%w]-$")

				warn("%s is using method '%s', which is no longer supported and should be updated to '%s'\nFile: %s:%s", __componentName, p8, v48, if not match then v49 else string.gsub(match, "^%.", ""), (tostring(v50)))
			end
		end

		p8 = t3[p8]
	end

	rawset(p7, p8, p9)
end

local t4 = {
	__newindex = handleNewLifecycle,
	__index = t2,
	__tostring = function(p10) -- line: 127
		return p10.__componentName
	end
}
local v17 = setmetatable({
	__componentName = "Component"
}, t4)
local v18 = ReactGlobals.__TESTEZ_RUNNING_TEST__ and 0 or 900
local n1 = 1
local t5 = table.create(v18)

for _ = 1, v18 do
	table.insert(t5, {
		props = nil,
		context = nil,
		state = UninitializedState,
		__refs = t1,
		__updater = ReactNoopUpdateQueue
	})
end

local function setStateInInit(p11, p12, p13: nil) -- line: 163
	-- upvalues: __DEV__ (copy), console (copy), Object (copy)
	if __DEV__ and p13 ~= nil then
		console.warn("Received a `callback` argument to `setState` during initialization of \"%s\". The callback behavior is not supported when using `setState` in `init`.\n\nConsider defining similar behavior in a `compontentDidMount` method instead.", p11.__componentName)
	end

	local v57 = p12 and type(p12)

	if p12 == nil or v57 ~= "table" and v57 ~= "function" then
		error("setState(...): takes an object of state variables to update or a function which returns an object of state variables.")
	end

	local state = p11.state
	local v59 = if v57 ~= "function" then p12 else p12(state, p11.props)

	p11.state = Object.assign({}, state, v59)
end

function v17.extend(p14, p15) -- line: 203
	-- upvalues: __COMPAT_WARNINGS__ (copy), console (copy), n1 (ref), v18 (copy), t5 (copy), UninitializedState (copy), t1 (copy), ReactNoopUpdateQueue (copy), setStateInInit (copy)
	if p15 == nil then
		if __COMPAT_WARNINGS__ then
			console.warn("Component:extend() accepting no arguments is deprecated, and will not be supported in a future version of Roact. Please provide an explicit name.")
		end

		p15 = ""
	elseif type(p15) ~= "string" then
		error("Component class name must be a string")
	end

	local t6 = {
		init = nil,
		__componentName = p15,
		setState = p14.setState,
		forceUpdate = p14.forceUpdate
	}

	t6.__index = t6

	function t6.__ctor(p16, p17, p18) -- line: 237
		-- upvalues: n1 (ref), v18 (copy), t5 (copy), UninitializedState (copy), t1 (copy), ReactNoopUpdateQueue (copy), t6 (copy), setStateInInit (copy)
		local v74

		if n1 <= v18 then
			v74 = t5[n1]
			v74.props = p16
			v74.context = p17
			t5[n1] = nil
			n1 += 1
		else
			v74 = {
				props = p16,
				context = p17,
				state = UninitializedState,
				__refs = t1,
				__updater = p18 or ReactNoopUpdateQueue
			}
		end

		local v75 = setmetatable(v74, t6)

		if t6.init and type(t6.init) == "function" then
			v75.setState = setStateInInit
			t6.init(v75, p16, p17)
			v75.setState = nil
		end

		return v75
	end

	setmetatable(t6, (getmetatable(p14)))

	return t6
end
function v17.setState(p19, p20, p21) -- line: 329
	if p20 ~= nil and (type(p20) ~= "table" and type(p20) ~= "function") then
		error("setState(...): takes an object of state variables to update or a function which returns an object of state variables.")
	end

	p19.__updater.enqueueSetState(p19, p20, p21, "setState")
end
function v17.forceUpdate(p22, p23) -- line: 358
	p22.__updater.enqueueForceUpdate(p22, p23, "forceUpdate")
end

if __DEV__ then
	local t7 = {
		isMounted = {
			"isMounted",
			"Instead, make sure to clean up subscriptions and pending requests in componentWillUnmount to prevent memory leaks."
		},
		replaceState = {
			"replaceState",
			"Refactor your code to use setState instead (see https://github.com/facebook/react/issues/3236)."
		}
	}

	for v24, _ in t7 do
		if t7[v24] ~= nil then
			local v26 = t7[v24]

			v17[v24] = function() -- line: 383
				-- upvalues: console (copy), v26 (copy)
				console.warn("%s(...) is deprecated in plain JavaScript React classes. %s", v26[1], v26[2])

				return nil
			end
		end
	end
end

local v27 = v17:extend("PureComponent")

v27.extend = v17.extend

local t8 = {
	isReactComponent = true,
	isPureReactComponent = true
}

setmetatable(v27, {
	__newindex = handleNewLifecycle,
	__index = t8,
	__tostring = function(p24) -- line: 430
		return p24.__componentName
	end
})

return {
	Component = v17,
	PureComponent = v27
}
