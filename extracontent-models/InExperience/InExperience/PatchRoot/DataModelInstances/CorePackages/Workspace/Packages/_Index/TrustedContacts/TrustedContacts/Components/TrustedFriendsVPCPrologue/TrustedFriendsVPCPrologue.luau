local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize

local Analytics = require(script.Parent.Parent.Parent.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local SharedFlags = require(parent.SharedFlags)
local FStringConnectionGraphCoreAmpNameSpace = SharedFlags.FStringConnectionGraphCoreAmpNameSpace

local SharedFlags2 = require(parent.SharedFlags)
local FFlagTCUpdateProfileCTAButton = SharedFlags2.FFlagTCUpdateProfileCTAButton

require(TrustedContacts.Common.Types)

local function TrustedFriendsVPCPrologue(props)
	local v = useLocalization({
		cancel = "CommonUI.Controls.Action.Cancel",
		ask = "Feature.Friends.Label.Ask",
		askYourParent = "Feature.Friends.Label.AskYourParent",
		vpcRequired = "Feature.Friends.Label.AddFriendVPC"
	})

	local fireAnalyticsEvent = useTCAnalytics({ friendId = props.userId }).fireAnalyticsEvent

	local v2 = React.useCallback(function()
		props.externalNavigation.closeModal()
	end, { props.externalNavigation })

	local onActivated = React.useCallback(function()
		fireAnalyticsEvent(EventNames.TrustedFriendsVPCCancelClicked)
		v2()
	end, { v2, fireAnalyticsEvent })

	local useCallback = React.useCallback
	local function fn(_, _)
		if FFlagTCUpdateProfileCTAButton and props.completionCallback then
			props.completionCallback()
		end
	end

	local v3

	if FFlagTCUpdateProfileCTAButton then
		v3 = props.completionCallback
	end

	local completionCallback = useCallback(fn, { v3 })

	local onActivated2 = React.useCallback(function()
		fireAnalyticsEvent(EventNames.TrustedFriendsVPCAskClicked)
		v2()

		props.externalNavigation.openAmpWizard({
			featureName = "TriggerTrustedFriendVPCRecourse",
			completionCallback = completionCallback,
			recourseData = { targetUserId = props.userId },
			entryPointEventCtx = Contexts.TrustedFriendsVPCPrologue,
			extraParameters = {
				{ name = "targetUser", type = "UserId", value = props.userId }
			},
			nameSpace = FStringConnectionGraphCoreAmpNameSpace
		})
	end, { fireAnalyticsEvent, v2, props.externalNavigation, props.userId, completionCallback })

	return React.createElement(Dialog.Root, { size = DialogSize.Small }, {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v.askYourParent }),
		Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			Text = React.createElement(Dialog.Text, { Text = v.vpcRequired })
		}),
		Buttons = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{ text = v.ask, variant = ButtonVariant.Emphasis, onActivated = onActivated2 },
				{ text = v.cancel, variant = ButtonVariant.Standard, onActivated = onActivated }
			}
		})
	})
end

return {
	Screen = function(p)
		return React.createElement(TrustedFriendsVPCPrologue, {
			userId = p.navigation.getParam("userId"),
			completionCallback = p.navigation.getParam("completionCallback"),
			externalNavigation = p.screenProps.externalNavigation
		})
	end
}
