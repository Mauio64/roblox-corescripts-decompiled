local ParentParent = script.Parent.Parent
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local GetFFlagDisableRobuxUpsell = require(ParentParent.Flags.GetFFlagDisableRobuxUpsell)
local GetFFlagEnableRestrictedAssetSaleLocationPurchasePrompt = require(ParentParent.Flags.GetFFlagEnableRestrictedAssetSaleLocationPurchasePrompt)

return {
	new = function() -- line: 12
		-- upvalues: UserInputService (copy), RunService (copy), GuiService (copy), GetFFlagDisableRobuxUpsell (copy), GetFFlagEnableRestrictedAssetSaleLocationPurchasePrompt (copy)
		local t1 = {}

		setmetatable(t1, {
			__tostring = function() -- line: 16
				return "Service(ExternalSettings)"
			end
		})

		function t1.getPlatform() -- line: 21
			-- upvalues: UserInputService (copy)
			return UserInputService:GetPlatform()
		end
		function t1.isStudio() -- line: 25
			-- upvalues: RunService (copy)
			return RunService:IsStudio()
		end
		function t1.isThirdPartyPurchaseAllowed() -- line: 29
			local u8 = true

			pcall(function() -- line: 32
				-- upvalues: u8 (ref)
				u8 = game:GetService("PermissionsService"):GetIsThirdPartyPurchaseAllowed()
			end)

			return u8
		end
		function t1.getLuaUseThirdPartyPermissions() -- line: 38
			return true
		end
		function t1.getFlagBypassThirdPartySettingForRobloxPurchase() -- line: 42
			return true
		end
		function t1.getFlagRestrictSales2() -- line: 47
			return settings():GetFFlag("RestrictSales2")
		end
		function t1.getFlagOrder66() -- line: 51
			return settings():GetFFlag("Order66")
		end
		function t1.isTenFootInterface() -- line: 55
			-- upvalues: GuiService (copy)
			return GuiService:IsTenFootInterface()
		end
		function t1.getFFlagDisableRobuxUpsell() -- line: 59
			-- upvalues: GetFFlagDisableRobuxUpsell (copy)
			return GetFFlagDisableRobuxUpsell()
		end
		function t1.GetFFlagEnableRestrictedAssetSaleLocationPurchasePrompt() -- line: 63
			-- upvalues: GetFFlagEnableRestrictedAssetSaleLocationPurchasePrompt (copy)
			return GetFFlagEnableRestrictedAssetSaleLocationPurchasePrompt()
		end

		return t1
	end
}
