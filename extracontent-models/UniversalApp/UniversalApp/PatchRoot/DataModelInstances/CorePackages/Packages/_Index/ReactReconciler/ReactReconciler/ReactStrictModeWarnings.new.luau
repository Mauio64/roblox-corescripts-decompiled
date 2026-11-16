local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Shared = require(parent.Shared)
local console = Shared.console

require(script.Parent.ReactInternalTypes)

local ReactCurrentFiber = require(script.Parent.ReactCurrentFiber)
local resetCurrentFiber = ReactCurrentFiber.resetCurrentFiber
local setCurrentFiber = ReactCurrentFiber.setCurrentFiber
local Shared2 = require(parent.Shared)
local getComponentName = Shared2.getComponentName
local ReactTypeOfMode = require(script.Parent.ReactTypeOfMode)
local StrictMode = ReactTypeOfMode.StrictMode

local New = {
	recordUnsafeLifecycleWarnings = function(_, _) end,
	flushPendingUnsafeLifecycleWarnings = function() end,
	recordLegacyContextWarning = function(_, _) end,
	flushLegacyContextWarning = function() end,
	discardPendingWarnings = function() end
}

local function fn(p) -- 1 equivalent call inferred from this helper
	local v = nil

	while p ~= nil do
		if bit32.band(p.mode, StrictMode) ~= 0 then
			v = p
		end

		p = p.return_
	end

	return v
end

if not ReactGlobals.__DEV__ then
	return New
end

local function fn2(items)
	local v = {}

	for k, _ in items do
		table.insert(v, k)
	end

	table.sort(v)
	return table.concat(v, ", ")
end

local v = {}
local v2 = {}
local v3 = {}
local v4 = {}
local v5 = {}
local v6 = {}

local typeSet = {}

function New.recordUnsafeLifecycleWarnings(p, data)
	if typeSet[p.type] then
		return
	end

	if typeof(data.componentWillMount) == "function" then
		table.insert(v, p)
	end

	if bit32.band(p.mode, StrictMode) ~= 0 and typeof(data.UNSAFE_componentWillMount) == "function" then
		table.insert(v2, p)
	end

	if typeof(data.componentWillReceiveProps) == "function" then
		table.insert(v3, p)
	end

	if bit32.band(p.mode, StrictMode) ~= 0 and typeof(data.UNSAFE_componentWillReceiveProps) == "function" then
		table.insert(v4, p)
	end

	if typeof(data.componentWillUpdate) == "function" then
		table.insert(v5, p)
	end

	if bit32.band(p.mode, StrictMode) ~= 0 and typeof(data.UNSAFE_componentWillUpdate) == "function" then
		table.insert(v6, p)
	end
end

