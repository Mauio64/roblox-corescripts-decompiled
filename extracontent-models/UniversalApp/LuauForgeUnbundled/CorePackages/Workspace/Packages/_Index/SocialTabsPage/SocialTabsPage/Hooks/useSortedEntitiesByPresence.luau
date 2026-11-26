local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SignalsReact")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/DataHydration")
local v5 = DataHydration.Presence.PresenceStore.get()
local presenceType = DataHydration.Presence.PresenceEnums.PresenceType

local v6 = {
	[presenceType.InGame] = 3,
	[presenceType.Online] = 2,
	[presenceType.InStudio] = 1,
	[presenceType.Offline] = 0
}

local function getStorePresenceWeight(p2)
	return v6[p2] or 0
end

local function usersOrderEqual(list, list2): boolean
	if list == list2 then
		return true
	end

	if not list or not list2 or #list ~= #list2 then
		return false
	end

	for k, item in list do
		if item.id ~= list2[k].id then
			return false
		end
	end

	return true
end

local function useSortedUsersByPresence(list)
	local v7 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if #list == 0 then
				return list
			end

			local v8 = {}

			for k, item in list do
				local data = v5.GetPresenceByUserId((tostring(item.id))).data(p2)
				local v9 = if data then data.userPresenceType else presenceType.Offline
				table.insert(v8, {
					user = item,
					weight = v6[v9] or 0,
					originalIndex = k
				})
			end

			table.sort(v8, function(a, b): boolean
				if a.weight == b.weight then
					return a.originalIndex < b.originalIndex
				end

				return a.weight > b.weight
			end)

			local users = {}

			for k, v9 in v8 do
				table.insert(users, v9.user)
			end

			return users
		end, usersOrderEqual)
	end, { list })

	return SignalsReact.useSignalState(v7)
end

return useSortedUsersByPresence
