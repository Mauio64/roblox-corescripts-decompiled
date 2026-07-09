local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationFrameworkParent = UserActivationFramework.Parent
local React = require(UserActivationFrameworkParent.React)

require(UserActivationFramework.Components.ActivationFrameworkTokenMapper)
require(UserActivationFramework.Types)

local FullPageActivationFrameworkContext = require(UserActivationFramework.Context.FullPageActivationFrameworkContext)
local ActivationFrameworkContextAction = require(UserActivationFramework.Enums.ActivationFrameworkContextAction)
local NavigationAction = require(UserActivationFramework.Enums.NavigationAction)
local useDesignTokens = require(UserActivationFrameworkParent.Style).useDesignTokens
local authPageload = require(UserActivationFrameworkParent.AuthAnalytics).Events.authPageload
local Text = require(UserActivationFrameworkParent.Foundation).Text
local useUpdateActivationWorkflowAndNavigate = require(UserActivationFramework.Hooks.useUpdateActivationWorkflowAndNavigate)

local function NonInteractiveActivationFrameworkWrapper(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), FullPageActivationFrameworkContext (copy), useDesignTokens (copy), useUpdateActivationWorkflowAndNavigate (copy), authPageload (copy), ActivationFrameworkContextAction (copy), NavigationAction (copy), Text (copy)
	local v13 = React.useContext(FullPageActivationFrameworkContext)
	local activationFrameworkState = v13.activationFrameworkState
	local ActivationFramework = useDesignTokens().LuaApps.ActivationFramework
	local v16 = useUpdateActivationWorkflowAndNavigate(t1.navigation)

	React.useEffect(function() -- line: 32
		-- upvalues: authPageload (copy), activationFrameworkState (copy), t1 (copy), v13 (copy), ActivationFrameworkContextAction (copy), v16 (copy), NavigationAction (copy)
		authPageload(activationFrameworkState.namespace, activationFrameworkState.currentState)

		local v17 = t1.step.onNonInteractiveStepExecution()
		local successPayloadAddendum = v17.successPayloadAddendum
		local _ = v17.errorOutput

		if successPayloadAddendum then
			v13.dispatch({
				type = ActivationFrameworkContextAction.SetMergePayload,
				data = {
					payloadTable = successPayloadAddendum
				}
			})
			v16(NavigationAction.Next)

			return
		end

		v16(NavigationAction.Back)
	end, {})

	return React.createElement("Frame", {
		BackgroundTransparency = 0.5,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0)
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, ActivationFramework.verticalPaddingPx),
			PaddingTop = UDim.new(0, ActivationFramework.verticalPaddingPx),
			PaddingLeft = UDim.new(0, ActivationFramework.horizontalPaddingPx),
			PaddingRight = UDim.new(0, ActivationFramework.horizontalPaddingPx)
		}),
		React.createElement(Text, {
			Text = "LOADING...",
			tag = "text-body-medium text-align-x-left auto-xy",
			TextWrapped = true,
			fontStyle = {
				LineHeight = 1
			}
		})
	})
end

return NonInteractiveActivationFrameworkWrapper
