local androidTVExitButtonManager = require("@luauforge/deferred/hcZ").AndroidTVExitButtonManager
local fFlagAndroidTVExitWithB = require("@luauforge/deferred/hbX").FFlagAndroidTVExitWithB

return function(object, p2)
	local showLeaveConfirmationConnection = nil
	local v5 = nil

	return {
		disconnect = function()
			if showLeaveConfirmationConnection then
				showLeaveConfirmationConnection:Disconnect()
				showLeaveConfirmationConnection = nil
			end

			if fFlagAndroidTVExitWithB and v5 then
				v5()
				v5 = nil
			end
		end,
		connect = function(onShowLeaveConfirmation)
			if showLeaveConfirmationConnection then
				if showLeaveConfirmationConnection then
					showLeaveConfirmationConnection:Disconnect()
					showLeaveConfirmationConnection = nil
				end

				if fFlagAndroidTVExitWithB and v5 then
					v5()
					v5 = nil
				end
			end

			if object then
				showLeaveConfirmationConnection = object.ShowLeaveConfirmation:Connect(onShowLeaveConfirmation)
			end

			if fFlagAndroidTVExitWithB then
				v5 = androidTVExitButtonManager.register(onShowLeaveConfirmation)
			end
		end,
		showExitDialog = function()
			if object and p2 then
				object:BroadcastNotification("", p2.BACK_BUTTON_NOT_CONSUMED)
			end
		end
	}
end
