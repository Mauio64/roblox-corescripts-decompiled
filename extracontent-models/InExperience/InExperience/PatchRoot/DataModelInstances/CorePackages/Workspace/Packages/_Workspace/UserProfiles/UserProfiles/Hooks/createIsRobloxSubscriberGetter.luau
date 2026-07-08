local UserProfiles = script:FindFirstAncestor("UserProfiles")
local UserProfilesParent = UserProfiles.Parent
local Signals = require(UserProfilesParent.Signals)
local FFlagEnableBlackbirdCheck = require(UserProfilesParent.SharedFlags).FFlagEnableBlackbirdCheck
local UserProfileStore = require(UserProfiles.Stores.UserProfileStore)
local createComputed = Signals.createComputed

local function createIsRobloxSubscriberGetter(s1: string?) -- line: 14
	-- upvalues: FFlagEnableBlackbirdCheck (copy), createComputed (copy), UserProfileStore (copy)
	if not FFlagEnableBlackbirdCheck or (s1 == nil or s1 == "") then
		return createComputed(function() -- line: 16
			return false
		end)
	end

	local v9 = UserProfileStore.get().fetchNamesByUserIds({ s1 })

	return createComputed(function(p1) -- line: 24
		-- upvalues: v9 (copy)
		local ok, result = pcall(v9, p1)

		if ok and (result.status == "success" and #result.data > 0) then
			local v13 = result.data[1]

			if v13.getHasRobloxSubscription ~= nil then
				return v13.getHasRobloxSubscription(p1)
			end
		end

		return false
	end)
end

return createIsRobloxSubscriberGetter
