local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local useLocalization = require(AvatarExperienceCommonParent.Localization).Hooks.useLocalization
local useIsSpatial = require(AvatarExperienceCommonParent.Responsive).useIsSpatial
local useEarlyIsFocused = require(AvatarExperienceCommonParent.Navigation).useEarlyIsFocused
local SignalsReact = require(AvatarExperienceCommonParent.SignalsReact)
local AXTooltipStore = require(AvatarExperienceCommon.Stores.AXTooltipStore)
local v9 = game:DefineFastInt("AXTooltipTimeToDismiss", 5)

require(AvatarExperienceCommonParent.AvatarExperienceUIKit)

local function useAXTooltipViewModel(t1: {[any]: any}) -- line: 36
	-- upvalues: AXTooltipStore (copy), useLocalization (copy), useIsSpatial (copy), useEarlyIsFocused (copy), SignalsReact (copy), React (copy), v9 (copy)
	local v12 = AXTooltipStore(false)
	local v13 = useLocalization({
		tooltipText = t1.tooltipLocalizationKey
	})
	local v14 = t1.localizedText or v13.tooltipText
	local v15 = useIsSpatial()
	local v16 = useEarlyIsFocused()
	local v17 = SignalsReact.useSignalState(v12.getIsTooltipAllowedToBeShown(t1.tooltipStorageKey))
	local v18 = t1.showTooltip and (v17 and (v16 and not v15))
	local v19 = React.useCallback(function() -- line: 49
		-- upvalues: v12 (copy), t1 (copy)
		v12.dismissTooltip(t1.tooltipStorageKey)
	end, { t1.tooltipStorageKey })

	if t1.dismissTooltipRef and t1.showTooltip then
		t1.dismissTooltipRef.current = v19
	end

	React.useEffect(function() -- line: 57
		-- upvalues: v18 (copy), v9 (copy), v12 (copy), t1 (copy)
		if v18 then
			task.spawn(function() -- line: 59
				-- upvalues: v9 (copy), v12 (copy), t1 (copy)
				task.wait(v9)
				v12.dismissTooltip(t1.tooltipStorageKey, true)
			end)
		end
	end, { v18 })

	return {
		isOpen = v18,
		popoverSide = t1.popoverSide,
		tooltipText = v14,
		onTooltipActivated = v19
	}
end

return useAXTooltipViewModel
