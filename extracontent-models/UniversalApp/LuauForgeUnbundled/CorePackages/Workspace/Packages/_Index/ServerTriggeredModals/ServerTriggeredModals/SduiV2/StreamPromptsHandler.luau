local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")

local promptsHandler = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler").PromptsHandler
local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")
local PromptStyle = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptStyle")

local fFlagPromptsEdpOpenReplaceOnFetch = SharedFlags.FFlagPromptsEdpOpenReplaceOnFetch

local function StreamPromptsHandler(p2)
	if p2.clientAttributes == nil then
		return nil
	end

	return React.createElement(promptsHandler, {
		entryPoint = PromptsEntryPoint.NotificationStreamOpen,
		promptStyle = PromptStyle.InlineBanner,
		clientAttributes = p2.clientAttributes,
		bottomPadding = p2.bottomPadding,
		replaceOnFetch = fFlagPromptsEdpOpenReplaceOnFetch and true or nil
	})
end

return StreamPromptsHandler
