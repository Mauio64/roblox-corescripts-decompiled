local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Responsive = require(parent.Responsive)
local useIsSpatial = Responsive.useIsSpatial
local Navigation = require(parent.Navigation)
local useEarlyIsFocused = Navigation.useEarlyIsFocused
local SignalsReact = require(parent.SignalsReact)
local AXTooltipStore = require(AvatarExperienceCommon.Stores.AXTooltipStore)

local defineFastInt = game:DefineFastInt("AXTooltipTimeToDismiss", 5)

require(parent.AvatarExperienceUIKit)

local function useAXTooltipViewModel(data)
	local aXTooltipStore = AXTooltipStore(false)

	local v = useLocalization({ tooltipText = data.tooltipLocalizationKey })
	local localizedText = data.localizedText or v.tooltipText

	local v2 = useIsSpatial()
	local v3 = useEarlyIsFocused()

	local v4 = SignalsReact.useSignalState(aXTooltipStore.getIsTooltipAllowedToBeShown(data.tooltipStorageKey))

	local isOpen = data.showTooltip and v4 and v3 and not v2

	local v5 = React.useCallback(function()
		aXTooltipStore.dismissTooltip(data.tooltipStorageKey)
	end, { data.tooltipStorageKey })

	if data.dismissTooltipRef and data.showTooltip then
		data.dismissTooltipRef.current = v5
	end

	React.useEffect(function()
		if isOpen then
			task.spawn(function()
				task.wait(defineFastInt)
				aXTooltipStore.dismissTooltip(data.tooltipStorageKey, true)
			end)
		end
	end, { isOpen })

	return {
		isOpen = isOpen,
		popoverSide = data.popoverSide,
		tooltipText = localizedText,
		onTooltipActivated = v5
	}
end

return useAXTooltipViewModel
