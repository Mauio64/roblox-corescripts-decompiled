local AppStorageService = game:GetService("AppStorageService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")

game:DefineFastInt("PlusReferralFlyoutBannerMaxImpressions", 10)

local function getImpressionCount(p2)
	local success, result = pcall(function()
		return AppStorageService:GetItem(p2)
	end)

	if success and typeof(result) == "string" and result ~= "" then
		return tonumber(result) or 0
	end

	return 0
end

local function incrementImpressionCount(p2)
	pcall(function()
		local v5 = p2
		local success, result = pcall(function()
			return AppStorageService:GetItem(v5)
		end)

		AppStorageService:SetItem(
			p2,
			(tostring((success and typeof(result) == "string" and result ~= "" and tonumber(result) or 0) + 1))
		)
		AppStorageService:Flush()
	end)
end

local function usePlusReferralFlyoutBannerBlindness(p2, p3, p4)
	local v5 = React.useState(function()
		local v6 = p3
		local success, result = pcall(function()
			return AppStorageService:GetItem(v6)
		end)

		if success and typeof(result) == "string" and result ~= "" then
			return tonumber(result) or 0
		end

		return 0
	end)

	local v6 = p4 or game:GetFastInt("PlusReferralFlyoutBannerMaxImpressions")
	local v7 = v6 == 0 or v5 < v6
	local v8 = p2 and v7

	React.useEffect(function()
		if v8 then
			local v9 = p3
			pcall(function()
				local v10 = v9
				local success, result = pcall(function()
					return AppStorageService:GetItem(v10)
				end)

				AppStorageService:SetItem(
					v9,
					(tostring((success and typeof(result) == "string" and result ~= "" and tonumber(result) or 0) + 1))
				)
				AppStorageService:Flush()
			end)
		end
	end, { v8, p3 })

	return v8
end

return usePlusReferralFlyoutBannerBlindness
