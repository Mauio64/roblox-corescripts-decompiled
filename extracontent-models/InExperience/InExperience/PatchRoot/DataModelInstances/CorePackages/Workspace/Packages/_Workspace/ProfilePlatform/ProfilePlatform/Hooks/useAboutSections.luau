local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local parseSectionsFromData = require(ProfilePlatform.Components.About.parseSectionsFromData)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfileAboutDetailsUseSheet = SharedFlags.FFlagProfileAboutDetailsUseSheet

return function()
	local profileType = useProfileWrapperContext().profileType
	local aboutDetails = useProfileJsonComponent(Enums.Components.About) or {}

	local aboutSections = React.useMemo(function()
		local v

		if profileType == Enums.ProfileTypes.User and aboutDetails.name then
			v = `@{aboutDetails.name}`
		else
			v = aboutDetails.name or ""
		end

		return parseSectionsFromData(aboutDetails, profileType, v)
	end, { aboutDetails, profileType, aboutDetails.name })
	local profileName

	if FFlagProfileAboutDetailsUseSheet then
		if profileType == Enums.ProfileTypes.User and aboutDetails.name then
			profileName = `@{aboutDetails.name}`
		else
			profileName = aboutDetails.name
		end
	end

	return { aboutDetails = aboutDetails, aboutSections = aboutSections, profileName = profileName }
end
