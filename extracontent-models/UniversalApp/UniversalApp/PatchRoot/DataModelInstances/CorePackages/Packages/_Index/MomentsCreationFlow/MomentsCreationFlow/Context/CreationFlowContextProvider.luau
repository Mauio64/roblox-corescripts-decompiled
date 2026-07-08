local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Dash = require(MomentsCreationFlowParent.Dash)
local React = require(MomentsCreationFlowParent.React)
local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)

local function CreationFlowContextProvider(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), CreationFlowContext (copy), Dash (copy)
	return React.createElement(CreationFlowContext.Provider, {
		value = Dash.join(t1.value, {
			captures = t1.captures,
			exitCreationFlow = t1.exitCreationFlow
		})
	}, t1.children)
end

return CreationFlowContextProvider
