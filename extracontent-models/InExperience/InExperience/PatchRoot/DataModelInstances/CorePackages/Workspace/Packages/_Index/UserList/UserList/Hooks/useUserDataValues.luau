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

		if not v.data or #v.data == 0 then
			return ""
		end

		return fn(v.data[1].names) or ""
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

	local userProfileNameGetter = createUserProfileNameGetter(v2, computed, fn) -- inferred equivalent call
	local v4 = useSignalState(userProfileNameGetter)

	local function fn2(p2)
		return p2.getUsername(false)
	end

	local userProfileNameGetter2 = createUserProfileNameGetter(v2, computed, fn2) -- inferred equivalent call
	local v5 = useSignalState(userProfileNameGetter2)

	local function fn3(p2)
		return p2.getCombinedName(false)
	end

	local userProfileNameGetter3 = createUserProfileNameGetter(v2, computed, fn3) -- inferred equivalent call
	local v6 = useSignalState(userProfileNameGetter3)

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
