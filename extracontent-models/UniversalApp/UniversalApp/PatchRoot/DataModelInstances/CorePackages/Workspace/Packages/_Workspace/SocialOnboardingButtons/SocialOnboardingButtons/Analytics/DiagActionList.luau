local Parent = script:FindFirstAncestor("SocialOnboardingButtons").Parent
local DiagEventTypes = require(Parent.SocialLuaAnalytics).Analytics.Enums.DiagEventTypes
local EventNames = require(script.Parent.EventNames)

return {
	[EventNames.AddFriendsBtn] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("AddFriendsBtnCounter", "AddFriendsBtnCounter")
	},
	[EventNames.FindContactsBtn] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("FindContactsBtnCounter", "FindContactsBtnCounter")
	},
	[EventNames.MyQRCodeBtn] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("MyQRCodeBtnCounter", "MyQRCodeBtnCounter")
	},
	[EventNames.SearchPeopleBtn] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("SearchPeopleBtnCounter", "SearchPeopleBtnCounter")
	},
	[EventNames.UnlockVoiceBtn] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("UnlockVoiceBtnCounter", "UnlockVoiceBtnCounter")
	},
	[EventNames.MyProfileBtn] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("MyProfileBtnCounter", "MyProfileBtnCounter")
	}
}
