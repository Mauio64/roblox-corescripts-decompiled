local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local useLocalization = require(TrustedContactsParent.Localization).Hooks.useLocalization
local AmpUpsell = require(TrustedContactsParent.AmpUpsell)
local Foundation = require(TrustedContactsParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local Analytics = require(script.Parent.Parent.Parent.Analytics)
local useTCAnalytics = Analytics.useTCAnalytics
local EventNames = Analytics.EventNames
local Contexts = require(TrustedContactsParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local FStringConnectionGraphCoreAmpNameSpace = require(TrustedContactsParent.SharedFlags).FStringConnectionGraphCoreAmpNameSpace
local FFlagTCUpdateProfileCTAButton = require(TrustedContactsParent.SharedFlags).FFlagTCUpdateProfileCTAButton
local FFlagConnectionsToFriendsRename = require(TrustedContactsParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagEnableTrustedFriendsInlineVPCPrologue = require(TrustedContacts.Flags.FFlagEnableTrustedFriendsInlineVPCPrologue)

require(TrustedContacts.Common.Types)

local function TrustedFriendsVPCPrologue(t1: {[any]: any}) -- line: 36
	-- upvalues: useLocalization (copy), FFlagConnectionsToFriendsRename (copy), useTCAnalytics (copy), React (copy), EventNames (copy), FFlagTCUpdateProfileCTAButton (copy), Contexts (copy), FStringConnectionGraphCoreAmpNameSpace (copy), FFlagEnableTrustedFriendsInlineVPCPrologue (copy), AmpUpsell (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy)
	local v20 = useLocalization({
		cancel = "CommonUI.Controls.Action.Cancel",
		ask = "Feature.Friends.Label.Ask",
		askYourParent = "Feature.Friends.Label.AskYourParent",
		vpcRequired = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.AddConnectionVPC" or "Feature.Friends.Label.AddFriendVPC"
	})
	local fireAnalyticsEvent = useTCAnalytics({
		friendId = t1.userId
	}).fireAnalyticsEvent
	local v22 = React.useCallback(function() -- line: 50
		-- upvalues: t1 (copy)
		t1.externalNavigation.closeModal()
	end, { t1.externalNavigation })
	local v23 = React.useCallback(function() -- line: 54
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v22 (copy)
		fireAnalyticsEvent(EventNames.TrustedFriendsVPCCancelClicked)
		v22()
	end, {
		v22,
		fireAnalyticsEvent
	})
	local v24 = React.useCallback(function(_, _) -- line: 59
		-- upvalues: FFlagTCUpdateProfileCTAButton (copy), t1 (copy)
		if FFlagTCUpdateProfileCTAButton and t1.completionCallback then
			t1.completionCallback()
		end
	end, { if not FFlagTCUpdateProfileCTAButton then nil else t1.completionCallback })
	local v25 = React.useCallback(function() -- line: 68
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v22 (copy), t1 (copy), v24 (copy), Contexts (copy), FStringConnectionGraphCoreAmpNameSpace (copy)
		fireAnalyticsEvent(EventNames.TrustedFriendsVPCAskClicked)
		v22()
		t1.externalNavigation.openAmpWizard({
			featureName = "TriggerTrustedFriendVPCRecourse",
			completionCallback = v24,
			recourseData = {
				targetUserId = t1.userId
			},
			entryPointEventCtx = Contexts.TrustedFriendsVPCPrologue,
			extraParameters = {{
				name = "targetUser",
				type = "UserId",
				value = t1.userId
			}},
			nameSpace = FStringConnectionGraphCoreAmpNameSpace
		})
	end, {
		fireAnalyticsEvent,
		v22,
		t1.externalNavigation,
		t1.userId,
		v24
	})

	if FFlagEnableTrustedFriendsInlineVPCPrologue and (AmpUpsell.GetFFlagEnableAmpVPCPrologue() and AmpUpsell.GetFFlagEnableReusableVPCPrologue()) then
		return React.createElement(AmpUpsell.VPCPrologue, {
			onConfirm = v25,
			onCancel = v23,
			config = {
				titleText = v20.askYourParent,
				bodyText = v20.vpcRequired,
				confirmText = v20.ask,
				cancelText = v20.cancel
			}
		})
	end

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v20.askYourParent
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Text = React.createElement(Dialog.Text, {
				Text = v20.vpcRequired
			})
		}),
		Buttons = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v20.ask,
					variant = ButtonVariant.Emphasis,
					onActivated = v25
				},
				{
					text = v20.cancel,
					variant = ButtonVariant.Standard,
					onActivated = v23
				}
			}
		})
	})
end

return {
	Screen = function(t2: {[any]: any}) -- line: 135
		-- upvalues: React (copy), TrustedFriendsVPCPrologue (copy)
		return React.createElement(TrustedFriendsVPCPrologue, {
			userId = t2.navigation.getParam("userId"),
			completionCallback = t2.navigation.getParam("completionCallback"),
			externalNavigation = t2.screenProps.externalNavigation
		})
	end
}
