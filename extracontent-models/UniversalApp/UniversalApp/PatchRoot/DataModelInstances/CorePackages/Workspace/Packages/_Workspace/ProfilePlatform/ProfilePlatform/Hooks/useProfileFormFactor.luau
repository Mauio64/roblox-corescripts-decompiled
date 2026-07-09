local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useSelector = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useSelector
local FormFactor = require(ProfilePlatformParent.FormFactor).Enums.FormFactor
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab
local Enums = require(ProfilePlatform.Common.Enums)

return function() -- line: 18
	-- upvalues: useSelector (copy), useProfileWrapperContext (copy), Enums (copy), FFlagAXEnableProfileTab (copy), React (copy), FormFactor (copy)
	local v9 = useSelector(function(p1) -- line: 19
		return p1.FormFactor
	end)
	local v10 = useProfileWrapperContext()
	local v11 = v10.profileType == Enums.ProfileTypes.Community
	local v12 = v10.sourceInfo.source == Enums.Sources.HomepageAd
	local v13 = ((if not FFlagAXEnableProfileTab then nil else v10.forceFullView == true)) or v11 and v12

	return (React.useMemo(function() -- line: 32
		-- upvalues: v9 (copy), FormFactor (copy), Enums (copy), v13 (copy)
		if v9 == FormFactor.WIDE then
			return {
				formFactor = Enums.ProfileFormFactor.Wide,
				isFullView = v13
			}
		end

		return {
			formFactor = Enums.ProfileFormFactor.PeekView,
			isFullView = v13
		}
	end, {
		v9,
		v13
	}))
end
