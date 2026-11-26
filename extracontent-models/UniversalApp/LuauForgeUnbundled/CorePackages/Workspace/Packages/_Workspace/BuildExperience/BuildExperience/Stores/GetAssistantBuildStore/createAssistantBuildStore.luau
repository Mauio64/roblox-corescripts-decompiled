local fFlagBuildExperienceInGameShell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceInGameShell
local v5 = if not fFlagBuildExperienceInGameShell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Display") else nil
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local function createAssistantBuildStore()
	local v6

	if fFlagBuildExperienceInGameShell then
		v6 = Signals.createSignal(false)
	else
		v6 = Signals.createComputed(function(p2): boolean
			local displayStore = v5.GetDisplayStore(p2)
			local displaySize = displayStore.getDisplaySize(p2)
			local viewportSize = displayStore.getViewportSize(p2)

			return displaySize == Enum.DisplaySize.Small and viewportSize.X > viewportSize.Y
		end)
	end

	local signal, v7 = Signals.createSignal(false)
	local signal2, v8 = Signals.createSignal(true)
	local function activate()
		if v6(false) then
			v7(not signal(false))
			return
		end

		v7(false)
		v8(not signal2(false))
	end

	return {
		getIsDisabled = v6,
		getIsDisabledTooltipOpen = signal,
		getIsOverlayVisible = signal2,
		activate = activate,
		setIsDisabledTooltipOpen = v7,
		setIsOverlayVisible = v8
	}
end

return createAssistantBuildStore
