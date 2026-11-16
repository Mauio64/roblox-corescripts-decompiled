local CorePackages = game:GetService("CorePackages")
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local UserProfileStore = UserProfiles.Stores.UserProfileStore
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local function usePlayerCombinedName(p: string, p2: string)
	local v = UserProfileStore.get().fetchNamesByUserIds({ p })(false).data[1]
	return SignalsReact.useSignalBinding(v.names.getInExperienceCombinedName):map(function(value)
		return if string.len(value) == 0 then p2 else value
	end)
end

return usePlayerCombinedName
