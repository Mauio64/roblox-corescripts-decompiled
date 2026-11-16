local parent = script:FindFirstAncestor("ReactUtils").Parent
local React = require(parent.React)
require(parent.GoodSignal)

local function useEventConnection(object, callback, p)
	local v = React.useMemo(function()
		return callback
	end, p)

	React.useEffect(function()
		if object == nil then
			return nil
		end

		if typeof(object) == "RBXScriptSignal" then
			local connection = object:Connect(v)

			return function()
				connection:Disconnect()
			end
		end

		local connection = object:Connect(v)

		return function()
			connection:Disconnect()
		end
	end, { object, v })
end

return useEventConnection
