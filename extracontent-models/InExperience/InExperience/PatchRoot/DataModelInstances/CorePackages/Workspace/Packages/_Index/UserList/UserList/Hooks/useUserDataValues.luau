local Parent = script:FindFirstAncestor("UserList").Parent
local Signals = require(Parent.Signals)
local useSignalState = require(Parent.SignalsReact).useSignalState
local UserProfiles = require(Parent.UserProfiles)
local React = require(Parent.React)

local function createUserProfileNameGetter(p1, p2, p3) -- line: 17
	-- upvalues: Signals (copy)
	return Signals.createComputed(function(p4) -- line: 18
		-- upvalues: p2 (copy), p1 (copy), p3 (copy)
		if p2(p4) then
			return ""
		end

		local v26 = p1(p4)

		if not v26.data or #v26.data == 0 then
			return ""
		end

		local names = v26.data[1].names

		return p3(names) or ""
	end)
end
local function useUserDataValues(s1: string) -- line: 31
	-- upvalues: UserProfiles (copy), Signals (copy), useSignalState (copy), React (copy)
	local v12 = UserProfiles.Stores.UserProfileStore.get()
	local v13 = if not s1 or s1 == "" then nil else v12.fetchNamesByUserIds({ s1 })
	local v14 = Signals.createComputed(function(p5) -- line: 35
		-- upvalues: v13 (copy)
		if not v13 then
			return true
		end

		return v13(p5).status ~= "success"
	end)
	local v15 = useSignalState(v14)

	local function v16(p6) -- line: 44
		local v30 = p6.getDisplayName(false)
		local v31 = p6.getUsername(false)

		return v30 or v31
	end

	local v17 = Signals.createComputed(function(p7) -- line: 18
		-- upvalues: v14 (copy), v13 (copy), v16 (copy)
		if v14(p7) then
			return ""
		end

		local v33 = v13(p7)

		if not v33.data or #v33.data == 0 then
			return ""
		end

		local names = v33.data[1].names

		return v16(names) or ""
	end)
	local v18 = useSignalState(v17)

	local function v19(p8) -- line: 51
		return p8.getUsername(false)
	end

	local v20 = Signals.createComputed(function(p9) -- line: 18
		-- upvalues: v14 (copy), v13 (copy), v19 (copy)
		if v14(p9) then
			return ""
		end

		local v37 = v13(p9)

		if not v37.data or #v37.data == 0 then
			return ""
		end

		local names = v37.data[1].names

		return v19(names) or ""
	end)
	local v21 = useSignalState(v20)

	local function v22(p10) -- line: 56
		return p10.getCombinedName(false)
	end

	local v23 = Signals.createComputed(function(p11) -- line: 18
		-- upvalues: v14 (copy), v13 (copy), v22 (copy)
		if v14(p11) then
			return ""
		end

		local v41 = v13(p11)

		if not v41.data or #v41.data == 0 then
			return ""
		end

		local names = v41.data[1].names

		return v22(names) or ""
	end)
	local v24 = useSignalState(v23)

	return React.useMemo(function() -- line: 62
		-- upvalues: v15 (copy), v18 (copy), v24 (copy), v21 (copy)
		return {
			isLoading = v15 or false,
			displayName = v18 or "",
			combinedName = v24 or "",
			username = v21 or ""
		}
	end, {
		s1,
		v15,
		v18,
		v24,
		v21
	})
end

return useUserDataValues
