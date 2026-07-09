local Squads = script:FindFirstAncestor("Squads")
local HttpService = game:GetService("HttpService")
local dependencies = require(Squads.dependencies)
local Cryo = dependencies.Cryo
local NetworkingSquads = dependencies.NetworkingSquads

local function encodeInvitees(t1: {[any]: any}) -- line: 9
	-- upvalues: Cryo (copy), HttpService (copy)
	local v8 = Cryo.List.map(t1, function(p1) -- line: 10
		return (tonumber(p1))
	end)
	local ok, result = pcall(function() -- line: 14
		-- upvalues: HttpService (copy), v8 (copy)
		return HttpService:JSONEncode(v8)
	end)

	if ok then
		return result
	end

	return "[]"
end

return function(s1: string, s2: string, s3: string, t2: {[any]: any}, p2: ((...any) -> ...any), b1: boolean) -- line: 25
	-- upvalues: NetworkingSquads (copy), encodeInvitees (copy), HttpService (copy)
	return function(p3) -- line: 33
		-- upvalues: NetworkingSquads (copy), s1 (copy), s2 (copy), t2 (copy), b1 (copy), encodeInvitees (copy), p2 (copy), s3 (copy), HttpService (copy)
		return p3:dispatch(NetworkingSquads.SquadInvite.API({
			squadId = s1,
			parentChannelId = s2,
			invitedUserIds = t2,
			isReparented = b1
		})):andThen(function() -- line: 41
			-- upvalues: encodeInvitees (copy), t2 (copy), p2 (copy), s3 (copy)
			local v19 = encodeInvitees(t2)

			p2({
				isSuccess = true,
				inviteeUserIds = v19,
				inviteeCount = #t2,
				userId = tonumber(s3)
			})
		end):catch(function(t3: {[any]: any}) -- line: 51
			-- upvalues: HttpService (copy), encodeInvitees (copy), t2 (copy), p2 (copy), s3 (copy)
			local Body = t3.Body
			local ok, result = pcall(function() -- line: 53
				-- upvalues: HttpService (copy), Body (copy)
				return HttpService:JSONDecode(Body)
			end)
			local v24 = if not ok then nil else result.errorType
			local v25 = encodeInvitees(t2)

			p2({
				isSuccess = false,
				errorMessage = v24,
				errorType = if not t3.StatusCode then nil else tostring(t3.StatusCode),
				inviteeUserIds = v25,
				inviteeCount = #t2,
				userId = tonumber(s3)
			})
		end)
	end
end
