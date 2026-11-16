local TrustedContacts = script:FindFirstAncestor("TrustedContacts")

local Enums = require(TrustedContacts.Enums)
local TrustedConnectionStatus = Enums.TrustedConnectionStatus
local TFActionsEnum = require(script.Parent.TFActionsEnum)

local v = {
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

local function normalizeTFActionsEnumToModalVariant(p)
	return v[p]
end

return normalizeTFActionsEnumToModalVariant
