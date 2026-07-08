local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Actions = script.Parent.Parent.Actions
local AddPlayer = require(Actions.AddPlayer)
local RemovePlayer = require(Actions.RemovePlayer)
local SetPlayerLeaderstat = require(Actions.SetPlayerLeaderstat)

local function createKey(p1, p2, p3) -- line: 10
	local v12 = nil

	if p2 ~= nil and (p3 ~= nil and p3[p1.UserId] ~= nil) then
		v12 = p3[p1.UserId][p2]
	end

	return {
		name = p1.DisplayName:upper(),
		stat = v12 and (tonumber(v12) or v12)
	}
end
local function PlayerKeys(p4, p5, p6) -- line: 22
	-- upvalues: createKey (copy), AddPlayer (copy), SetPlayerLeaderstat (copy), Cryo (copy), RemovePlayer (copy)
	local v16 = p6.gameStats[1] and p6.gameStats[1].name or nil

	if not p4 or v16 ~= p4.primaryStat then
		local t1 = {}

		for _, v in pairs(p6.players) do
			t1[v] = createKey(v, v16, p6.playerStats)
		end

		return {
			primaryStat = v16,
			keys = t1
		}
	end

	if p5.type == AddPlayer.name or p5.type == SetPlayerLeaderstat.name then
		return {
			primaryStat = v16,
			keys = Cryo.Dictionary.join(p4.keys, {
				[p5.player] = createKey(p5.player, v16, p6.playerStats)
			})
		}
	end

	if p5.type == RemovePlayer.name then
		return {
			primaryStat = v16,
			keys = Cryo.Dictionary.join(p4.keys, {
				[p5.player] = Cryo.None
			})
		}
	end

	return p4
end

return PlayerKeys
