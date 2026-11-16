local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)
local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local DataStatus = DataHydration.DataStatus
local getAndFetchUserNames = DataHydration.UserProfile.getAndFetchUserNames
local getAndFetchUserNamesByUserIds = DataHydration.UserProfile.getAndFetchUserNamesByUserIds
local useSignalState = SignalsReact.useSignalState

local SharedFlags = require(parent.SharedFlags)
local FFlagHomeFriendNamesUseUserProfileHydration = SharedFlags.FFlagHomeFriendNamesUseUserProfileHydration

local v = { status = DataStatus.Ready, namesByUserId = {} }

local function nonEmpty(p: string?) -- 2 equivalent calls inferred from this helper
	return if p ~= "" then p else nil
end

local function useProfileNames(p)
	local joined = table.concat(Cryo.List.filter(p, function(p2): boolean
		return tonumber(p2) ~= nil
	end), ",")

	return useSignalState((React.useMemo(function()
		if FFlagHomeFriendNamesUseUserProfileHydration then
			return getAndFetchUserNamesByUserIds(string.split(joined, ","))
		end

		if joined == "" then
			return Signals.createComputed(function()
				return v
			end)
		end

		local v2 = {}

		for _, v3 in string.split(joined, ",") do
			v2[v3] = getAndFetchUserNames(v3)
		end

		return Signals.createComputed(function(p2)
			local status2 = DataStatus.Ready
			local namesByUserId = {}

			for k, v3 in v2 do
				local status = v3.status(p2)

				if status == DataStatus.NotReady then
					status2 = DataStatus.NotReady
				elseif status == DataStatus.Failed and status2 == DataStatus.Ready then
					status2 = DataStatus.Failed
				end

				local names = v3.names(p2)

				if names then
					namesByUserId[k] = {
						combinedName = nonEmpty(names.combinedName), -- inferred equivalent call
						username = nonEmpty(names.username) -- inferred equivalent call
					}
				end
			end

			return { status = status2, namesByUserId = namesByUserId }
		end)
	end, { joined })))
end

return useProfileNames
