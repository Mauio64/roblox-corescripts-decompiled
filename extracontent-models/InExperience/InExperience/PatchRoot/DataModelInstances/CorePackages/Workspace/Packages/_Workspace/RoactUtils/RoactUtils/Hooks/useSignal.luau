local parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(parent.React)

require(parent.AppCommonLib)

local function useSignal(object, callback)
	React.useEffect(function()
		if not object then
			return
		end

		assert(object ~= nil, "signal is not nil")

		local connection = object:connect(callback)
		return function()
			connection:disconnect()
		end
	end, { object, callback })
end

return useSignal
