local parent = script:FindFirstAncestor("UserProfiles").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableVerifiedBadgeStore = SharedFlags.FFlagEnableVerifiedBadgeStore
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local UserProfileModel = {}

function UserProfileModel.update(data, data2)
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

	local isVerified

	if FFlagEnableVerifiedBadgeStore then
		isVerified = data2.isVerified
	end

	if isVerified ~= nil and type(isVerified) == "boolean" then
		data.setIsVerified(isVerified)
	end

	local hasRobloxSubscription

	if FFlagEnableBlackbirdCheck then
		hasRobloxSubscription = data2.hasRobloxSubscription
	end

	if hasRobloxSubscription ~= nil and type(hasRobloxSubscription) == "boolean" then
		data.setHasRobloxSubscription(hasRobloxSubscription)
	end
end

function UserProfileModel.create(userId: string)
	local signal, setUsername = createSignal("")
	local signal2, setDisplayName = createSignal("")
	local signal3, setCombinedName = createSignal("")
	local signal4, setInExperienceCombinedName = createSignal("")
	local signal5, setPlatformName = createSignal("")
	local signal6, setContactName = createSignal("")
	local signal7, setAlias = createSignal("")
	local signal8, setPlatformProfileId = createSignal("")
	local getIsVerified, setIsVerified

	if FFlagEnableVerifiedBadgeStore then
		getIsVerified, setIsVerified = createSignal(false)
	end

	local getHasRobloxSubscription, setHasRobloxSubscription

	if FFlagEnableBlackbirdCheck then
		getHasRobloxSubscription, setHasRobloxSubscription = createSignal(false)
	end

	if not FFlagEnableVerifiedBadgeStore then
		getIsVerified = nil
	end

	if not FFlagEnableVerifiedBadgeStore then
		setIsVerified = nil
	end

	if not FFlagEnableBlackbirdCheck then
		getHasRobloxSubscription = nil
	end

	if not FFlagEnableBlackbirdCheck then
		setHasRobloxSubscription = nil
	end

	return {
		userId = userId,
		names = {
			getUsername = signal,
			setUsername = setUsername,
			getDisplayName = signal2,
			setDisplayName = setDisplayName,
			getCombinedName = signal3,
			setCombinedName = setCombinedName,
			getInExperienceCombinedName = signal4,
			setInExperienceCombinedName = setInExperienceCombinedName,
			getPlatformName = signal5,
			setPlatformName = setPlatformName,
			getContactName = signal6,
			setContactName = setContactName,
			getAlias = signal7,
			setAlias = setAlias
		},
		getPlatformProfileId = signal8,
		setPlatformProfileId = setPlatformProfileId,
		getIsVerified = getIsVerified,
		setIsVerified = setIsVerified,
		getHasRobloxSubscription = getHasRobloxSubscription,
		setHasRobloxSubscription = setHasRobloxSubscription
	}
end

return UserProfileModel
