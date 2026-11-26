local module = require("@luauforge/bundled/fvN")
local GuiService = game:GetService("GuiService")

local androidTVExitButtonManager = require("@luauforge/bundled/dFB").AndroidTVExitButtonManager
local fFlagAndroidTVExitWithB = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAndroidTVExitWithB

return function()
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

			if GuiService then
				showLeaveConfirmationConnection = GuiService.ShowLeaveConfirmation:Connect(onShowLeaveConfirmation)
			end

			if fFlagAndroidTVExitWithB then
				v5 = androidTVExitButtonManager.register(onShowLeaveConfirmation)
			end
		end,
		showExitDialog = function()
			if GuiService and module then
				GuiService:BroadcastNotification("", module.BACK_BUTTON_NOT_CONSUMED)
			end
		end
	}
end
