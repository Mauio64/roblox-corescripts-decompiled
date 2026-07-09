local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local useLocalization = require(TrustedContactsParent.Localization).Hooks.useLocalization
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

require(TrustedContacts.Common.Types)

local function TrustedFriendsVPCPrologue(t1: {[any]: any}) -- line: 33
	-- upvalues: useLocalization (copy), FFlagConnectionsToFriendsRename (copy), useTCAnalytics (copy), React (copy), EventNames (copy), FFlagTCUpdateProfileCTAButton (copy), Contexts (copy), FStringConnectionGraphCoreAmpNameSpace (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy)
	local v18 = useLocalization({
		cancel = "CommonUI.Controls.Action.Cancel",
		ask = "Feature.Friends.Label.Ask",
		askYourParent = "Feature.Friends.Label.AskYourParent",
		vpcRequired = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.AddConnectionVPC" or "Feature.Friends.Label.AddFriendVPC"
	})
	local fireAnalyticsEvent = useTCAnalytics({
		friendId = t1.userId
	}).fireAnalyticsEvent
	local v20 = React.useCallback(function() -- line: 47
		-- upvalues: t1 (copy)
		t1.externalNavigation.closeModal()
	end, { t1.externalNavigation })
	local v21 = React.useCallback(function() -- line: 51
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v20 (copy)
		fireAnalyticsEvent(EventNames.TrustedFriendsVPCCancelClicked)
		v20()
	end, {
		v20,
		fireAnalyticsEvent
	})
	local v22 = React.useCallback(function(_, _) -- line: 56
		-- upvalues: FFlagTCUpdateProfileCTAButton (copy), t1 (copy)
		if FFlagTCUpdateProfileCTAButton and t1.completionCallback then
			t1.completionCallback()
		end
	end, { if not FFlagTCUpdateProfileCTAButton then nil else t1.completionCallback })
	local v23 = React.useCallback(function() -- line: 65
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v20 (copy), t1 (copy), v22 (copy), Contexts (copy), FStringConnectionGraphCoreAmpNameSpace (copy)
		fireAnalyticsEvent(EventNames.TrustedFriendsVPCAskClicked)
		v20()
		t1.externalNavigation.openAmpWizard({
			featureName = "TriggerTrustedFriendVPCRecourse",
			completionCallback = v22,
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
		v20,
		t1.externalNavigation,
		t1.userId,
		v22
	})

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v18.askYourParent
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Text = React.createElement(Dialog.Text, {
				Text = v18.vpcRequired
			})
		}),
		Buttons = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v18.ask,
					variant = ButtonVariant.Emphasis,
					onActivated = v23
				},
				{
					text = v18.cancel,
					variant = ButtonVariant.Standard,
					onActivated = v21
				}
			}
		})
	})
end

return {
	Screen = function(t2: {[any]: any}) -- line: 115
		-- upvalues: React (copy), TrustedFriendsVPCPrologue (copy)
		return React.createElement(TrustedFriendsVPCPrologue, {
			userId = t2.navigation.getParam("userId"),
			completionCallback = t2.navigation.getParam("completionCallback"),
			externalNavigation = t2.screenProps.externalNavigation
		})
	end
}
