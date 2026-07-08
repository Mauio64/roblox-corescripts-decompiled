local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Cryo = require(ProfilePlatformParent.Cryo)
local Enums = require(ProfilePlatform.Common.Enums)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)

function refreshProfilePlatform(t1: {[any]: any}) -- line: 17
	-- upvalues: Cryo (copy), Enums (copy), FFlagProfilePlatformCTAsRefactor (copy), getProfilePlatform (copy)
	local v8 = Cryo.List.map(t1.components, function(p1) -- line: 18
		-- upvalues: Enums (copy), FFlagProfilePlatformCTAsRefactor (copy)
		local t2 = {
			component = p1
		}

		if p1 == Enums.Components.Actions and FFlagProfilePlatformCTAsRefactor then
			t2.isActionsV2Supported = true
		end

		return t2
	end)

	return getProfilePlatform.API({
		includeComponentOrdering = false,
		profileType = t1.profileType,
		profileId = t1.profileId,
		components = v8
	})
end

return refreshProfilePlatform
