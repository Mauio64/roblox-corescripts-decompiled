local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local React = require(Parent.React)
local PeekView = require(Parent.PeekView)
local PeekView2 = PeekView.PeekView
local PeekViewState = PeekView.PeekViewState
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local UIBlox = require(Parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local InputLabel = Foundation.InputLabel
local InputLabelSize = Foundation.Enums.InputLabelSize
local Responsive = require(Parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useScreenSize = require(Parent.RobloxAppHooks).useScreenSize
local useNavigation = require(Parent.Navigation).useNavigation
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v23 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local Analytics = require(script.Parent.Parent.Parent.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames
local v28 = game:DefineFastFlag("FriendsRenameModalUnboldText", false)

local function FriendsRenameInfoModal() -- line: 48
	-- upvalues: usePreferredInput (copy), useDispatch (copy), useScreenSize (copy), useNavigation (copy), useTCAnalytics (copy), React (copy), EventNames (copy), Responsive (copy), useLocalization (copy), PeekViewState (copy), useAppPolicy (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), NavigateDown (copy), FoundationText (copy), View (copy), v28 (copy), InputLabel (copy), InputLabelSize (copy), InteractiveAlert (copy), ButtonType (copy), PeekView2 (copy)
	local v30 = usePreferredInput()
	local v31 = useDispatch()
	local v32 = useScreenSize()
	local v33 = useNavigation()
	local fireAnalyticsEvent = useTCAnalytics().fireAnalyticsEvent

	React.useEffect(function() -- line: 56
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy)
		fireAnalyticsEvent(EventNames.FriendsRenameInfoModalSeen)
	end, {})

	local v35 = v30 ~= Responsive.Input.Touch
	local v36 = useLocalization({
		gotIt = "Feature.Avatar.Action.GotIt",
		learnMore = "Feature.Chat.Action.LearnMore",
		introducingConnections = "Feature.Friends.Label.IntroducingConnections",
		renameInfoText = "Feature.Friends.Label.RenameInfoText"
	})
	local v37 = React.useCallback(function() -- line: 70
		-- upvalues: v33 (copy)
		v33.pop()
	end, { v33 })
	local v38 = React.useCallback(function(p1, _) -- line: 74
		-- upvalues: PeekViewState (copy), v33 (copy)
		if p1 == PeekViewState.Closed or p1 == PeekViewState.Hidden then
			v33.goBack()
		end
	end, { v33 })
	local v39 = useAppPolicy(function(p3) -- line: 80
		return p3.getWebViewSupport()
	end)
	local v40 = React.useCallback(function() -- line: 84
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v23 (copy), v31 (copy), NavigateDown (copy)
		fireAnalyticsEvent(EventNames.FriendsRenameLearnMoreClicked)

		local t1 = {
			detail = "https://en.help.roblox.com/hc/en-us/articles/37725513985812",
			name = AppPage.GenericWebPage,
			extraProps = {
				title = ""
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v23.down(v23.fromLegacyPage(t1))

			return
		end

		v31(NavigateDown(t1, nil))
	end, { v31 })
	local introducingConnections = v36.introducingConnections
	local v42 = React.useMemo(function() -- line: 101
		-- upvalues: React (copy), FoundationText (copy), introducingConnections (copy)
		return React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 text-align-x-left text-wrap text-heading-small",
			Text = introducingConnections
		})
	end, { introducingConnections })
	local v43 = React.useCallback(function() -- line: 109
		-- upvalues: React (copy), View (copy), v35 (copy), v28 (copy), FoundationText (copy), InputLabel (copy), InputLabelSize (copy), v36 (copy), v39 (copy), v40 (copy)
		return React.createElement(View, {
			tag = "col size-full-0 auto-y gap-small padding-0",
			["align-x-left"] = not v35,
			["align-x-center"] = v35,
			LayoutOrder = 2
		}, {
			BodyText = React.createElement(if not v28 then InputLabel else FoundationText, {
				LayoutOrder = 1,
				RichText = true,
				tag = not v28 and "auto-y size-full-0 text-wrap grow" or "auto-y size-full-0 text-wrap grow text-align-x-left",
				size = if not v28 then InputLabelSize.Large else nil,
				Text = v36.renameInfoText
			}),
			LearnMoreWebLink = v39 and React.createElement(if not v28 then InputLabel else FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				tag = not v28 and "auto-y size-full-0" or "auto-y size-full-0 text-align-x-left",
				Text = `<u>{ v36.learnMore }</u>`,
				size = if not v28 then InputLabelSize.Large else nil,
				onActivated = v40
			})
		})
	end, {
		v40,
		v36,
		v35
	})

	if v35 then
		return (React.createElement(InteractiveAlert, {
			richText = true,
			screenSize = v32,
			title = introducingConnections,
			middleContent = v43,
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = v37,
						text = v36.gotIt
					}
				}}
			}
		}))
	end

	return (React.createElement(PeekView2, {
		hasScrim = true,
		mountAsFullView = true,
		returnToFullView = true,
		showDraggerInClosedState = false,
		thumbstickScrollEnabled = true,
		briefViewContentHeight = UDim.new(0, 0),
		viewStateChanged = v38
	}, {
		Contents = React.createElement(View, {
			tag = "col size-full-0 auto-y gap-small padding-xxlarge align-x-left"
		}, {
			Title = v42,
			TextContent = v43()
		})
	}))
end

return FriendsRenameInfoModal
