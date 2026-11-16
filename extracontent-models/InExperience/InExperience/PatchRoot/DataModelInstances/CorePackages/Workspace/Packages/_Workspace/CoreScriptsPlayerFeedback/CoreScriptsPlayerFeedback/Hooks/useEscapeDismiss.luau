local parent = script:FindFirstAncestor("CoreScriptsPlayerFeedback").Parent

local React = require(parent.React)

local ContextActionService = game:GetService("ContextActionService")

local function useEscapeDismiss(p: string, callback)
	React.useEffect(function()
		pcall(function()
			ContextActionService:BindCoreActionAtPriority(p, function(_, p2)
				if p2 ~= Enum.UserInputState.Begin then
					return Enum.ContextActionResult.Pass
				end

				callback()
				return Enum.ContextActionResult.Sink
			end, false, 100000, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB)
		end)

		return function()
			pcall(function()
				ContextActionService:UnbindCoreAction(p)
			end)
		end
	end, { callback, p })
end

return useEscapeDismiss
