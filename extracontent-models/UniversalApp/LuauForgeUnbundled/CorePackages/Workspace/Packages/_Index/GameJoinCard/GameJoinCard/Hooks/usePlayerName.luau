local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SignalsReact")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserProfiles")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags")

local fFlagSocialCarouselUseProfileStore = SharedFlags.FFlagSocialCarouselUseProfileStore
local fFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile

local function usePlayerName(p2)
	if fFlagSocialCarouselUseProfileStore then
		local v5 = React.useMemo(function()
			return UserProfiles.Stores.UserProfileStore.get().fetchNamesByUserIds({ p2 })
		end, { p2 })

		local v6 = React.useMemo(function()
			return Signals.createComputed(function(p3)
				local v7 = v5(p3)
				local v8 = v7 and v7.data and v7.data[1]

				if v8 and v8.names then
					return (v8.names.getCombinedName(p3))
				end

				return nil
			end)
		end, { v5 })

		return SignalsReact.useSignalState(v6) or ""
	else
		local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
		local v5 = {
			userIds = { p2 },
			query = 0
		}

		local v6 = if fFlagUserProfilePlatformProfile then UserProfiles.Queries.userProfilesCombinedNameByUserIds else UserProfiles.Queries.userProfilesCombinedAndPlatformByUserIds
		v5.query = v6
		local v7 = useUserProfilesFetch(v5)

		return React.useMemo(function()
			if v7.data then
				return UserProfiles.Selectors.getCombinedNameFromId(v7.data, p2) or ""
			end

			return ""
		end, { v7.data, p2 })
	end
end

return usePlayerName
