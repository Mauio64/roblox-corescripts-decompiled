local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local AppStorageService = game:GetService("AppStorageService")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local ProfileActionBar = require(ProfilePlatform.Components.ProfileActionBar.ProfileActionBar)
local GetFIntProfilePlatformCurrencyTransferTooltipMaxImpressions = require(ProfilePlatform.Flags.GetFIntProfilePlatformCurrencyTransferTooltipMaxImpressions)

require(ProfilePlatform.Types.UpsellTooltipProps)

local function ProfileActionBarWithTransferTooltip(t1: {[any]: any}) -- line: 26
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), GetFIntProfilePlatformCurrencyTransferTooltipMaxImpressions (copy), AppStorageService (copy), ProfileActionBar (copy)
	local v11 = useLocalization({
		plusMoreMenuTooltipBody = TextKeys.CurrencyTransferTooltipBody
	})
	local v12, v13 = React.useState(false)
	local v14 = React.useRef(false)
	local EngineFeature = game:GetEngineFeature("CurrencyTransferProfileActionTooltipStorageKey")

	React.useEffect(function() -- line: 34
		-- upvalues: v14 (copy), EngineFeature (copy), GetFIntProfilePlatformCurrencyTransferTooltipMaxImpressions (copy), AppStorageService (copy), v13 (copy)
		if v14.current then
			return
		end

		if EngineFeature then
			local v19 = GetFIntProfilePlatformCurrencyTransferTooltipMaxImpressions()
			local v20 = tonumber(AppStorageService:GetItem("CurrencyTransferProfileActionTooltipImpressionsCount")) or 0

			if v19 <= v20 then
				return
			end

			AppStorageService:SetItem("CurrencyTransferProfileActionTooltipImpressionsCount", (tostring(v20 + 1)))
			AppStorageService:Flush()
		end

		v14.current = true
		v13(true)
	end, { EngineFeature })

	local v16 = React.useCallback(function() -- line: 54
		-- upvalues: EngineFeature (copy), GetFIntProfilePlatformCurrencyTransferTooltipMaxImpressions (copy), AppStorageService (copy), v13 (copy)
		if EngineFeature then
			local v21 = GetFIntProfilePlatformCurrencyTransferTooltipMaxImpressions()

			AppStorageService:SetItem("CurrencyTransferProfileActionTooltipImpressionsCount", (tostring(v21)))
			AppStorageService:Flush()
		end

		v13(false)
	end, { EngineFeature })
	local v17 = React.useCallback(function() -- line: 64
		-- upvalues: v13 (copy)
		v13(false)
	end, {})
	local v18 = React.useMemo(function() -- line: 69
		-- upvalues: v11 (copy), v16 (copy), v17 (copy)
		return {
			plusMoreMenuTooltipTitle = nil,
			plusMoreMenuTooltipBody = v11.plusMoreMenuTooltipBody,
			onPlusMoreMenuTooltipClose = v16,
			onPlusMoreMenuTooltipDismiss = v17
		}
	end, {
		v11.plusMoreMenuTooltipBody,
		v16,
		v17
	})

	return React.createElement(ProfileActionBar, {
		isContextualMenuOpen = t1.isContextualMenuOpen,
		layoutOrder = t1.layoutOrder,
		openContextualMenu = t1.openContextualMenu,
		profileActions = t1.profileActions,
		primaryButtonRef = t1.primaryButtonRef,
		moreButtonRef = t1.moreButtonRef,
		showPlusMoreMenuTooltip = v12,
		upsellTooltipProps = if not v12 then nil else v18
	})
end

return ProfileActionBarWithTransferTooltip
