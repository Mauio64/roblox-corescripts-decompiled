local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local SocialCommon = require(Parent.SocialCommon)

return React.createContext({
	getParentContainer = function() -- line: 18
		return nil
	end,
	visibilitySignal = Instance.new("BindableEvent"),
	getShouldSetAppChatVisible = function() -- line: 22
		return false
	end,
	entryPoint = SocialCommon.Enums.ChatEntryPointNames.Unknown,
	showParentContainer = function() -- line: 26
	end,
	hideParentContainer = function() -- line: 27
	end,
	updateCurrentSquadId = function() -- line: 28
	end
})
