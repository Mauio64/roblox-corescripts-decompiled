local parent = script:FindFirstAncestor("GameJoinCard").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local UserProfiles = require(parent.UserProfiles)
local SharedFlags = require(parent.SharedFlags)

local FFlagSocialCarouselUseProfileStore = SharedFlags.FFlagSocialCarouselUseProfileStore
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile

local function usePlayerName(p: string)
	if FFlagSocialCarouselUseProfileStore then
		local v = React.useMemo(function()
			return UserProfiles.Stores.UserProfileStore.get().fetchNamesByUserIds({ p })
		end, { p })

		local v2 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				local v2 = v(p2)
				local v3 = v2 and v2.data and v2.data[1]

				if v3 and v3.names then
					return (v3.names.getCombinedName(p2))
				end

				return nil
			end)
		end, { v })

		return SignalsReact.useSignalState(v2) or ""
	else
		local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
		local v = {
			userIds = { p },
			query = 0
		}
		local query

		if FFlagUserProfilePlatformProfile then
			query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
		else
			query = UserProfiles.Queries.userProfilesCombinedAndPlatformByUserIds
		end

		v.query = query
		local v2 = useUserProfilesFetch(v)

		return React.useMemo(function()
			if v2.data then
				return UserProfiles.Selectors.getCombinedNameFromId(v2.data, p) or ""
			end

			return ""
		end, { v2.data, p })
	end
end

return usePlayerName
