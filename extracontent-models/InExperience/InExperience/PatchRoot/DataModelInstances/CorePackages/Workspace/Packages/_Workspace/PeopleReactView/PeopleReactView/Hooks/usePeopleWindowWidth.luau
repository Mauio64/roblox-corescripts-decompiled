local parent = script:FindFirstAncestor("PeopleReactView").Parent

local React = require(parent.React)

local function usePeopleWindowWidth()
	local state, setState = React.useState(0)
	local ref = React.useRef(nil)

	return state, (React.useCallback(function(instance)
		if ref.current then
			ref.current()
			ref.current = nil
		end

		if not instance then
			return
		end

		local absoluteSizeChangedConnection = nil
		local function track()
			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end

			local scrollingFrame = instance:FindFirstAncestorWhichIsA("ScrollingFrame") or instance
			setState(scrollingFrame.AbsoluteSize.X)
			absoluteSizeChangedConnection = scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				setState(scrollingFrame.AbsoluteSize.X)
			end)
		end

		track()

		local ancestryChangedConnection = instance.AncestryChanged:Connect(track)

		function ref.current()
			ancestryChangedConnection:Disconnect()

			if absoluteSizeChangedConnection then
				absoluteSizeChangedConnection:Disconnect()
			end
		end
	end, {}))
end

return usePeopleWindowWidth
