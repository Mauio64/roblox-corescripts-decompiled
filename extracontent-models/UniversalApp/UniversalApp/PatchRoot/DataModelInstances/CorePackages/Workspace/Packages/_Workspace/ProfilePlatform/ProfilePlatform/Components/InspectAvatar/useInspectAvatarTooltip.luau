local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local AppStorageService = game:GetService("AppStorageService")
local React = require(Parent.React)
local v4 = game:DefineFastInt("ProfilePlatformInspectAvatarTooltipMaxImpressions", 3)

local function useInspectAvatarTooltip() -- line: 10
	-- upvalues: React (copy), AppStorageService (copy), v4 (copy)
	local v6, v7 = React.useState(false)
	local v8 = React.useRef(false)

	React.useEffect(function() -- line: 14
		-- upvalues: v8 (copy), AppStorageService (copy), v4 (copy), v7 (copy)
		if v8.current then
			return
		end

		local ok, result = pcall(function() -- line: 19
			-- upvalues: AppStorageService (copy)
			return tonumber(AppStorageService:GetItem("ProfileInspectAndBuyImpressionCount")) or 0
		end)

		if not ok or result >= v4 then
			return
		end

		pcall(function() -- line: 25
			-- upvalues: AppStorageService (copy), result (copy)
			AppStorageService:SetItem("ProfileInspectAndBuyImpressionCount", (tostring(result + 1)))
			AppStorageService:Flush()
		end)
		v8.current = true
		v7(true)
	end, {})

	local v9 = React.useCallback(function() -- line: 34
		-- upvalues: AppStorageService (copy), v4 (copy), v7 (copy)
		pcall(function() -- line: 35
			-- upvalues: AppStorageService (copy), v4 (copy)
			AppStorageService:SetItem("ProfileInspectAndBuyImpressionCount", (tostring(v4)))
			AppStorageService:Flush()
		end)
		v7(false)
	end, {})

	return {
		showTooltip = v6,
		onDismiss = v9
	}
end

return useInspectAvatarTooltip
