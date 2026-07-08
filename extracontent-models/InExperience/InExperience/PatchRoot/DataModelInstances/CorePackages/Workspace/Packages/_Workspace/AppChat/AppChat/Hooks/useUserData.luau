local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Signals = require(AppChatParent.Signals)
local useSignalBinding = require(AppChatParent.SignalsReact).useSignalBinding
local UserProfiles = require(AppChatParent.UserProfiles)
local React = require(AppChatParent.React)

require(AppChat.types)

local useFoundationPresence = require(script.Parent.useFoundationPresence)

local function createUserProfileNameGetter(p1, p2, p3) -- line: 14
	-- upvalues: Signals (copy)
	return Signals.createComputed(function(p4) -- line: 15
		-- upvalues: p2 (copy), p1 (copy), p3 (copy)
		if p2(p4) then
			return ""
		end

		local v29 = p1(p4)

		if not v29.data or #v29.data == 0 then
			return ""
		end

		local names = v29.data[1].names

		return p3(names) or ""
	end)
end
local function useUserData(s1: string) -- line: 28
	-- upvalues: UserProfiles (copy), Signals (copy), useSignalBinding (copy), useFoundationPresence (copy), React (copy)
	local v14 = UserProfiles.Stores.UserProfileStore.get()
	local v15 = if not s1 or s1 == "" then nil else v14.fetchNamesByUserIds({ s1 })
	local v16 = Signals.createComputed(function(p5) -- line: 31
		-- upvalues: v15 (copy)
		if not v15 then
			return true
		end

		return v15(p5).status ~= "success"
	end)
	local v17 = useSignalBinding(v16)

	local function v18(p6) -- line: 40
		local v33 = p6.getDisplayName(false)
		local v34 = p6.getUsername(false)

		return v33 or v34
	end

	local v19 = Signals.createComputed(function(p7) -- line: 15
		-- upvalues: v16 (copy), v15 (copy), v18 (copy)
		if v16(p7) then
			return ""
		end

		local v36 = v15(p7)

		if not v36.data or #v36.data == 0 then
			return ""
		end

		local names = v36.data[1].names

		return v18(names) or ""
	end)
	local v20 = useSignalBinding(v19)

	local function v21(p8) -- line: 47
		return p8.getUsername(false)
	end

	local v22 = Signals.createComputed(function(p9) -- line: 15
		-- upvalues: v16 (copy), v15 (copy), v21 (copy)
		if v16(p9) then
			return ""
		end

		local v40 = v15(p9)

		if not v40.data or #v40.data == 0 then
			return ""
		end

		local names = v40.data[1].names

		return v21(names) or ""
	end)
	local v23 = useSignalBinding(v22)

	local function v24(p10) -- line: 52
		return p10.getCombinedName(false)
	end

	local v25 = Signals.createComputed(function(p11) -- line: 15
		-- upvalues: v16 (copy), v15 (copy), v24 (copy)
		if v16(p11) then
			return ""
		end

		local v44 = v15(p11)

		if not v44.data or #v44.data == 0 then
			return ""
		end

		local names = v44.data[1].names

		return v24(names) or ""
	end)
	local v26 = useSignalBinding(v25)
	local v27 = useFoundationPresence(s1)

	return React.useMemo(function() -- line: 60
		-- upvalues: v17 (copy), s1 (copy), v20 (copy), v26 (copy), v23 (copy), v27 (copy)
		return {
			isLoading = v17,
			id = tonumber(s1) or -1,
			displayName = v20,
			combinedName = v26,
			username = v23,
			presenceText = v27.presenceText,
			presence = v27.presence
		}
	end, {
		s1,
		v27
	})
end

return useUserData
