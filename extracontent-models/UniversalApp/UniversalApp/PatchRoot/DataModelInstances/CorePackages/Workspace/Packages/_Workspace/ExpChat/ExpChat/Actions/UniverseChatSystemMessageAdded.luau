local Parent = script:FindFirstAncestor("ExpChat").Parent
local ExpChat = script:FindFirstAncestor("ExpChat")
local Rodux = require(Parent.Rodux)
local SharedFlags = require(Parent.SharedFlags)
local FFlagExpChatEnablePostProcessRichSystemMessageTextFormat = require(ExpChat.Flags.FFlagExpChatEnablePostProcessRichSystemMessageTextFormat)
local FFlagExpChatDictation = SharedFlags.FFlagExpChatDictation

return Rodux.makeActionCreator(script.Name, function(s1: string, s2: string, s3: string?, b1: boolean?, p1: ((...any) -> ...any)?) -- line: 22
	-- upvalues: FFlagExpChatDictation (copy), FFlagExpChatEnablePostProcessRichSystemMessageTextFormat (copy)
	return {
		text = s1,
		channelNameOverride = s2,
		metadata = s3,
		isError = if not FFlagExpChatDictation then nil else b1,
		postProcessMessage = if not FFlagExpChatEnablePostProcessRichSystemMessageTextFormat then nil else p1
	}
end)
