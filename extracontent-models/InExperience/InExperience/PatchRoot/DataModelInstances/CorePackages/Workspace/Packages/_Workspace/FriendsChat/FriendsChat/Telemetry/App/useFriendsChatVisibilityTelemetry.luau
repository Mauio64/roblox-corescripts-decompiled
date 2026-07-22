local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local AppTelemetryLayer = require(Parent.AppChat.AppTelemetryLayer)
local useTelemetry = require(Parent.AppChat.useTelemetry)
local AppLevelTelemetryEvents = require(script.Parent.AppLevelTelemetryEvents)

local function useFriendsChatVisibilityTelemetry() -- line: 18
	-- upvalues: useTelemetry (copy), AppTelemetryLayer (copy), React (copy), AppLevelTelemetryEvents (copy)
	local emit = useTelemetry(AppTelemetryLayer.Context).emit

	React.useEffect(function() -- line: 26
		-- upvalues: emit (copy), AppLevelTelemetryEvents (copy)
		emit(AppLevelTelemetryEvents.AppChatVisible, {
			isChatEnabled = true
		})

		return function() -- line: 31
			-- upvalues: emit (copy), AppLevelTelemetryEvents (copy)
			emit(AppLevelTelemetryEvents.AppChatClosed, {
				isChatEnabled = true
			})
		end
	end, {})
end

return useFriendsChatVisibilityTelemetry
