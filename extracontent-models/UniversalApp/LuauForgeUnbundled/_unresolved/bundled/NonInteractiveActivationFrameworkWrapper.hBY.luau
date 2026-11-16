local module = require("@luauforge/bundled/hBF")
require("@luauforge/bundled/hBR")
require("@luauforge/bundled/hBB")
local module2 = require("@luauforge/bundled/hBE")
local module3 = require("@luauforge/bundled/hBv")
local module4 = require("@luauforge/bundled/hBx")
local useDesignTokens = require("@luauforge/bundled/hBP").useDesignTokens
local authPageload = require("@luauforge/bundled/hBU").Events.authPageload
local text = require("@luauforge/bundled/hBN").Text

local module5 = require("@luauforge/bundled/hBW")

local function NonInteractiveActivationFrameworkWrapper(p2)
	local v5 = module.useContext(module2)
	local activationFrameworkState = v5.activationFrameworkState
	local activationFramework = useDesignTokens().LuaApps.ActivationFramework

	local v6 = module5(p2.navigation)

	module.useEffect(function()
		authPageload(activationFrameworkState.namespace, activationFrameworkState.currentState)

		local v7 = p2.step.onNonInteractiveStepExecution()
		local successPayloadAddendum = v7.successPayloadAddendum
		local errorOutput = v7.errorOutput

		if not successPayloadAddendum then
			v6(module4.Back)

			return
		end

		v5.dispatch({
			type = module3.SetMergePayload,
			data = { payloadTable = successPayloadAddendum }
		})

		v6(module4.Next)
	end, {})

	return module.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 0.5
		},
		{
			Padding = module.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, activationFramework.verticalPaddingPx),
				PaddingTop = UDim.new(0, activationFramework.verticalPaddingPx),
				PaddingLeft = UDim.new(0, activationFramework.horizontalPaddingPx),
				PaddingRight = UDim.new(0, activationFramework.horizontalPaddingPx)
			}),
			module.createElement(text, {
				Text = "LOADING...",
				fontStyle = { LineHeight = 1 },
				tag = "text-body-medium text-align-x-left auto-xy",
				TextWrapped = true
			})
		}
	)
end

return NonInteractiveActivationFrameworkWrapper
