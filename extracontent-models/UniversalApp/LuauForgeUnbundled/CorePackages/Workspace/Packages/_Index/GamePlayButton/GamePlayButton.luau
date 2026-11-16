require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonTypes")

require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/usePlayButtonState")

local fFlagEnablePlayWithRewardComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagEnablePlayWithRewardComponent

local v5 = {
	Flags = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/Flags"),
	FetchGamePlayButtonData = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/FetchGamePlayButtonData"),
	delayedAmpWizardCompletionCallbackOverride = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/delayedAmpWizardCompletionCallbackOverride"),
	LegacyPlayButtonContainer = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/LegacyPlayButtonContainer"),
	PlayButton = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButton"),
	PlusEarlyAccessUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlusEarlyAccessUpsellBanner"),
	useEarlyAccessCaption = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/EarlyAccess/useEarlyAccessCaption"),
	PlayButtonView = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonView"),
	PlayButtonReferralSource = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonReferralSource"),
	PlayButtonStates = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonStates"),
	PlayButtonUpsellDialog = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonUpsellDialog"),
	useOnPlayButtonCallback = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/useOnPlayButtonCallback"),
	useOnPlaySquadButtonCallback = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/useOnPlaySquadButtonCallback"),
	usePlayButtonState = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/usePlayButtonState"),
	usePlayButtonContextualMessage = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/usePlayButtonContextualMessage"),
	PlayButtonContextualMessageImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonContextualMessageImpressionsDetector"),
	usePlayButtonLaunchGame = 0,
	LaunchUnlessNotPlayable = 0
}

local v6 = if fFlagEnablePlayWithRewardComponent then require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/PlayButtonLaunchChecks/usePlayButtonLaunchGame") else nil
v5.usePlayButtonLaunchGame = v6

v5.LaunchUnlessNotPlayable = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/LaunchUnlessNotPlayable")
return v5
