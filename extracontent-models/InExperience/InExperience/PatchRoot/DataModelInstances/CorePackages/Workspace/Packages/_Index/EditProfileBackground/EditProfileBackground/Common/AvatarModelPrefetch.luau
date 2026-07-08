local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local Promise = require(Parent.Promise)
local Players = game:GetService("Players")
local t1 = {}
local t2 = {
	prefetch = function(n1: number) -- line: 11
		-- upvalues: t1 (copy), Promise (copy), Players (copy)
		if t1[n1] then
			return
		end

		t1[n1] = Promise.new(function(resolve, reject) -- line: 16
			-- upvalues: Players (copy), n1 (copy)
			local ok, result = pcall(function() -- line: 17
				-- upvalues: Players (copy), n1 (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return Players:CreateHumanoidModelFromUserIdAsync(n1)
				end

				return game.Players:CreateHumanoidModelFromUserId(n1)
			end)

			if ok and result then
				resolve(result)

				return
			end

			reject("CharacterModelCreationFailed")
		end)
	end
}

function t2.get(n2: number) -- line: 32
	-- upvalues: t1 (copy), t2 (copy)
	if t1[n2] then
		return t1[n2]
	end

	t2.prefetch(n2)

	return t1[n2]
end
function t2.clear(n3: number) -- line: 41
	-- upvalues: t1 (copy)
	t1[n3] = nil
end

return t2
