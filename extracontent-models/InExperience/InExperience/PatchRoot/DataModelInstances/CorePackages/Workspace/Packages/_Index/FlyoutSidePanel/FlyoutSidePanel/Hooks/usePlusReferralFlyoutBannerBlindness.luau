local AppStorageService = game:GetService("AppStorageService")

local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)

game:DefineFastInt("PlusReferralFlyoutBannerMaxImpressions", 10)

local function getImpressionCount(p: string) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return AppStorageService:GetItem(p)
	end)

	if success and typeof(result) == "string" and result ~= "" then
		return tonumber(result) or 0
	end

	return 0
end

local function incrementImpressionCount(p: string) -- 1 equivalent call inferred from this helper
	pcall(function()
		local v = p
		local success, result = pcall(function()
			return AppStorageService:GetItem(v)
		end)

		local v2 = (success and typeof(result) == "string" and result ~= "" and tonumber(result) or 0) + 1

		AppStorageService:SetItem(p, (tostring(v2)))
		AppStorageService:Flush()
	end)
end

local function usePlusReferralFlyoutBannerBlindness(flag: boolean, p: string, p2: number?)
	local v = React.useState(function()
		return getImpressionCount(p) -- inferred equivalent call
	end)

	local v2 = p2 or game:GetFastInt("PlusReferralFlyoutBannerMaxImpressions")
	local v3 = v2 == 0 or v < v2
	local v4 = flag and v3

	React.useEffect(function()
		if v4 then
			incrementImpressionCount(p) -- inferred equivalent call
		end
	end, { v4, p })

	return v4
end

return usePlusReferralFlyoutBannerBlindness
