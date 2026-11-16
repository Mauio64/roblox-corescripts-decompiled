local parent = script:FindFirstAncestor("SocialTabsPage").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)
local v = DataHydration.Presence.PresenceStore.get()
local PresenceType = DataHydration.Presence.PresenceEnums.PresenceType

local v2 = {
	[PresenceType.InGame] = 3,
	[PresenceType.Online] = 2,
	[PresenceType.InStudio] = 1,
	[PresenceType.Offline] = 0
}

local function getStorePresenceWeight(p: string) -- 1 equivalent call inferred from this helper
	return v2[p] or 0
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
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if #list == 0 then
				return list
			end

			local v3 = {}

			for k, item in list do
				local data = v.GetPresenceByUserId((tostring(item.id))).data(p)
				local v4

				if data then
					v4 = data.userPresenceType
				else
					v4 = PresenceType.Offline
				end

				table.insert(v3, {
					user = item,
					weight = getStorePresenceWeight(v4), -- inferred equivalent call
					originalIndex = k
				})
			end

			table.sort(v3, function(a, b): boolean
				if a.weight == b.weight then
					return a.originalIndex < b.originalIndex
				end

				return a.weight > b.weight
			end)

			local users = {}

			for _, v4 in v3 do
				table.insert(users, v4.user)
			end

			return users
		end, usersOrderEqual)
	end, { list })

	return SignalsReact.useSignalState(v3)
end

return useSortedUsersByPresence
