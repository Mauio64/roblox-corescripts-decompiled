local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/ArgCheck")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/Dash")

local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Hooks/RoactRodux/useStore")

local function fn(p2, p3): boolean
	return p2 == p3
end

function LUAUFORGE_MODULE_GLOBALS_xx_useSelectorWithStore(current, callback, object)
	local v5, v6 = React.useReducer(function(p2)
		return p2 + 1
	end, 0)

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)

	local state = object:getState()
	local v7 = nil

	local success, result = pcall(function()
		if current == ref2.current and state == ref3.current and not ref.current then
			v7 = ref4.current

			return
		end

		local v8 = current(state)

		v7 = if ref4.current == nil or not callback(v8, ref4.current) then v8 else ref4.current
	end)

	if not success then
		if ref.current then
			result = string.format(
				"%s\nThe error may be correlated with this previous error:\n%s\n\n",
				tostring(result),
				(tostring(ref.current))
			)
		end

		error(result)
	end

	React.useLayoutEffect(function()
		ref2.current = current
		ref3.current = state
		ref4.current = v7
		ref.current = nil
	end)

	React.useLayoutEffect(function()
		local function checkForUpdates(current2)
			local success2, result2 = pcall(function(): boolean
				if current2 == ref3.current then
					return false
				end

				assert(ref2.current, "latestSelector")
				local current3 = ref2.current(current2)

				if callback(current3, ref4.current) then
					return false
				end

				ref4.current = current3
				ref3.current = current2
				return true
			end)

			if not success2 then
				result2 = result2 or "Error"

				ref.current = result2
			end

			if result2 then
				v6(nil)
			end
		end
		local changedConnection = object.changed:connect(checkForUpdates)

		local state2 = object:getState()
		local success2, result2 = pcall(function(): boolean
			if state2 == ref3.current then
				return false
			end

			assert(ref2.current, "latestSelector")
			local current2 = ref2.current(state2)

			if callback(current2, ref4.current) then
				return false
			end

			ref4.current = current2
			ref3.current = state2
			return true
		end)

		if not success2 then
			result2 = result2 or "Error"

			ref.current = result2
		end

		if result2 then
			v6(nil)
		end

		return function()
			changedConnection:disconnect()
		end
	end, { object })

	return v7
end

function LUAUFORGE_MODULE_GLOBALS_xx_useSelector(p2, p3)
	ArgCheck.isNotNil(p2, "selector")
	ArgCheck.assert(Dash.isCallable(p2), "useSelector expects 'selector' to be callable")
	ArgCheck.isTypeOrNil(p3, "function", "equalityFn")

	local v6 = useStore()

	return (LUAUFORGE_MODULE_GLOBALS_xx_useSelectorWithStore(p2, p3 or fn, v6))
end

return LUAUFORGE_MODULE_GLOBALS_xx_useSelector
