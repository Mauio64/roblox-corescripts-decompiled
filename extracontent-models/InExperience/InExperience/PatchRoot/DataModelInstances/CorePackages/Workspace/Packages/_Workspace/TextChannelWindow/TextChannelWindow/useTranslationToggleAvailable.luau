local TextChatService = game:GetService("TextChatService")

local parent = script.Parent.Parent
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection

local function readAvailable() -- 1 equivalent call inferred from this helper
	return TextChatService.ChatTranslationEnabled and TextChatService.ChatTranslationToggleEnabled
end

local function useTranslationToggleAvailable()
	local state, setState = React.useState(readAvailable)

	useEventConnection(TextChatService.Changed, function(p: string)
		if p == "ChatTranslationEnabled" or p == "ChatTranslationToggleEnabled" then
			setState(readAvailable()) -- inferred equivalent call
		end
	end)

	return state
end

return useTranslationToggleAvailable
