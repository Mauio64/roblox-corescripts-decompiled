local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local SystemBarVisibility = require(Modules.LuaApp.Enum.SystemBarVisibility)
local FFlagLuaAppEdpKeepFullPageOnPortraitRotation = SharedFlags.FFlagLuaAppEdpKeepFullPageOnPortraitRotation

return function(p1) -- line: 13
	-- upvalues: UserInputService (copy), FFlagLuaAppEdpKeepFullPageOnPortraitRotation (copy), DeviceOrientationMode (copy), SystemBarVisibility (copy), FormFactor (copy)
	local None = Enum.Platform.None

	pcall(function() -- line: 15
		-- upvalues: None (ref), UserInputService (copy)
		None = UserInputService:GetPlatform()
	end)

	if None == Enum.Platform.IOS or None == Enum.Platform.Android then
		if FFlagLuaAppEdpKeepFullPageOnPortraitRotation then
			if p1.deviceOrientation == DeviceOrientationMode.Landscape then
				return SystemBarVisibility.Visible
			end

			return SystemBarVisibility.Hidden
		end

		if p1.FormFactor == FormFactor.WIDE then
			return SystemBarVisibility.Visible
		end
	end

	return SystemBarVisibility.PolicyDependent
end
