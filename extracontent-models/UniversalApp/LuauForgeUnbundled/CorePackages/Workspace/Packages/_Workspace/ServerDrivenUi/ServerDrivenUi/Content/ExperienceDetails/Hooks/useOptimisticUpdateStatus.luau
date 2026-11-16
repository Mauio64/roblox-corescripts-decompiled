local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")

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

		local v5 = callback(...)

		if v5 then
			ref.current = Signals.createEffect(function(p2)
				local v6 = v5(p2)

				if v6 ~= nil then
					callback2(v6)
				end
			end)
		end
	end, { callback, callback2 })
end

return useOptimisticUpdateStatus
