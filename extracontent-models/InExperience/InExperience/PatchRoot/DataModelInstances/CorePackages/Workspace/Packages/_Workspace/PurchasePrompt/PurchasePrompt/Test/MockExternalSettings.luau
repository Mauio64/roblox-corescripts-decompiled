local parent = script.Parent.Parent

local parent2 = script:FindFirstAncestor("PurchasePrompt").Parent
local PurchasePromptDeps = require(parent2.PurchasePromptDeps)
local Cryo = PurchasePromptDeps.Cryo

local v = { RestrictSales2 = false, Order66 = false }

return {
	new = function(p, p2, options, p3)
		local joined = Cryo.Dictionary.join(v, options or {})

		local function getMockFlag(p4, p5)
			return if p4 == nil then p5 else p4
		end

		return {
			getPlatform = function()
				return p3 or Enum.Platform.Windows
			end,
			isStudio = function()
				return p or false
			end,
			isThirdPartyPurchaseAllowed = function()
				return joined.PermissionsServiceIsThirdPartyPurchaseAllowed
			end,
			getLuaUseThirdPartyPermissions = function()
				local luaUseThirdPartyPermissions = joined.LuaUseThirdPartyPermissions
				return luaUseThirdPartyPermissions == nil or luaUseThirdPartyPermissions
			end,
			getFlagBypassThirdPartySettingForRobloxPurchase = function()
				return joined.BypassThirdPartySettingForRobloxPurchase
			end,
			getFlagRestrictSales2 = function()
				return joined.RestrictSales2
			end,
			getFlagOrder66 = function()
				return joined.Order66
			end,
			isTenFootInterface = function()
				return p2
			end,
			getFFlagDisableRobuxUpsell = function()
				return joined.DisableRobuxUpsell
			end
		}
	end
}
