local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

local useScreen = require(Foundation.Providers.Overlay.useScreen)

local function useScreenSize()
	local v = useScreen()
	local state, setState = React.useState(v and v.AbsoluteSize or Vector2.new(0, 0))

	React.useLayoutEffect(function()
		local absoluteSizeChangedConnection

		if v then
			setState(v.AbsoluteSize)
			absoluteSizeChangedConnection = v:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				setState(v.AbsoluteSize)
			end)
		else
			absoluteSizeChangedConnection = nil
		end

		return function()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, { v })

	return state
end

return useScreenSize
