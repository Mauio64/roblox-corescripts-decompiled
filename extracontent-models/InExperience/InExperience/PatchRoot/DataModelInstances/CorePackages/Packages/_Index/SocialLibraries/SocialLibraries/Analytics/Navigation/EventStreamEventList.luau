local EventNames = require(script.Parent.EventNames)
local Enums = require(script.Parent.Parent.Enums)
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local SubPages = Enums.SubPages
local Pages = Enums.Pages
local BtnValues = require(script.Parent.BtnValues)

local function fn(p)
	return (tostring(p))
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
		formatRulesForAdditionalInfo = { uid = fn }
	},
	[EventNames.HomePage_Carousel_FriendsLanding] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { btn = BtnValues.FriendsLanding },
		formatRulesForAdditionalInfo = { uid = fn }
	},
	[EventNames.MorePage_FriendsLanding] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { btn = BtnValues.FriendsLanding },
		formatRulesForAdditionalInfo = { uid = fn }
	}
}
