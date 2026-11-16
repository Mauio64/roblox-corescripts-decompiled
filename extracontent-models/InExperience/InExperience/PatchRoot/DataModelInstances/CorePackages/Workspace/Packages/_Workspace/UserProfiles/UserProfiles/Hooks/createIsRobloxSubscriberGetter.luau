local UserProfiles = script:FindFirstAncestor("UserProfiles")
local parent = UserProfiles.Parent

local Signals = require(parent.Signals)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

local UserProfileStore = require(UserProfiles.Stores.UserProfileStore)

local createComputed = Signals.createComputed

local function createIsRobloxSubscriberGetter(p: string?)
	if not FFlagEnableBlackbirdCheck or p == nil or p == "" then
		return createComputed(function(): boolean
			return false
		end)
	end

	local namesByUserIds = UserProfileStore.get().fetchNamesByUserIds({ p })

	return createComputed(function(p2)
		local success, result = pcall(namesByUserIds, p2)

		if success and result.status == "success" and #result.data > 0 then
			local v = result.data[1]

			if v.getHasRobloxSubscription ~= nil then
				return v.getHasRobloxSubscription(p2)
			end
		end

		return false
	end)
end

return createIsRobloxSubscriberGetter
