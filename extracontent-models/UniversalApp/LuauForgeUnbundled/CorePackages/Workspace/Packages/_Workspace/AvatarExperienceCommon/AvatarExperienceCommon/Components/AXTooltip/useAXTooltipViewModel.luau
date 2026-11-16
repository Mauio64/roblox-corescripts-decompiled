local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Localization").Hooks.useLocalization
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Responsive").useIsSpatial
local useEarlyIsFocused = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Navigation").useEarlyIsFocused
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SignalsReact")
local AXTooltipStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Stores/AXTooltipStore")

local defineFastInt = game:DefineFastInt("AXTooltipTimeToDismiss", 5)

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceUIKit")

local function useAXTooltipViewModel(data)
	local v5 = AXTooltipStore(false)

	local v6 = useLocalization({ tooltipText = data.tooltipLocalizationKey })
	local localizedText = data.localizedText or v6.tooltipText

	local v7 = useIsSpatial()
	local v8 = useEarlyIsFocused()

	local v9 = SignalsReact.useSignalState(v5.getIsTooltipAllowedToBeShown(data.tooltipStorageKey))

	local v10 = data.showTooltip and v9 and v8 and not v7

	local v11 = React.useCallback(function()
		v5.dismissTooltip(data.tooltipStorageKey)
	end, { data.tooltipStorageKey })

	if data.dismissTooltipRef and data.showTooltip then
		data.dismissTooltipRef.current = v11
	end

	React.useEffect(function()
		if v10 then
			task.spawn(function()
				task.wait(defineFastInt)
				v5.dismissTooltip(data.tooltipStorageKey, true)
			end)
		end
	end, { v10 })

	return {
		isOpen = v10,
		popoverSide = data.popoverSide,
		tooltipText = localizedText,
		onTooltipActivated = v11
	}
end

return useAXTooltipViewModel
