local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local NavigationRodux = require(parent.NavigationRodux)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local RoactUtils = require(parent.RoactUtils)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local useAboutSections = require(ProfilePlatform.Hooks.useAboutSections)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local Description = require(ProfilePlatform.Components.Description)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local parseSectionsFromData = require(script.Parent.parseSectionsFromData)

local NavigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function AboutDescriptionContainer(p)
	local v = useDispatch()
	local v2, sections

	if FFlagProfilePlatformNewProfileHeader then
		local v3 = useAboutSections()
		v2 = v3.aboutDetails
		sections = v3.aboutSections
	else
		local profileType = useProfileWrapperContext().profileType
		v2 = useProfileJsonComponent(Enums.Components.About)
		sections = React.useMemo(function()
			local v3 = v2
			local v4

			if profileType == Enums.ProfileTypes.User then
				v4 = `@{v2.name}`
			else
				v4 = v2.name
			end

			return parseSectionsFromData(v3, profileType, v4)
		end, { v2, profileType, v2.name })
	end

	local profileName

	if FFlagProfileAboutDetailsUseSheet then
		if useProfileWrapperContext().profileType == Enums.ProfileTypes.User then
			profileName = `@{v2.name}`
		else
			profileName = v2.name
		end
	else
		profileName = nil
	end

	local description = v2.description
	local v3 = useLocalization({ noBioYet = TextKeys.NoBioYet })

	if description == nil or description == "" then
		if FFlagProfilePlatformNewProfileHeader then
			description = nil
		else
			description = v3.noBioYet
		end
	end

	local onActivateMoreButton = React.useCallback(function()
		local v4 = {
			name = AppPage.AboutDetailsSheet,
			extraProps = { sections = sections, profileName = profileName }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v4))
		else
			v(NavigateDown(v4))
		end
	end, { v, sections, profileName })

	return React.createElement(Description, {
		description = description,
		layoutOrder = p.layoutOrder,
		onActivateMoreButton = onActivateMoreButton
	})
end

return AboutDescriptionContainer
