local HttpService = game:GetService("HttpService")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local cryo = dependencies.Cryo
local networkingSquads = dependencies.NetworkingSquads

local function encodeInvitees(list)
	local mapped = cryo.List.map(list, function(p2)
		return (tonumber(p2))
	end)

	local success, result = pcall(function()
		return HttpService:JSONEncode(mapped)
	end)

	if success then
		return result
	end

	return "[]"
end

return function(p2, p3, p4, list, callback, p5)
	return function(object)
		return object:dispatch(networkingSquads.SquadInvite.API({
			squadId = p2,
			parentChannelId = p3,
			invitedUserIds = list,
			isReparented = p5
		})):andThen(function()
			callback({
				isSuccess = true,
				inviteeUserIds = encodeInvitees(list),
				inviteeCount = #list,
				userId = tonumber(p4)
			})
		end):catch(function(p6)
			local body = p6.Body
			local success, result = pcall(function()
				return HttpService:JSONDecode(body)
			end)

			local errorType = if success then result.errorType else nil

			local v5 = encodeInvitees(list)

			local v8 = if p6.StatusCode then tostring(p6.StatusCode) else nil
			callback({
				isSuccess = false,
				errorMessage = errorType,
				errorType = v8,
				inviteeUserIds = v5,
				inviteeCount = #list,
				userId = tonumber(p4)
			})
		end)
	end
end
