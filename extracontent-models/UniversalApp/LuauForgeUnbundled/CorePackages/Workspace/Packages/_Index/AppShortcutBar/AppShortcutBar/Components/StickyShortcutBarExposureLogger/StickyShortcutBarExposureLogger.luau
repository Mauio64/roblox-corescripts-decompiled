local useIsStickyShortcutBarEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks/useIsStickyShortcutBarEnabled")
local useStickyShortcutBarExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks/useStickyShortcutBarExposureLogging")

local function StickyShortcutBarExposureLogger(p2): nil
	useStickyShortcutBarExposureLogging((useIsStickyShortcutBarEnabled(p2.currentPage)))

	return nil
end

return StickyShortcutBarExposureLogger
