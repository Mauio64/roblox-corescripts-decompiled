local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")

local PushUpsellPromptView = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/PushUpsellPrompt/PushUpsellPromptView")
local usePushUpsellPromptViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/PushUpsellPrompt/usePushUpsellPromptViewModel")

local function PushUpsellPromptContainer(p2)
	local v5 = usePushUpsellPromptViewModel(p2)
	return React.createElement(PushUpsellPromptView, v5)
end

return PushUpsellPromptContainer
