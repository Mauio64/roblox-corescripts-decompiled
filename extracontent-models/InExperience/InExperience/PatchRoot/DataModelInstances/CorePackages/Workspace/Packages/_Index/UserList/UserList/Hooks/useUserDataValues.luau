local parent = script:FindFirstAncestor("UserList").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local UserProfiles = require(parent.UserProfiles)
local React = require(parent.React)

local function createUserProfileNameGetter(callback, computed, fn) -- 3 equivalent calls inferred from this helper
	return Signals.createComputed(function(p)
		if computed(p) then
			return ""
		end

		local v = callback(p)

		if v.data and #v.data ~= 0 then
			return fn(v.data[1].names) or ""
		end

		return ""
	end)
end

local function useUserDataValues(p: string)
	local v = UserProfiles.Stores.UserProfileStore.get()
	local v2

	if p and p ~= "" then
		v2 = v.fetchNamesByUserIds({ p })
	else
		v2 = nil
	end

	local computed = Signals.createComputed(function(p2): boolean
		return not v2 or v2(p2).status ~= "success"
	end)

	local v3 = useSignalState(computed)

	local function fn(p2)
		local displayName = p2.getDisplayName(false)
		local username = p2.getUsername(false)
		return displayName or username
	end

	local v4 = useSignalState((createUserProfileNameGetter(v2, computed, fn))) -- inferred equivalent call

	local function fn2(p2)
		return p2.getUsername(false)
	end

	local v5 = useSignalState((createUserProfileNameGetter(v2, computed, fn2))) -- inferred equivalent call

	local function fn3(p2)
		return p2.getCombinedName(false)
	end

	local v6 = useSignalState((createUserProfileNameGetter(v2, computed, fn3))) -- inferred equivalent call

	return React.useMemo(function()
		return {
			isLoading = v3 or false,
			displayName = v4 or "",
			combinedName = v6 or "",
			username = v5 or ""
		}
	end, { p, v3, v4, v6, v5 })
end

return useUserDataValues
