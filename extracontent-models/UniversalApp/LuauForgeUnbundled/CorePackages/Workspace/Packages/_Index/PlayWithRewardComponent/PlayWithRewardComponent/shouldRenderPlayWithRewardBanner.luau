local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Workspace/PlayWithRewardComponent/PlayWithRewardState")

local function shouldRenderPlayWithRewardBanner(p2, p3, p4, data)
	local localPlayer = Players.LocalPlayer
	local productId = tonumber(data and data.productId or 0) or 0
	local v5

	if
		localPlayer == nil
		or p3 == ""
		or p4 == nil
		or p4 ~= p2
		or data == nil
		or data.adAvailabilityResult ~= Enum.AdAvailabilityResult.IsAvailable
		or data.experimentVariantData == nil
		or data.experimentVariantData.titleText == "" and data.experimentVariantData.subtitleText == ""
	then
		v5 = false
	else
		v5 = productId ~= 0
	end

	return v5
end

return shouldRenderPlayWithRewardBanner
