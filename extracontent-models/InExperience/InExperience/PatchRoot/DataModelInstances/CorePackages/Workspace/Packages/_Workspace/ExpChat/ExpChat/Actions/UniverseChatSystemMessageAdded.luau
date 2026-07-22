local Parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(Parent.Rodux)
local FFlagExpChatDictation = require(Parent.SharedFlags).FFlagExpChatDictation

return Rodux.makeActionCreator(script.Name, function(s1: string, s2: string, s3: string?, b1: boolean?, p1: ((...any) -> ...any)?) -- line: 18
	-- upvalues: FFlagExpChatDictation (copy)
	return {
		text = s1,
		channelNameOverride = s2,
		metadata = s3,
		isError = if not FFlagExpChatDictation then nil else b1,
		postProcessMessage = p1
	}
end)
