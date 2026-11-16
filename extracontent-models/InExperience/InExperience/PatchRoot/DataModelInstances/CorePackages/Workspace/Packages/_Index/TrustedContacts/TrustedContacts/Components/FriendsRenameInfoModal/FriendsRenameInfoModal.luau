local parent = script:FindFirstAncestor("TrustedContacts").Parent

local React = require(parent.React)

local PeekView = require(parent.PeekView)
local peekView = PeekView.PeekView
local PeekViewState = PeekView.PeekViewState

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local InputLabel = Foundation.InputLabel
local InputLabelSize = Foundation.Enums.InputLabelSize

local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local Analytics = require(script.Parent.Parent.Parent.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames

local defineFastFlag = game:DefineFastFlag("FriendsRenameModalUnboldText", false)

local function FriendsRenameInfoModal()
	local v = usePreferredInput()
	local v2 = useDispatch()
	local screenSize = useScreenSize()
	local v3 = useNavigation()

	local fireAnalyticsEvent = useTCAnalytics().fireAnalyticsEvent

	React.useEffect(function()
		fireAnalyticsEvent(EventNames.FriendsRenameInfoModalSeen)
	end, {})

	local alignxcenter = v ~= Responsive.Input.Touch

	local v4 = useLocalization({
		gotIt = "Feature.Avatar.Action.GotIt",
		learnMore = "Feature.Chat.Action.LearnMore",
		introducingConnections = "Feature.Friends.Label.IntroducingConnections",
		renameInfoText = "Feature.Friends.Label.RenameInfoText"
	})

	local onActivated = React.useCallback(function()
		v3.pop()
	end, { v3 })

	local viewStateChanged = React.useCallback(function(p, _)
		if p == PeekViewState.Closed or p == PeekViewState.Hidden then
			v3.goBack()
		end
	end, { v3 })

	local v5 = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)

	local onActivated2 = React.useCallback(function()
		fireAnalyticsEvent(EventNames.FriendsRenameLearnMoreClicked)
		local v6 = {
			name = AppPage.GenericWebPage,
			detail = "https://en.help.roblox.com/hc/en-us/articles/37725513985812",
			extraProps = { title = "" }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			v2(NavigateDown(v6, nil))
		end
	end, { v2 })

	local introducingConnections = v4.introducingConnections
	local title = React.useMemo(function()
		return React.createElement(Text, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 text-align-x-left text-wrap text-heading-small",
			Text = introducingConnections
		})
	end, { introducingConnections })

	local middleContent = React.useCallback(function()
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v6 = if defineFastFlag then Text else InputLabel
		local v7 = {
			LayoutOrder = 1,
			tag = defineFastFlag and "auto-y size-full-0 text-wrap grow text-align-x-left" or "auto-y size-full-0 text-wrap grow",
			RichText = true,
			size = 0,
			Text = 0
		}
		local size

		if not defineFastFlag then
			size = InputLabelSize.Large
		end

		v7.size = size
		v7.Text = v4.renameInfoText
		local v8 = { BodyText = createElement2(v6, v7), LearnMoreWebLink = 0 }

		local learnMoreWebLink = v5

		if learnMoreWebLink then
			local createElement3 = React.createElement
			local v9 = if defineFastFlag then Text else InputLabel
			local v10 = {
				LayoutOrder = 2,
				tag = defineFastFlag and "auto-y size-full-0 text-align-x-left" or "auto-y size-full-0",
				RichText = true,
				Text = `<u>{v4.learnMore}</u>`,
				size = 0,
				onActivated = 0
			}
			local size2

			if not defineFastFlag then
				size2 = InputLabelSize.Large
			end

			v10.size = size2
			v10.onActivated = onActivated2
			learnMoreWebLink = createElement3(v9, v10)
		end

		v8.LearnMoreWebLink = learnMoreWebLink
		return createElement(View, {
			tag = "col size-full-0 auto-y gap-small padding-0",
			["align-x-left"] = not alignxcenter,
			["align-x-center"] = alignxcenter,
			LayoutOrder = 2
		}, v8)
	end, { onActivated2, v4, alignxcenter })

	if alignxcenter then
		return (React.createElement(InteractiveAlert, {
			richText = true,
			screenSize = screenSize,
			title = introducingConnections,
			middleContent = middleContent,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = { onActivated = onActivated, text = v4.gotIt }
					}
				}
			}
		}))
	end

	return (React.createElement(peekView, {
		briefViewContentHeight = UDim.new(0, 0),
		hasScrim = true,
		mountAsFullView = true,
		returnToFullView = true,
		showDraggerInClosedState = false,
		thumbstickScrollEnabled = true,
		viewStateChanged = viewStateChanged
	}, {
		Contents = React.createElement(
			View,
			{ tag = "col size-full-0 auto-y gap-small padding-xxlarge align-x-left" },
			{ Title = title, TextContent = middleContent() }
		)
	}))
end

return FriendsRenameInfoModal
