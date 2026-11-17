local parent = script:FindFirstAncestor("ExpChat").Parent

local ChatModerationStatusHydrationMiddleware = require(parent.AppChat.ChatModerationStatusHydrationMiddleware)
local ExpChatShared = require(parent.ExpChatShared)
local Rodux = require(parent.Rodux)

local RaiseActionAsEventMiddleware = ExpChatShared.RaiseActionAsEventMiddleware
local installReducer = require(script.Parent.installReducer)
local stickyTabMiddleware = require(script.Parent.StickyTabs.stickyTabMiddleware)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions
local SharedFlags2 = require(parent.SharedFlags)
local FFlagExpChatStickyTabs = SharedFlags2.FFlagExpChatStickyTabs

local function createStore(p)
	if FFlagExpChatStickyTabs then
		local new = Rodux.Store.new
		local v

		if FFlagAppChatReactiveFeatureRestrictions then
			v = {
				Rodux.thunkMiddleware,
				ChatModerationStatusHydrationMiddleware,
				RaiseActionAsEventMiddleware,
				stickyTabMiddleware
			}
		else
			v = { Rodux.thunkMiddleware, RaiseActionAsEventMiddleware, stickyTabMiddleware }
		end

		return new(installReducer, p, v)
	else
		local new = Rodux.Store.new
		local v

		if FFlagAppChatReactiveFeatureRestrictions then
			v = { Rodux.thunkMiddleware, ChatModerationStatusHydrationMiddleware, RaiseActionAsEventMiddleware }
		else
			v = { Rodux.thunkMiddleware, RaiseActionAsEventMiddleware }
		end

		return new(installReducer, p, v)
	end
end

return createStore
