local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local NavigationRodux = require(ProfilePlatformParent.NavigationRodux)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useAboutSections = require(ProfilePlatform.Hooks.useAboutSections)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local Description = require(ProfilePlatform.Components.Description)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local parseSectionsFromData = require(script.Parent.parseSectionsFromData)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v21 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands

local function AboutDescriptionContainer(t1: {[any]: any}) -- line: 31
	-- upvalues: useDispatch (copy), FFlagProfilePlatformNewProfileHeader (copy), useAboutSections (copy), useProfileWrapperContext (copy), useProfileJsonComponent (copy), Enums (copy), React (copy), parseSectionsFromData (copy), FFlagProfileAboutDetailsUseSheet (copy), useLocalization (copy), TextKeys (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateDown (copy), Description (copy)
	local v24 = useDispatch()
	local aboutDetails, aboutSections

	if FFlagProfilePlatformNewProfileHeader then
		local v25 = useAboutSections()

		aboutDetails = v25.aboutDetails
		aboutSections = v25.aboutSections
	else
		local profileType = useProfileWrapperContext().profileType

		aboutDetails = useProfileJsonComponent(Enums.Components.About)
		aboutSections = React.useMemo(function() -- line: 43
			-- upvalues: parseSectionsFromData (copy), aboutDetails (ref), profileType (copy), Enums (copy)
			return parseSectionsFromData(aboutDetails, profileType, if profileType ~= Enums.ProfileTypes.User then aboutDetails.name else `@{ aboutDetails.name }`)
		end, {
			aboutDetails,
			profileType,
			aboutDetails.name
		})
	end

	local v29 = if not FFlagProfileAboutDetailsUseSheet then nil else if useProfileWrapperContext().profileType ~= Enums.ProfileTypes.User then aboutDetails.name else `@{ aboutDetails.name }`
	local description = aboutDetails.description
	local v31 = useLocalization({
		noBioYet = TextKeys.NoBioYet
	})

	if description == nil or description == "" then
		description = if not FFlagProfilePlatformNewProfileHeader then v31.noBioYet else nil
	end

	local v32 = React.useCallback(function() -- line: 69
		-- upvalues: AppPage (copy), aboutSections (ref), v29 (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), v24 (copy), NavigateDown (copy)
		local t2 = {
			name = AppPage.AboutDetailsSheet,
			extraProps = {
				sections = aboutSections,
				profileName = v29
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v21.down(v21.fromLegacyPage(t2))

			return
		end

		v24(NavigateDown(t2))
	end, {
		v24,
		aboutSections,
		v29
	})

	return React.createElement(Description, {
		description = description,
		layoutOrder = t1.layoutOrder,
		onActivateMoreButton = v32
	})
end

return AboutDescriptionContainer
