local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local UserInputService = game:GetService("UserInputService")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls

function dismissRobloxMenuAndRun(callback)
	if FFlagEnableConsoleExpControls and UserInputService.GamepadEnabled then
		GuiService.SelectedCoreObject = nil
	end

	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

	if not GuiService.MenuIsOpen then
		callback(false)

		return
	end

	local v = tick() + 3
	local menuClosedConnection = nil
	menuClosedConnection = GuiService.MenuClosed:Connect(function()
		if menuClosedConnection then
			menuClosedConnection:Disconnect()
			menuClosedConnection = nil
		end

		if tick() < v then
			callback(true)
		end
	end)
	SettingsHub:SetVisibility(false)
end

return { dismissRobloxMenuAndRun = dismissRobloxMenuAndRun }
