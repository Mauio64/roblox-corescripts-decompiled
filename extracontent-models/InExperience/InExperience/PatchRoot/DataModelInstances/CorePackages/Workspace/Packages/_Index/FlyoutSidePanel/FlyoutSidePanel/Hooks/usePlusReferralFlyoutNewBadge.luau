local AppStorageService = game:GetService("AppStorageService")

local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)

local function getImpressionCount(p: string)
	local success, result = pcall(function()
		return AppStorageService:GetItem(p)
	end)

	if success and typeof(result) == "string" and result ~= "" then
		return tonumber(result) or 0
	end

	return 0
end

local function markSeen(p: string) -- 1 equivalent call inferred from this helper
	pcall(function()
		AppStorageService:SetItem(p, "1")
		AppStorageService:Flush()
	end)
end

local function usePlusReferralFlyoutNewBadge(callback, p: string)
	local shouldShowNewBadge = React.useState(function(): boolean
		local v = p
		local success, result = pcall(function()
			return AppStorageService:GetItem(v)
		end)

		return (success and typeof(result) == "string" and result ~= "" and tonumber(result) or 0) < 1
	end)

	return {
		shouldShowNewBadge = shouldShowNewBadge,
		onActivated = React.useCallback(function()
			if shouldShowNewBadge then
				markSeen(p) -- inferred equivalent call
			end

			callback()
		end, { shouldShowNewBadge, callback, p })
	}
end

return usePlusReferralFlyoutNewBadge
