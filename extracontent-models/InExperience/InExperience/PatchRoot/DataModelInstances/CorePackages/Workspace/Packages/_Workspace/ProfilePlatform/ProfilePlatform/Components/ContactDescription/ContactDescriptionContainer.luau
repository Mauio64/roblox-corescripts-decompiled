local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Enums = require(ProfilePlatform.Common.Enums)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local parseSectionsFromData = require(ProfilePlatform.Components.About).parseSectionsFromData
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local Description = require(ProfilePlatform.Components.Description)
local NavigationRodux = require(ProfilePlatformParent.NavigationRodux)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v16 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands

local function ContactDescriptionContainer(t1: {[any]: any}) -- line: 32
	-- upvalues: useDispatch (copy), useProfileJsonComponent (copy), Enums (copy), useLocalization (copy), TextKeys (copy), React (copy), parseSectionsFromData (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v16 (copy), NavigateDown (copy), Description (copy)
	local v19 = useDispatch()
	local v20 = useProfileJsonComponent(Enums.Components.ContactDescription)
	local contactsProfileDescription = useLocalization({
		contactsProfileDescription = {
			TextKeys.ContactsProfileBody,
			contactName = v20.contactName
		}
	}).contactsProfileDescription
	local v22 = React.useMemo(function() -- line: 40
		-- upvalues: parseSectionsFromData (copy), contactsProfileDescription (copy), Enums (copy)
		return parseSectionsFromData({
			description = contactsProfileDescription
		}, Enums.ProfileTypes.Contact)
	end, { contactsProfileDescription })
	local v23 = React.useCallback(function() -- line: 44
		-- upvalues: AppPage (copy), v22 (copy), FFlagSignalsNavP3Dispatch (copy), v16 (copy), v19 (copy), NavigateDown (copy)
		local t2 = {
			name = AppPage.AboutDetailsSheet,
			extraProps = {
				sections = v22
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v16.down(v16.fromLegacyPage(t2))

			return
		end

		v19(NavigateDown(t2))
	end, {
		v19,
		v22
	})

	return React.createElement(Description, {
		description = contactsProfileDescription,
		layoutOrder = t1.layoutOrder,
		onActivateMoreButton = v23
	})
end

return ContactDescriptionContainer
