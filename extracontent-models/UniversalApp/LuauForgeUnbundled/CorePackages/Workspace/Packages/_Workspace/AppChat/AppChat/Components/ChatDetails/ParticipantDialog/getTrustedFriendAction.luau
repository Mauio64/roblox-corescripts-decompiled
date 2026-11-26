local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local sources = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics").Analytics.Enums.Sources

local getProfileTrustedFriendActions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/getProfileTrustedFriendActions")

local fFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC

local function createTrustedFriendAction(p2, p3, p4, p5)
	return {
		rawActionType = p2,
		actionType = p3,
		isDisabled = p4,
		modalVariantOverride = p5
	}
end

local function normalizeTrustedFriendAction(items)
	for k, item in items do
		if item == "RemoveTrustedConnection" then
			return {
				rawActionType = "RemoveTrustedConnection",
				actionType = "RemoveTrustedConnection",
				isDisabled = false,
				modalVariantOverride = nil
			}
		end

		if item == "AddTrustedConnection" then
			if fFlagProfilePlatformAddTC then
				return {
					rawActionType = "AddTrustedConnection",
					actionType = "AddTrustedConnection",
					isDisabled = false,
					modalVariantOverride = nil
				}
			end
		else
			if item == "AddTrustedConnectionViaLink" then
				return {
					rawActionType = "AddTrustedConnectionViaLink",
					actionType = "AddTrustedConnection",
					isDisabled = false,
					modalVariantOverride = sources.ShareLinkSender
				}
			end

			if item == "PendingTrustedConnection" then
				if fFlagProfilePlatformAddTC then
					return {
						rawActionType = "PendingTrustedConnection",
						actionType = "AddTrustedConnection",
						isDisabled = true,
						modalVariantOverride = nil
					}
				end
			elseif item == "AddIncomingTrustedConnection" then
				if fFlagProfilePlatformAddTC then
					return {
						rawActionType = "AddIncomingTrustedConnection",
						actionType = "AddIncomingTrustedConnection",
						isDisabled = false,
						modalVariantOverride = nil
					}
				end
			elseif item == "PendingIncomingTrustedConnection" then
				return {
					rawActionType = "PendingIncomingTrustedConnection",
					actionType = "AddIncomingTrustedConnection",
					isDisabled = true,
					modalVariantOverride = nil
				}
			end
		end
	end

	return nil
end

local function getTrustedFriendAction(p2)
	if p2 == "" then
		return Promise.resolve(nil)
	end

	return getProfileTrustedFriendActions(p2):andThen(function(p3)
		return normalizeTrustedFriendAction(p3)
	end):catch(function(): nil
		return nil
	end)
end

return getTrustedFriendAction
