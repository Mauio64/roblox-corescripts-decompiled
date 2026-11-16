local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local PromptsHandler = require(script.Parent.PromptsHandler)
local promptsHandler = PromptsHandler.PromptsHandler
local PromptsEntryPoint = require(script.Parent.PromptsEntryPoint)

local FFlagPromptsEdpOpenReplaceOnFetch = SharedFlags.FFlagPromptsEdpOpenReplaceOnFetch

local function EdpOpenPromptsHandler(p)
	local clientAttributes = React.useMemo(function()
		if p.universeId == nil then
			return nil
		end

		return { universeId = p.universeId }
	end, { p.universeId })

	if clientAttributes == nil then
		return nil
	end

	return React.createElement(promptsHandler, {
		entryPoint = PromptsEntryPoint.ExperienceDetailsPageOpen,
		clientAttributes = clientAttributes,
		replaceOnFetch = FFlagPromptsEdpOpenReplaceOnFetch and true or nil
	})
end

return EdpOpenPromptsHandler
