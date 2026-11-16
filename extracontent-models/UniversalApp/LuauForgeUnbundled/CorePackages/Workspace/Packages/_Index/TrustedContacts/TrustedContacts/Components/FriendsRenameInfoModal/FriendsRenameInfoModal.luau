local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")

local PeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/PeekView")
local peekView = PeekView.PeekView
local peekViewState = PeekView.PeekViewState

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RoactUtils").Hooks.RoactRodux.useDispatch

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Foundation")
local view = Foundation.View
local text = Foundation.Text
local inputLabel = Foundation.InputLabel
local inputLabelSize = Foundation.Enums.InputLabelSize

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Responsive")
local usePreferredInput = Responsive.usePreferredInput

local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppHooks").useScreenSize
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/RobloxAppNavigation").NavigationCommands else nil

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/UniversalAppPolicy").useAppPolicy

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Analytics")
local useTCAnalytics = Analytics.useTCAnalytics
local eventNames = Analytics.EventNames

local defineFastFlag = game:DefineFastFlag("FriendsRenameModalUnboldText", false)

local function FriendsRenameInfoModal()
	local v5 = usePreferredInput()
	local v6 = useDispatch()
	local v7 = useScreenSize()
	local v8 = useNavigation()

	local fireAnalyticsEvent = useTCAnalytics().fireAnalyticsEvent

	React.useEffect(function()
		fireAnalyticsEvent(eventNames.FriendsRenameInfoModalSeen)
	end, {})

	local v9 = v5 ~= Responsive.Input.Touch

	local v10 = useLocalization({
		gotIt = "Feature.Avatar.Action.GotIt",
		learnMore = "Feature.Chat.Action.LearnMore",
		introducingConnections = "Feature.Friends.Label.IntroducingConnections",
		renameInfoText = "Feature.Friends.Label.RenameInfoText"
	})

	local v11 = React.useCallback(function()
		v8.pop()
	end, { v8 })

	local v12 = React.useCallback(function(p2, p3)
		if p2 == peekViewState.Closed or p2 == peekViewState.Hidden then
			v8.goBack()
		end
	end, { v8 })

	local v13 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local v14 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.FriendsRenameLearnMoreClicked)
		local v15 = {
			name = appPage.GenericWebPage,
			detail = "https://en.help.roblox.com/hc/en-us/articles/37725513985812",
			extraProps = { title = "" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v15))
		else
			v6(navigateDown(v15, nil))
		end
	end, { v6 })

	local introducingConnections = v10.introducingConnections
	local v15 = React.useMemo(function()
		return React.createElement(text, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 text-align-x-left text-wrap text-heading-small",
			Text = introducingConnections
		})
	end, { introducingConnections })

	local v16 = React.useCallback(function()
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v20 = if defineFastFlag then text else inputLabel
		local v21 = {
			LayoutOrder = 1,
			tag = defineFastFlag and "auto-y size-full-0 text-wrap grow text-align-x-left" or "auto-y size-full-0 text-wrap grow",
			RichText = true,
			size = 0,
			Text = 0
		}

		local v22 = if not defineFastFlag then inputLabelSize.Large else nil
		v21.size = v22
		v21.Text = v10.renameInfoText
		local v19 = { BodyText = createElement2(v20, v21), LearnMoreWebLink = 0 }

		local v23 = v13

		if v23 then
			local createElement3 = React.createElement
			local v24 = if defineFastFlag then text else inputLabel
			local v25 = {
				LayoutOrder = 2,
				tag = defineFastFlag and "auto-y size-full-0 text-align-x-left" or "auto-y size-full-0",
				RichText = true,
				Text = `<u>{v10.learnMore}</u>`,
				size = 0,
				onActivated = 0
			}
			local v26 = if not defineFastFlag then inputLabelSize.Large else nil
			v25.size = v26
			v25.onActivated = v14
			v23 = createElement3(v24, v25)
		end

		v19.LearnMoreWebLink = v23
		return createElement(view, {
			tag = "col size-full-0 auto-y gap-small padding-0",
			["align-x-left"] = not v9,
			["align-x-center"] = v9,
			LayoutOrder = 2
		}, v19)
	end, { v14, v10, v9 })

	if v9 then
		return React.createElement(interactiveAlert, {
			richText = true,
			screenSize = v7,
			title = introducingConnections,
			middleContent = v16,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = buttonType.Secondary,
						props = { onActivated = v11, text = v10.gotIt }
					}
				}
			}
		})
	end

	return React.createElement(peekView, {
		briefViewContentHeight = UDim.new(0, 0),
		hasScrim = true,
		mountAsFullView = true,
		returnToFullView = true,
		showDraggerInClosedState = false,
		thumbstickScrollEnabled = true,
		viewStateChanged = v12
	}, {
		Contents = React.createElement(
			view,
			{ tag = "col size-full-0 auto-y gap-small padding-xxlarge align-x-left" },
			{ Title = v15, TextContent = v16() }
		)
	})
end

return FriendsRenameInfoModal
