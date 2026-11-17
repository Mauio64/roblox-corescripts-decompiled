local parent = script:FindFirstAncestor("RobloxAppHooks").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local function useSignalsEffect(callback, current, current2)
	local ref = React.useRef(current)
	ref.current = current
	local ref2 = React.useRef(current2)
	ref2.current = current2

	local ref3 = React.useRef(nil)

	React.useEffect(function()
		local function readChange(p)
			local v = callback(p)
			local current3 = ref3.current
			local current4 = ref2.current
			local v2

			if current3 == nil then
				v2 = false
				return v, false
			end

			if current4 then
				return v, (current4(current3.value, v))
			end

			v2 = current3.value == v
			return v, v2
		end

		return Signals.createEffect(function(p)
			local success, result, v = xpcall(readChange, debug.traceback, p)

			if not success then
				task.spawn(error, result, 0)
				return
			end

			if v then
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
