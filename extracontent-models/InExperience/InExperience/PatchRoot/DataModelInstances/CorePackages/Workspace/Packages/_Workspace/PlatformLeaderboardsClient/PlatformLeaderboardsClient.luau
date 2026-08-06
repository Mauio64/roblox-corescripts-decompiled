local v1 = if not game:DefineFastFlag("PlatformLeaderboardEnabled", false) then nil else require(script.PlatformLeaderboardClientStore)
local u2 = nil

return {
	["jest.config"] = script["jest.config"],
	PlatformLeaderboardClientStore = v1,
	getPlatformLeaderboardClientStore = function() -- line: 11
		-- upvalues: u2 (ref), v1 (copy)
		if u2 == nil and v1 ~= nil then
			u2 = v1.new()
		end

		return u2
	end,
	reset = function() -- line: 18
		-- upvalues: u2 (ref)
		if u2 ~= nil then
			u2:destroy()
			u2 = nil
		end
	end
}
