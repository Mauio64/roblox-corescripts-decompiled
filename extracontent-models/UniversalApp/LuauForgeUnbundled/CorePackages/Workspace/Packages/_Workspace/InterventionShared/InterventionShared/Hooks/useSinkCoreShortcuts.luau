local ContextActionService = game:GetService("ContextActionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")

local v5 = Enum.ContextActionPriority.High.Value + 1

local function useSinkCoreShortcuts(p2, p3)
	local v6 = p3 or ContextActionService
	React.useEffect(function()
		if not p2 then
			return nil
		end

		v6:BindCoreActionAtPriority("InterventionDialogSinkCoreShortcuts", function()
			return Enum.ContextActionResult.Sink
		end, false, v5, Enum.KeyCode.Escape, Enum.KeyCode.Tab, Enum.KeyCode.ButtonStart)

		return function()
			v6:UnbindCoreAction("InterventionDialogSinkCoreShortcuts")
		end
	end, { p2, v6 })
end

return useSinkCoreShortcuts
