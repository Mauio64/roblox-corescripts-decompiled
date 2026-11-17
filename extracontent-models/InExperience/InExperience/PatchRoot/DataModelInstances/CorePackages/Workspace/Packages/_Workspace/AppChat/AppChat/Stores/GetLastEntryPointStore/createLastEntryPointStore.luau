local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.Signals)
require(parent.SocialCommon)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local trackChatLanding = require(AppChat.Telemetry.trackChatLanding)

local function createLastEntryPointStore()
	local sessionScopedSignal, v = createSessionScopedSignal("NotSet")

	return {
		getLastEntryPoint = sessionScopedSignal,
		enteredChatFromEntryPoint = function(value)
			if FFlagAppChatPerfTracking then
				trackChatLanding(value)
			end

			v(value or "NotSet")
		end,
		reset = function()
			v("NotSet")
		end
	}
end

return createLastEntryPointStore
