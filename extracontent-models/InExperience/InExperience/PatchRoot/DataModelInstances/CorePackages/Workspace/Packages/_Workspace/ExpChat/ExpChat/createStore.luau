local parent = script:FindFirstAncestor("ExpChat").Parent

local ChatModerationStatusHydrationMiddleware = require(parent.AppChat.ChatModerationStatusHydrationMiddleware)
local ExpChatShared = require(parent.ExpChatShared)
local Rodux = require(parent.Rodux)

local RaiseActionAsEventMiddleware = ExpChatShared.RaiseActionAsEventMiddleware
local installReducer = require(script.Parent.installReducer)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

local function createStore(p)
	local new = Rodux.Store.new
	local v

	if FFlagAppChatReactiveFeatureRestrictions then
		v = { Rodux.thunkMiddleware, ChatModerationStatusHydrationMiddleware, RaiseActionAsEventMiddleware }
	else
		v = { Rodux.thunkMiddleware, RaiseActionAsEventMiddleware }
	end

	return new(installReducer, p, v)
end

return createStore
