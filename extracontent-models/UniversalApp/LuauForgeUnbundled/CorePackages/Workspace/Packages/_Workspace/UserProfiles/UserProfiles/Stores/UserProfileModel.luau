local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/Signals").createSignal

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/SharedFlags")
local fFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

return {
	update = function(data, data2)
		if not data2 or type(data2) ~= "table" then
			return
		end

		local names = data2.names

		if names and type(names) == "table" then
			local username = names.username

			if username and type(username) == "string" then
				data.names.setUsername(username)
			end

			local displayName = names.displayName

			if displayName and type(displayName) == "string" then
				data.names.setDisplayName(displayName)
			end

			local combinedName = names.combinedName

			if combinedName and type(combinedName) == "string" then
				data.names.setCombinedName(combinedName)
			end

			local inExperienceCombinedName = names.inExperienceCombinedName

			if inExperienceCombinedName and type(inExperienceCombinedName) == "string" then
				data.names.setInExperienceCombinedName(inExperienceCombinedName)
			end

			local platformName = names.platformName

			if platformName and type(platformName) == "string" then
				data.names.setPlatformName(platformName)
			end

			local contactName = names.contactName

			if contactName and type(contactName) == "string" then
				data.names.setContactName(contactName)
			end

			local alias = names.alias

			if alias and type(alias) == "string" then
				data.names.setAlias(alias)
			end
		end

		local platformProfileId = data2.platformProfileId

		if platformProfileId and type(platformProfileId) == "string" then
			data.setPlatformProfileId(platformProfileId)
		end

		local isVerified = if fFlagEnableVerifiedBadgeStore then data2.isVerified else nil

		if isVerified ~= nil and type(isVerified) == "boolean" then
			data.setIsVerified(isVerified)
		end

		local hasRobloxSubscription = if fFlagEnableBlackbirdCheck then data2.hasRobloxSubscription else nil

		if hasRobloxSubscription ~= nil and type(hasRobloxSubscription) == "boolean" then
			data.setHasRobloxSubscription(hasRobloxSubscription)
		end
	end,
	create = function(p2)
		local signal, v5 = createSignal("")
		local signal2, v6 = createSignal("")
		local signal3, v7 = createSignal("")
		local signal4, v8 = createSignal("")
		local signal5, v9 = createSignal("")
		local signal6, v10 = createSignal("")
		local signal7, v11 = createSignal("")
		local signal8, v12 = createSignal("")
		local v13, v14

		if fFlagEnableVerifiedBadgeStore then
			v13, v14 = createSignal(false)
		end

		local v15, v16

		if fFlagEnableBlackbirdCheck then
			v15, v16 = createSignal(false)
		end

		if not fFlagEnableVerifiedBadgeStore then
			v13 = nil
		end

		if not fFlagEnableVerifiedBadgeStore then
			v14 = nil
		end

		if not fFlagEnableBlackbirdCheck then
			v15 = nil
		end

		if not fFlagEnableBlackbirdCheck then
			v16 = nil
		end

		return {
			userId = p2,
			names = {
				getUsername = signal,
				setUsername = v5,
				getDisplayName = signal2,
				setDisplayName = v6,
				getCombinedName = signal3,
				setCombinedName = v7,
				getInExperienceCombinedName = signal4,
				setInExperienceCombinedName = v8,
				getPlatformName = signal5,
				setPlatformName = v9,
				getContactName = signal6,
				setContactName = v10,
				getAlias = signal7,
				setAlias = v11
			},
			getPlatformProfileId = signal8,
			setPlatformProfileId = v12,
			getIsVerified = v13,
			setIsVerified = v14,
			getHasRobloxSubscription = v15,
			setHasRobloxSubscription = v16
		}
	end
}
