local script2 = script
local FFlagAmpV2WizardSharedLauncher = require(script2.FFlagAmpV2WizardSharedLauncher)

local AmpV2Wizard = {}
AmpV2Wizard.useAmpUpsell = require(script2.useAmpUpsell)
AmpV2Wizard.useAmpUpsellLauncher = require(script2.useAmpUpsellLauncher)
local launchAmpUpsell

if FFlagAmpV2WizardSharedLauncher then
	launchAmpUpsell = require(script2.launchAmpUpsell)
end

AmpV2Wizard.launchAmpUpsell = launchAmpUpsell
AmpV2Wizard.FFlagAmpV2WizardSharedLauncher = FFlagAmpV2WizardSharedLauncher

AmpV2Wizard.FFlagAmpWizardV2VpcHandoff = require(script2.FFlagAmpWizardV2VpcHandoff)
AmpV2Wizard.FFlagAmpV2WizardTerminalOutcome = require(script2.FFlagAmpV2WizardTerminalOutcome)
AmpV2Wizard.getOdpCheckpointDeepLinkRoute = require(script2.getOdpCheckpointDeepLinkRoute)
AmpV2Wizard.openOdpFlowHandoff = require(script2.openOdpFlowHandoff)

AmpV2Wizard.getAmpV2WizardRoutes = require(script2.getAmpV2WizardRoutes)
AmpV2Wizard.getParentModeChromeThemeStore = require(script2.getParentModeChromeThemeStore)

AmpV2Wizard.Types = require(script2.Types)

AmpV2Wizard["jest.config"] = script["jest.config"]
return AmpV2Wizard
