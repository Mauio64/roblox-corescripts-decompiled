local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)

local Actions = script.Parent.Parent.Actions
local AddPlayer = require(Actions.AddPlayer)
local RemovePlayer = require(Actions.RemovePlayer)
local SetPlayerLeaderstat = require(Actions.SetPlayerLeaderstat)

local function createKey(player, name, playerStats)
	local v

	if not (name == nil or playerStats == nil or playerStats[player.UserId] == nil) then
		v = playerStats[player.UserId][name]
	end

	return {
		name = player.DisplayName:upper(),
		stat = v and (tonumber(v) or v)
	}
end

local function PlayerKeys(p, p2, data)
	local name

	if data.gameStats[1] then
		name = data.gameStats[1].name or nil
	end

	if p and name == p.primaryStat then
		if p2.type == AddPlayer.name or p2.type == SetPlayerLeaderstat.name then
			return {
				primaryStat = name,
				keys = Cryo.Dictionary.join(p.keys, {
					[p2.player] = createKey(p2.player, name, data.playerStats)
				})
			}
		end

		if p2.type ~= RemovePlayer.name then
			return p
		end

		return {
			primaryStat = name,
			keys = Cryo.Dictionary.join(p.keys, { [p2.player] = Cryo.None })
		}
	else
		local keys = {}

		for _, player in pairs(data.players) do
			keys[player] = createKey(player, name, data.playerStats)
		end

		return { primaryStat = name, keys = keys }
	end
end

return PlayerKeys
