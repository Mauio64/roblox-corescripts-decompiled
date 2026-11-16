local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)

local function CreationFlowContextProvider(props)
	return React.createElement(CreationFlowContext.Provider, {
		value = Dash.join(props.value, {
			captures = props.captures,
			exitCreationFlow = props.exitCreationFlow
		})
	}, props.children)
end

return CreationFlowContextProvider
