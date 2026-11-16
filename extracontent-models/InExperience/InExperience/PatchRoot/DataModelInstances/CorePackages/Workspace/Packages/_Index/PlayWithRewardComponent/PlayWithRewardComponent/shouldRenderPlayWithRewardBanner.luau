local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("PlayWithRewardComponent").Parent
require(parent.PlayWithRewardState)

local function shouldRenderPlayWithRewardBanner(p: string, p2: string, p3: string?, data): boolean
	local localPlayer = Players.LocalPlayer
	local productId = tonumber(data and data.productId or 0) or 0

	if
		localPlayer == nil
		or p2 == ""
		or p3 == nil
		or p3 ~= p
		or data == nil
		or data.adAvailabilityResult ~= Enum.AdAvailabilityResult.IsAvailable
		or data.experimentVariantData == nil
		or data.experimentVariantData.titleText == "" and data.experimentVariantData.subtitleText == ""
	then
		return false
	end

	return productId ~= 0
end

return shouldRenderPlayWithRewardBanner
