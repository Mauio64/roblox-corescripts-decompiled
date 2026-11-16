local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local React = require(parent.React)
local Dash = require(parent.Dash)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local NetworkingFriends = require(SocialTabsPage.Networking.NetworkingFriends)
local FindFriendsFromUserId = NetworkingFriends.FindFriendsFromUserId

local usePageSize = require(SocialTabsPage.Hooks.usePageSize)

local function mapPageItemsToFriends(pageItems)
	local mapped = Dash.map(pageItems, function(p)
		return {
			id = tostring(p.id),
			hasVerifiedBadge = p.hasVerifiedBadge or false
		}
	end)

	local result = {}

	for _, v in mapped do
		local id = tonumber(v.id)

		if id ~= nil and id > 0 then
			table.insert(result, v)
		end
	end

	return result
end

local function useFriendsList(p)
	local v = useDispatch()
	local limit = usePageSize()
	local v2 = p.skip == true or (not p.targetUserId or p.targetUserId == "")

	local state, setState = React.useState({})
	local state2, setState2 = React.useState(not v2)
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

	local v3 = React.useCallback(function(p2: string, cursor: string?, p3: number)
		local v3 = not cursor or cursor == ""

		if v3 then
			setState2(true)
		end

		ref2.current = true
		setState3(nil)

		local api = FindFriendsFromUserId.API
		local v4 = { limit = limit, cursor = nil }

		if not cursor or cursor == "" then
			cursor = nil
		end

		v4.cursor = cursor
		v(api(p2, v4)):andThen(function(p4)
			if ref.current ~= p3 or not ref3.current then
				ref2.current = false
				return
			end

			local responseBody

			if p4 then
				responseBody = p4.responseBody
			end

			local pageItems

			if responseBody then
				pageItems = responseBody.PageItems
			end

			local v5

			if responseBody and responseBody.NextCursor and responseBody.NextCursor ~= "" then
				v5 = responseBody.NextCursor
			end

			setState4(v5)

			if pageItems then
				local v6 = mapPageItemsToFriends(pageItems)

				if v3 then
					setState(v6)
				else
					setState(function(p5)
						local clone = table.clone(p5)

						for _, v7 in v6 do
							table.insert(clone, v7)
						end

						return clone
					end)
				end
			elseif v3 then
				setState({})
			end

			if v3 then
				setState2(false)
			end

			ref2.current = false
		end):catch(function(p4)
			if ref.current ~= p3 or not ref3.current then
				ref2.current = false
				return
			end

			setState3(p4)

			if v3 then
				setState2(false)
			end

			ref2.current = false
		end)
	end, { v, limit })

	React.useEffect(function(): nil
		if v2 then
			return nil
		end

		ref.current += 1
		local current = ref.current
		setState4(nil)
		setState({})
		v3(p.targetUserId, nil, current)

		return nil
	end, { v2, p.targetUserId, v3 })

	return {
		friends = state,
		loading = state2,
		hasMore = state4 ~= nil,
		fetchMore = React.useCallback(function()
			if ref2.current or not state4 then
				return
			end

			v3(p.targetUserId, state4, ref.current)
		end, { state4, v3, p.targetUserId }),
		refresh = React.useCallback(function()
			ref.current += 1
			local current = ref.current
			setState4(nil)
			setState({})
			v3(p.targetUserId, nil, current)
		end, { v3, p.targetUserId }),
		error = state3
	}
end

return useFriendsList
