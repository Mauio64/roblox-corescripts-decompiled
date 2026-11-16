local trustedConnectionStatus = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Enums").TrustedConnectionStatus
local TFActionsEnum = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/TrustedFriendActions/TFActionsEnum")

local v5 = {
	[TFActionsEnum.RemoveTrustedConnection] = trustedConnectionStatus.TrustedFriends,
	[TFActionsEnum.AddTrustedConnectionViaLink] = trustedConnectionStatus.Friends,
	[TFActionsEnum.AddTrustedFriendDoubleOptin] = trustedConnectionStatus.Friends,
	[TFActionsEnum.AddTrustedFriendWithVpc] = trustedConnectionStatus.Friends,
	[TFActionsEnum.PendingTrustedConnection] = trustedConnectionStatus.Friends,
	[TFActionsEnum.AcceptTrustedFriendViaLinkWithVpcRecipient] = trustedConnectionStatus.RequestReceived,
	[TFActionsEnum.AcceptTrustedFriendWithVpcRecipient] = trustedConnectionStatus.RequestReceived,
	[TFActionsEnum.AcceptTrustedFriendViaLink] = trustedConnectionStatus.RequestReceived,
	[TFActionsEnum.AcceptTrustedFriend] = trustedConnectionStatus.RequestReceived,
	[TFActionsEnum.AcceptTrustedFriendInvalid] = trustedConnectionStatus.RequestReceived,
	[TFActionsEnum.PendingIncomingTrustedConnection] = trustedConnectionStatus.RequestReceived
}

local function normalizeTFActionsEnumToModalVariant(p2)
	return v5[p2]
end

return normalizeTFActionsEnumToModalVariant
