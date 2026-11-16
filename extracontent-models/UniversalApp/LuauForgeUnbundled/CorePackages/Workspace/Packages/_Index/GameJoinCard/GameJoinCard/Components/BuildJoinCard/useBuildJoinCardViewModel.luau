local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppEnums")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SocialCommon")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RoactUtils").Hooks.RoactRodux.useDispatch
local goToBuild = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/BuildExperiencePlaytestLaunch/goToBuild")
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction
local appGuiService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RoactServiceTags").AppGuiService
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Navigation").useNavigation
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppHooks").useRoactService
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/UniversalAppPolicy").useAppPolicy
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagEnableSplitPane
local fFlagSocialCarouselBuildPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagSocialCarouselBuildPresence

local AnalyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants")
local useGameJoinCardAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics")

require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/TextKeys")
local ViewProfileLink = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/ViewProfileLink")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/BuildJoinCard/Types")

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local appPage = RobloxAppEnums.AppPage
local notificationType = RobloxAppEnums.NotificationType
local chatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local enteredChatFromEntryPoint = SocialCommon.Actions.EnteredChatFromEntryPoint

local udim = UDim.new(1, 0)
local gameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction

local function logBuildCardButton(p2, p3)
	local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent

	local v6 = if fFlagSocialCarouselBuildPresence then AnalyticsConstants.JoinCardType.Build else nil
	logGameJoinCardButtonEvent(p2, { friendId = p3, cardType = v6 })
end

local function renderViewProfileLink(p2, p3)
	return React.createElement(ViewProfileLink, {
		text = p2.text,
		onActivated = p2.onActivated,
		LayoutOrder = p3
	})
end

local function useBuildJoinCardViewModel(data)
	local userId = data.userId
	local v5 = useNavigation()
	local v6 = useRoactService(appGuiService)
	local v7 = if fFlagSocialCarouselBuildPresence then useDispatch() else nil
	local v8 = useAppPolicy(function(p2)
		return p2.getCanUsePlatformChat()
	end)

	local v9 = useLocalization({
		createInBuild = "Feature.Profile.Action.CreateInBuild",
		chat = TextKeys[userCtaAction.Chat],
		viewProfile = TextKeys[userCtaAction.ViewProfile]
	})

	local v10 = if fFlagEnableSplitPane then v5.push else v5.navigate
	local v11 = {
		id = userCtaAction.GoToBuild,
		text = v9.createInBuild,
		variant = buttonVariant.Emphasis,
		inputSize = inputSize.Medium,
		width = udim,
		keepOpenOnActivate = true,
		onActivated = function()
			local createInBuild = gameJoinCardButtonAction.CreateInBuild
			local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent

			local v14 = if fFlagSocialCarouselBuildPresence then AnalyticsConstants.JoinCardType.Build else nil
			logGameJoinCardButtonEvent(createInBuild, {
				friendId = userId,
				cardType = v14
			})

			data.onClose()
			goToBuild(false, v5)
		end
	}

	local v12 = {
		id = userCtaAction.Chat,
		text = v9.chat,
		variant = buttonVariant.Standard,
		inputSize = inputSize.Medium,
		width = udim,
		keepOpenOnActivate = data.keepsOpenOnNavigation,
		onActivated = function()
			local chat = gameJoinCardButtonAction.Chat
			local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent

			local v15 = if fFlagSocialCarouselBuildPresence then AnalyticsConstants.JoinCardType.Build else nil
			logGameJoinCardButtonEvent(chat, { friendId = userId, cardType = v15 })

			if fFlagSocialCarouselBuildPresence then
				v7(enteredChatFromEntryPoint(chatEntryPointNames.BuildJoinCard))
			end

			v6:BroadcastNotification(userId, notificationType.LAUNCH_CONVERSATION)
		end
	}

	local v13 = {
		id = userCtaAction.ViewProfile,
		text = v9.viewProfile,
		keepOpenOnActivate = data.keepsOpenOnNavigation,
		render = renderViewProfileLink,
		onActivated = function()
			local openProfileFromViewProfile = gameJoinCardButtonAction.OpenProfileFromViewProfile
			local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent

			local v16 = if fFlagSocialCarouselBuildPresence then AnalyticsConstants.JoinCardType.Build else nil
			logGameJoinCardButtonEvent(openProfileFromViewProfile, {
				friendId = userId,
				cardType = v16
			})

			v10(appPage.ProfilePlatform, { detail = userId })
		end
	}

	local v14 = { v11 }

	if v8 then
		table.insert(v14, v12)
	end

	table.insert(v14, v13)

	return { actions = v14 }
end

return useBuildJoinCardViewModel
