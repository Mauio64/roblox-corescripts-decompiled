local Parent = script:FindFirstAncestor("FriendRequestNicknames").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local EventNames = require(script.Parent.EventNames)
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes

local function v7(p1) -- line: 10
	return p1
end

return {
	[EventNames.SetNicknameModalOpened] = {
		context = Contexts.SetNicknameModal,
		eventType = EventTypes.PageLoad,
		formatRulesForAdditionalInfo = {
			friendshipOriginSourceType = v7,
			previousNicknames = v7
		}
	},
	[EventNames.SetNicknameSkipClicked] = {
		context = Contexts.SetNicknameModal,
		additionalInfo = {
			btn = EventNames.SetNicknameSkipClicked
		},
		eventType = EventTypes.ButtonClick,
		formatRulesForAdditionalInfo = {
			friendshipOriginSourceType = v7,
			previousNicknames = v7
		}
	},
	[EventNames.SetNicknameAddNameClicked] = {
		context = Contexts.SetNicknameModal,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = EventNames.SetNicknameAddNameClicked
		},
		formatRulesForAdditionalInfo = {
			friendshipOriginSourceType = v7,
			previousNicknames = v7,
			submittedNickname = v7
		}
	}
}
