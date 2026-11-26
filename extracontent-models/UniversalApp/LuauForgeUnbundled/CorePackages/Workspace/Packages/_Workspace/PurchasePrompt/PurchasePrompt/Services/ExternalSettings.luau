local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/AppCommonLib").isTenFootInterface
local GetFFlagDisableRobuxUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagDisableRobuxUpsell")

return {
	new = function()
		local v5 = {}

		setmetatable(v5, {
			__tostring = function(): string
				return "Service(ExternalSettings)"
			end
		})

		function v5.getPlatform()
			return UserInputService:GetPlatform()
		end

		function v5.isStudio()
			return RunService:IsStudio()
		end

		function v5.isThirdPartyPurchaseAllowed()
			local v6 = true
			pcall(function()
				local PermissionsService = game:GetService("PermissionsService")
				v6 = PermissionsService:GetIsThirdPartyPurchaseAllowed()
			end)
			return v6
		end

		function v5.getLuaUseThirdPartyPermissions(): boolean
			return true
		end

		function v5.getFlagBypassThirdPartySettingForRobloxPurchase(): boolean
			return true
		end

		function v5.getFlagRestrictSales2()
			return settings():GetFFlag("RestrictSales2")
		end

		function v5.getFlagOrder66()
			return settings():GetFFlag("Order66")
		end

		function v5.isTenFootInterface()
			return isTenFootInterface()
		end

		function v5.getFFlagDisableRobuxUpsell()
			return GetFFlagDisableRobuxUpsell()
		end

		return v5
	end
}
