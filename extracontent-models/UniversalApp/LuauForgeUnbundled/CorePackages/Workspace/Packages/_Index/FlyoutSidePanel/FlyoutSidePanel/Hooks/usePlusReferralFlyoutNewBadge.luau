local AppStorageService = game:GetService("AppStorageService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")

local function getImpressionCount(p2)
	local success, result = pcall(function()
		return AppStorageService:GetItem(p2)
	end)

	if success and typeof(result) == "string" and result ~= "" then
		return tonumber(result) or 0
	end

	return 0
end

local function markSeen(p2)
	pcall(function()
		AppStorageService:SetItem(p2, "1")
		AppStorageService:Flush()
	end)
end

local function usePlusReferralFlyoutNewBadge(callback, p2)
	local v5 = React.useState(function(): boolean
		local v6 = p2
		local success, result = pcall(function()
			return AppStorageService:GetItem(v6)
		end)

		return (success and typeof(result) == "string" and result ~= "" and tonumber(result) or 0) < 1
	end)

	return {
		shouldShowNewBadge = v5,
		onActivated = React.useCallback(function()
			if v5 then
				local v6 = p2
				pcall(function()
					AppStorageService:SetItem(v6, "1")
					AppStorageService:Flush()
				end)
			end

			callback()
		end, { v5, callback, p2 })
	}
end

return usePlusReferralFlyoutNewBadge
