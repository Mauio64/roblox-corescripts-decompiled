local parent = script:FindFirstAncestor("VirtualEvents").Parent
local React = require(parent.React)

local PushUpsellPromptView = require(script.Parent.PushUpsellPromptView)
local usePushUpsellPromptViewModel = require(script.Parent.usePushUpsellPromptViewModel)

local function PushUpsellPromptContainer(p)
	local v = usePushUpsellPromptViewModel(p)
	return React.createElement(PushUpsellPromptView, v)
end

return PushUpsellPromptContainer
