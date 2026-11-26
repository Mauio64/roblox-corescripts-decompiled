local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Foundation")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppHooks")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums")

local useTokens = Foundation.Hooks.useTokens

local function useXSmallTileTypography()
	local v5 = useTokens()
	local v6 = RobloxAppHooks.useDeviceType() == RobloxAppEnums.DeviceType.Phone

	return React.useMemo(function()
		if not v6 then
			return nil
		end

		local fontSize_200 = v5.FontSize.FontSize_200

		local clone = table.clone(v5.Typography.TitleSmall)
		clone.FontSize = fontSize_200

		local clone2 = table.clone(v5.Typography.LabelSmall)
		clone2.FontSize = fontSize_200

		return { title = clone, label = clone2 }
	end, { v5, v6 })
end

return useXSmallTileTypography
