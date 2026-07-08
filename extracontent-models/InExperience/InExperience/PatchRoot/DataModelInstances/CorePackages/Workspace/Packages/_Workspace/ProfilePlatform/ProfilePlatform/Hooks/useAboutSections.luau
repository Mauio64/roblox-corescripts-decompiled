local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local parseSectionsFromData = require(ProfilePlatform.Components.About.parseSectionsFromData)
local FFlagProfileAboutDetailsUseSheet = require(ProfilePlatformParent.SharedFlags).FFlagProfileAboutDetailsUseSheet

return function() -- line: 11
	-- upvalues: useProfileWrapperContext (copy), useProfileJsonComponent (copy), Enums (copy), React (copy), parseSectionsFromData (copy), FFlagProfileAboutDetailsUseSheet (copy)
	local profileType = useProfileWrapperContext().profileType
	local v10 = useProfileJsonComponent(Enums.Components.About) or {}
	local v11 = React.useMemo(function() -- line: 16
		-- upvalues: parseSectionsFromData (copy), v10 (copy), profileType (copy), Enums (copy)
		return parseSectionsFromData(v10, profileType, if profileType ~= Enums.ProfileTypes.User or not v10.name then v10.name or "" else `@{ v10.name }`)
	end, {
		v10,
		profileType,
		v10.name
	})
	local v12 = if not FFlagProfileAboutDetailsUseSheet then nil else if profileType ~= Enums.ProfileTypes.User or not v10.name then v10.name else `@{ v10.name }`

	return {
		aboutDetails = v10,
		aboutSections = v11,
		profileName = v12
	}
end
