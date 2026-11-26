local UserInputService = game:GetService("UserInputService")

local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module2 = require("@luauforge/bundled/dGK")

local fFlagLuaAppEdpKeepFullPageOnPortraitRotation = SharedFlags.FFlagLuaAppEdpKeepFullPageOnPortraitRotation

return function(p2)
	local v5 = Enum.Platform.None
	pcall(function()
		v5 = UserInputService:GetPlatform()
	end)

	if v5 ~= Enum.Platform.IOS and v5 ~= Enum.Platform.Android then
		return module2.PolicyDependent
	end

	if fFlagLuaAppEdpKeepFullPageOnPortraitRotation then
		if p2.deviceOrientation == deviceOrientationMode.Landscape then
			return module2.Visible
		end

		return module2.Hidden
	elseif p2.FormFactor == formFactor.WIDE then
		return module2.Visible
	end

	return module2.PolicyDependent
end
