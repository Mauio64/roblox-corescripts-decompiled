local parent = script:FindFirstAncestor("Foundation").Parent
local React = require(parent.React)

local function useDialogSize(p)
	local v, v2 = React.useBinding(Vector2.new(0, 0))

	React.useEffect(function()
		local current = p.current

		if not current then
			return
		end

		local function updateDialogSize() -- 1 equivalent call inferred from this helper
			local absoluteSize = current.AbsoluteSize

			if absoluteSize.X == 0 or absoluteSize.Y == 0 then
				return
			end

			v2(absoluteSize)
		end

		updateDialogSize() -- inferred equivalent call
		local absoluteSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateDialogSize)

		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, {})

	return v
end

return useDialogSize
