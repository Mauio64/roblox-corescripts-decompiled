local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent
local React = require(parent.React)

local useScreen = require(foundation.Providers.Overlay.useScreen)

local function useScreenHeight()
	local v = useScreen()
	local state, setState = React.useState(v and v.AbsoluteSize.Y or 0)

	React.useLayoutEffect(function()
		local absoluteSizeChangedConnection

		if v then
			setState(v.AbsoluteSize.Y)
			absoluteSizeChangedConnection = v:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				setState(v.AbsoluteSize.Y)
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

return useScreenHeight
