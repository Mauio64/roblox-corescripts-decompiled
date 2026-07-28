local Players = game:GetService("Players")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local createDataCache = require(DataHydration.createDataCache)
local DataHydrationTypes = require(DataHydration.DataHydrationTypes)
local Signals = require(DataHydrationParent.Signals)
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local v8 = createDataCache()
local t1 = {}
local u10 = getLocalPlayerUserId()

Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 68
	-- upvalues: getLocalPlayerUserId (copy), u10 (ref), t1 (copy)
	local v16 = getLocalPlayerUserId()

	if v16 ~= u10 then
		u10 = v16
		table.clear(t1)
	end
end)

local UserProfileStore = nil

local function getUserProfileStore() -- line: 77
	-- upvalues: UserProfileStore (ref), DataHydrationParent (copy)
	if not UserProfileStore then
		UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
	end

	return UserProfileStore
end
local function getProfileModel(s1: string) -- line: 84
	-- upvalues: UserProfileStore (ref), DataHydrationParent (copy)
	if not UserProfileStore then
		UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
	end

	return (UserProfileStore.get().getProfileByUserId(s1))
end
local function getStatusAndFetch(s2: string) -- line: 88
	-- upvalues: v8 (copy), UserProfileStore (ref), DataHydrationParent (copy)
	local v19, v20 = v8.getItem(s2)

	if v20 then
		if not UserProfileStore then
			UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
		end

		UserProfileStore.get().fetchNamesByUserIds({ s2 }, function(p1) -- line: 91
			-- upvalues: v8 (copy), s2 (copy)
			if p1.status == "success" then
				v8.replaceItem(s2, true)

				return
			end

			if p1.status == "failed" then
				v8.markItemsAsFailed({ s2 })
			end
		end)
	end

	return v19, v20
end
local function resolveUserProfileField(t2: {[any]: any}, s3: string, p2) -- line: 102
	if s3 == "userId" then
		return (tonumber(t2.userId))
	end

	if s3 == "username" then
		return t2.names.getUsername(p2)
	end

	if s3 == "displayName" then
		return t2.names.getDisplayName(p2)
	end

	if s3 == "isVerified" then
		if t2.getIsVerified ~= nil then
			return (t2.getIsVerified(p2))
		end

		return nil
	end

	return nil
end

return {
	resolveField = function(_: string, t3: {[any]: any}, s5: string, p3, _: boolean?) -- line: 115
		-- upvalues: getStatusAndFetch (copy), DataHydrationTypes (copy), UserProfileStore (ref), DataHydrationParent (copy), resolveUserProfileField (copy)
		if #t3 < 2 then
			return nil, nil
		end

		local str = tostring(s5)
		local v30 = getStatusAndFetch(str).status(p3)

		if v30 ~= DataHydrationTypes.DataStatus.Ready then
			return nil, v30
		end

		if not UserProfileStore then
			UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
		end

		local v31 = UserProfileStore.get().getProfileByUserId(str)

		if not v31 then
			return nil, v30
		end

		local v32 = t3[2]

		return resolveUserProfileField(v31, v32, p3), v30
	end,
	updateFromHydration = function(t4: {[any]: any}) -- line: 182
		-- upvalues: UserProfileStore (ref), DataHydrationParent (copy), v8 (copy)
		if not UserProfileStore then
			UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
		end

		UserProfileStore.get().updateFromHydration(t4)

		local t5 = {}

		for v40, v41 in t4 do
			t5[if v41.userId == nil then v40 else tostring(v41.userId)] = true
		end

		v8.replaceItems(t5)
	end,
	getAndFetchUserInfo = function(p4) -- line: 147
		-- upvalues: t1 (copy), Signals (copy), getStatusAndFetch (copy), DataHydrationTypes (copy), UserProfileStore (ref), DataHydrationParent (copy)
		local str = tostring(p4)
		local v35 = t1[str]

		if v35 ~= nil then
			return v35
		end

		local v36 = Signals.createComputed(function(p5) -- line: 154
			-- upvalues: getStatusAndFetch (copy), str (copy)
			return getStatusAndFetch(str).status(p5)
		end)
		local t6 = {
			info = Signals.createComputed(function(p6) -- line: 159
				-- upvalues: v36 (copy), DataHydrationTypes (copy), str (copy), UserProfileStore (ref), DataHydrationParent (copy)
				if v36(p6) ~= DataHydrationTypes.DataStatus.Ready then
					return nil
				end

				local v45 = str

				if not UserProfileStore then
					UserProfileStore = require(DataHydrationParent.UserProfiles).Stores.UserProfileStore
				end

				local v46 = UserProfileStore.get().getProfileByUserId(v45)

				if v46 == nil then
					return nil
				end

				return {
					userId = tonumber(str),
					displayName = v46.names.getDisplayName(p6),
					username = v46.names.getUsername(p6),
					hasVerifiedBadge = v46.getIsVerified ~= nil and v46.getIsVerified(p6)
				}
			end),
			status = v36
		}

		t1[str] = t6

		return t6
	end
}
