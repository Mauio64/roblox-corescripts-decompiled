local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local defineFastInt = game:DefineFastInt("BuildAgentRollbackSnackbarAutoDismissSeconds", 4)

local function AgentRollbackSnackbar(p)
	local v = Foundation.Hooks.useOverlay()
	local v2 = Foundation.Hooks.useTokens()

	React.useEffect(function()
		local thread = task.delay(defineFastInt, p.onClose)
		return function()
			task.cancel(thread)
		end
	end, { p.onClose })

	if v == nil then
		return nil
	end

	return ReactRoblox.createPortal(React.createElement(Foundation.Snackbar, {
		AnchorPoint = Vector2.new(0.5, 1),
		onClose = p.onClose,
		Position = UDim2.new(0.5, 0, 1, -v2.Padding.XLarge),
		testId = "build-agent-rollback-snackbar",
		title = p.title,
		ZIndex = 999
	}), v)
end

return AgentRollbackSnackbar
