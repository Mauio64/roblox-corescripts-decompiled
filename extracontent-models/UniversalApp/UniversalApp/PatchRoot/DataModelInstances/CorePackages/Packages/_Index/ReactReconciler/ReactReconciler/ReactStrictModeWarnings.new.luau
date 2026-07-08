local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console

require(script.Parent.ReactInternalTypes)

local ReactCurrentFiber = require(script.Parent.ReactCurrentFiber)
local resetCurrentFiber = ReactCurrentFiber.resetCurrentFiber
local setCurrentFiber = ReactCurrentFiber.setCurrentFiber
local getComponentName = require(ParentParent.Shared).getComponentName
local StrictMode = require(script.Parent.ReactTypeOfMode).StrictMode
local t1 = {
	recordUnsafeLifecycleWarnings = function(_, _) -- line: 32
	end,
	flushPendingUnsafeLifecycleWarnings = function() -- line: 33
	end,
	recordLegacyContextWarning = function(_, _) -- line: 34
	end,
	flushLegacyContextWarning = function() -- line: 35
	end,
	discardPendingWarnings = function() -- line: 36
	end
}

if ReactGlobals.__DEV__ then
	local function v10(p5) -- line: 55
		local t2 = {}

		for v28, _ in p5 do
			table.insert(t2, v28)
		end

		table.sort(t2)

		return table.concat(t2, ", ")
	end

	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local t7 = {}
	local t8 = {}
	local t9 = {}

	function t1.recordUnsafeLifecycleWarnings(p6, p7) -- line: 74
		-- upvalues: t9 (copy), t3 (copy), StrictMode (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy)
		if t9[p6.type] then
			return
		end

		if typeof(p7.componentWillMount) == "function" then
			table.insert(t3, p6)
		end

		if bit32.band(p6.mode, StrictMode) ~= 0 and typeof(p7.UNSAFE_componentWillMount) == "function" then
			table.insert(t4, p6)
		end

		if typeof(p7.componentWillReceiveProps) == "function" then
			table.insert(t5, p6)
		end

		if bit32.band(p6.mode, StrictMode) ~= 0 and typeof(p7.UNSAFE_componentWillReceiveProps) == "function" then
			table.insert(t6, p6)
		end

		if typeof(p7.componentWillUpdate) == "function" then
			table.insert(t7, p6)
		end

		if bit32.band(p6.mode, StrictMode) ~= 0 and typeof(p7.UNSAFE_componentWillUpdate) == "function" then
			table.insert(t8, p6)
		end
	end
	function t1.flushPendingUnsafeLifecycleWarnings() -- line: 130
		-- upvalues: t3 (copy), getComponentName (copy), t9 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), v10 (copy), console (copy)
		local t10 = {}

		if #t3 > 0 then
			for _, v34 in t3 do
				t10[getComponentName(v34.type) or "Component"] = true
				t9[v34.type] = true
			end

			table.clear(t3)
		end

		local t11 = {}

		if #t4 > 0 then
			for _, v37 in t4 do
				t11[getComponentName(v37.type) or "Component"] = true
				t9[v37.type] = true
			end

			table.clear(t4)
		end

		local t12 = {}

		if #t5 > 0 then
			for _, v40 in t5 do
				t12[getComponentName(v40.type) or "Component"] = true
				t9[v40.type] = true
			end

			table.clear(t5)
		end

		local t13 = {}

		if #t6 > 0 then
			for _, v43 in t6 do
				t13[getComponentName(v43.type) or "Component"] = true
				t9[v43.type] = true
			end

			table.clear(t6)
		end

		local t14 = {}

		if #t7 > 0 then
			for _, v46 in t7 do
				t14[getComponentName(v46.type) or "Component"] = true
				t9[v46.type] = true
			end

			table.clear(t7)
		end

		local t15 = {}

		if #t8 > 0 then
			for _, v49 in t8 do
				t15[getComponentName(v49.type) or "Component"] = true
				t9[v49.type] = true
			end

			table.clear(t8)
		end

		if next(t11) ~= nil then
			local v50 = v10(t11)

			console.error("Using UNSAFE_componentWillMount in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move code with side effects to componentDidMount, and set initial state in the constructor.\n\nPlease update the following components: %s", v50)
		end

		if next(t13) ~= nil then
			local v51 = v10(t13)

			console.error("Using UNSAFE_componentWillReceiveProps in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move data fetching code or side effects to componentDidUpdate.\n* If you're updating state whenever props change, refactor your code to use memoization techniques or move it to static getDerivedStateFromProps. Learn more at: https://reactjs.org/link/derived-state\n\nPlease update the following components: %s", v51)
		end

		if next(t15) ~= nil then
			local v52 = v10(t15)

			console.error("Using UNSAFE_componentWillUpdate in strict mode is not recommended and may indicate bugs in your code. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move data fetching code or side effects to componentDidUpdate.\n\nPlease update the following components: %s", v52)
		end

		if next(t10) ~= nil then
			local v53 = v10(t10)

			console.warn("componentWillMount has been renamed, and is not recommended for use. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move code with side effects to componentDidMount, and set initial state in the constructor.\n* Rename componentWillMount to UNSAFE_componentWillMount to suppress this warning in non-strict mode. In React 18.x, only the UNSAFE_ name will work.\n\nPlease update the following components: %s", v53)
		end

		if next(t12) ~= nil then
			local v54 = v10(t12)

			console.warn("componentWillReceiveProps has been renamed, and is not recommended for use. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move data fetching code or side effects to componentDidUpdate.\n* If you're updating state whenever props change, refactor your code to use memoization techniques or move it to static getDerivedStateFromProps. Learn more at: https://reactjs.org/link/derived-state\n* Rename componentWillReceiveProps to UNSAFE_componentWillReceiveProps to suppress this warning in non-strict mode. In React 18.x, only the UNSAFE_ name will work.\n\nPlease update the following components: %s", v54)
		end

		if next(t14) ~= nil then
			local v55 = v10(t14)

			console.warn("componentWillUpdate has been renamed, and is not recommended for use. See https://reactjs.org/link/unsafe-component-lifecycles for details.\n\n* Move data fetching code or side effects to componentDidUpdate.\n* Rename componentWillUpdate to UNSAFE_componentWillUpdate to suppress this warning in non-strict mode. In React 18.x, only the UNSAFE_ name will work.\n\nPlease update the following components: %s", v55)
		end
	end

	local t16 = {}
	local t17 = {}

	function t1.recordLegacyContextWarning(p8, p9) -- line: 303
		-- upvalues: StrictMode (copy), console (copy), t17 (copy), t16 (copy)
		local v58 = nil
		local v59 = p8

		while v59 ~= nil do
			if bit32.band(v59.mode, StrictMode) ~= 0 then
				v58 = v59
			end

			v59 = v59.return_
		end

		if v58 == nil then
			console.error("Expected to find a StrictMode component in a strict mode tree. This error is likely caused by a bug in React. Please file an issue.")

			return
		end

		if t17[p8.type] then
			return
		end

		local v60 = t16[v58]

		if typeof(p8.type) ~= "function" and (p8.type.contextTypes ~= nil or p8.type.childContextTypes ~= nil or p9 ~= nil and typeof(p9.getChildContext) == "function") then
			if v60 == nil then
				v60 = {}
				t16[v58] = v60
			end

			table.insert(v60, p8)
		end
	end
	function t1.flushLegacyContextWarning() -- line: 342
		-- upvalues: t16 (copy), getComponentName (copy), t17 (copy), v10 (copy), setCurrentFiber (copy), console (copy), resetCurrentFiber (copy)
		for _, v62 in t16 do
			if #v62 == 0 then
				return
			end

			local v63 = v62[1]
			local t18 = {}

			for _, v66 in v62 do
				t18[getComponentName(v66.type) or "Component"] = true
				t17[v66.type] = true
			end

			local v67 = v10(t18)
			local ok, result = pcall(function() -- line: 357
				-- upvalues: setCurrentFiber (copy), v63 (copy), console (copy), v67 (copy)
				setCurrentFiber(v63)
				console.error("Legacy context API has been detected within a strict-mode tree.\n\nThe old API will be supported in all 16.x releases, but applications using it should migrate to the new version.\n\nPlease update the following components: %s\n\nLearn more about this warning here: https://reactjs.org/link/legacy-context", v67)
			end)

			resetCurrentFiber()

			if not ok then
				error(result)
			end
		end
	end
	function t1.discardPendingWarnings() -- line: 378
		-- upvalues: t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t16 (copy)
		table.clear(t3)
		table.clear(t4)
		table.clear(t5)
		table.clear(t6)
		table.clear(t7)
		table.clear(t8)
		table.clear(t16)
	end
end

return t1
