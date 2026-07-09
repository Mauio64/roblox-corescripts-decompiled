local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Immutable = require(Modules.Common.Immutable)
local ConvertUniverseIdToString = require(CorePackages.Workspace.Packages.SharedFlags).ConvertUniverseIdToString
local ReceivedUserPresence = require(CorePackages.Workspace.Packages.UserLib).Actions.ReceivedUserPresence
local User = require(Modules.LuaApp.Models.User)

return function(p1, p2) -- line: 10
	-- upvalues: Immutable (copy), ReceivedUserPresence (copy), User (copy), ConvertUniverseIdToString (copy)
	local u9 = p1 or {}

	local function RemoveUserIdFromMap(p3, p4) -- line: 13
		-- upvalues: u9 (ref), Immutable (copy)
		if p4 then
			local v19 = u9[tostring(p4)]

			if v19 then
				u9 = Immutable.Set(u9, tostring(p4), Immutable.RemoveFromDictionary(v19, p3))
			end
		end
	end
	local function AddUserIdToMap(p5, p6) -- line: 26
		-- upvalues: u9 (ref), Immutable (copy)
		local v22 = u9[p6] or {}

		u9 = Immutable.JoinDictionaries(u9, {
			[p6] = Immutable.JoinDictionaries(v22, {
				[p5] = p5
			})
		})
	end

	if p2.type == ReceivedUserPresence.name then
		local str = tostring(p2.userId)
		local str2 = tostring(p2.previousUniverseId)

		if p2.presence == User.PresenceType.IN_GAME then
			local v14 = ConvertUniverseIdToString(p2.universeId)

			if str2 and v14 ~= str2 and str2 then
				local v15 = u9[tostring(str2)]

				if v15 then
					u9 = Immutable.Set(u9, tostring(str2), Immutable.RemoveFromDictionary(v15, str))
				end
			end

			AddUserIdToMap(str, v14)
		elseif str2 then
			local v16 = u9[tostring(str2)]

			if v16 then
				u9 = Immutable.Set(u9, tostring(str2), Immutable.RemoveFromDictionary(v16, str))
			end
		end
	end

	return u9
end
