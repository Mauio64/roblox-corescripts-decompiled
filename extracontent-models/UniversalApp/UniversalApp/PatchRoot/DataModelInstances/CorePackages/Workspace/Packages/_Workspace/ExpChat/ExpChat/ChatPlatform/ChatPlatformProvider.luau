local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)
local RoactUtils = require(ExpChatParent.RoactUtils)
local SharedFlags = require(ExpChatParent.SharedFlags)
local ChatUIPrimitives = require(ExpChatParent.ChatUIPrimitives)
local Config = require(ExpChat.Config)
local ClientSettings = require(ExpChat.ClientSettings)
local ClientSettingsUtility = require(ExpChat.ClientSettings.ClientSettingsUtility)
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local Provider = require(ExpChatParent.ExpChatIntegration.ChatPlatformContext).Provider
local usePropSignal = ChatUIPrimitives.Hooks.usePropSignal
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore
local t1 = {
	ChatWindowBackgroundColor3 = Config.ChatWindowBackgroundColor3,
	ChatWindowBackgroundTransparency = Config.ChatWindowBackgroundTransparency,
	ChatWindowMaxWidth = Config.ChatWindowMaxWidth,
	ChatWindowMaxHeight = Config.ChatWindowMaxHeight
}

local function makeInterpolators(p1) -- line: 60
	-- upvalues: ClientSettingsUtility (copy)
	return {
		getBackgroundColor = function(p2) -- line: 62
			-- upvalues: ClientSettingsUtility (copy), p1 (copy)
			return ClientSettingsUtility.getBackgroundColor(p2, p1)
		end,
		getBackgroundTransparency = function(p3) -- line: 65
			-- upvalues: ClientSettingsUtility (copy), p1 (copy)
			return ClientSettingsUtility.getBackgroundTransparency(p3, p1)
		end
	}
end
local function ChatPlatformProvider(t2: {[any]: any}) -- line: 71
	-- upvalues: React (copy), ClientSettings (copy), FFlagExpChatUseChatConfigStore (copy), SignalsReact (copy), GetChatConfigurationStore (copy), useSelector (copy), makeInterpolators (copy), usePropSignal (copy), t1 (copy), GetTransparencyStore (copy), Provider (copy)
	local v22 = React.useContext(ClientSettings)
	local v23 = if not FFlagExpChatUseChatConfigStore then useSelector(function(p4) -- line: 78
		return p4.ChatLayout.ChatInputBarSettings
	end) else SignalsReact.useSignalState(GetChatConfigurationStore(false).getChatInputBarSettings)
	local v24 = React.useMemo(function() -- line: 85
		-- upvalues: makeInterpolators (copy), v22 (copy)
		return (makeInterpolators(v22))
	end, { v22 })
	local v25 = usePropSignal(v23)
	local v26 = usePropSignal(v24)
	local v27 = React.useMemo(function() -- line: 92
		-- upvalues: v25 (copy), t1 (copy), v26 (copy), GetTransparencyStore (copy)
		return {
			getChatInputBarSettings = v25,
			chatWindowSettings = t1,
			getInterpolators = v26,
			getTransparencyStore = GetTransparencyStore
		}
	end, {
		v25,
		v26
	})

	return React.createElement(Provider, {
		value = v27
	}, t2.children)
end

return ChatPlatformProvider
