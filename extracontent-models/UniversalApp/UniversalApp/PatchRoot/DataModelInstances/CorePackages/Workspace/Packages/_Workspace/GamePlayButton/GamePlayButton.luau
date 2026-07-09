require(script.PlayButtonTypes)
require(script.usePlayButtonState)

local FFlagEnablePlayWithRewardComponent = require(script.Parent.SharedFlags).FFlagEnablePlayWithRewardComponent

return {
	Flags = require(script.Flags),
	FetchGamePlayButtonData = require(script.FetchGamePlayButtonData),
	delayedAmpWizardCompletionCallbackOverride = require(script.PlayButtonLaunchChecks.delayedAmpWizardCompletionCallbackOverride),
	PlayButton = require(script.PlayButton),
	PlayButtonReferralSource = require(script.PlayButtonReferralSource),
	PlayButtonStates = require(script.PlayButtonStates),
	PlayButtonUpsellDialog = require(script.PlayButtonUpsellDialog),
	useOnPlayButtonCallback = require(script.useOnPlayButtonCallback),
	useOnPlaySquadButtonCallback = require(script.useOnPlaySquadButtonCallback),
	usePlayButtonState = require(script.usePlayButtonState),
	usePlayButtonContextualMessage = require(script.usePlayButtonContextualMessage),
	PlayButtonContextualMessageImpressionsDetector = require(script.PlayButtonContextualMessageImpressionsDetector),
	usePlayButtonLaunchGame = if not FFlagEnablePlayWithRewardComponent then nil else require(script.PlayButtonLaunchChecks.usePlayButtonLaunchGame),
	["jest.config"] = script["jest.config"]
}
