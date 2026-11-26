local module = require("@luauforge/deferred/gBd")

local module2 = require("@luauforge/deferred/gBe")
local notificationType = require("@luauforge/deferred/gAu").NotificationType
local setModerationStatus = require("@luauforge/deferred/gzN").SetModerationStatus

local fFlagUseSignalsForModeration = require("@luauforge/deferred/gAd").FFlagUseSignalsForModeration

local getModerationStore = if fFlagUseSignalsForModeration then require("@luauforge/deferred/gzN").GetModerationStore else nil

local GuiService = game:GetService("GuiService")

local function ReactivateAccount(p2, p3)
	return function(object)
		return module(p2, p3):andThen(function(p4)
			if fFlagUseSignalsForModeration then
				getModerationStore(false).setModerationStatus(false)
			else
				object:dispatch(setModerationStatus(false))
			end

			GuiService:BroadcastNotification("", notificationType.RESTART_LUA_APP)
			return module2.resolve()
		end, function(p4)
			return module2.reject({ error = p4 })
		end)
	end
end

return ReactivateAccount
