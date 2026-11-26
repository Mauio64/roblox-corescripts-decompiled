local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Analytics")
local useTCAnalytics = Analytics.useTCAnalytics
local eventNames = Analytics.EventNames

local contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SocialLuaAnalytics").Analytics.Enums.Contexts

local fStringConnectionGraphCoreAmpNameSpace = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FStringConnectionGraphCoreAmpNameSpace

local fFlagTCUpdateProfileCTAButton = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/SharedFlags").FFlagTCUpdateProfileCTAButton

require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Common/Types")

local function TrustedFriendsVPCPrologue(props)
	local v5 = useLocalization({
		cancel = "CommonUI.Controls.Action.Cancel",
		ask = "Feature.Friends.Label.Ask",
		askYourParent = "Feature.Friends.Label.AskYourParent",
		vpcRequired = "Feature.Friends.Label.AddFriendVPC"
	})

	local fireAnalyticsEvent = useTCAnalytics({ friendId = props.userId }).fireAnalyticsEvent

	local v6 = React.useCallback(function()
		props.externalNavigation.closeModal()
	end, { props.externalNavigation })

	local v7 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.TrustedFriendsVPCCancelClicked)
		v6()
	end, { v6, fireAnalyticsEvent })

	local function fn(p2, p3)
		if fFlagTCUpdateProfileCTAButton and props.completionCallback then
			props.completionCallback()
		end
	end

	local v10 = React.useCallback(fn, {
		if fFlagTCUpdateProfileCTAButton then props.completionCallback else nil
	})

	local v11 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.TrustedFriendsVPCAskClicked)
		v6()

		props.externalNavigation.openAmpWizard({
			featureName = "TriggerTrustedFriendVPCRecourse",
			completionCallback = v10,
			recourseData = { targetUserId = props.userId },
			entryPointEventCtx = contexts.TrustedFriendsVPCPrologue,
			extraParameters = {
				{ name = "targetUser", type = "UserId", value = props.userId }
			},
			nameSpace = fStringConnectionGraphCoreAmpNameSpace
		})
	end, { fireAnalyticsEvent, v6, props.externalNavigation, props.userId, v10 })

	return React.createElement(dialog.Root, { size = dialogSize.Small }, {
		Title = React.createElement(dialog.Title, {
			LayoutOrder = 1,
			text = v5.askYourParent
		}),
		Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			Text = React.createElement(dialog.Text, { Text = v5.vpcRequired })
		}),
		Buttons = React.createElement(dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{ text = v5.ask, variant = buttonVariant.Emphasis, onActivated = v11 },
				{ text = v5.cancel, variant = buttonVariant.Standard, onActivated = v7 }
			}
		})
	})
end

return {
	Screen = function(p2)
		return React.createElement(TrustedFriendsVPCPrologue, {
			userId = p2.navigation.getParam("userId"),
			completionCallback = p2.navigation.getParam("completionCallback"),
			externalNavigation = p2.screenProps.externalNavigation
		})
	end
}
