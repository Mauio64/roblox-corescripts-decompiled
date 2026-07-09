local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedConnectionStatus = require(TrustedContacts.Enums).TrustedConnectionStatus
local TFActionsEnum = require(script.Parent.TFActionsEnum)
local t1 = {
	[TFActionsEnum.RemoveTrustedConnection] = TrustedConnectionStatus.TrustedFriends,
	[TFActionsEnum.AddTrustedConnectionViaLink] = TrustedConnectionStatus.Friends,
	[TFActionsEnum.AddTrustedFriendDoubleOptin] = TrustedConnectionStatus.Friends,
	[TFActionsEnum.AddTrustedFriendWithVpc] = TrustedConnectionStatus.Friends,
	[TFActionsEnum.PendingTrustedConnection] = TrustedConnectionStatus.Friends,
	[TFActionsEnum.AcceptTrustedFriendViaLinkWithVpcRecipient] = TrustedConnectionStatus.RequestReceived,
	[TFActionsEnum.AcceptTrustedFriendWithVpcRecipient] = TrustedConnectionStatus.RequestReceived,
	[TFActionsEnum.AcceptTrustedFriendViaLink] = TrustedConnectionStatus.RequestReceived,
	[TFActionsEnum.AcceptTrustedFriend] = TrustedConnectionStatus.RequestReceived,
	[TFActionsEnum.AcceptTrustedFriendInvalid] = TrustedConnectionStatus.RequestReceived,
	[TFActionsEnum.PendingIncomingTrustedConnection] = TrustedConnectionStatus.RequestReceived
}

local function normalizeTFActionsEnumToModalVariant(p1) -- line: 24
	-- upvalues: t1 (copy)
	return t1[p1]
end

return normalizeTFActionsEnumToModalVariant
