local module = require("@luauforge/deferred/eko")
local module2 = require("@luauforge/deferred/fbr")
local useNavigation = require("@luauforge/deferred/ekp").useNavigation

local module3 = require("@luauforge/deferred/fbs")
local module4 = require("@luauforge/deferred/fbN")
local module5 = require("@luauforge/deferred/fbT")
local module6 = require("@luauforge/deferred/fco")
local module7 = require("@luauforge/deferred/fcE")
local module8 = require("@luauforge/deferred/fcU")
local module9 = require("@luauforge/deferred/fdf")
local module10 = require("@luauforge/deferred/fdo")
local module11 = require("@luauforge/deferred/fdt")
local module12 = require("@luauforge/deferred/eli")
local module13 = require("@luauforge/deferred/fbJ")
local module14 = require("@luauforge/deferred/fbI")
local module15 = require("@luauforge/deferred/eln")
local module16 = require("@luauforge/deferred/elo")
local module17 = require("@luauforge/deferred/fbE")
local module18 = require("@luauforge/deferred/ekL")

local v5 = {
	overlayEnabled = true,
	overlayTransparency = 1,
	absorbInput = true,
	disableBackButton = true
}

local v6 = { overlayEnabled = false, absorbInput = true }

local v15 = {
	{
		[module12.SchoolEntryDecision] = { screen = module3, navigationOptions = v5 }
	},
	{
		[module12.AddSchoolUpsell] = { screen = module4, navigationOptions = v5 }
	},
	{
		[module12.VerifyEmail] = { screen = module6, navigationOptions = v6 }
	},
	{
		[module12.SchoolWaitlist] = { screen = module8, navigationOptions = v6 }
	},
	{
		[module12.SchoolSelection] = { screen = module9, navigationOptions = v6 }
	},
	{
		[module12.GraduationYear] = { screen = module10, navigationOptions = v6 }
	},
	{
		[module12.OtpVerification] = { screen = module11, navigationOptions = v6 }
	},
	{
		[module12.SchoolMemberList] = { screen = module7, navigationOptions = v6 }
	}
}

if module18 then
	local v16 = {
		[module12.SchoolLocked] = { screen = module5, navigationOptions = v6 }
	}
	table.insert(v15, v16)
end

local robloxStackNavigator = module2.createRobloxStackNavigator(v15, {
	initialRouteName = module12.SchoolEntryDecision,
	defaultNavigationOptions = v5,
	mode = module2.StackPresentationStyle.Overlay
})

local function SchoolsNavigatorContent(p2)
	local v16 = module.useMemo(module16, {})
	return module.createElement(module15.Provider, { value = v16 }, {
		Navigator = module.createElement(robloxStackNavigator, p2)
	})
end

local function SchoolsNavigatorWithEntrySource(p2)
	local source = useNavigation().getParam("extraProps", {}).source or module13.AddFriends
	return module.createElement(module14.Provider, { value = source }, {
		Content = module.createElement(SchoolsNavigatorContent, p2)
	})
end

local function SchoolsNavigatorWithProviders(p2)
	if module17 then
		return module.createElement(SchoolsNavigatorWithEntrySource, p2)
	end

	return module.createElement(SchoolsNavigatorContent, p2)
end

local extended = module.PureComponent:extend("SchoolsNavigatorWrapper")

function extended.render(p2)
	return module.createElement(SchoolsNavigatorWithProviders, p2.props)
end

extended.router = robloxStackNavigator.router

return extended
