local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent

local network = parent.Network

local AppChatNetworking = require(CorePackages.Workspace.Packages.AppChatNetworking)
local httpRequest = require(network.httpRequest)
local GetPlaceInfos = require(network.Requests.GetPlaceInfos)
local constructGameLinkUrl = require(parent.Utility.constructGameLinkUrl)

local v = httpRequest(HttpRbxApiService)

local Constants = require(parent.Resources.Constants)
local InviteStatus = Constants.InviteStatus

local ReceivedUserInviteStatus = require(parent.Actions.ReceivedUserInviteStatus)

return function(p, p2)
	return function(object)
		if object:getState().invites[tostring(p)] == InviteStatus.Pending then
			return
		end

		object:dispatch(ReceivedUserInviteStatus(p, InviteStatus.Pending))

		if not RunService:IsStudio() then
			return GetPlaceInfos(v, { p2 }):andThen(function(p3)
				local v2 = p3.responseBody[1]
				assert(v2, "Error fetching placeInfos")

				v2.placeId = tostring(v2.placeId)
				v2.universeId = tostring(v2.universeId)

				return v2
			end):andThen(function(p3)
				local v2 = string.format("Come join me in %s", p3.name)
				assert(p3.universeRootPlaceId, "Failed to get universe root place id")
				local v3 = v2 .. "\n" .. constructGameLinkUrl(p3.universeRootPlaceId)
				return AppChatNetworking.http.CreateConversation(nil, "one_to_one", { p }):andThen(function(p4)
					local conversation = p4.responseBody.conversations[1]
					assert(conversation, "Failed to create conversation")
					return AppChatNetworking.http.SendChatTextMessage(nil, conversation.id, v3):andThen(function(p5)
						local message = p5.responseBody.messages[1]
						assert(message, "Failed to send message")
						return {
							resultType = message.status == "success" and "Success" or "Failed",
							conversationId = conversation.id,
							placeId = p3.universeRootPlaceId
						}
					end)
				end):catch(function(p4)
					warn("Failed to send invite: " .. tostring(p4))
				end)
			end):andThen(function(object2)
				local v2, v3 = object2:await()
				assert(v2, "Failed to unroll promise after friend invitation: " .. tostring(v3))

				object:dispatch(ReceivedUserInviteStatus(p, InviteStatus[v3.resultType] or InviteStatus.Failed))
				return v3
			end, function(_)
				object:dispatch(ReceivedUserInviteStatus(p, InviteStatus.Failed))
			end)
		end

		spawn(function()
			object:dispatch(ReceivedUserInviteStatus(p, InviteStatus.Failed))
		end)
	end
end
