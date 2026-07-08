local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local Foundation = require(TrustedContactsParent.Foundation)
local useLocalization = require(TrustedContactsParent.Localization).Hooks.useLocalization
local TFActionsEnum = require(TrustedContacts.TrustedFriendActions.TFActionsEnum)
local useGetTFActionsCallbacks = require(script.Parent.useGetTFActionsCallbacks)
local useGetTFActionsEnum_legacy = require(script.Parent.useGetTFActionsEnum_legacy)
local FFlagTrustedFriendsLinkVPC = require(TrustedContacts.Flags.FFlagTrustedFriendsLinkVPC)
local FFlagTFWithActionsCheck = require(TrustedContactsParent.SharedFlags).FFlagTFWithActionsCheck

local function useModalButtonActions(s1: string, _: string?, p1, p2) -- line: 27
	-- upvalues: FFlagTFWithActionsCheck (copy), useGetTFActionsEnum_legacy (copy), useGetTFActionsCallbacks (copy), useLocalization (copy), React (copy), TFActionsEnum (copy), Foundation (copy), FFlagTrustedFriendsLinkVPC (copy)
	local v16 = if not FFlagTFWithActionsCheck then useGetTFActionsEnum_legacy(s1, {
		modalVariant = p1,
		tokens = p2.tokens,
		isShareLinkSender = p2.isShareLinkSender
	}) else p1
	local v17 = useGetTFActionsCallbacks(s1, p2)
	local v18 = useLocalization({
		cancel = "CommonUI.Controls.Action.Cancel",
		add = "Feature.Friends.Action.Add",
		addViaLink = "Feature.Friends.Button.AddViaLink",
		ok = "CommonUI.Controls.Action.OK",
		accept = "CommonUI.Controls.Action.Accept"
	})
	local v19 = React.useMemo(function() -- line: 52
		-- upvalues: v18 (copy), v17 (copy), TFActionsEnum (copy), FFlagTFWithActionsCheck (copy), Foundation (copy), FFlagTrustedFriendsLinkVPC (copy)
		local t1 = {
			icon = nil,
			isLoading = false,
			text = v18.cancel,
			onActivated = v17.onCancelButtonPress
		}

		return {
			[TFActionsEnum.Loading] = if not FFlagTFWithActionsCheck then {
				{
					isLoading = true,
					onActivated = function() -- line: 66
					end
				},
				t1
			} else nil,
			[TFActionsEnum.RemoveTrustedConnection] = {{
				text = v18.ok,
				onActivated = v17.onOkButtonPress
			}},
			[TFActionsEnum.AddTrustedConnectionViaLink] = {
				{
					text = v18.addViaLink,
					onActivated = v17.onAddViaLinkButtonPress
				},
				t1
			},
			[TFActionsEnum.AddTrustedFriendDoubleOptin] = {
				{
					text = v18.add,
					onActivated = v17.onSendTrustedConnectionRequest
				},
				t1
			},
			[TFActionsEnum.AddTrustedFriendWithVpc] = {
				{
					text = v18.add,
					icon = Foundation.Enums.IconName.LockClosed,
					onActivated = v17.onOpenVPCProloguePress
				},
				t1
			},
			[TFActionsEnum.AcceptTrustedFriendWithVpcRecipient] = {
				{
					text = v18.accept,
					icon = Foundation.Enums.IconName.LockClosed,
					onActivated = v17.onOpenVPCProloguePress
				},
				t1
			},
			[TFActionsEnum.AcceptTrustedFriendViaLink] = {
				{
					text = v18.accept,
					onActivated = v17.onAddTrustedFriendFromLink
				},
				t1
			},
			[TFActionsEnum.AcceptTrustedFriend] = {
				{
					text = v18.accept,
					onActivated = v17.onAcceptRequestReceived
				},
				t1
			},
			[TFActionsEnum.AcceptTrustedFriendViaLinkWithVpcRecipient] = if not FFlagTrustedFriendsLinkVPC then nil else {
				{
					text = v18.accept,
					icon = Foundation.Enums.IconName.LockClosed,
					onActivated = v17.onAddTrustedFriendFromLinkWithVPC
				},
				t1
			},
			[TFActionsEnum.AcceptTrustedFriendInvalid] = {
				{
					isDisabled = true,
					text = v18.accept,
					onActivated = function() -- line: 121
					end
				},
				t1
			},
			[TFActionsEnum.PendingTrustedConnection] = {
				{
					isDisabled = true,
					text = v18.add,
					onActivated = function() -- line: 129
					end
				},
				t1
			},
			[TFActionsEnum.PendingIncomingTrustedConnection] = {
				{
					isDisabled = true,
					text = v18.accept,
					onActivated = function() -- line: 137
					end
				},
				t1
			}
		}
	end, {
		v16,
		v18,
		v17
	})

	if v16 then
		return v19[v16]
	end

	return nil
end

return useModalButtonActions
