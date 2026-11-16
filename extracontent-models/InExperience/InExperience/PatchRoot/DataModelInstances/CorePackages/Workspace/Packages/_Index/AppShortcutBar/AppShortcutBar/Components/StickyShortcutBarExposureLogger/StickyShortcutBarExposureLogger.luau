local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")

local useIsStickyShortcutBarEnabled = require(AppShortcutBar.Hooks.useIsStickyShortcutBarEnabled)
local useStickyShortcutBarExposureLogging = require(AppShortcutBar.Hooks.useStickyShortcutBarExposureLogging)

local function StickyShortcutBarExposureLogger(p): nil
	useStickyShortcutBarExposureLogging((useIsStickyShortcutBarEnabled(p.currentPage)))

	return nil
end

return StickyShortcutBarExposureLogger
