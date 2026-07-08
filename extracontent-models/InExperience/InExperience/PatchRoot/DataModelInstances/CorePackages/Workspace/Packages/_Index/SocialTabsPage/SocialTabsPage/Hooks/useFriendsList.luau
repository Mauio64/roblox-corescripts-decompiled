local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local Dash = require(SocialTabsPageParent.Dash)
local useDispatch = require(SocialTabsPageParent.RoactUtils).Hooks.RoactRodux.useDispatch
local FindFriendsFromUserId = require(SocialTabsPage.Networking.NetworkingFriends).FindFriendsFromUserId
local usePageSize = require(SocialTabsPage.Hooks.usePageSize)

local function mapPageItemsToFriends(p1) -- line: 33
	-- upvalues: Dash (copy)
	return Dash.map(p1, function(p2) -- line: 34
		return {
			id = tostring(p2.id),
			hasVerifiedBadge = p2.hasVerifiedBadge or false
		}
	end)
end
local function useFriendsList(t1: {[any]: any}) -- line: 42
	-- upvalues: useDispatch (copy), usePageSize (copy), React (copy), FindFriendsFromUserId (copy), Dash (copy)
	local v12 = useDispatch()
	local v13 = usePageSize()
	local v14 = t1.skip == true or (not t1.targetUserId or t1.targetUserId == "")
	local v15, v16 = React.useState({})
	local v17, v18 = React.useState(not v14)
	local v19, v20 = React.useState(nil)
	local v21, v22 = React.useState(nil)
	local v23 = React.useRef(0)
	local v24 = React.useRef(false)
	local v25 = React.useRef(true)

	React.useEffect(function() -- line: 55
		-- upvalues: v25 (copy)
		return function() -- line: 56
			-- upvalues: v25 (copy)
			v25.current = false
		end
	end, {})

	local v26 = React.useCallback(function(s1: string, s2: string?, n1: number) -- line: 61
		-- upvalues: v18 (copy), v24 (copy), v20 (copy), v12 (copy), FindFriendsFromUserId (copy), v13 (copy), v23 (copy), v25 (copy), v22 (copy), Dash (copy), v16 (copy)
		local v34 = not s2 or s2 == ""

		if v34 then
			v18(true)
		end

		v24.current = true
		v20(nil)
		v12(FindFriendsFromUserId.API(s1, {
			limit = v13,
			cursor = if not s2 or s2 == "" then nil else s2
		})):andThen(function(p3) -- line: 74
			-- upvalues: v23 (copy), n1 (copy), v25 (copy), v24 (copy), v22 (copy), Dash (copy), v34 (copy), v16 (copy), v18 (copy)
			if v23.current ~= n1 or not v25.current then
				v24.current = false

				return
			end

			local v40 = if not p3 then nil else p3.responseBody
			local v41 = if not v40 then nil else v40.PageItems
			local v42 = if not v40 or (not v40.NextCursor or v40.NextCursor == "") then nil else v40.NextCursor

			v22(v42)

			if v41 then
				local v43 = Dash.map(v41, function(p4) -- line: 34
					return {
						id = tostring(p4.id),
						hasVerifiedBadge = p4.hasVerifiedBadge or false
					}
				end)

				if v34 then
					v16(v43)
				else
					v16(function(t2: {[any]: any}) -- line: 94
						-- upvalues: v43 (copy)
						local v47 = table.clone(t2)

						for _, v49 in v43 do
							table.insert(v47, v49)
						end

						return v47
					end)
				end
			elseif v34 then
				v16({})
			end

			if v34 then
				v18(false)
			end

			v24.current = false
		end):catch(function(p5) -- line: 111
			-- upvalues: v23 (copy), n1 (copy), v25 (copy), v24 (copy), v20 (copy), v34 (copy), v18 (copy)
			if v23.current ~= n1 or not v25.current then
				v24.current = false

				return
			end

			v20(p5)

			if v34 then
				v18(false)
			end

			v24.current = false
		end)
	end, {
		v12,
		v13
	})

	React.useEffect(function() -- line: 124
		-- upvalues: v14 (copy), v23 (copy), v22 (copy), v16 (copy), v26 (copy), t1 (copy)
		if v14 then
			return nil
		end

		local v35 = v23

		v35.current = v35.current + 1

		local current = v23.current

		v22(nil)
		v16({})
		v26(t1.targetUserId, nil, current)

		return nil
	end, {
		v14,
		t1.targetUserId,
		v26
	})

	local v27 = v21 ~= nil
	local v28 = React.useCallback(function() -- line: 140
		-- upvalues: v24 (copy), v21 (copy), v26 (copy), t1 (copy), v23 (copy)
		if v24.current or not v21 then
			return
		end

		v26(t1.targetUserId, v21, v23.current)
	end, {
		v21,
		v26,
		t1.targetUserId
	})
	local v29 = React.useCallback(function() -- line: 147
		-- upvalues: v23 (copy), v22 (copy), v16 (copy), v26 (copy), t1 (copy)
		local v37 = v23

		v37.current = v37.current + 1

		local current = v23.current

		v22(nil)
		v16({})
		v26(t1.targetUserId, nil, current)
	end, {
		v26,
		t1.targetUserId
	})

	return {
		friends = v15,
		loading = v17,
		hasMore = v27,
		fetchMore = v28,
		refresh = v29,
		error = v19
	}
end

return useFriendsList
