local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Enums = require(ProfilePlatform.Common.Enums)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local About = require(ProfilePlatform.Components.About)
local parseSectionsFromData = About.parseSectionsFromData

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Description = require(ProfilePlatform.Components.Description)
local NavigationRodux = require(parent.NavigationRodux)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local NavigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function ContactDescriptionContainer(p)
	local v = useDispatch()
	local v2 = useProfileJsonComponent(Enums.Components.ContactDescription)
	local contactsProfileDescription = useLocalization({
		contactsProfileDescription = {
			TextKeys.ContactsProfileBody,
			contactName = v2.contactName
		}
	}).contactsProfileDescription

	local sections = React.useMemo(function()
		return parseSectionsFromData({ description = contactsProfileDescription }, Enums.ProfileTypes.Contact)
	end, { contactsProfileDescription })

	local onActivateMoreButton = React.useCallback(function()
		local v3 = {
			name = AppPage.AboutDetailsSheet,
			extraProps = { sections = sections }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v3))
		else
			v(NavigateDown(v3))
		end
	end, { v, sections })

	return React.createElement(Description, {
		description = contactsProfileDescription,
		layoutOrder = p.layoutOrder,
		onActivateMoreButton = onActivateMoreButton
	})
end

return ContactDescriptionContainer
