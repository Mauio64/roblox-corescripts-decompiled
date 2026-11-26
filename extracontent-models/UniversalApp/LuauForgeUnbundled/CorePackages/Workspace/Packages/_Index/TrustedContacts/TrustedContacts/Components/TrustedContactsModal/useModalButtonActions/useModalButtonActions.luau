local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization

local TFActionsEnum = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/TrustedFriendActions/TFActionsEnum")

local useGetTFActionsCallbacks = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Components/TrustedContactsModal/useModalButtonActions/useGetTFActionsCallbacks")

local FFlagTrustedFriendsLinkVPC = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTrustedFriendsLinkVPC")

local function useModalButtonActions(p2, p3, p4, p5)
	local v5 = useGetTFActionsCallbacks(p2, p5)

	local v6 = useLocalization({
		cancel = "CommonUI.Controls.Action.Cancel",
		add = "Feature.Friends.Action.Add",
		addViaLink = "Feature.Friends.Button.AddViaLink",
		ok = "CommonUI.Controls.Action.OK",
		accept = "CommonUI.Controls.Action.Accept"
	})

	local v7 = React.useMemo(function()
		local v8 = {
			text = v6.cancel,
			onActivated = v5.onCancelButtonPress,
			icon = nil,
			isLoading = false
		}

		return {
			[TFActionsEnum.RemoveTrustedConnection] = {
				{ text = v6.ok, onActivated = v5.onOkButtonPress }
			},
			[TFActionsEnum.AddTrustedConnectionViaLink] = {
				{ text = v6.addViaLink, onActivated = v5.onAddViaLinkButtonPress },
				v8
			},
			[TFActionsEnum.AddTrustedFriendDoubleOptin] = {
				{ text = v6.add, onActivated = v5.onSendTrustedConnectionRequest },
				v8
			},
			[TFActionsEnum.AddTrustedFriendWithVpc] = {
				{
					text = v6.add,
					icon = Foundation.Enums.IconName.LockClosed,
					onActivated = v5.onOpenVPCProloguePress
				},
				v8
			},
			[TFActionsEnum.AcceptTrustedFriendWithVpcRecipient] = {
				{
					text = v6.accept,
					icon = Foundation.Enums.IconName.LockClosed,
					onActivated = v5.onOpenVPCProloguePress
				},
				v8
			},
			[TFActionsEnum.AcceptTrustedFriendViaLink] = {
				{ text = v6.accept, onActivated = v5.onAddTrustedFriendFromLink },
				v8
			},
			[TFActionsEnum.AcceptTrustedFriend] = {
				{ text = v6.accept, onActivated = v5.onAcceptRequestReceived },
				v8
			},
			[TFActionsEnum.AcceptTrustedFriendViaLinkWithVpcRecipient] = FFlagTrustedFriendsLinkVPC and {
				{
					text = v6.accept,
					icon = Foundation.Enums.IconName.LockClosed,
					onActivated = v5.onAddTrustedFriendFromLinkWithVPC
				},
				v8
			} or nil,
			[TFActionsEnum.AcceptTrustedFriendInvalid] = {
				{
					text = v6.accept,
					onActivated = function() end,
					isDisabled = true
				},
				v8
			},
			[TFActionsEnum.PendingTrustedConnection] = {
				{
					text = v6.add,
					onActivated = function() end,
					isDisabled = true
				},
				v8
			},
			[TFActionsEnum.PendingIncomingTrustedConnection] = {
				{
					text = v6.accept,
					onActivated = function() end,
					isDisabled = true
				},
				v8
			}
		}
	end, { p4, v6, v5 })

	if p4 then
		return v7[p4]
	end

	return nil
end

return useModalButtonActions
