local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local parseSectionsFromData = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/About/parseSectionsFromData")
local fFlagProfileAboutDetailsUseSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfileAboutDetailsUseSheet

return function()
	local profileType = useProfileWrapperContext().profileType
	local v5 = useProfileJsonComponent(Enums.Components.About) or {}

	local v6 = React.useMemo(function()
		local v10 = if profileType == Enums.ProfileTypes.User and v5.name then `@{v5.name}` else v5.name or ""
		return parseSectionsFromData(v5, profileType, v10)
	end, { v5, profileType, v5.name })
	local v7

	if fFlagProfileAboutDetailsUseSheet then
		v7 = if profileType == Enums.ProfileTypes.User and v5.name then `@{v5.name}` else v5.name
	end

	return { aboutDetails = v5, aboutSections = v6, profileName = v7 }
end
