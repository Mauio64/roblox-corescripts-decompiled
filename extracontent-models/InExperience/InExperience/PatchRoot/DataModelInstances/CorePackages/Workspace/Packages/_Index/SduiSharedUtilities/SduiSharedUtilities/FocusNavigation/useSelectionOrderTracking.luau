local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(Parent.React)

local function useSelectionOrderTracking(t1: {[any]: any}) -- line: 8
	-- upvalues: React (copy)
	React.useEffect(function() -- line: 9
		-- upvalues: t1 (copy)
		local current = t1.current

		if not current then
			return
		end

		local n1 = -1
		local connection = current.SelectionChanged:Connect(function(_: boolean, p1, p2) -- line: 17
			-- upvalues: current (copy), n1 (ref)
			if p2 == nil or (p1 == nil or not p2:IsDescendantOf(current) or not p1:IsDescendantOf(current)) then
				return
			end

			p2.SelectionOrder = n1
			n1 -= 1
		end)

		return function() -- line: 31
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})
end

return useSelectionOrderTracking
