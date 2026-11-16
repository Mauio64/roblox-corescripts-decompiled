local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Signals")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SignalsReact").useSignalState
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserProfiles")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")

local function createUserProfileNameGetter(callback, callback2, callback3)
	return Signals.createComputed(function(p2)
		if callback2(p2) then
			return ""
		end

		local v5 = callback(p2)

		if not v5.data or #v5.data == 0 then
			return ""
		end

		return callback3(v5.data[1].names) or ""
	end)
end

local function useUserDataValues(p2)
	local v5 = UserProfiles.Stores.UserProfileStore.get()
	local v6

	if p2 and p2 ~= "" then
		v6 = v5.fetchNamesByUserIds({ p2 })
	else
		v6 = nil
	end

	local computed = Signals.createComputed(function(p3): boolean
		if v6 then
			return v6(p3).status ~= "success"
		end

		return true
	end)

	local v7 = useSignalState(computed)

	local function fn(names)
		local displayName = names.getDisplayName(false)
		local username = names.getUsername(false)
		return displayName or username
	end

	local v8 = useSignalState((Signals.createComputed(function(p3)
		if computed(p3) then
			return ""
		end

		local v8 = v6(p3)

		if not v8.data or #v8.data == 0 then
			return ""
		end

		return fn(v8.data[1].names) or ""
	end)))

	local function fn2(names)
		return names.getUsername(false)
	end

	local v9 = useSignalState((Signals.createComputed(function(p3)
		if computed(p3) then
			return ""
		end

		local v9 = v6(p3)

		if not v9.data or #v9.data == 0 then
			return ""
		end

		return fn2(v9.data[1].names) or ""
	end)))

	local function fn3(names)
		return names.getCombinedName(false)
	end

	local v10 = useSignalState((Signals.createComputed(function(p3)
		if computed(p3) then
			return ""
		end

		local v10 = v6(p3)

		if not v10.data or #v10.data == 0 then
			return ""
		end

		return fn3(v10.data[1].names) or ""
	end)))

	return React.useMemo(function()
		return {
			isLoading = v7 or false,
			displayName = v8 or "",
			combinedName = v10 or "",
			username = v9 or ""
		}
	end, { p2, v7, v8, v10, v9 })
end

return useUserDataValues
