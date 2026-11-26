local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local parseSectionsFromData = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/About").parseSectionsFromData

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local Description = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Description")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage

local navigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local function ContactDescriptionContainer(p2)
	local v5 = useDispatch()
	local v6 = useProfileJsonComponent(Enums.Components.ContactDescription)
	local contactsProfileDescription = useLocalization({
		contactsProfileDescription = {
			TextKeys.ContactsProfileBody,
			contactName = v6.contactName
		}
	}).contactsProfileDescription

	local v7 = React.useMemo(function()
		return parseSectionsFromData(
			{ description = contactsProfileDescription },
			Enums.ProfileTypes.Contact
		)
	end, { contactsProfileDescription })

	local v8 = React.useCallback(function()
		local v9 = {
			name = appPage.AboutDetailsSheet,
			extraProps = { sections = v7 }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v5(navigateDown(v9))
		end
	end, { v5, v7 })

	return React.createElement(Description, {
		description = contactsProfileDescription,
		layoutOrder = p2.layoutOrder,
		onActivateMoreButton = v8
	})
end

return ContactDescriptionContainer
