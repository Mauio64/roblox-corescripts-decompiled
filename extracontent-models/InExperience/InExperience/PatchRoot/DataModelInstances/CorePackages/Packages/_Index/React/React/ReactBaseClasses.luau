local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local Shared = require(parent.Shared)
local console = Shared.console

local Shared2 = require(parent.Shared)
local enableAllocationTrims = Shared2.ReactFeatureFlags.enableAllocationTrims

local ReactNoopUpdateQueue = require(script.Parent.ReactNoopUpdateQueue)
local refs = {}

local __DEV__ = ReactGlobals.__DEV__
local __COMPAT_WARNINGS__ = ReactGlobals.__COMPAT_WARNINGS__

if __DEV__ then
	Object.freeze(refs)
end

local Shared3 = require(parent.Shared)
local UninitializedState = Shared3.UninitializedState

local function trimPath(value: string)
	local v = string.match(value, "%.%u[%.%w]-$")

	if v then
		return string.gsub(v, "^%.", "")
	end

	return value
end

local function warnAboutExistingLifecycle(p, p2, p3)
	console.warn(
		"%s already defined '%s', but it also defining the deprecated Roact method '%s'. %s should only implement one of these methods, preferably using the non-deprecated name.",
		p,
		p3,
		p2,
		p
	)
end

local function warnAboutDeprecatedLifecycleName(p, p2, p3)
	if __DEV__ and __COMPAT_WARNINGS__ then
		local v, v2 = debug.info(3, "sln")
		local Warn = console.warn
		local v3 = string.match(v, "%.%u[%.%w]-$")

		if v3 then
			v = string.gsub(v3, "^%.", "")
		end

		Warn(
			"%s is using method '%s', which is no longer supported and should be updated to '%s'\nFile: %s:%s",
			p,
			p2,
			p3,
			v,
			(tostring(v2))
		)
	end
end

local v = {
	didMount = "componentDidMount",
	shouldUpdate = "shouldComponentUpdate",
	willUpdate = "UNSAFE_componentWillUpdate",
	didUpdate = "componentDidUpdate",
	willUnmount = "componentWillUnmount"
}

local function handleNewLifecycle(p, p2, p3)
	if v[p2] ~= nil then
		if p[v[p2]] == nil then
			if p2 == "willUpdate" and p.componentWillUpdate then
				local __componentName = p.__componentName
				console.warn(
					"%s already defined '%s', but it also defining the deprecated Roact method '%s'. %s should only implement one of these methods, preferably using the non-deprecated name.",
					__componentName,
					"UNSAFE_componentWillUpdate",
					"willUpdate",
					__componentName
				)
			else
				local __componentName = p.__componentName

				local v2 = v[p2]

				if __DEV__ and __COMPAT_WARNINGS__ then
					local v3, v4 = debug.info(3, "sln")
					local Warn = console.warn
					local v5 = string.match(v3, "%.%u[%.%w]-$")

					if v5 then
						v3 = string.gsub(v5, "^%.", "")
					end

					Warn(
						"%s is using method '%s', which is no longer supported and should be updated to '%s'\nFile: %s:%s",
						__componentName,
						p2,
						v2,
						v3,
						(tostring(v4))
					)
				end
			end
		else
			local __componentName = p.__componentName
			local v2 = v[p2]
			console.warn(
				"%s already defined '%s', but it also defining the deprecated Roact method '%s'. %s should only implement one of these methods, preferably using the non-deprecated name.",
				__componentName,
				v2,
				p2,
				__componentName
			)
		end

		p2 = v[p2]
	end

	rawset(p, p2, p3)
end

local object = setmetatable({ __componentName = "Component" }, {
	__newindex = handleNewLifecycle,
	__index = { isReactComponent = true },
	__tostring = function(p)
		return p.__componentName
	end
})

local v2 = ReactGlobals.__TESTEZ_RUNNING_TEST__ and 0 or 900

local v3 = table.create(v2)
local v4 = 1

for _ = 1, v2 do
	table.insert(v3, {
		props = nil,
		context = nil,
		state = UninitializedState,
		__refs = refs,
		__updater = ReactNoopUpdateQueue
	})
end

local function setStateInInit(state, callback, p: nil)
	if __DEV__ and p ~= nil then
		console.warn(
			"Received a `callback` argument to `setState` during initialization of \"%s\". The callback behavior is not supported when using `setState` in `init`.\n\nConsider defining similar behavior in a `compontentDidMount` method instead.",
			state.__componentName
		)
	end

	local typeName = callback and type(callback)

	if callback == nil or typeName ~= "table" and typeName ~= "function" then
		error("setState(...): takes an object of state variables to update or a function which returns an object of state variables.")
	end

	local state2 = state.state

	if typeName == "function" then
		callback = callback(state2, state.props)
	end

	if not enableAllocationTrims then
		state.state = Object.assign({}, state2, callback)

		return
	end

	local state3

	if type(state2) == "table" and getmetatable(state2) == nil then
		state3 = Object.assign(table.clone(state2), callback)
	else
		state3 = Object.assign({}, state2, callback)
	end

	state.state = state3
end

function object:extend(componentName)
	if componentName == nil then
		if __COMPAT_WARNINGS__ then
			console.warn("Component:extend() accepting no arguments is deprecated, and will not be supported in a future version of Roact. Please provide an explicit name.")
		end

		componentName = ""
	elseif type(componentName) ~= "string" then
		error("Component class name must be a string")
	end

	local v5 = {
		__componentName = componentName,
		setState = self.setState,
		forceUpdate = self.forceUpdate,
		init = nil
	}

	v5.__index = v5

	function v5.__ctor(props, context, p)
		local v6

		if v4 <= v2 then
			v6 = v3[v4]

			v6.props = props
			v6.context = context

			v3[v4] = nil
			v4 += 1
		else
			v6 = {
				props = props,
				context = context,
				state = UninitializedState,
				__refs = refs,
				__updater = p or ReactNoopUpdateQueue
			}
		end

		local object2 = setmetatable(v6, v5)

		if v5.init and type(v5.init) == "function" then
			object2.setState = setStateInInit

			v5.init(object2, props, context)

			object2.setState = nil
		end

		return object2
	end

	setmetatable(v5, (getmetatable(self)))

	return v5
end

function object:setState(value, p)
	if value ~= nil and type(value) ~= "table" and type(value) ~= "function" then
		error("setState(...): takes an object of state variables to update or a function which returns an object of state variables.")
	end

	self.__updater.enqueueSetState(self, value, p, "setState")
end

function object:forceUpdate(p)
	self.__updater.enqueueForceUpdate(self, p, "forceUpdate")
end

if __DEV__ then
	local v5 = {
		isMounted = {
			"isMounted",
			"Instead, make sure to clean up subscriptions and pending requests in componentWillUnmount to prevent memory leaks."
		},
		replaceState = {
			"replaceState",
			"Refactor your code to use setState instead (see https://github.com/facebook/react/issues/3236)."
		}
	}

	for k, _ in v5 do
		if v5[k] == nil then
			continue
		end

		local v6 = v5[k]

		object[k] = function(): nil
			console.warn("%s(...) is deprecated in plain JavaScript React classes. %s", v6[1], v6[2])

			return nil
		end
	end
end

local extended = object:extend("PureComponent")

extended.extend = object.extend

setmetatable(extended, {
	__newindex = handleNewLifecycle,
	__index = { isReactComponent = true, isPureReactComponent = true },
	__tostring = function(p)
		return p.__componentName
	end
})

return { Component = object, PureComponent = extended }
