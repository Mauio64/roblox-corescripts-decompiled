local parent = script:FindFirstAncestor("SocialCarousel").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppEnums = require(parent.RobloxAppEnums)

local useTokens = Foundation.Hooks.useTokens

local function useXSmallTileTypography()
	local v = useTokens()
	local v2 = RobloxAppHooks.useDeviceType() == RobloxAppEnums.DeviceType.Phone

	return React.useMemo(function()
		if not v2 then
			return nil
		end

		local fontSize_200 = v.FontSize.FontSize_200

		local clone = table.clone(v.Typography.TitleSmall)
		clone.FontSize = fontSize_200

		local clone2 = table.clone(v.Typography.LabelSmall)
		clone2.FontSize = fontSize_200

		return { title = clone, label = clone2 }
	end, { v, v2 })
end

return useXSmallTileTypography
