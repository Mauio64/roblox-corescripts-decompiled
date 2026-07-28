local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local AppTelemetryLayer = require(Parent.AppChat.AppTelemetryLayer)
local GetFriendsChatSettingsStore = require(Parent.AppChat.GetFriendsChatSettingsStore)
local useTelemetry = require(Parent.AppChat.useTelemetry)
local AppLevelTelemetryEvents = require(script.Parent.AppLevelTelemetryEvents)

local function getIsChatEnabled() -- line: 19
	-- upvalues: GetFriendsChatSettingsStore (copy)
	return GetFriendsChatSettingsStore(false).getChatEnabled(false)
end
local function useFriendsChatVisibilityTelemetry() -- line: 23
	-- upvalues: useTelemetry (copy), AppTelemetryLayer (copy), React (copy), AppLevelTelemetryEvents (copy), GetFriendsChatSettingsStore (copy)
	local emit = useTelemetry(AppTelemetryLayer.Context).emit

	React.useEffect(function() -- line: 31
		-- upvalues: emit (copy), AppLevelTelemetryEvents (copy), GetFriendsChatSettingsStore (copy)
		emit(AppLevelTelemetryEvents.AppChatVisible, {
			isChatEnabled = GetFriendsChatSettingsStore(false).getChatEnabled(false)
		})

		return function() -- line: 35
			-- upvalues: emit (copy), AppLevelTelemetryEvents (copy), GetFriendsChatSettingsStore (copy)
			emit(AppLevelTelemetryEvents.AppChatClosed, {
				isChatEnabled = GetFriendsChatSettingsStore(false).getChatEnabled(false)
			})
		end
	end, {})
end

return useFriendsChatVisibilityTelemetry
