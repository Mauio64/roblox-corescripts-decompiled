local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("PlayWithRewardComponent").Parent

require(Parent.PlayWithRewardState)

local function shouldRenderPlayWithRewardBanner(s1: string, s2: string, s3: string?, p1) -- line: 10
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer
	local v9 = tonumber(p1 and p1.productId or 0) or 0

	return LocalPlayer ~= nil and (s2 ~= "" and (s3 ~= nil and (s3 == s1 and (p1 ~= nil and (p1.adAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable and (p1.experimentVariantData ~= nil and ((p1.experimentVariantData.titleText ~= "" or p1.experimentVariantData.subtitleText ~= "") and v9 ~= 0)))))))
end

return shouldRenderPlayWithRewardBanner
