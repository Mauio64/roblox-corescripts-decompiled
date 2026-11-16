local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local PromptsHandler = require(script.Parent.PromptsHandler)
local promptsHandler = PromptsHandler.PromptsHandler
local PromptsEntryPoint = require(script.Parent.PromptsEntryPoint)
local PromptStyle = require(script.Parent.PromptStyle)

local FFlagPromptsEdpOpenReplaceOnFetch = SharedFlags.FFlagPromptsEdpOpenReplaceOnFetch

local function StreamPromptsHandler(p)
	if p.clientAttributes == nil then
		return nil
	end

	return React.createElement(promptsHandler, {
		entryPoint = PromptsEntryPoint.NotificationStreamOpen,
		promptStyle = PromptStyle.InlineBanner,
		clientAttributes = p.clientAttributes,
		bottomPadding = p.bottomPadding,
		replaceOnFetch = FFlagPromptsEdpOpenReplaceOnFetch and true or nil
	})
end

return StreamPromptsHandler
