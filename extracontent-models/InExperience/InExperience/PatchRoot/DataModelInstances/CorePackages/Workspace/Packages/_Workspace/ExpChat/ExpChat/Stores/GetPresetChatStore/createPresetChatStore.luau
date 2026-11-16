local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

return function()
	local signal, setIsEnabled = createSignal(false)
	local signal2, setIsLoading = createSignal(true)
	local signal3, setIsTrayOpen = createSignal(false)
	local signal4, setCategoryGroups = createSignal({})
	local signal5, setSelectedGroupIndex = createSignal(1)
	local signal6, setVersion = createSignal("")
	local signal7, setAccessLevel = createSignal("Disabled")
	local signal8, setLayoutModeOverride = createSignal(nil)
	local signal9, setPresetCooldownEndsAt = createSignal(nil)
	local signal10, setChatWindowBottomY = createSignal(0)
	local signal11, setPresetClickCounts = createSignal({})
	local signal12, setViewedGroupIds = createSignal({})

	return {
		getIsEnabled = signal,
		getIsLoading = signal2,
		getIsTrayOpen = signal3,
		getCategoryGroups = signal4,
		getSelectedGroupIndex = signal5,
		getVersion = signal6,
		getAccessLevel = signal7,
		getLayoutModeOverride = signal8,
		getPresetCooldownEndsAt = signal9,
		getChatWindowBottomY = signal10,
		getPresetClickCounts = signal11,
		getViewedGroupIds = signal12,
		setIsEnabled = setIsEnabled,
		setIsLoading = setIsLoading,
		setIsTrayOpen = setIsTrayOpen,
		setCategoryGroups = setCategoryGroups,
		setSelectedGroupIndex = setSelectedGroupIndex,
		setVersion = setVersion,
		setAccessLevel = setAccessLevel,
		setLayoutModeOverride = setLayoutModeOverride,
		setPresetCooldownEndsAt = setPresetCooldownEndsAt,
		setChatWindowBottomY = setChatWindowBottomY,
		setPresetClickCounts = setPresetClickCounts,
		incrementPresetClickCount = function(p: string)
			local clone = table.clone(signal11(false))
			clone[p] = not clone[p] and 1 or clone[p] + 1
			setPresetClickCounts(clone)
		end,
		setViewedGroupIds = setViewedGroupIds,
		markGroupViewed = function(p: string)
			if signal12(false)[p] then
				return
			end

			local clone = table.clone(signal12(false))
			clone[p] = true
			setViewedGroupIds(clone)
		end
	}
end
