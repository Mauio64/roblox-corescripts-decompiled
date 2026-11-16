local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)
local Cryo = require(parent.Cryo)
local RoduxPresence = require(AppChat.Http.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType

local users = {
	["1"] = {
		id = "1",
		username = "username1",
		displayName = "displayName1",
		combinedName = "combinedName1",
		alias = "alias1",
		presenceType = PresenceType.Online,
		presenceText = "Online",
		lastLocation = "TestLocation"
	},
	["2"] = {
		id = "2",
		username = "username2",
		displayName = "displayName2",
		combinedName = "combinedName2",
		alias = "alias2",
		presenceType = PresenceType.InGame,
		presenceText = "Studio - Testing",
		lastLocation = "Studio - Testing"
	},
	["3"] = {
		id = "3",
		username = "username3",
		displayName = "displayName3",
		combinedName = "combinedName3",
		alias = "alias3",
		presenceType = PresenceType.Offline,
		presenceText = "Offline",
		lastLocation = nil
	},
	["4"] = {
		id = "4",
		username = "username4",
		displayName = "displayName4",
		combinedName = "combinedName4",
		alias = "alias4",
		presenceType = PresenceType.Online,
		presenceText = "Online",
		lastLocation = "TestLocation"
	},
	["1989"] = {
		id = "1989",
		username = "username",
		displayName = "Test Display Name",
		combinedName = "Test Primary Name",
		alias = "Test Primary Name",
		presenceType = PresenceType.Online,
		presenceText = "Online",
		lastLocation = "TestLocation"
	},
	["1969"] = {
		id = "1969",
		username = "username",
		displayName = "ClementOrange",
		combinedName = "OrangeClement",
		alias = "OrangeClement",
		presenceType = PresenceType.InGame,
		presenceText = "Studio - Testing",
		lastLocation = "Studio - Testing"
	},
	["1949"] = {
		id = "1949",
		username = "username",
		displayName = "PineAzure",
		combinedName = "AzurePine",
		alias = "AzurePine",
		presenceType = PresenceType.Offline,
		presenceText = "Offline",
		lastLocation = nil
	},
	["422502"] = {
		id = "422502",
		username = "username",
		displayName = "TestUserB",
		combinedName = "TestUserB",
		alias = "(alias)",
		presenceType = PresenceType.InGame,
		presenceText = "Studio - Testing",
		lastLocation = "Studio - Testing"
	}
}

function createMockUserProfile(data)
	local createSignal = Signals.createSignal

	local signal, _ = createSignal(data.username or "")
	local signal2, _ = createSignal(data.displayName or "")
	local signal3, _ = createSignal(data.combinedName or "")
	local signal4, _ = createSignal(data.combinedName or "")
	local signal5, _ = createSignal(data.combinedName or "")
	local signal6, _ = createSignal(data.alias or "")
	local signal7, _ = createSignal("")

	return {
		userId = data.id,
		names = {
			getUsername = signal,
			getDisplayName = signal2,
			getCombinedName = signal3,
			getInExperienceCombinedName = signal4,
			getPlatformName = signal5,
			getAlias = signal6
		},
		getPlatformProfileId = signal7
	}
end

function createMockUserProfileStore()
	local v = {}

	for k, v2 in pairs(users) do
		v[k] = createMockUserProfile(v2)
	end

	return {
		fetchNamesByUserIds = function(p)
			local v2 = {
				status = "success",
				data = Cryo.List.filterMap(p, function(p2)
					local v2 = v[p2]

					if not v2 and users[p2] then
						v2 = createMockUserProfile(users[p2])
						v[p2] = v2
					end

					return v2
				end)
			}

			return Signals.createSignal(v2)
		end,
		invalidateCachedNamesForUserIds = function() end
	}
end

function useMockProfileNames(items)
	local namesByUserId = {}
	local v = false

	for _, item in items do
		local v2 = users[tostring(item)]

		if v2 then
			namesByUserId[v2.id] = { combinedName = v2.combinedName, username = v2.username }
		else
			v = true
		end
	end

	return {
		status = v and "Failed" or "Ready",
		namesByUserId = namesByUserId
	}
end

function createMockPresenceData()
	local mockPresenceData = {}

	for k, v in pairs(users) do
		mockPresenceData[k] = { userPresenceType = v.presenceType, lastLocation = v.lastLocation }
	end

	return mockPresenceData
end

function createMockApolloProfiles()
	local mockApolloProfiles = {}

	for k, v in pairs(users) do
		mockApolloProfiles[k] = {
			combinedName = v.combinedName,
			alias = v.alias,
			displayName = v.displayName,
			username = v.username,
			platformName = v.combinedName
		}
	end

	return mockApolloProfiles
end

function getUserProfilesFetchData()
	return Cryo.List.map(users, function(p)
		return p
	end)
end

return {
	USERS = users,
	createMockUserProfile = createMockUserProfile,
	createMockUserProfileStore = createMockUserProfileStore,
	useMockProfileNames = useMockProfileNames,
	createMockPresenceData = createMockPresenceData,
	createMockApolloProfiles = createMockApolloProfiles,
	getUserProfilesFetchData = getUserProfilesFetchData
}
