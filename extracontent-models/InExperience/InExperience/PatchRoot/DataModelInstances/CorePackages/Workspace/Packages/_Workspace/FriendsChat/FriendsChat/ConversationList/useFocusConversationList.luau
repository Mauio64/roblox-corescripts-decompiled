local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local useStableSignal = ChatUIPrimitives.Hooks.useStableSignal
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useContainerFocusBehavior = ReactFocusNavigation.useContainerFocusBehavior

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsChatConversationListFocusNav = SharedFlags.FFlagFriendsChatConversationListFocusNav
local useConsumeFocusConversationListRequest = require(script.Parent.useConsumeFocusConversationListRequest)

local function useFocusConversationList(callback)
	local v, v2

	if not FFlagFriendsChatConversationListFocusNav then
		return v2, v
	end

	local v3 = useFocusGuiObject()
	local v4
	v4, v = useStableSignal(nil)

	useConsumeFocusConversationListRequest(v4, (React.useCallback(function(p)
		callback(false).resetAllTransparency()
		v3(p)
	end, { callback, v3 })))

	v2 = useContainerFocusBehavior(React.useMemo(function()
		return {
			getTargets = function()
				local v5 = v4(false)

				if v5 == nil then
					return {}
				end

				return { v5 }
			end
		}
	end, { v4 }), nil)

	return v2, v
end

return useFocusConversationList
