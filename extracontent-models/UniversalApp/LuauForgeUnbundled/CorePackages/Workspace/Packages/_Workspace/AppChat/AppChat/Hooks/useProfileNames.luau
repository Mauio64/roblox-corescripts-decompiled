local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")

local dataStatus = DataHydration.DataStatus
local getAndFetchUserNames = DataHydration.UserProfile.getAndFetchUserNames
local getAndFetchUserNamesByUserIds = DataHydration.UserProfile.getAndFetchUserNamesByUserIds
local useSignalState = SignalsReact.useSignalState

local fFlagHomeFriendNamesUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagHomeFriendNamesUseUserProfileHydration

local v5 = { status = dataStatus.Ready, namesByUserId = {} }

local function nonEmpty(p2)
	if p2 == "" then
		return nil
	end

	return p2
end

local function useProfileNames(p2)
	local joined = table.concat(Cryo.List.filter(p2, function(p3): boolean
		return tonumber(p3) ~= nil
	end), ",")

	return useSignalState((React.useMemo(function()
		if fFlagHomeFriendNamesUseUserProfileHydration then
			return getAndFetchUserNamesByUserIds(string.split(joined, ","))
		end

		if joined == "" then
			return Signals.createComputed(function()
				return v5
			end)
		end

		local v7 = {}

		for k, v8 in string.split(joined, ",") do
			v7[v8] = getAndFetchUserNames(v8)
		end

		return Signals.createComputed(function(p3)
			local v8 = dataStatus.Ready
			local v9 = {}

			for k, v10 in v7 do
				local status = v10.status(p3)

				if status == dataStatus.NotReady then
					v8 = dataStatus.NotReady
				elseif status == dataStatus.Failed and v8 == dataStatus.Ready then
					v8 = dataStatus.Failed
				end

				local names = v10.names(p3)

				if not names then
					continue
				end

				local combinedName = names.combinedName

				if combinedName == "" then
					combinedName = nil
				end

				local username = names.username

				if username == "" then
					username = nil
				end

				v9[k] = { combinedName = combinedName, username = username }
			end

			return { status = v8, namesByUserId = v9 }
		end)
	end, { joined })))
end

return useProfileNames
