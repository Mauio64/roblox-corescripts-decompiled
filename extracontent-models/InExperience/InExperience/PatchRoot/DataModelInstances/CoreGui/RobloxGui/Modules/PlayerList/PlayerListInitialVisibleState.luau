local VRService = game:GetService("VRService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local Utility = require(RobloxGui.Modules.Settings.Utility)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local scriptParent = script.Parent
local FFlagPlayerListPersistVisibility = require(scriptParent.Flags.FFlagPlayerListPersistVisibility)
local FStringPlayerListOverrideType = require(scriptParent.Flags.FStringPlayerListOverrideType)
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local FFlagPlayerListUseMobileOnSmallDisplay = PlayerList.Flags.FFlagPlayerListUseMobileOnSmallDisplay

local function isSmallTouchScreen() -- line: 19
	-- upvalues: FFlagPlayerListUseMobileOnSmallDisplay (copy), GuiService (copy), FFlagEnableMobilePlayerListOnConsole (copy), UserInputService (copy), Utility (copy), FStringPlayerListOverrideType (copy)
	if _G.__TESTEZ_RUNNING_TEST__ then
		return false
	end

	local v16 = not not FFlagPlayerListUseMobileOnSmallDisplay and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small
	local v17 = not not FFlagEnableMobilePlayerListOnConsole and GuiService.ViewportDisplaySize == Enum.DisplaySize.Large
	local v18 = (FFlagEnableMobilePlayerListOnConsole or not not FFlagPlayerListUseMobileOnSmallDisplay) and (UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService.PreferredInput == Enum.PreferredInput.Gamepad)

	return Utility:IsSmallTouchScreen() or (FFlagEnableMobilePlayerListOnConsole and (not not v17 and v18) or (FFlagPlayerListUseMobileOnSmallDisplay and (not not v16 and v18) or FStringPlayerListOverrideType == "mobile"))
end

return function() -- line: 32
	-- upvalues: isSmallTouchScreen (copy), VRService (copy), FFlagEnableMobilePlayerListOnConsole (copy), TenFootInterface (copy), FFlagPlayerListPersistVisibility (copy)
	local v19 = not isSmallTouchScreen()

	if v19 then
		v19 = not VRService.VREnabled

		if not v19 then
			return v19
		end

		if not FFlagEnableMobilePlayerListOnConsole then
			v19 = not TenFootInterface:IsEnabled()

			if not v19 then
				return v19
			end
		end

		if FFlagPlayerListPersistVisibility then
			return UserSettings().GameSettings.PlayerListVisible
		end

		v19 = true
	end

	return v19
end
