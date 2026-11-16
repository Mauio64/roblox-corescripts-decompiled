local parent = script.Parent.Parent
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local AppCommonLib = require(parent.Parent.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface
local GetFFlagDisableRobuxUpsell = require(parent.Flags.GetFFlagDisableRobuxUpsell)

return {
	new = function()
		local v = {}

		setmetatable(v, {
			__tostring = function(): string
				return "Service(ExternalSettings)"
			end
		})

		function v.getPlatform()
			return UserInputService:GetPlatform()
		end

		function v.isStudio()
			return RunService:IsStudio()
		end

		function v.isThirdPartyPurchaseAllowed()
			local v2 = true
			pcall(function()
				local PermissionsService = game:GetService("PermissionsService")
				v2 = PermissionsService:GetIsThirdPartyPurchaseAllowed()
			end)
			return v2
		end

		function v.getLuaUseThirdPartyPermissions(): boolean
			return true
		end

		function v.getFlagBypassThirdPartySettingForRobloxPurchase(): boolean
			return true
		end

		function v.getFlagRestrictSales2()
			return settings():GetFFlag("RestrictSales2")
		end

		function v.getFlagOrder66()
			return settings():GetFFlag("Order66")
		end

		function v.isTenFootInterface()
			return isTenFootInterface()
		end

		function v.getFFlagDisableRobuxUpsell()
			return GetFFlagDisableRobuxUpsell()
		end

		return v
	end
}
