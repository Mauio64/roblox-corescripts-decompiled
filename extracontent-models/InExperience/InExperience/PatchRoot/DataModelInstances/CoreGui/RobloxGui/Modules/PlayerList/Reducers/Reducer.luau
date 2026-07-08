local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local DisplayOptions = require(script.Parent.DisplayOptions)
local ScreenSize = require(script.Parent.ScreenSize)
local Settings = require(script.Parent.Settings)
local GameStats = require(script.Parent.GameStats)
local Teams = require(script.Parent.Teams)
local TeamNames = require(script.Parent.TeamNames)
local TeamColors = require(script.Parent.TeamColors)
local Players = require(script.Parent.Players)
local PlayerStats = require(script.Parent.PlayerStats)
local PlayerTeam = require(script.Parent.PlayerTeam)
local PlayerIconInfo = require(script.Parent.PlayerIconInfo)
local PlayerRelationship = require(script.Parent.PlayerRelationship)
local PlayerDropDown = require(script.Parent.PlayerDropDown)
local PlayerKeys = require(script.Parent.PlayerKeys)
local v17 = Rodux.combineReducers({
	displayOptions = DisplayOptions,
	screenSize = ScreenSize,
	settings = Settings,
	gameStats = GameStats,
	teams = Teams,
	teamNames = TeamNames,
	teamColors = TeamColors,
	players = Players,
	playerStats = PlayerStats,
	playerTeam = PlayerTeam,
	playerIconInfo = PlayerIconInfo,
	playerRelationship = PlayerRelationship,
	playerDropDown = PlayerDropDown
})

return function(p1, p2) -- line: 42
	-- upvalues: v17 (copy), PlayerKeys (copy)
	local v20 = v17(p1, p2)

	v20.playerKeys = PlayerKeys(p1 and p1.playerKeys or nil, p2, v20)

	return v20
end
