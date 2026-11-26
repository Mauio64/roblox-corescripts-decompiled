local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/Signals")

local function useSignalsEffect(callback, current, current2)
	local ref = React.useRef(current)
	ref.current = current
	local ref2 = React.useRef(current2)
	ref2.current = current2

	local ref3 = React.useRef(nil)

	React.useEffect(function()
		local function readChange(p2)
			local v5 = callback(p2)
			local current3 = ref3.current
			local current4 = ref2.current
			local v6

			if current3 == nil then
				v6 = false
				return v5, false
			end

			if current4 then
				return v5, (current4(current3.value, v5))
			end

			v6 = current3.value == v5
			return v5, v6
		end

		return Signals.createEffect(function(p2)
			local success, result, v5 = xpcall(readChange, debug.traceback, p2)

			if not success then
				task.spawn(error, result, 0)
				return
			end

			if v5 then
				return
			end

			ref3.current = { value = result }
			local current3 = ref.current
			task.spawn(function()
				current3(result)
			end)
		end)
	end, { callback })
end

return useSignalsEffect
