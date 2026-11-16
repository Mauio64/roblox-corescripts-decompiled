local useFlyoutTradesEntryExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useFlyoutTradesEntryExposureLogging")
local useFlyoutProfileEntryExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useFlyoutProfileEntryExposureLogging")

local useCTAChangeMorePageFlyoutButtonTextExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useCTAChangeMorePageFlyoutButtonTextExposureLogging")
local useFlyoutTradesEntryImpressionLogging = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useFlyoutTradesEntryImpressionLogging")
local useFlyoutSidePanelExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Hooks/useFlyoutSidePanelExposureLogging")

local FFlagFlyoutTradesEntryExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutTradesEntryExposureLogging")
local FFlagFlyoutProfileEntryExposureLogging = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutProfileEntryExposureLogging")
local FFlagFlyoutTradesEntryImpressionLogging = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutTradesEntryImpressionLogging")
local FFlagFlyoutSidePanelIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutSidePanelIxpEnabled")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")
local fFlagEnableMeTabProfile = SharedFlags.FFlagEnableMeTabProfile
local fFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled = SharedFlags.FFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled

local function useFlyoutSidePanelLogging(p2)
	if FFlagFlyoutTradesEntryExposureLogging then
		useFlyoutTradesEntryExposureLogging()
	end

	if FFlagFlyoutProfileEntryExposureLogging and fFlagEnableMeTabProfile then
		useFlyoutProfileEntryExposureLogging()
	end

	if fFlagCTAChangeMorePageFlyoutButtonTextIxpEnabled then
		useCTAChangeMorePageFlyoutButtonTextExposureLogging()
	end

	if FFlagFlyoutTradesEntryImpressionLogging then
		useFlyoutTradesEntryImpressionLogging(p2)
	end

	if FFlagFlyoutSidePanelIxpEnabled then
		useFlyoutSidePanelExposureLogging()
	end
end

return useFlyoutSidePanelLogging
