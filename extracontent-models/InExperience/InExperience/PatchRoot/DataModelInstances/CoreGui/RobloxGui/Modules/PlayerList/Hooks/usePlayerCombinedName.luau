local CorePackages = game:GetService("CorePackages")
local UserProfileStore = require(CorePackages.Workspace.Packages.UserProfiles).Stores.UserProfileStore
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local function usePlayerCombinedName(s1: string, s2: string) -- line: 6
	-- upvalues: UserProfileStore (copy), SignalsReact (copy)
	local v7 = UserProfileStore.get().fetchNamesByUserIds({ s1 })(false).data[1]

	return SignalsReact.useSignalBinding(v7.names.getInExperienceCombinedName):map(function(p1) -- line: 9
		-- upvalues: s2 (copy)
		if string.len(p1) == 0 then
			return s2
		end

		return p1
	end)
end

return usePlayerCombinedName
