local parent = script:FindFirstAncestor("Foundation").Parent
local React = require(parent.React)

local getHardwareSafeAreaInsets = require(script.Parent.getHardwareSafeAreaInsets)

local function useHardwareInsets(instance)
	local state, setState = React.useState(getHardwareSafeAreaInsets)

	React.useEffect(function()
		local absoluteSizeChangedConnection

		if instance then
			absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				setState(function(data)
					local hardwareSafeAreaInsets = getHardwareSafeAreaInsets()

					if
						hardwareSafeAreaInsets.bottom == data.bottom
						and hardwareSafeAreaInsets.top == data.top
						and hardwareSafeAreaInsets.left == data.left
						and hardwareSafeAreaInsets.right == data.right
					then
						return data
					end

					return hardwareSafeAreaInsets
				end)
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { instance })

	return state
end

return useHardwareInsets
