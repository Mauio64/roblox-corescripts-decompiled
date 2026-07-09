local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local GuiService = game:GetService("GuiService")
local AndroidTVExitButtonManager = require(CorePackages.Workspace.Packages.RobloxAppNavigationCore).AndroidTVExitButtonManager
local FFlagAndroidTVExitWithB = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAndroidTVExitWithB

return function() -- line: 12
	-- upvalues: FFlagAndroidTVExitWithB (copy), GuiService (copy), AndroidTVExitButtonManager (copy), NotificationType (copy)
	local u8 = nil
	local u9 = nil

	return {
		disconnect = function() -- line: 16
			-- upvalues: u8 (ref), FFlagAndroidTVExitWithB (copy), u9 (ref)
			if u8 then
				u8:Disconnect()
				u8 = nil
			end

			if FFlagAndroidTVExitWithB and u9 then
				u9()
				u9 = nil
			end
		end,
		connect = function(p1) -- line: 27
			-- upvalues: u8 (ref), FFlagAndroidTVExitWithB (copy), u9 (ref), GuiService (copy), AndroidTVExitButtonManager (copy)
			if u8 then
				if u8 then
					u8:Disconnect()
					u8 = nil
				end

				if FFlagAndroidTVExitWithB and u9 then
					u9()
					u9 = nil
				end
			end

			if GuiService then
				u8 = GuiService.ShowLeaveConfirmation:Connect(p1)
			end

			if FFlagAndroidTVExitWithB then
				u9 = AndroidTVExitButtonManager.register(p1)
			end
		end,
		showExitDialog = function() -- line: 39
			-- upvalues: GuiService (copy), NotificationType (copy)
			if GuiService and NotificationType then
				GuiService:BroadcastNotification("", NotificationType.BACK_BUTTON_NOT_CONSUMED)
			end
		end
	}
end
