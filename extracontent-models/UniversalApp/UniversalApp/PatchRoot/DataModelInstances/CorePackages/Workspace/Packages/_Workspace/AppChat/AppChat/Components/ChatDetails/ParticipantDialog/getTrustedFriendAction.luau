local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Promise = require(AppChatParent.Promise)
local SharedFlags = require(AppChatParent.SharedFlags)
local Sources = require(AppChatParent.SocialLuaAnalytics).Analytics.Enums.Sources
local getProfileTrustedFriendActions = require(AppChat.Http.getProfileTrustedFriendActions)
local FFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC
local v8 = game:DefineFastFlag("PendingIncomingTrustedConnection", false)

local function createTrustedFriendAction(s1: string, s2: string, b1: boolean, s3: string?) -- line: 22
	return {
		rawActionType = s1,
		actionType = s2,
		isDisabled = b1,
		modalVariantOverride = s3
	}
end
local function normalizeTrustedFriendAction(t1: {[any]: any}) -- line: 36
	-- upvalues: FFlagProfilePlatformAddTC (copy), Sources (copy), v8 (copy)
	for _, v18 in t1 do
		if v18 == "RemoveTrustedConnection" then
			return {
				actionType = "RemoveTrustedConnection",
				isDisabled = false,
				modalVariantOverride = nil,
				rawActionType = v18
			}
		end

		if v18 ~= "AddTrustedConnection" then
			if v18 == "AddTrustedConnectionViaLink" then
				local ShareLinkSender = Sources.ShareLinkSender

				return {
					actionType = "AddTrustedConnection",
					isDisabled = false,
					rawActionType = v18,
					modalVariantOverride = ShareLinkSender
				}
			end

			if v18 == "PendingTrustedConnection" then
				if not FFlagProfilePlatformAddTC then
					continue
				end

				return {
					actionType = "AddTrustedConnection",
					isDisabled = true,
					modalVariantOverride = nil,
					rawActionType = v18
				}
			end

			if v18 == "AddIncomingTrustedConnection" then
				if not FFlagProfilePlatformAddTC then
					continue
				end

				return {
					actionType = "AddIncomingTrustedConnection",
					isDisabled = false,
					modalVariantOverride = nil,
					rawActionType = v18
				}
			end

			if v18 ~= "PendingIncomingTrustedConnection" or not v8 then
				continue
			end

			return {
				actionType = "AddIncomingTrustedConnection",
				isDisabled = true,
				modalVariantOverride = nil,
				rawActionType = v18
			}
		end

		if FFlagProfilePlatformAddTC then
			return {
				actionType = "AddTrustedConnection",
				isDisabled = false,
				modalVariantOverride = nil,
				rawActionType = v18
			}
		end
	end

	return nil
end
local function getTrustedFriendAction(s4: string) -- line: 64
	-- upvalues: Promise (copy), getProfileTrustedFriendActions (copy), normalizeTrustedFriendAction (copy)
	if s4 == "" then
		return Promise.resolve(nil)
	end

	return getProfileTrustedFriendActions(s4):andThen(function(p1) -- line: 70
		-- upvalues: normalizeTrustedFriendAction (copy)
		return (normalizeTrustedFriendAction(p1))
	end):catch(function() -- line: 73
		return nil
	end)
end

return getTrustedFriendAction
