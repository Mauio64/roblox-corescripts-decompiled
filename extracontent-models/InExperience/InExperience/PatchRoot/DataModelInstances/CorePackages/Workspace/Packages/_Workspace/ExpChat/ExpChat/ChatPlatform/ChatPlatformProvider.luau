local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local RoactUtils = require(parent.RoactUtils)
local SharedFlags = require(parent.SharedFlags)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)

local Config = require(ExpChat.Config)
local ClientSettings = require(ExpChat.ClientSettings)
local ClientSettingsUtility = require(ExpChat.ClientSettings.ClientSettingsUtility)
local GetChatConfigurationStore = require(ExpChat.Stores.GetChatConfigurationStore)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)

local ChatPlatformContext = require(parent.ExpChatIntegration.ChatPlatformContext)
local Provider = ChatPlatformContext.Provider
local usePropSignal = ChatUIPrimitives.Hooks.usePropSignal
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FFlagExpChatUseChatConfigStore = SharedFlags.FFlagExpChatUseChatConfigStore

local chatWindowSettings = {
	ChatWindowBackgroundColor3 = Config.ChatWindowBackgroundColor3,
	ChatWindowBackgroundTransparency = Config.ChatWindowBackgroundTransparency,
	ChatWindowMaxWidth = Config.ChatWindowMaxWidth,
	ChatWindowMaxHeight = Config.ChatWindowMaxHeight
}

local function makeInterpolators(p)
	return {
		getBackgroundColor = function(p2)
			return ClientSettingsUtility.getBackgroundColor(p2, p)
		end,
		getBackgroundTransparency = function(p2)
			return ClientSettingsUtility.getBackgroundTransparency(p2, p)
		end
	}
end

local function ChatPlatformProvider(p)
	local v = React.useContext(ClientSettings)
	local v2

	if FFlagExpChatUseChatConfigStore then
		v2 = SignalsReact.useSignalState(GetChatConfigurationStore(false).getChatInputBarSettings)
	else
		v2 = useSelector(function(p2)
			return p2.ChatLayout.ChatInputBarSettings
		end)
	end

	local v3 = React.useMemo(function()
		return makeInterpolators(v)
	end, { v })

	local getChatInputBarSettings = usePropSignal(v2)
	local getInterpolators = usePropSignal(v3)

	local v4 = React.useMemo(function()
		return {
			getChatInputBarSettings = getChatInputBarSettings,
			chatWindowSettings = chatWindowSettings,
			getInterpolators = getInterpolators,
			getTransparencyStore = GetTransparencyStore
		}
	end, { getChatInputBarSettings, getInterpolators })

	return React.createElement(Provider, { value = v4 }, p.children)
end

return ChatPlatformProvider
