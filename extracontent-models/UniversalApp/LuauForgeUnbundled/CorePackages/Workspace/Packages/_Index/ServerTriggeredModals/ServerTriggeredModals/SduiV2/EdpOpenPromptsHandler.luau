local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/SharedFlags")

local promptsHandler = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsHandler").PromptsHandler
local PromptsEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/SduiV2/PromptsEntryPoint")

local fFlagPromptsEdpOpenReplaceOnFetch = SharedFlags.FFlagPromptsEdpOpenReplaceOnFetch

local function EdpOpenPromptsHandler(p2)
	local v5 = React.useMemo(function()
		if p2.universeId == nil then
			return nil
		end

		return { universeId = p2.universeId }
	end, { p2.universeId })

	if v5 == nil then
		return nil
	end

	return React.createElement(promptsHandler, {
		entryPoint = PromptsEntryPoint.ExperienceDetailsPageOpen,
		clientAttributes = v5,
		replaceOnFetch = fFlagPromptsEdpOpenReplaceOnFetch and true or nil
	})
end

return EdpOpenPromptsHandler
