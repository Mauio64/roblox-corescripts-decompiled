local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local getFirstFocusableDescendant = FocusNavigationUtils.getFirstFocusableDescendant
local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsChatConversationListFocusNav = SharedFlags.FFlagFriendsChatConversationListFocusNav

local function useFocusConversationInput(p, flag: boolean, p2)
	local v = ChatUIPrimitives.Hooks.useFocusInputBar()
	local focus = v.focus

	if FFlagFriendsChatConversationListFocusNav then
		local v2 = useFocusGuiObject()

		focus = React.useCallback(function()
			if flag then
				v.focus()
				return
			end

			local v3

			if p2 ~= nil then
				v3 = p2.current
			end

			local current

			if p ~= nil then
				current = p.current
			end

			if v3 == nil and current ~= nil then
				v3 = getFirstFocusableDescendant(current)
			end

			if v3 ~= nil then
				v2(v3)
			end
		end, { flag, v.focus, v2, p, p2 })
	end

	return { ref = v.ref, focus = focus }
end

return useFocusConversationInput
