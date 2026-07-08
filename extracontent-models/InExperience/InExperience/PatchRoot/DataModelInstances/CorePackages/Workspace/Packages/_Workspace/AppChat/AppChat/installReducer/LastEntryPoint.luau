local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Rodux = require(AppChatParent.Rodux)

require(AppChatParent.SocialCommon)

local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)

return Rodux.createReducer("NotSet", {
	[EnteredChatFromEntryPoint.name] = function(_, p2) -- line: 11
		return p2.entryPoint
	end
})
