local ContextActionService = game:GetService("ContextActionService")

local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local function useCloseOnEscapeEffect(p: string, current)
	local ref = React.useRef(current)
	React.useEffect(function()
		ref.current = current
	end, { current })

	React.useEffect(function()
		ContextActionService:BindCoreAction(p, function(_, p2)
			if p2 == Enum.UserInputState.Begin then
				ref.current()
			end

			return Enum.ContextActionResult.Pass
		end, false, Enum.KeyCode.Escape)

		return function()
			ContextActionService:UnbindCoreAction(p)
		end
	end, { p })
end

return useCloseOnEscapeEffect
