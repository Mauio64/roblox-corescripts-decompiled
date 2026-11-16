require(script.PlayButtonTypes)

require(script.usePlayButtonState)

local SharedFlags = require(script.Parent.SharedFlags)
local FFlagEnablePlayWithRewardComponent = SharedFlags.FFlagEnablePlayWithRewardComponent

local GamePlayButton = {}
GamePlayButton.Flags = require(script.Flags)
GamePlayButton.FetchGamePlayButtonData = require(script.FetchGamePlayButtonData)
GamePlayButton.delayedAmpWizardCompletionCallbackOverride = require(script.PlayButtonLaunchChecks.delayedAmpWizardCompletionCallbackOverride)

GamePlayButton.LegacyPlayButtonContainer = require(script.LegacyPlayButtonContainer)
GamePlayButton.PlayButton = require(script.PlayButton)
GamePlayButton.PlusEarlyAccessUpsellBanner = require(script.PlusEarlyAccessUpsellBanner)
GamePlayButton.useEarlyAccessCaption = require(script.EarlyAccess.useEarlyAccessCaption)
GamePlayButton.PlayButtonView = require(script.PlayButtonView)
GamePlayButton.PlayButtonReferralSource = require(script.PlayButtonReferralSource)
GamePlayButton.PlayButtonStates = require(script.PlayButtonStates)
GamePlayButton.PlayButtonUpsellDialog = require(script.PlayButtonUpsellDialog)
GamePlayButton.useOnPlayButtonCallback = require(script.useOnPlayButtonCallback)
GamePlayButton.useOnPlaySquadButtonCallback = require(script.useOnPlaySquadButtonCallback)
GamePlayButton.usePlayButtonState = require(script.usePlayButtonState)
GamePlayButton.usePlayButtonContextualMessage = require(script.usePlayButtonContextualMessage)
GamePlayButton.PlayButtonContextualMessageImpressionsDetector = require(script.PlayButtonContextualMessageImpressionsDetector)
local usePlayButtonLaunchGame

if FFlagEnablePlayWithRewardComponent then
	usePlayButtonLaunchGame = require(script.PlayButtonLaunchChecks.usePlayButtonLaunchGame)
end

GamePlayButton.usePlayButtonLaunchGame = usePlayButtonLaunchGame

GamePlayButton.LaunchUnlessNotPlayable = require(script.LaunchUnlessNotPlayable)
GamePlayButton["jest.config"] = script["jest.config"]
return GamePlayButton