function New.flushPendingUnsafeLifecycleWarnings()
	local set = {}

	if #v > 0 then
		for _, v7 in v do
			set[getComponentName(v7.type) or "Component"] = true

			typeSet[v7.type] = true
		end

		table.clear(v)
	end

	local set2 = {}

	if #v2 > 0 then
		for _, v7 in v2 do
			set2[getComponentName(v7.type) or "Component"] = true

			typeSet[v7.type] = true
		end

		table.clear(v2)
	end

	local set3 = {}

	if #v3 > 0 then
		for _, v7 in v3 do
			set3[getComponentName(v7.type) or "Component"] = true

			typeSet[v7.type] = true
		end

		table.clear(v3)
	end

	local set4 = {}

	if #v4 > 0 then
		for _, v7 in v4 do
			set4[getComponentName(v7.type) or "Component"] = true

			typeSet[v7.type] = true
		end

		table.clear(v4)
	end

	local set5 = {}

	if #v5 > 0 then
		for _, v7 in v5 do
			set5[getComponentName(v7.type) or "Component"] = true

			typeSet[v7.type] = true
		end

		table.clear(v5)
	end

	local set6 = {}

	if #v6 > 0 then
		for _, v7 in v6 do
			set6[getComponentName(v7.type) or "Component"] = true

			typeSet[v7.type] = true
		end

		table.clear(v6)
	end

	if next(set2) ~= nil then
		local v7 = fn2(set2)
		console.error(
			"Using UNSAFE_componentWillMount in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move code with side effects to componentDidMount, and set initial state in the constructor.\n\nPlease update the following components: %s",
			v7
		)
	end

	if next(set4) ~= nil then
		local v7 = fn2(set4)
		console.error(
			"Using UNSAFE_componentWillReceiveProps in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move data fetching code or side effects to componentDidUpdate.\n* If you're updating state whenever props change, refactor your code to use memoization techniques or move it to static getDerivedStateFromProps. Learn more at: https://reactjs.org/link/derived-state\n\nPlease update the following components: %s",
			v7
		)
	end

	if next(set6) ~= nil then
		local v7 = fn2(set6)
		console.error(
			"Using UNSAFE_componentWillUpdate in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move data fetching code or side effects to componentDidUpdate.\n\nPlease update the following components: %s",
			v7
		)
	end

	if next(set) ~= nil then
		local v7 = fn2(set)

		console.warn(
			"componentWillMount has been renamed, and is not recommended for use. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move code with side effects to componentDidMount, and set initial state in the constructor.\n* Rename componentWillMount to UNSAFE_componentWillMount to suppress this warning in non-strict mode. In React 18.x, only the UNSAFE_ name will work.\n\nPlease update the following components: %s",
			v7
		)
	end

	if next(set3) ~= nil then
		local v7 = fn2(set3)

		console.warn(
			"componentWillReceiveProps has been renamed, and is not recommended for use. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move data fetching code or side effects to componentDidUpdate.\n* If you're updating state whenever props change, refactor your code to use memoization techniques or move it to static getDerivedStateFromProps. Learn more at: https://reactjs.org/link/derived-state\n* Rename componentWillReceiveProps to UNSAFE_componentWillReceiveProps to suppress this warning in non-strict mode. In React 18.x, only the UNSAFE_ name will work.\n\nPlease update the following components: %s",
			v7
		)
	end

	if next(set5) ~= nil then
		local v7 = fn2(set5)

		console.warn(
			"componentWillUpdate has been renamed, and is not recommended for use. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move data fetching code or side effects to componentDidUpdate.\n* Rename componentWillUpdate to UNSAFE_componentWillUpdate to suppress this warning in non-strict mode. In React 18.x, only the UNSAFE_ name will work.\n\nPlease update the following components: %s",
			v7
		)
	end
end

local v7 = {}

local typeSet2 = {}

function New.recordLegacyContextWarning(p, p2)
	local v8 = fn(p) -- inferred equivalent call

	if v8 == nil then
		console.error("Expected to find a StrictMode component in a strict mode tree. This error is likely caused by a bug in React. Please file an issue.")

		return
	end

	if typeSet2[p.type] then
		return
	end

	local v9 = v7[v8]

	if
		typeof(p.type) ~= "function"
		and (p.type.contextTypes ~= nil or p.type.childContextTypes ~= nil or p2 ~= nil and typeof(p2.getChildContext) == "function")
	then
		if v9 == nil then
			v9 = {}

			v7[v8] = v9
		end

		table.insert(v9, p)
	end
end

function New.flushLegacyContextWarning()
	for _, v8 in v7 do
		if #v8 == 0 then
			break
		end

		local v9 = v8[1]

		local set = {}

		for _, v10 in v8 do
			set[getComponentName(v10.type) or "Component"] = true
			typeSet2[v10.type] = true
		end

		local v10 = fn2(set)

		local success, result = pcall(function()
			setCurrentFiber(v9)
			console.error(
				"Legacy context API has been detected within a strict-mode tree.\n\nThe old API will be supported in all 16.x releases, but applications using it should migrate to the new version.\n\nPlease update the following components: %s\n\nLearn more about this warning here: https://reactjs.org/link/legacy-context",
				v10
			)
		end)

		resetCurrentFiber()

		if not success then
			error(result)
		end
	end
end

function New.discardPendingWarnings()
	table.clear(v)
	table.clear(v2)
	table.clear(v3)
	table.clear(v4)
	table.clear(v5)
	table.clear(v6)
	table.clear(v7)
end

return New
