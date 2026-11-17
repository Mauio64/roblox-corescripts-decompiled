local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useSignalBinding = SignalsReact.useSignalBinding
local UserProfiles = require(parent.UserProfiles)
local React = require(parent.React)
require(AppChat.types)
local useFoundationPresence = require(script.Parent.useFoundationPresence)

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

local function useUserData(p: string)
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

	local isLoading = useSignalBinding(computed)

	local function fn(p2)
		local displayName = p2.getDisplayName(false)
		local username = p2.getUsername(false)
		return displayName or username
	end

	local userProfileNameGetter = createUserProfileNameGetter(v2, computed, fn) -- inferred equivalent call
	local displayName = useSignalBinding(userProfileNameGetter)

	local function fn2(p2)
		return p2.getUsername(false)
	end

	local userProfileNameGetter2 = createUserProfileNameGetter(v2, computed, fn2) -- inferred equivalent call
	local username = useSignalBinding(userProfileNameGetter2)

	local function fn3(p2)
		return p2.getCombinedName(false)
	end

	local userProfileNameGetter3 = createUserProfileNameGetter(v2, computed, fn3) -- inferred equivalent call
	local combinedName = useSignalBinding(userProfileNameGetter3)

	local v3 = useFoundationPresence(p)

	return React.useMemo(function()
		return {
			isLoading = isLoading,
			id = tonumber(p) or -1,
			displayName = displayName,
			combinedName = combinedName,
			username = username,
			presenceText = v3.presenceText,
			presence = v3.presence
		}
	end, { p, v3 })
end

return useUserData
