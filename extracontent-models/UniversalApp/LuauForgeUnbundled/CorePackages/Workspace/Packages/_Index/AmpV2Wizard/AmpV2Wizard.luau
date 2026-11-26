local module = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardSharedLauncher")

local v5 = {
	useAmpUpsell = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/useAmpUpsell"),
	useAmpUpsellLauncher = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/useAmpUpsellLauncher"),
	launchAmpUpsell = 0,
	FFlagAmpV2WizardSharedLauncher = 0,
	FFlagAmpWizardV2VpcHandoff = 0,
	FFlagAmpV2WizardTerminalOutcome = 0,
	getOdpCheckpointDeepLinkRoute = 0,
	openOdpFlowHandoff = 0,
	getAmpV2WizardRoutes = 0,
	getParentModeChromeThemeStore = 0,
	Types = 0
}
local v6 = if module then require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/launchAmpUpsell") else nil
v5.launchAmpUpsell = v6
v5.FFlagAmpV2WizardSharedLauncher = module

v5.FFlagAmpWizardV2VpcHandoff = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpWizardV2VpcHandoff")
v5.FFlagAmpV2WizardTerminalOutcome = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/FFlagAmpV2WizardTerminalOutcome")
v5.getOdpCheckpointDeepLinkRoute = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/getOdpCheckpointDeepLinkRoute")
v5.openOdpFlowHandoff = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/openOdpFlowHandoff")

v5.getAmpV2WizardRoutes = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/getAmpV2WizardRoutes")
v5.getParentModeChromeThemeStore = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/getParentModeChromeThemeStore")

v5.Types = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
return v5
