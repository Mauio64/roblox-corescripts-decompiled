local Parent = script:FindFirstAncestor("SocialOnboardingButtons").Parent
local EventTypes = require(Parent.SocialLuaAnalytics).Analytics.Enums.EventTypes
local EventNames = require(script.Parent.EventNames)
local BtnValues = require(script.Parent.BtnValues)

return function(s1: string) -- line: 11
	-- upvalues: EventNames (copy), EventTypes (copy), BtnValues (copy)
	return {
		[EventNames.AddFriendsBtn] = {
			context = s1,
			eventType = EventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.AddFriends
			}
		},
		[EventNames.FindContactsBtn] = {
			context = s1,
			eventType = EventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.FindContacts
			}
		},
		[EventNames.MyQRCodeBtn] = {
			context = s1,
			eventType = EventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.MyQRCode
			}
		},
		[EventNames.SearchPeopleBtn] = {
			context = s1,
			eventType = EventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.SearchPeople
			}
		},
		[EventNames.UnlockVoiceBtn] = {
			context = s1,
			eventType = EventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.UnlockVoice
			}
		},
		[EventNames.MyProfileBtn] = {
			context = s1,
			eventType = EventTypes.ButtonClick,
			additionalInfo = {
				btn = BtnValues.MyProfile
			}
		}
	}
end
