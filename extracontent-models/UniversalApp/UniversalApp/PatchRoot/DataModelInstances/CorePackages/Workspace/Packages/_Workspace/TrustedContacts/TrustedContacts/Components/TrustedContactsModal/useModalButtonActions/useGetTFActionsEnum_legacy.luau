local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local AmpApiProvider = require(TrustedContactsParent.AmpUpsell).AmpApiProvider
local AmpEnums = require(TrustedContactsParent.AmpUpsell).AmpEnums
local TrustedConnectionStatus = require(TrustedContacts.Enums).TrustedConnectionStatus
local TFActionsEnum = require(TrustedContacts.TrustedFriendActions.TFActionsEnum)
local FFlagTrustedFriendsLinkVPC = require(TrustedContacts.Flags.FFlagTrustedFriendsLinkVPC)
local FStringConnectionGraphCoreAmpNameSpace = require(TrustedContactsParent.SharedFlags).FStringConnectionGraphCoreAmpNameSpace

local function useGetTFActionsEnum_legacy(s1: string, t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), AmpApiProvider (copy), FStringConnectionGraphCoreAmpNameSpace (copy), AmpEnums (copy), TrustedConnectionStatus (copy), TFActionsEnum (copy), FFlagTrustedFriendsLinkVPC (copy)
	local modalVariant = t1.modalVariant
	local tokens = t1.tokens
	local isShareLinkSender = t1.isShareLinkSender
	local v16, v17 = React.useState(false)
	local v18, v19 = React.useState(true)

	React.useEffect(function() -- line: 35
		-- upvalues: s1 (copy), AmpApiProvider (copy), FStringConnectionGraphCoreAmpNameSpace (copy), AmpEnums (copy), v17 (copy), v19 (copy)
		local t2 = {
			name = "targetUser",
			type = "UserId",
			value = s1
		}

		if AmpApiProvider.upsellFeatureAccess("ShowTrustedFriendVPCModalVariant", {}, FStringConnectionGraphCoreAmpNameSpace, { t2 }).access == AmpEnums.AccessResponseEnum.Granted then
			v17(true)
		end

		v19(false)
	end, { s1 })

	return (React.useMemo(function() -- line: 48
		-- upvalues: modalVariant (copy), TrustedConnectionStatus (copy), TFActionsEnum (copy), v18 (copy), FFlagTrustedFriendsLinkVPC (copy), v16 (copy), tokens (copy), isShareLinkSender (copy)
		if not modalVariant then
			return nil
		end

		if modalVariant == TrustedConnectionStatus.TrustedFriends then
			return TFActionsEnum.RemoveTrustedConnection
		end

		if v18 then
			return TFActionsEnum.Loading
		end

		if modalVariant == TrustedConnectionStatus.RequestReceived then
			if FFlagTrustedFriendsLinkVPC and v16 and tokens and #tokens > 0 then
				return TFActionsEnum.AcceptTrustedFriendViaLinkWithVpcRecipient
			end

			if v16 then
				return TFActionsEnum.AcceptTrustedFriendWithVpcRecipient
			end

			if tokens and #tokens > 0 then
				return TFActionsEnum.AcceptTrustedFriendViaLink
			end

			return TFActionsEnum.AcceptTrustedFriend
		end

		if modalVariant == TrustedConnectionStatus.Friends then
			if v16 then
				return TFActionsEnum.AddTrustedFriendWithVpc
			end

			if isShareLinkSender then
				return TFActionsEnum.AddTrustedConnectionViaLink
			end

			return TFActionsEnum.AddTrustedFriendDoubleOptin
		end

		return nil
	end, {
		modalVariant,
		v18,
		v16,
		tokens,
		isShareLinkSender
	}))
end

return useGetTFActionsEnum_legacy
