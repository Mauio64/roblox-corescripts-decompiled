local _ = script.Parent.Parent
local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local Cryo = require(Parent.PurchasePromptDeps).Cryo
local t1 = {
	RestrictSales2 = false,
	Order66 = false
}

return {
	new = function(p1, p2, p3, p4) -- line: 23
		-- upvalues: Cryo (copy), t1 (copy)
		local t2 = {}
		local u10 = Cryo.Dictionary.join(t1, p3 or {})

		local function getMockFlag(p5, p6) -- line: 34
			if p5 ~= nil then
				return p5
			end

			return p6
		end

		function t2.getPlatform() -- line: 41
			-- upvalues: p4 (copy)
			return p4 or Enum.Platform.Windows
		end
		function t2.isStudio() -- line: 45
			-- upvalues: p1 (copy)
			return p1 or false
		end
		function t2.isThirdPartyPurchaseAllowed() -- line: 49
			-- upvalues: u10 (ref)
			return u10.PermissionsServiceIsThirdPartyPurchaseAllowed
		end
		function t2.getLuaUseThirdPartyPermissions() -- line: 53
			-- upvalues: u10 (ref)
			local LuaUseThirdPartyPermissions = u10.LuaUseThirdPartyPermissions

			if LuaUseThirdPartyPermissions ~= nil then
				return LuaUseThirdPartyPermissions
			end

			return true
		end
		function t2.getFlagBypassThirdPartySettingForRobloxPurchase() -- line: 57
			-- upvalues: u10 (ref)
			return u10.BypassThirdPartySettingForRobloxPurchase
		end
		function t2.getFlagRestrictSales2() -- line: 62
			-- upvalues: u10 (ref)
			return u10.RestrictSales2
		end
		function t2.getFlagOrder66() -- line: 66
			-- upvalues: u10 (ref)
			return u10.Order66
		end
		function t2.isTenFootInterface() -- line: 70
			-- upvalues: p2 (copy)
			return p2
		end
		function t2.getFFlagDisableRobuxUpsell() -- line: 74
			-- upvalues: u10 (ref)
			return u10.DisableRobuxUpsell
		end
		function t2.GetFFlagEnableRestrictedAssetSaleLocationPurchasePrompt() -- line: 78
			-- upvalues: u10 (ref)
			return u10.EnableRestrictedAssetSaleLocationPurchasePrompt
		end

		return t2
	end
}
