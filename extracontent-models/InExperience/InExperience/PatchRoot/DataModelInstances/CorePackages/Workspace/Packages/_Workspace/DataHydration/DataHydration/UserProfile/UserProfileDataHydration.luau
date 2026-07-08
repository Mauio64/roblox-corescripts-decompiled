local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local createDataCache = require(DataHydration.createDataCache)
local DataHydrationTypes = require(DataHydration.DataHydrationTypes)

require(DataHydrationParent.Signals)

local v5 = createDataCache()
local UserProfileStore = nil

local function getUserProfileStore() -- line: 42
	-- upvalues: UserProfileStore (ref), DataHydrationParent (copy)
	if not UserProfileStore then
		UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
	end

	return UserProfileStore
end
local function getProfileModel(s1: string) -- line: 49
	-- upvalues: UserProfileStore (ref), DataHydrationParent (copy)
	if not UserProfileStore then
		UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
	end

	return (UserProfileStore.get().getProfileByUserId(s1))
end
local function getStatusAndFetch(s2: string) -- line: 53
	-- upvalues: v5 (copy), UserProfileStore (ref), DataHydrationParent (copy)
	local v13, v14 = v5.getItem(s2)

	if v14 then
		if not UserProfileStore then
			UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
		end

		UserProfileStore.get().fetchNamesByUserIds({ s2 }, function(p1) -- line: 56
			-- upvalues: v5 (copy), s2 (copy)
			if p1.status == "success" then
				v5.replaceItem(s2, true)

				return
			end

			if p1.status == "failed" then
				v5.markItemsAsFailed({ s2 })
			end
		end)
	end

	return v13, v14
end
local function resolveUserProfileField(t1: {[any]: any}, s3: string, p2) -- line: 67
	if s3 == "userId" then
		return (tonumber(t1.userId))
	end

	if s3 == "username" then
		return t1.names.getUsername(p2)
	end

	if s3 == "displayName" then
		return t1.names.getDisplayName(p2)
	end

	if s3 == "isVerified" then
		if t1.getIsVerified ~= nil then
			return (t1.getIsVerified(p2))
		end

		return nil
	end

	return nil
end

return {
	resolveField = function(_: string, t2: {[any]: any}, s5: string, p3, _: boolean?) -- line: 80
		-- upvalues: getStatusAndFetch (copy), DataHydrationTypes (copy), UserProfileStore (ref), DataHydrationParent (copy), resolveUserProfileField (copy)
		if #t2 < 2 then
			return nil, nil
		end

		local str = tostring(s5)
		local v24 = getStatusAndFetch(str).status(p3)

		if v24 ~= DataHydrationTypes.DataStatus.Ready then
			return nil, v24
		end

		if not UserProfileStore then
			UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
		end

		local v25 = UserProfileStore.get().getProfileByUserId(str)

		if not v25 then
			return nil, v24
		end

		local v26 = t2[2]

		return resolveUserProfileField(v25, v26, p3), v24
	end,
	updateFromHydration = function(t3: {[any]: any}) -- line: 108
		-- upvalues: UserProfileStore (ref), DataHydrationParent (copy), v5 (copy)
		if not UserProfileStore then
			UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
		end

		UserProfileStore.get().updateFromHydration(t3)

		local t4 = {}

		for v29, v30 in t3 do
			t4[if v30.userId == nil then v29 else tostring(v30.userId)] = true
		end

		v5.replaceItems(t4)
	end
}
