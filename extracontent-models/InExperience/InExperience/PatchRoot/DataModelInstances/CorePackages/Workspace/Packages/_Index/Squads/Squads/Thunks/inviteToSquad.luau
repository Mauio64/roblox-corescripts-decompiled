local Squads = script:FindFirstAncestor("Squads")
local HttpService = game:GetService("HttpService")

local dependencies = require(Squads.dependencies)

local cryo = dependencies.Cryo
local networkingSquads = dependencies.NetworkingSquads

local function encodeInvitees(list)
	local mapped = cryo.List.map(list, function(p)
		return (tonumber(p))
	end)

	local success, result = pcall(function()
		return HttpService:JSONEncode(mapped)
	end)
	return if success then result else "[]"
end

return function(squadId: string, parentChannelId: string, p: string, invitedUserIds, callback, isReparented: boolean)
	return function(object)
		return object:dispatch(networkingSquads.SquadInvite.API({
			squadId = squadId,
			parentChannelId = parentChannelId,
			invitedUserIds = invitedUserIds,
			isReparented = isReparented
		})):andThen(function()
			callback({
				isSuccess = true,
				inviteeUserIds = encodeInvitees(invitedUserIds),
				inviteeCount = #invitedUserIds,
				userId = tonumber(p)
			})
		end):catch(function(p2)
			local body = p2.Body
			local success, result = pcall(function()
				return HttpService:JSONDecode(body)
			end)
			local errorType

			if success then
				errorType = result.errorType
			end

			local inviteeUserIds = encodeInvitees(invitedUserIds)
			local errorType2

			if p2.StatusCode then
				errorType2 = tostring(p2.StatusCode)
			end

			callback({
				isSuccess = false,
				errorMessage = errorType,
				errorType = errorType2,
				inviteeUserIds = inviteeUserIds,
				inviteeCount = #invitedUserIds,
				userId = tonumber(p)
			})
		end)
	end
end
