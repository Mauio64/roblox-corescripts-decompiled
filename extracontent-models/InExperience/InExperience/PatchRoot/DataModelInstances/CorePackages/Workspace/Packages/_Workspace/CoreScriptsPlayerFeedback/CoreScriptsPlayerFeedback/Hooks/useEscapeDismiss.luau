local Parent = script:FindFirstAncestor("CoreScriptsPlayerFeedback").Parent
local React = require(Parent.React)
local ContextActionService = game:GetService("ContextActionService")

local function useEscapeDismiss(s1: string, p1: ((...any) -> ...any)) -- line: 9
	-- upvalues: React (copy), ContextActionService (copy)
	React.useEffect(function() -- line: 10
		-- upvalues: ContextActionService (copy), s1 (copy), p1 (copy)
		pcall(function() -- line: 11
			-- upvalues: ContextActionService (copy), s1 (copy), p1 (copy)
			ContextActionService:BindCoreActionAtPriority(s1, function(_, p3) -- line: 12
				-- upvalues: p1 (copy)
				if p3 == Enum.UserInputState.Begin then
					p1()

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end, false, 100000, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB)
		end)

		return function() -- line: 21
			-- upvalues: ContextActionService (copy), s1 (copy)
			pcall(function() -- line: 22
				-- upvalues: ContextActionService (copy), s1 (copy)
				ContextActionService:UnbindCoreAction(s1)
			end)
		end
	end, {
		p1,
		s1
	})
end

return useEscapeDismiss
