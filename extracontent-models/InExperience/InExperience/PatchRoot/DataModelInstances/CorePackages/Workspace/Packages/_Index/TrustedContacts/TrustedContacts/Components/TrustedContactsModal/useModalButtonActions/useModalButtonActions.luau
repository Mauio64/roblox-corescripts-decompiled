local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local TFActionsEnum = require(TrustedContacts.TrustedFriendActions.TFActionsEnum)

local useGetTFActionsCallbacks = require(script.Parent.useGetTFActionsCallbacks)

local FFlagTrustedFriendsLinkVPC = require(TrustedContacts.Flags.FFlagTrustedFriendsLinkVPC)

local function useModalButtonActions(p: string, _: string?, p2, p3)
	local v = useGetTFActionsCallbacks(p, p3)

	local v2 = useLocalization({
		cancel = "CommonUI.Controls.Action.Cancel",
		add = "Feature.Friends.Action.Add",
		addViaLink = "Feature.Friends.Button.AddViaLink",
		ok = "CommonUI.Controls.Action.OK",
		accept = "CommonUI.Controls.Action.Accept"
	})

	local v3 = React.useMemo(function()
		local v3 = {
			text = v2.cancel,
			onActivated = v.onCancelButtonPress,
			icon = nil,
			isLoading = false
		}

		return {
			[TFActionsEnum.RemoveTrustedConnection] = {
				{ text = v2.ok, onActivated = v.onOkButtonPress }
			},
			[TFActionsEnum.AddTrustedConnectionViaLink] = {
				{ text = v2.addViaLink, onActivated = v.onAddViaLinkButtonPress },
				v3
			},
			[TFActionsEnum.AddTrustedFriendDoubleOptin] = {
				{ text = v2.add, onActivated = v.onSendTrustedConnectionRequest },
				v3
			},
			[TFActionsEnum.AddTrustedFriendWithVpc] = {
				{
					text = v2.add,
					icon = Foundation.Enums.IconName.LockClosed,
					onActivated = v.onOpenVPCProloguePress
				},
				v3
			},
			[TFActionsEnum.AcceptTrustedFriendWithVpcRecipient] = {
				{
					text = v2.accept,
					icon = Foundation.Enums.IconName.LockClosed,
					onActivated = v.onOpenVPCProloguePress
				},
				v3
			},
			[TFActionsEnum.AcceptTrustedFriendViaLink] = {
				{ text = v2.accept, onActivated = v.onAddTrustedFriendFromLink },
				v3
			},
			[TFActionsEnum.AcceptTrustedFriend] = {
				{ text = v2.accept, onActivated = v.onAcceptRequestReceived },
				v3
			},
			[TFActionsEnum.AcceptTrustedFriendViaLinkWithVpcRecipient] = FFlagTrustedFriendsLinkVPC and {
				{
					text = v2.accept,
					icon = Foundation.Enums.IconName.LockClosed,
					onActivated = v.onAddTrustedFriendFromLinkWithVPC
				},
				v3
			} or nil,
			[TFActionsEnum.AcceptTrustedFriendInvalid] = {
				{
					text = v2.accept,
					onActivated = function() end,
					isDisabled = true
				},
				v3
			},
			[TFActionsEnum.PendingTrustedConnection] = {
				{
					text = v2.add,
					onActivated = function() end,
					isDisabled = true
				},
				v3
			},
			[TFActionsEnum.PendingIncomingTrustedConnection] = {
				{
					text = v2.accept,
					onActivated = function() end,
					isDisabled = true
				},
				v3
			}
		}
	end, { p2, v2, v })

	if p2 then
		return v3[p2]
	end

	return nil
end

return useModalButtonActions
