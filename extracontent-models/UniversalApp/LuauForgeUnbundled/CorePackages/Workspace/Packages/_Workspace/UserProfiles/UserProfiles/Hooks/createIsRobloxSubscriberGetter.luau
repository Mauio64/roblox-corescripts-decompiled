local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/Signals")

local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/SharedFlags").FFlagEnableBlackbirdCheck

local UserProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Stores/UserProfileStore")

local createComputed = Signals.createComputed

local function createIsRobloxSubscriberGetter(p2)
	if not fFlagEnableBlackbirdCheck or p2 == nil or p2 == "" then
		return createComputed(function(): boolean
			return false
		end)
	end

	local namesByUserIds = UserProfileStore.get().fetchNamesByUserIds({ p2 })

	return createComputed(function(p3)
		local success, result = pcall(namesByUserIds, p3)

		if success and result.status == "success" and #result.data > 0 then
			local v5 = result.data[1]

			if v5.getHasRobloxSubscription ~= nil then
				return v5.getHasRobloxSubscription(p3)
			end
		end

		return false
	end)
end

return createIsRobloxSubscriberGetter
