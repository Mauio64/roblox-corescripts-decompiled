local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local UserInputService = game:GetService("UserInputService")
local FFlagEnableConsoleExpControls = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableConsoleExpControls

function dismissRobloxMenuAndRun(p1) -- line: 10
	-- upvalues: FFlagEnableConsoleExpControls (copy), UserInputService (copy), GuiService (copy), RobloxGui (copy)
	if FFlagEnableConsoleExpControls and UserInputService.GamepadEnabled then
		GuiService.SelectedCoreObject = nil
	end

	local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

	if GuiService.MenuIsOpen then
		local v8 = tick() + 3
		local u9 = nil

		u9 = GuiService.MenuClosed:Connect(function() -- line: 20
			-- upvalues: u9 (ref), v8 (copy), p1 (copy)
			if u9 then
				u9:Disconnect()
				u9 = nil
			end

			if tick() < v8 then
				p1(true)
			end
		end)
		SettingsHub:SetVisibility(false)

		return
	end

	p1(false)
end

return {
	dismissRobloxMenuAndRun = dismissRobloxMenuAndRun
}
