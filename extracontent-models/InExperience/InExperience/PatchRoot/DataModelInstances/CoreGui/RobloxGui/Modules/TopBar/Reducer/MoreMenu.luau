local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent
local FFlagTopBarDeprecateMoreMenuRodux = require(parent.Flags.FFlagTopBarDeprecateMoreMenuRodux)

if FFlagTopBarDeprecateMoreMenuRodux then
	return nil
end

local Actions = script.Parent.Parent.Actions
local SetMoreMenuOpen = require(Actions.SetMoreMenuOpen)
local SetBackpackOpen = require(Actions.SetBackpackOpen)
local SetEmotesOpen = require(Actions.SetEmotesOpen)
local SetLeaderboardOpen = require(Actions.SetLeaderboardOpen)
local SetEmotesEnabled = require(Actions.SetEmotesEnabled)

return (Rodux.createReducer({
	open = false,
	backpackOpen = false,
	leaderboardOpen = false,
	emotesOpen = false,
	emotesEnabled = true
}, {
	[SetMoreMenuOpen.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { open = p2.open })
	end,
	[SetBackpackOpen.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { open = false, backpackOpen = p2.open })
	end,
	[SetEmotesOpen.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { open = false, emotesOpen = p2.open })
	end,
	[SetEmotesEnabled.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { emotesEnabled = p2.enabled })
	end,
	[SetLeaderboardOpen.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { open = false, leaderboardOpen = p2.open })
	end
}))
