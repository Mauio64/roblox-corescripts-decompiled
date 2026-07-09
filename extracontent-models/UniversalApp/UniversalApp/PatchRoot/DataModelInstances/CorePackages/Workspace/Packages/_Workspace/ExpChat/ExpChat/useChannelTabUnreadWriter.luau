local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local RoactUtils = require(ExpChatParent.RoactUtils)
local SharedFlags = require(ExpChatParent.SharedFlags)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local SetChannelUnreadStatus = require(ExpChat.Actions.SetChannelUnreadStatus)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

return function(s1: string) -- line: 20
	-- upvalues: GetChannelTabsStore (copy), useDispatch (copy), React (copy), SetChannelUnreadStatus (copy), FFlagExpChatUseChannelTabsStore (copy)
	local v11 = GetChannelTabsStore(false)
	local v12 = useDispatch()

	return React.useCallback(function(b1: boolean) -- line: 24
		-- upvalues: v12 (copy), SetChannelUnreadStatus (copy), s1 (copy), FFlagExpChatUseChannelTabsStore (copy), v11 (copy)
		v12(SetChannelUnreadStatus(s1, b1))

		if FFlagExpChatUseChannelTabsStore then
			v11.setChannelUnreadStatus(s1, b1)
		end
	end, {
		v11,
		v12,
		s1
	})
end
