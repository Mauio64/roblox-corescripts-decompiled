local Parent = script:FindFirstAncestor("UserProfiles").Parent
local createSignal = require(Parent.Signals).createSignal
local SharedFlags = require(Parent.SharedFlags)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

return {
	update = function(t1: {[any]: any}, p1) -- line: 61
		-- upvalues: FFlagEnableVerifiedBadgeStore (copy), FFlagEnableBlackbirdCheck (copy)
		if not p1 or type(p1) ~= "table" then
			return
		end

		local names = p1.names

		if names and type(names) == "table" then
			local username = names.username

			if username and type(username) == "string" then
				t1.names.setUsername(username)
			end

			local displayName = names.displayName

			if displayName and type(displayName) == "string" then
				t1.names.setDisplayName(displayName)
			end

			local combinedName = names.combinedName

			if combinedName and type(combinedName) == "string" then
				t1.names.setCombinedName(combinedName)
			end

			local inExperienceCombinedName = names.inExperienceCombinedName

			if inExperienceCombinedName and type(inExperienceCombinedName) == "string" then
				t1.names.setInExperienceCombinedName(inExperienceCombinedName)
			end

			local platformName = names.platformName

			if platformName and type(platformName) == "string" then
				t1.names.setPlatformName(platformName)
			end

			local contactName = names.contactName

			if contactName and type(contactName) == "string" then
				t1.names.setContactName(contactName)
			end

			local alias = names.alias

			if alias and type(alias) == "string" then
				t1.names.setAlias(alias)
			end
		end

		local platformProfileId = p1.platformProfileId

		if platformProfileId and type(platformProfileId) == "string" then
			t1.setPlatformProfileId(platformProfileId)
		end

		local v17 = if not FFlagEnableVerifiedBadgeStore then nil else p1.isVerified

		if v17 ~= nil and type(v17) == "boolean" then
			t1.setIsVerified(v17)
		end

		local v18 = if not FFlagEnableBlackbirdCheck then nil else p1.hasRobloxSubscription

		if v18 ~= nil and type(v18) == "boolean" then
			t1.setHasRobloxSubscription(v18)
		end
	end,
	create = function(s1: string) -- line: 114
		-- upvalues: createSignal (copy), FFlagEnableVerifiedBadgeStore (copy), FFlagEnableBlackbirdCheck (copy)
		local v20, v21 = createSignal("")
		local v22, v23 = createSignal("")
		local v24, v25 = createSignal("")
		local v26, v27 = createSignal("")
		local v28, v29 = createSignal("")
		local v30, v31 = createSignal("")
		local v32, v33 = createSignal("")
		local v34, v35 = createSignal("")
		local v36 = nil
		local v37 = nil

		if FFlagEnableVerifiedBadgeStore then
			v36, v37 = createSignal(false)
		end

		local v38 = nil
		local v39 = nil

		if FFlagEnableBlackbirdCheck then
			v38, v39 = createSignal(false)
		end

		return {
			userId = s1,
			names = {
				getUsername = v20,
				setUsername = v21,
				getDisplayName = v22,
				setDisplayName = v23,
				getCombinedName = v24,
				setCombinedName = v25,
				getInExperienceCombinedName = v26,
				setInExperienceCombinedName = v27,
				getPlatformName = v28,
				setPlatformName = v29,
				getContactName = v30,
				setContactName = v31,
				getAlias = v32,
				setAlias = v33
			},
			getPlatformProfileId = v34,
			setPlatformProfileId = v35,
			getIsVerified = if not FFlagEnableVerifiedBadgeStore then nil else v36,
			setIsVerified = if not FFlagEnableVerifiedBadgeStore then nil else v37,
			getHasRobloxSubscription = if not FFlagEnableBlackbirdCheck then nil else v38,
			setHasRobloxSubscription = if not FFlagEnableBlackbirdCheck then nil else v39
		}
	end
}
