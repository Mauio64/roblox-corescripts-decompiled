local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)
local Cryo = require(AppChatParent.Cryo)
local PresenceType = require(AppChat.Http.RoduxPresence).Enums.PresenceType
local t1 = {
	["1"] = {
		id = "1",
		username = "username1",
		displayName = "displayName1",
		combinedName = "combinedName1",
		alias = "alias1",
		presenceText = "Online",
		lastLocation = "TestLocation",
		presenceType = PresenceType.Online
	},
	["2"] = {
		id = "2",
		username = "username2",
		displayName = "displayName2",
		combinedName = "combinedName2",
		alias = "alias2",
		presenceText = "Studio - Testing",
		lastLocation = "Studio - Testing",
		presenceType = PresenceType.InGame
	},
	["3"] = {
		id = "3",
		username = "username3",
		displayName = "displayName3",
		combinedName = "combinedName3",
		alias = "alias3",
		presenceText = "Offline",
		lastLocation = nil,
		presenceType = PresenceType.Offline
	},
	["4"] = {
		id = "4",
		username = "username4",
		displayName = "displayName4",
		combinedName = "combinedName4",
		alias = "alias4",
		presenceText = "Online",
		lastLocation = "TestLocation",
		presenceType = PresenceType.Online
	},
	["1989"] = {
		id = "1989",
		username = "username",
		displayName = "Test Display Name",
		combinedName = "Test Primary Name",
		alias = "Test Primary Name",
		presenceText = "Online",
		lastLocation = "TestLocation",
		presenceType = PresenceType.Online
	},
	["1969"] = {
		id = "1969",
		username = "username",
		displayName = "ClementOrange",
		combinedName = "OrangeClement",
		alias = "OrangeClement",
		presenceText = "Studio - Testing",
		lastLocation = "Studio - Testing",
		presenceType = PresenceType.InGame
	},
	["1949"] = {
		id = "1949",
		username = "username",
		displayName = "PineAzure",
		combinedName = "AzurePine",
		alias = "AzurePine",
		presenceText = "Offline",
		lastLocation = nil,
		presenceType = PresenceType.Offline
	},
	["422502"] = {
		id = "422502",
		username = "username",
		displayName = "TestUserB",
		combinedName = "TestUserB",
		alias = "(alias)",
		presenceText = "Studio - Testing",
		lastLocation = "Studio - Testing",
		presenceType = PresenceType.InGame
	}
}

function createMockUserProfile(p1) -- line: 107
	-- upvalues: Signals (copy)
	local createSignal = Signals.createSignal
	local v9, _ = createSignal(p1.username or "")
	local v11, _ = createSignal(p1.displayName or "")
	local v13, _ = createSignal(p1.combinedName or "")
	local v15, _ = createSignal(p1.combinedName or "")
	local v17, _ = createSignal(p1.combinedName or "")
	local v19, _ = createSignal(p1.alias or "")
	local v21, _ = createSignal("")

	return {
		userId = p1.id,
		names = {
			getUsername = v9,
			getDisplayName = v11,
			getCombinedName = v13,
			getInExperienceCombinedName = v15,
			getPlatformName = v17,
			getAlias = v19
		},
		getPlatformProfileId = v21
	}
end
function createMockUserProfileStore() -- line: 133
	-- upvalues: t1 (copy), Cryo (copy), Signals (copy)
	local t2 = {}

	for k, v in pairs(t1) do
		t2[k] = createMockUserProfile(v)
	end

	return {
		fetchNamesByUserIds = function(p2) -- line: 141
			-- upvalues: Cryo (copy), t2 (copy), t1 (copy), Signals (copy)
			local v33 = Cryo.List.filterMap(p2, function(p3) -- line: 142
				-- upvalues: t2 (copy), t1 (copy)
				local v37 = t2[p3]

				if not v37 and t1[p3] then
					v37 = createMockUserProfile(t1[p3])
					t2[p3] = v37
				end

				return v37
			end)
			local t3 = {
				status = "success",
				data = v33
			}

			return Signals.createSignal(t3)
		end,
		invalidateCachedNamesForUserIds = function() -- line: 164
		end
	}
end
function createMockPresenceData() -- line: 169
	-- upvalues: t1 (copy)
	local t4 = {}

	for k, v in pairs(t1) do
		t4[k] = {
			userPresenceType = v.presenceType,
			lastLocation = v.lastLocation
		}
	end

	return t4
end
function createMockApolloProfiles() -- line: 183
	-- upvalues: t1 (copy)
	local t5 = {}

	for k, v in pairs(t1) do
		t5[k] = {
			combinedName = v.combinedName,
			alias = v.alias,
			displayName = v.displayName,
			username = v.username,
			platformName = v.combinedName
		}
	end

	return t5
end
function getUserProfilesFetchData() -- line: 200
	-- upvalues: Cryo (copy), t1 (copy)
	return Cryo.List.map(t1, function(p4) -- line: 201
		return p4
	end)
end

return {
	USERS = t1,
	createMockUserProfile = createMockUserProfile,
	createMockUserProfileStore = createMockUserProfileStore,
	createMockPresenceData = createMockPresenceData,
	createMockApolloProfiles = createMockApolloProfiles,
	getUserProfilesFetchData = getUserProfilesFetchData
}
