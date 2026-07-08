local Parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(Parent.Rodux)
local FFlagChatLineReportingGlobalMuteEnabled = require(Parent.SharedFlags).FFlagChatLineReportingGlobalMuteEnabled

return Rodux.makeActionCreator(script.Name, function(p1, b1: boolean, s1: string?, b2: boolean?) -- line: 17
	-- upvalues: FFlagChatLineReportingGlobalMuteEnabled (copy)
	return {
		textChatMessage = p1,
		isSenderLocalPlayer = b1,
		channelNameOverride = s1,
		isUniverseChat = if not FFlagChatLineReportingGlobalMuteEnabled then nil else b2
	}
end)
