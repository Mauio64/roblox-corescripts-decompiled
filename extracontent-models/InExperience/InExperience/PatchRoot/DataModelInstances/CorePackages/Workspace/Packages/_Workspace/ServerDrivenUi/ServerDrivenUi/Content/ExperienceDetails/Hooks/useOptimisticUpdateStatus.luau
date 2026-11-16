local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local function useOptimisticUpdateStatus(callback, callback2)
	local ref = React.useRef(nil)

	React.useEffect(function()
		return function()
			if ref.current then
				ref.current()
			end
		end
	end, {})

	return React.useCallback(function(...)
		if ref.current then
			ref.current()
			ref.current = nil
		end

		local v = callback(...)

		if v then
			ref.current = Signals.createEffect(function(p)
				local v2 = v(p)

				if v2 ~= nil then
					callback2(v2)
				end
			end)
		end
	end, { callback, callback2 })
end

return useOptimisticUpdateStatus
