local Parent = script:FindFirstAncestor("Foundation").Parent
local React = require(Parent.React)

local function useDialogSize(t1: {[any]: any}) -- line: 5
	-- upvalues: React (copy)
	local v5, v6 = React.useBinding(Vector2.new(0, 0))

	React.useEffect(function() -- line: 8
		-- upvalues: t1 (copy), v6 (copy)
		local current = t1.current

		if not current then
			return
		end

		local function updateDialogSize() -- line: 14
			-- upvalues: current (copy), v6 (copy)
			local AbsoluteSize = current.AbsoluteSize

			if AbsoluteSize.X == 0 or AbsoluteSize.Y == 0 then
				return
			end

			v6(AbsoluteSize)
		end

		local AbsoluteSize = current.AbsoluteSize

		if AbsoluteSize.X ~= 0 and AbsoluteSize.Y ~= 0 then
			v6(AbsoluteSize)
		end

		local connection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateDialogSize)

		return function() -- line: 26
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v5
end

return useDialogSize
