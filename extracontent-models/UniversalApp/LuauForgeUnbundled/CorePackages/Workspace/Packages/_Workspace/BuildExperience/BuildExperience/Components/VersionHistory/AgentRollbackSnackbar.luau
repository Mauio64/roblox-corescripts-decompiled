local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactRoblox")

local defineFastInt = game:DefineFastInt("BuildAgentRollbackSnackbarAutoDismissSeconds", 4)

local function AgentRollbackSnackbar(p2)
	local v5 = Foundation.Hooks.useOverlay()
	local v6 = Foundation.Hooks.useTokens()

	React.useEffect(function()
		local thread = task.delay(defineFastInt, p2.onClose)
		return function()
			task.cancel(thread)
		end
	end, { p2.onClose })

	if v5 == nil then
		return nil
	end

	return ReactRoblox.createPortal(React.createElement(Foundation.Snackbar, {
		AnchorPoint = Vector2.new(0.5, 1),
		onClose = p2.onClose,
		Position = UDim2.new(0.5, 0, 1, -v6.Padding.XLarge),
		testId = "build-agent-rollback-snackbar",
		title = p2.title,
		ZIndex = 999
	}), v5)
end

return AgentRollbackSnackbar
