local parent = script:FindFirstAncestor("InterventionShared").Parent

local ContextActionService = game:GetService("ContextActionService")

local React = require(parent.React)

local v = Enum.ContextActionPriority.High.Value + 1

local function useSinkCoreShortcuts(flag: boolean, p)
	local v2 = p or ContextActionService
	React.useEffect(function()
		if not flag then
			return nil
		end

		v2:BindCoreActionAtPriority("InterventionDialogSinkCoreShortcuts", function()
			return Enum.ContextActionResult.Sink
		end, false, v, Enum.KeyCode.Escape, Enum.KeyCode.Tab, Enum.KeyCode.ButtonStart)

		return function()
			v2:UnbindCoreAction("InterventionDialogSinkCoreShortcuts")
		end
	end, { flag, v2 })
end

return useSinkCoreShortcuts
