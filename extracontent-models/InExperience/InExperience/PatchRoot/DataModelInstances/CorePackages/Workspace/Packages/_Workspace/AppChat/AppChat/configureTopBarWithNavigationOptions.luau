local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local ArgCheck = require(AppChatParent.ArgCheck)
local Cryo = require(AppChatParent.Cryo)
local Roact = require(AppChatParent.Roact)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local SignalsReact = require(AppChatParent.SignalsReact)
local createChatTopBar = require(AppChat.createChatTopBar)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local TopBarContext = require(AppChat.TopBarContext)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)

local function TopBarFromStore(p1) -- line: 64
	-- upvalues: RoactNavigation (copy), GetTopBarStore (copy), SignalsReact (copy), ArgCheck (copy), Cryo (copy), createChatTopBar (copy)
	local navigation = p1.navigation
	local v16 = RoactNavigation.getActiveChildNavigationOptions(navigation)
	local state = navigation.state
	local v18 = state.routes[state.index]
	local v19 = GetTopBarStore(false).getScreenTopBar(v18.routeName)
	local v20 = SignalsReact.useSignalState(v19)

	ArgCheck.isType(v20, "table", "screenTopBar")

	local v21 = v18.params and v18.params.conversationId
	local conversationId = v20.conversationId

	if v21 and (conversationId and v21 ~= conversationId) then
		v20 = Cryo.Dictionary.union(v20, {
			headerText = {
				raw = "",
				shouldLocalize = false
			}
		})
	end

	return createChatTopBar(Cryo.Dictionary.join(v20, v16, {
		navigation = navigation
	}))
end
local function TopBarFromContext(p2) -- line: 95
	-- upvalues: RoactNavigation (copy), Roact (copy), TopBarContext (copy), ArgCheck (copy), Cryo (copy), createChatTopBar (copy)
	local navigation = p2.navigation
	local v25 = RoactNavigation.getActiveChildNavigationOptions(navigation)

	return Roact.createElement(TopBarContext.Consumer, {
		render = function(p3) -- line: 100
			-- upvalues: navigation (copy), ArgCheck (copy), Cryo (copy), createChatTopBar (copy), v25 (copy)
			local state = navigation.state
			local v30 = state.routes[state.index]
			local v31 = p3.getScreenTopBar(v30.routeName)

			ArgCheck.isType(v31, "table", "screenTopBar")

			local v32 = v30.params and v30.params.conversationId
			local conversationId = v31.conversationId

			if v32 and (conversationId and v32 ~= conversationId) then
				v31 = Cryo.Dictionary.union(v31, {
					headerText = {
						raw = "",
						shouldLocalize = false
					}
				})
			end

			return createChatTopBar(Cryo.Dictionary.join(v31, v25, {
				navigation = navigation
			}))
		end
	})
end

return function(p4) -- line: 128
	-- upvalues: FFlagAppChatTopBarSignalsStore (copy), TopBarFromStore (copy), TopBarFromContext (copy), Roact (copy)
	local v27 = if not FFlagAppChatTopBarSignalsStore then TopBarFromContext else TopBarFromStore

	return Roact.createElement(v27, {
		navigation = p4
	})
end
