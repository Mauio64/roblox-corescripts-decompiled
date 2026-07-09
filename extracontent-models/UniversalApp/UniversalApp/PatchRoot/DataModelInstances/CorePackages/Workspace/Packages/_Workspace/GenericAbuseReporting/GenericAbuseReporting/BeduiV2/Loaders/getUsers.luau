local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Foundation = require(Parent.Foundation)
local Promise = require(Parent.Promise)
local AccessoryType = Foundation.Enums.AccessoryType

local function getUsers() -- line: 15
	-- upvalues: Promise (copy), Players (copy), LocalPlayer (copy), AccessoryType (copy)
	return Promise.new(function(resolve, reject) -- line: 16
		-- upvalues: Players (copy), LocalPlayer (copy), AccessoryType (copy)
		local ok, result = pcall(function() -- line: 17
			-- upvalues: Players (copy), LocalPlayer (copy), AccessoryType (copy)
			local players = Players:GetPlayers()

			table.sort(players, function(p1, p2) -- line: 19
				return p1.Name:lower() < p2.Name:lower()
			end)

			local t1 = {}

			for _, v in ipairs(players) do
				if not LocalPlayer or v.UserId ~= LocalPlayer.UserId then
					table.insert(t1, {
						leading = {
							type = AccessoryType.Avatar,
							userId = v.UserId
						},
						id = tostring(v.UserId),
						label = v.DisplayName,
						description = v.Name,
						meta = {
							username = v.Name,
							displayName = v.DisplayName
						}
					})
				end
			end

			return t1
		end)

		if ok then
			resolve(result)

			return
		end

		reject(result)
	end)
end

return getUsers
