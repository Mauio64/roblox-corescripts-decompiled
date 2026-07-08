local EventNames = require(script.Parent.EventNames)
local Enums = require(script.Parent.Parent.Enums)
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local SubPages = Enums.SubPages
local Pages = Enums.Pages
local BtnValues = require(script.Parent.BtnValues)

local function v8(p1) -- line: 10
	return (tostring(p1))
end

return {
	[EventNames.HomePage_Carousel_LuaProfile] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.PlayerProfile,
			subpage = SubPages.PeekView,
			page = Pages.PlayerProfile
		},
		formatRulesForAdditionalInfo = {
			uid = v8
		}
	},
	[EventNames.HomePage_Carousel_FriendsLanding] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.FriendsLanding
		},
		formatRulesForAdditionalInfo = {
			uid = v8
		}
	},
	[EventNames.MorePage_FriendsLanding] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.FriendsLanding
		},
		formatRulesForAdditionalInfo = {
			uid = v8
		}
	}
}
