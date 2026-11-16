local parent = script:FindFirstAncestor("BuildExperience").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceInGameShell = SharedFlags.FFlagBuildExperienceInGameShell
local Display

if FFlagBuildExperienceInGameShell then
	Display = nil
else
	Display = require(parent.Display)
end

local Signals = require(parent.Signals)

local function createAssistantBuildStore()
	local getIsDisabled

	if FFlagBuildExperienceInGameShell then
		getIsDisabled = Signals.createSignal(false)
	else
		getIsDisabled = Signals.createComputed(function(p): boolean
			local displayStore = Display.GetDisplayStore(p)
			local displaySize = displayStore.getDisplaySize(p)
			local viewportSize = displayStore.getViewportSize(p)

			return displaySize == Enum.DisplaySize.Small and viewportSize.X > viewportSize.Y
		end)
	end

	local signal, setIsDisabledTooltipOpen = Signals.createSignal(false)
	local signal2, setIsOverlayVisible = Signals.createSignal(true)
	local function activate()
		if getIsDisabled(false) then
			setIsDisabledTooltipOpen(not signal(false))
			return
		end

		setIsDisabledTooltipOpen(false)
		setIsOverlayVisible(not signal2(false))
	end

	return {
		getIsDisabled = getIsDisabled,
		getIsDisabledTooltipOpen = signal,
		getIsOverlayVisible = signal2,
		activate = activate,
		setIsDisabledTooltipOpen = setIsDisabledTooltipOpen,
		setIsOverlayVisible = setIsOverlayVisible
	}
end

return createAssistantBuildStore
