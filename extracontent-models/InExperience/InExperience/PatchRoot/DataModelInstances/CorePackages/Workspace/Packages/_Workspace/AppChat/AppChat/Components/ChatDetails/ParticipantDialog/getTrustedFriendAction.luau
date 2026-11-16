local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources

local getProfileTrustedFriendActions = require(AppChat.Http.getProfileTrustedFriendActions)

local FFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC

local function createTrustedFriendAction(item: string, actionType: string, isDisabled: boolean, shareLinkSender: string?) -- 6 equivalent calls inferred from this helper
	return {
		rawActionType = item,
		actionType = actionType,
		isDisabled = isDisabled,
		modalVariantOverride = shareLinkSender
	}
end

local function normalizeTrustedFriendAction(items)
	for _, item in items do
		if item == "RemoveTrustedConnection" then
			return createTrustedFriendAction("RemoveTrustedConnection", "RemoveTrustedConnection", false) -- inferred equivalent call
		end

		if item == "AddTrustedConnection" then
			if FFlagProfilePlatformAddTC then
				return createTrustedFriendAction("AddTrustedConnection", "AddTrustedConnection", false) -- inferred equivalent call
			end
		else
			if item == "AddTrustedConnectionViaLink" then
				return createTrustedFriendAction( -- inferred equivalent call
					"AddTrustedConnectionViaLink",
					"AddTrustedConnection",
					false,
					Sources.ShareLinkSender
				)
			end

			if item == "PendingTrustedConnection" then
				if FFlagProfilePlatformAddTC then
					return createTrustedFriendAction("PendingTrustedConnection", "AddTrustedConnection", true) -- inferred equivalent call
				end
			elseif item == "AddIncomingTrustedConnection" then
				if FFlagProfilePlatformAddTC then
					return createTrustedFriendAction( -- inferred equivalent call
						"AddIncomingTrustedConnection",
						"AddIncomingTrustedConnection",
						false
					)
				end
			elseif item == "PendingIncomingTrustedConnection" then
				return createTrustedFriendAction( -- inferred equivalent call
					"PendingIncomingTrustedConnection",
					"AddIncomingTrustedConnection",
					true
				)
			end
		end
	end

	return nil
end

local function getTrustedFriendAction(p: string)
	if p == "" then
		return Promise.resolve(nil)
	end

	return getProfileTrustedFriendActions(p):andThen(function(p2)
		return (normalizeTrustedFriendAction(p2))
	end):catch(function(): nil
		return nil
	end)
end

return getTrustedFriendAction
