local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local AppStorageService = game:GetService("AppStorageService")
local React = require(ProfilePlatformParent.React)
local useSignalState = require(ProfilePlatformParent.SignalsReact).useSignalState
local GetInspectAvatarTooltipStore = require(ProfilePlatform.Stores.GetInspectAvatarTooltipStore)
local FFlagProfileInspectAndBuyRefactorTooltip = require(ProfilePlatform.Flags.FFlagProfileInspectAndBuyRefactorTooltip)
local v8 = game:DefineFastInt("ProfilePlatformInspectAvatarTooltipMaxImpressions", 3)
local v9 = GetInspectAvatarTooltipStore(false)

local function useInspectAvatarTooltip() -- line: 16
	-- upvalues: FFlagProfileInspectAndBuyRefactorTooltip (copy), useSignalState (copy), v9 (copy), React (copy), AppStorageService (copy), v8 (copy)
	if FFlagProfileInspectAndBuyRefactorTooltip then
		local v11 = useSignalState(v9.getIsOpen)

		React.useEffect(function() -- line: 20
			-- upvalues: v9 (copy)
			v9.tryShow()

			return function() -- line: 23
				-- upvalues: v9 (copy)
				v9.hide()
			end
		end, {})

		return {
			showTooltip = v11,
			onDismiss = v9.permanentlyDismiss
		}
	end

	local v12, v13 = React.useState(false)
	local v14 = React.useRef(false)

	React.useEffect(function() -- line: 37
		-- upvalues: v14 (copy), AppStorageService (copy), v8 (copy), v13 (copy)
		if v14.current then
			return
		end

		local ok, result = pcall(function() -- line: 42
			-- upvalues: AppStorageService (copy)
			return tonumber(AppStorageService:GetItem("ProfileInspectAndBuyImpressionCount")) or 0
		end)

		if not ok or result >= v8 then
			return
		end

		pcall(function() -- line: 48
			-- upvalues: AppStorageService (copy), result (copy)
			AppStorageService:SetItem("ProfileInspectAndBuyImpressionCount", (tostring(result + 1)))
			AppStorageService:Flush()
		end)
		v14.current = true
		v13(true)
	end, {})

	local v15 = React.useCallback(function() -- line: 57
		-- upvalues: AppStorageService (copy), v8 (copy), v13 (copy)
		pcall(function() -- line: 58
			-- upvalues: AppStorageService (copy), v8 (copy)
			AppStorageService:SetItem("ProfileInspectAndBuyImpressionCount", (tostring(v8)))
			AppStorageService:Flush()
		end)
		v13(false)
	end, {})

	return {
		showTooltip = v12,
		onDismiss = v15
	}
end

return useInspectAvatarTooltip
