local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent
local Network = ParentParent.Network
local AppChatNetworking = require(CorePackages.Workspace.Packages.AppChatNetworking)
local httpRequest = require(Network.httpRequest)
local GetPlaceInfos = require(Network.Requests.GetPlaceInfos)
local constructGameLinkUrl = require(ParentParent.Utility.constructGameLinkUrl)
local v10 = httpRequest(HttpRbxApiService)
local InviteStatus = require(ParentParent.Resources.Constants).InviteStatus
local ReceivedUserInviteStatus = require(ParentParent.Actions.ReceivedUserInviteStatus)

return function(p1, p2) -- line: 25
	-- upvalues: InviteStatus (copy), ReceivedUserInviteStatus (copy), RunService (copy), GetPlaceInfos (copy), v10 (copy), constructGameLinkUrl (copy), AppChatNetworking (copy)
	return function(p3) -- line: 26
		-- upvalues: p1 (copy), InviteStatus (copy), ReceivedUserInviteStatus (copy), RunService (copy), GetPlaceInfos (copy), v10 (copy), p2 (copy), constructGameLinkUrl (copy), AppChatNetworking (copy)
		if p3:getState().invites[tostring(p1)] == InviteStatus.Pending then
			return
		end

		p3:dispatch(ReceivedUserInviteStatus(p1, InviteStatus.Pending))

		if RunService:IsStudio() then
			spawn(function() -- line: 36
				-- upvalues: p3 (copy), ReceivedUserInviteStatus (copy), p1 (copy), InviteStatus (copy)
				p3:dispatch(ReceivedUserInviteStatus(p1, InviteStatus.Failed))
			end)

			return
		end

		return GetPlaceInfos(v10, { p2 }):andThen(function(p4) -- line: 42
			local v17 = p4.responseBody[1]

			assert(v17, "Error fetching placeInfos")
			v17.placeId = tostring(v17.placeId)
			v17.universeId = tostring(v17.universeId)

			return v17
		end):andThen(function(p5) -- line: 52
			-- upvalues: constructGameLinkUrl (copy), AppChatNetworking (copy), p1 (copy)
			local v19 = string.format("Come join me in %s", p5.name)

			assert(p5.universeRootPlaceId, "Failed to get universe root place id")

			local u20 = v19 .. "\n" .. constructGameLinkUrl(p5.universeRootPlaceId)

			return AppChatNetworking.http.CreateConversation(nil, "one_to_one", { p1 }):andThen(function(p6) -- line: 56
				-- upvalues: AppChatNetworking (copy), u20 (ref), p5 (copy)
				local v27 = p6.responseBody.conversations[1]

				assert(v27, "Failed to create conversation")

				return AppChatNetworking.http.SendChatTextMessage(nil, v27.id, u20):andThen(function(p7) -- line: 59
					-- upvalues: v27 (copy), p5 (copy)
					local v30 = p7.responseBody.messages[1]

					assert(v30, "Failed to send message")

					return {
						resultType = v30.status ~= "success" and "Failed" or "Success",
						conversationId = v27.id,
						placeId = p5.universeRootPlaceId
					}
				end)
			end):catch(function(p8) -- line: 72
				warn("Failed to send invite: " .. tostring(p8))
			end)
		end):andThen(function(p9) -- line: 75
			-- upvalues: InviteStatus (copy), p3 (copy), ReceivedUserInviteStatus (copy), p1 (copy)
			local v22, v23 = p9:await()

			assert(v22, "Failed to unroll promise after friend invitation: " .. tostring(v23))

			local v24 = InviteStatus[v23.resultType] or InviteStatus.Failed

			p3:dispatch(ReceivedUserInviteStatus(p1, v24))

			return v23
		end, function(_) -- line: 88
			-- upvalues: p3 (copy), ReceivedUserInviteStatus (copy), p1 (copy), InviteStatus (copy)
			p3:dispatch(ReceivedUserInviteStatus(p1, InviteStatus.Failed))
		end)
	end
end
