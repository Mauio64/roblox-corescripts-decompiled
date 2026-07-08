local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Requests = require(CorePackages.Workspace.Packages.Http).Requests
local DEPRECATED_ChatSendMessage = Requests.DEPRECATED_ChatSendMessage
local DEPRECATED_ChatStartOneToOneConversation = Requests.DEPRECATED_ChatStartOneToOneConversation
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local DEPRECATED_ChatSendGameLinkMessage = Requests.DEPRECATED_ChatSendGameLinkMessage

return function(p1, p2, p3) -- line: 17
	-- upvalues: Players (copy), RobloxTranslator (copy), DEPRECATED_ChatStartOneToOneConversation (copy), DEPRECATED_ChatSendMessage (copy), DEPRECATED_ChatSendGameLinkMessage (copy)
	local UserId = Players.LocalPlayer.UserId
	local u12 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Message.InviteToGameTitle", {
		PLACENAME = p3.name
	})

	return function(_) -- line: 26
		-- upvalues: DEPRECATED_ChatStartOneToOneConversation (copy), p1 (copy), p2 (copy), UserId (copy), DEPRECATED_ChatSendMessage (copy), u12 (ref), p3 (copy), DEPRECATED_ChatSendGameLinkMessage (copy)
		return DEPRECATED_ChatStartOneToOneConversation(p1, p2, UserId):andThen(function(p5) -- line: 27
			-- upvalues: DEPRECATED_ChatSendMessage (copy), p1 (copy), u12 (ref), p2 (copy), p3 (copy), DEPRECATED_ChatSendGameLinkMessage (copy)
			local conversation = p5.responseBody.conversation

			return DEPRECATED_ChatSendMessage(p1, conversation.id, u12, nil, true, p2):andThen(function() -- line: 30
				-- upvalues: conversation (copy), p3 (copy), DEPRECATED_ChatSendGameLinkMessage (copy), p1 (copy), p2 (copy)
				local function handleResult(p6) -- line: 31
					-- upvalues: conversation (copy), p3 (copy)
					return {
						resultType = p6.responseBody.resultType,
						conversationId = conversation.id,
						placeId = p3.universeRootPlaceId
					}
				end

				return DEPRECATED_ChatSendGameLinkMessage(p1, conversation.id, p3.universeId, nil, true, p2, p3.universeRootPlaceId):andThen(handleResult)
			end)
		end)
	end
end
