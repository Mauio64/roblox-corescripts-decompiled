local parent = script:FindFirstAncestor("InExperienceShop").Parent

local v = game:DefineFastFlag("EnableFreeTrialShopMenuBadge", false)
	and require(script.Parent.FFlagLuaAppEnableGamePassFreeTrials)

if v then
	local SharedFlags = require(parent.SharedFlags)
	return SharedFlags.FFlagEnableCustomTextInMenuTrailingBadge
end

return v
