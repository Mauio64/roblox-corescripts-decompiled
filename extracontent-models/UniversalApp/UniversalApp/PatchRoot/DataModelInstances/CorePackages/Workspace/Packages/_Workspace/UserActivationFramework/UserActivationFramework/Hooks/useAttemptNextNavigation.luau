local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationFrameworkParent = UserActivationFramework.Parent
local React = require(UserActivationFrameworkParent.React)
local FullPageActivationFrameworkContext = require(UserActivationFramework.Context.FullPageActivationFrameworkContext)
local NavigationAction = require(UserActivationFramework.Enums.NavigationAction)
local ActivationFrameworkContextAction = require(UserActivationFramework.Enums.ActivationFrameworkContextAction)
local CallbackStatus = require(UserActivationFramework.Enums.CallbackStatus)
local useUpdateActivationWorkflowAndNavigate = require(UserActivationFramework.Hooks.useUpdateActivationWorkflowAndNavigate)

require(UserActivationFramework.Types)
require(UserActivationFramework.Enums.PayloadKey)

return function(p1) -- line: 13
	-- upvalues: useUpdateActivationWorkflowAndNavigate (copy), React (copy), FullPageActivationFrameworkContext (copy), ActivationFrameworkContextAction (copy), CallbackStatus (copy), NavigationAction (copy)
	local v10 = useUpdateActivationWorkflowAndNavigate(p1)
	local v11 = React.useContext(FullPageActivationFrameworkContext)

	return React.useCallback(function(p2) -- line: 18
		-- upvalues: v11 (copy), ActivationFrameworkContextAction (copy), CallbackStatus (copy), v10 (copy), NavigationAction (copy)
		if p2 and not v11.activationFrameworkState.isLoading then
			v11.dispatch({
				type = ActivationFrameworkContextAction.SetIsLoading,
				data = {
					isLoading = true
				}
			})

			local v13 = p2.onButtonClicked()

			if v13 ~= nil then
				local payloadAddendum = v13.payloadAddendum
				local status = v13.status

				if status == CallbackStatus.Success then
					if payloadAddendum ~= nil then
						v11.dispatch({
							type = ActivationFrameworkContextAction.SetMergePayload,
							data = {
								payloadTable = payloadAddendum
							}
						})
					end

					v10(NavigationAction.Next, payloadAddendum)
				elseif status == CallbackStatus.NeedsReset then
					v11.dispatch({
						type = ActivationFrameworkContextAction.ClearPayload
					})
					v10(NavigationAction.Reset)
				end
			end

			v11.dispatch({
				type = ActivationFrameworkContextAction.SetIsLoading,
				data = {
					isLoading = false
				}
			})
		end
	end, {
		p1,
		v10,
		v11
	})
end
