local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local Http = require(CorePackages.Workspace.Packages.Http)
local Requests = Http.Requests

local DEPRECATED_ChatSendMessage = Requests.DEPRECATED_ChatSendMessage

local DEPRECATED_ChatStartOneToOneConversation = Requests.DEPRECATED_ChatStartOneToOneConversation

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local DEPRECATED_ChatSendGameLinkMessage = Requests.DEPRECATED_ChatSendGameLinkMessage

return function(p, p2, data)
	local userId = Players.LocalPlayer.UserId

	local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.Message.InviteToGameTitle", {
		PLACENAME = data.name
	})

	return function(_)
		return DEPRECATED_ChatStartOneToOneConversation(p, p2, userId):andThen(function(p3)
			local conversation = p3.responseBody.conversation

			return DEPRECATED_ChatSendMessage(p, conversation.id, formatByKey, nil, true, p2):andThen(function()
				local function handleResult(p4)
					return {
						resultType = p4.responseBody.resultType,
						conversationId = conversation.id,
						placeId = data.universeRootPlaceId
					}
				end

				return DEPRECATED_ChatSendGameLinkMessage(
					p,
					conversation.id,
					data.universeId,
					nil,
					true,
					p2,
					data.universeRootPlaceId
				):andThen(handleResult)
			end)
		end)
	end
end
