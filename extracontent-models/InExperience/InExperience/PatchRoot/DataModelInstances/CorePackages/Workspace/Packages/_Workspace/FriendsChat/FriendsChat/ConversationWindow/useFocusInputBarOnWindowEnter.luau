local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local GetFriendsChatNavigationStore = require(FriendsChat.Stores.GetFriendsChatNavigationStore)
local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsChatConversationListFocusNav = SharedFlags.FFlagFriendsChatConversationListFocusNav

local function useFocusInputBarOnWindowEnter(p, p2)
	local v = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	React.useEffect(function()
		if not FFlagFriendsChatConversationListFocusNav or v == nil then
			return
		end

		local friendsChatNavigationStore = GetFriendsChatNavigationStore(false)
		local function isInsideWindow(instance)
			if instance == nil then
				return false
			end

			local current = p.current
			local current2 = p2.current
			local v2 = current ~= nil and instance:IsDescendantOf(current)

			if not v2 then
				if current2 == nil then
					return false
				end

				return (instance:IsDescendantOf(current2))
			end

			return v2
		end

		local v2 = v.focusedGuiObject:getValue()
		local v3 = v.focusedGuiObject:subscribe(function(instance)
			local v3

			if instance == nil then
				v3 = false
			else
				local current = p.current
				local current2 = p2.current
				v3 = current ~= nil and instance:IsDescendantOf(current)

				if not v3 then
					if current2 == nil then
						v3 = false
					else
						v3 = instance:IsDescendantOf(current2)
					end
				end
			end

			if v3 and v2 ~= nil then
				local v4 = v2
				local v5

				if v4 == nil then
					v5 = false
				else
					local current = p.current
					local current2 = p2.current
					v5 = current ~= nil and v4:IsDescendantOf(current)

					if not v5 then
						if current2 == nil then
							v5 = false
						else
							v5 = v4:IsDescendantOf(current2)
						end
					end
				end

				if not v5 then
					friendsChatNavigationStore.requestFocusInputBar()
				end
			end

			v2 = instance
		end)
		return function()
			v3:unsubscribe()
		end
	end, { v })
end

return useFocusInputBarOnWindowEnter
