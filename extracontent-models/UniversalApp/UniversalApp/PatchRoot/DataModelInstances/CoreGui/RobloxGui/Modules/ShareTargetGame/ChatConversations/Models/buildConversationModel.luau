local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ShareTargetGame = script:FindFirstAncestor("ShareTargetGame")
local dependencies = require(ShareTargetGame.dependencies)
local Common = CoreGui.RobloxGui.Modules.Common
local formatAlias = dependencies.SocialLibraries.Utils.formatAlias
local Constants = require(CorePackages.Workspace.Packages.AppChat.Constants)
local Functional = require(Common.Functional)
local Conversation = require(CorePackages.Workspace.Packages.AppChat.Conversation)
local getStandardSizeAvatarHeadShotRbxthumb = require(CorePackages.Workspace.Packages.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb

return function(p1, p2, p3) -- line: 21
	-- upvalues: Players (copy), Functional (copy), Conversation (copy), formatAlias (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), Constants (copy)
	local str = tostring(Players.LocalPlayer.UserId)
	local v16 = Functional.Filter(p2.participants, function(p4) -- line: 23
		-- upvalues: str (copy)
		return p4 ~= str
	end)
	local v17 = p2.conversationType == Conversation.Type.ONE_TO_ONE_CONVERSATION
	local lastLocation = nil
	local presence = nil
	local s1 = ""

	if v17 then
		local v21 = p1[v16[1]]

		if v21 then
			presence = v21.presence
			lastLocation = v21.lastLocation

			local v22 = p3.byUserId[v21.id] or ""

			if v22 ~= "" then
				s1 = formatAlias(v22)
			end
		end
	end

	local t1 = {}

	for _, v in pairs(p2.participants) do
		if v17 and v ~= str or not v17 then
			table.insert(t1, (getStandardSizeAvatarHeadShotRbxthumb(v)))
		end
	end

	local v26 = not v17 and "" or (Constants.PresenceIndicatorImagesBySize[Constants:GetPresenceIndicatorSizeKey(14)][presence] or "")
	local v27 = not p2.lastUpdated and 0 or p2.lastUpdated:GetUnixTimestamp()

	return {
		oneToOne = v17,
		lastUpdated = v27,
		conversationId = p2.id,
		lastLocation = lastLocation,
		presence = presence,
		presenceImage = v26,
		title = p2.title,
		thumbnails = t1,
		participants = p2.participants,
		alias = s1
	}
end
