local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local SocialCommon = require(parent.SocialCommon)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local goToBuild = require(parent.BuildExperiencePlaytestLaunch.goToBuild)
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction
local RoactServiceTags = require(parent.RoactServiceTags)
local AppGuiService = RoactServiceTags.AppGuiService
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSocialCarouselBuildPresence = SharedFlags2.FFlagSocialCarouselBuildPresence

local AnalyticsConstants = require(GameJoinCard.Analytics.AnalyticsConstants)
local useGameJoinCardAnalytics = require(GameJoinCard.Analytics.useGameJoinCardAnalytics)

require(GameJoinCard.Components.Actions.Types)
local TextKeys = require(GameJoinCard.Components.Actions.TextKeys)
local ViewProfileLink = require(GameJoinCard.Components.Actions.ViewProfileLink)
require(script.Parent.Types)

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local AppPage = RobloxAppEnums.AppPage
local NotificationType = RobloxAppEnums.NotificationType
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local EnteredChatFromEntryPoint = SocialCommon.Actions.EnteredChatFromEntryPoint

local udim = UDim.new(1, 0)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction

local function logBuildCardButton(p: number, userId: string) -- 3 equivalent calls inferred from this helper
	local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent
	local cardType

	if FFlagSocialCarouselBuildPresence then
		cardType = AnalyticsConstants.JoinCardType.Build
	end

	logGameJoinCardButtonEvent(p, { friendId = userId, cardType = cardType })
end

local function renderViewProfileLink(p, layoutOrder: number)
	return React.createElement(ViewProfileLink, {
		text = p.text,
		onActivated = p.onActivated,
		LayoutOrder = layoutOrder
	})
end

local function useBuildJoinCardViewModel(data)
	local userId = data.userId
	local v = useNavigation()
	local v2 = useRoactService(AppGuiService)
	local v3

	if FFlagSocialCarouselBuildPresence then
		v3 = useDispatch()
	else
		v3 = nil
	end

	local v4 = useAppPolicy(function(p)
		return p.getCanUsePlatformChat()
	end)

	local v5 = useLocalization({
		createInBuild = "Feature.Profile.Action.CreateInBuild",
		chat = TextKeys[UserCtaAction.Chat],
		viewProfile = TextKeys[UserCtaAction.ViewProfile]
	})
	local v6

	if FFlagEnableSplitPane then
		v6 = v.push
	else
		v6 = v.navigate
	end

	local v7 = {
		id = UserCtaAction.GoToBuild,
		text = v5.createInBuild,
		variant = ButtonVariant.Emphasis,
		inputSize = InputSize.Medium,
		width = udim,
		keepOpenOnActivate = true,
		onActivated = function()
			logBuildCardButton(GameJoinCardButtonAction.CreateInBuild, userId) -- inferred equivalent call
			data.onClose()
			goToBuild(false, v)
		end
	}

	local v8 = {
		id = UserCtaAction.Chat,
		text = v5.chat,
		variant = ButtonVariant.Standard,
		inputSize = InputSize.Medium,
		width = udim,
		keepOpenOnActivate = data.keepsOpenOnNavigation,
		onActivated = function()
			logBuildCardButton(GameJoinCardButtonAction.Chat, userId) -- inferred equivalent call

			if FFlagSocialCarouselBuildPresence then
				v3(EnteredChatFromEntryPoint(ChatEntryPointNames.BuildJoinCard))
			end

			v2:BroadcastNotification(userId, NotificationType.LAUNCH_CONVERSATION)
		end
	}

	local v9 = {
		id = UserCtaAction.ViewProfile,
		text = v5.viewProfile,
		keepOpenOnActivate = data.keepsOpenOnNavigation,
		render = renderViewProfileLink,
		onActivated = function()
			logBuildCardButton(GameJoinCardButtonAction.OpenProfileFromViewProfile, userId) -- inferred equivalent call
			v6(AppPage.ProfilePlatform, { detail = userId })
		end
	}

	local actions = { v7 }

	if v4 then
		table.insert(actions, v8)
	end

	table.insert(actions, v9)

	return { actions = actions }
end

return useBuildJoinCardViewModel
