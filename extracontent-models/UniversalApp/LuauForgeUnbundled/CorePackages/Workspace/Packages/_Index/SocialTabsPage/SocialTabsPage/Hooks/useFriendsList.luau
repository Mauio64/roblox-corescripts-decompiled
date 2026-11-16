local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Dash")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/RoactUtils").Hooks.RoactRodux.useDispatch

local findFriendsFromUserId = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Networking/NetworkingFriends").FindFriendsFromUserId

local usePageSize = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/usePageSize")

local function mapPageItemsToFriends(pageItems)
	local mapped = Dash.map(pageItems, function(p2)
		return {
			id = tostring(p2.id),
			hasVerifiedBadge = p2.hasVerifiedBadge or false
		}
	end)

	local result = {}

	for k, v5 in mapped do
		local id = tonumber(v5.id)

		if id ~= nil and id > 0 then
			table.insert(result, v5)
		end
	end

	return result
end

local function useFriendsList(p2)
	local v5 = useDispatch()
	local v6 = usePageSize()
	local v7 = p2.skip == true or (not p2.targetUserId or p2.targetUserId == "")

	local state, setState = React.useState({})
	local state2, setState2 = React.useState(not v7)
	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(nil)
	local ref = React.useRef(0)
	local ref2 = React.useRef(false)
	local ref3 = React.useRef(true)

	React.useEffect(function()
		return function()
			ref3.current = false
		end
	end, {})

	local v8 = React.useCallback(function(p3, cursor, p4)
		local v9 = not cursor or cursor == ""

		if v9 then
			setState2(true)
		end

		ref2.current = true
		setState3(nil)

		local api = findFriendsFromUserId.API
		local v11 = { limit = v6, cursor = nil }

		if not cursor or cursor == "" then
			cursor = nil
		end

		v11.cursor = cursor
		v5(api(p3, v11)):andThen(function(p5)
			if ref.current ~= p4 or not ref3.current then
				ref2.current = false
				return
			end

			local responseBody = if p5 then p5.responseBody else nil
			local pageItems = if responseBody then responseBody.PageItems else nil

			local v12 = if responseBody and responseBody.NextCursor and responseBody.NextCursor ~= "" then responseBody.NextCursor else nil

			setState4(v12)

			if pageItems then
				local v13 = mapPageItemsToFriends(pageItems)

				if v9 then
					setState(v13)
				else
					setState(function(p6)
						local clone = table.clone(p6)

						for k, v14 in v13 do
							table.insert(clone, v14)
						end

						return clone
					end)
				end
			elseif v9 then
				setState({})
			end

			if v9 then
				setState2(false)
			end

			ref2.current = false
		end):catch(function(p5)
			if ref.current ~= p4 or not ref3.current then
				ref2.current = false
				return
			end

			setState3(p5)

			if v9 then
				setState2(false)
			end

			ref2.current = false
		end)
	end, { v5, v6 })

	React.useEffect(function(): nil
		if v7 then
			return nil
		end

		ref.current += 1
		local current = ref.current
		setState4(nil)
		setState({})
		v8(p2.targetUserId, nil, current)

		return nil
	end, { v7, p2.targetUserId, v8 })

	return {
		friends = state,
		loading = state2,
		hasMore = state4 ~= nil,
		fetchMore = React.useCallback(function()
			if ref2.current or not state4 then
				return
			end

			v8(p2.targetUserId, state4, ref.current)
		end, { state4, v8, p2.targetUserId }),
		refresh = React.useCallback(function()
			ref.current += 1
			local current = ref.current
			setState4(nil)
			setState({})
			v8(p2.targetUserId, nil, current)
		end, { v8, p2.targetUserId }),
		error = state3
	}
end

return useFriendsList
