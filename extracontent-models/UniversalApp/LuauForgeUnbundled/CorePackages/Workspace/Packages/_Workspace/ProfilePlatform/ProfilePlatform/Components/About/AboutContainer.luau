local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local useAboutSections = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useAboutSections")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local Description = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Description")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local parseSectionsFromData = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/About/parseSectionsFromData")

local navigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local fFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local fFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

local function AboutDescriptionContainer(p2)
	local v5 = useDispatch()
	local v6, v7

	if fFlagProfilePlatformNewProfileHeader then
		local v8 = useAboutSections()
		v6 = v8.aboutDetails
		v7 = v8.aboutSections
	else
		local profileType = useProfileWrapperContext().profileType
		v6 = useProfileJsonComponent(Enums.Components.About)
		v7 = React.useMemo(function()
			local v9 = v6

			local v11 = if profileType == Enums.ProfileTypes.User then `@{v6.name}` else v6.name
			return parseSectionsFromData(v9, profileType, v11)
		end, { v6, profileType, v6.name })
	end

	local v8

	if fFlagProfileAboutDetailsUseSheet then
		v8 = if useProfileWrapperContext().profileType == Enums.ProfileTypes.User then `@{v6.name}` else v6.name
	else
		v8 = nil
	end

	local v9 = v6.description
	local v10 = useLocalization({ noBioYet = TextKeys.NoBioYet })

	if v9 == nil or v9 == "" then
		v9 = if not fFlagProfilePlatformNewProfileHeader then v10.noBioYet else nil
	end

	local v11 = React.useCallback(function()
		local v12 = {
			name = appPage.AboutDetailsSheet,
			extraProps = { sections = v7, profileName = v8 }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v12))
		else
			v5(navigateDown(v12))
		end
	end, { v5, v7, v8 })

	return React.createElement(Description, {
		description = v9,
		layoutOrder = p2.layoutOrder,
		onActivateMoreButton = v11
	})
end

return AboutDescriptionContainer
