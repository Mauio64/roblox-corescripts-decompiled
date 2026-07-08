local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent

if require(ParentParent.Flags.FFlagTopBarDeprecateMoreMenuRodux) then
	return nil
end

local Actions = script.Parent.Parent.Actions
local SetMoreMenuOpen = require(Actions.SetMoreMenuOpen)
local SetBackpackOpen = require(Actions.SetBackpackOpen)
local SetEmotesOpen = require(Actions.SetEmotesOpen)
local SetLeaderboardOpen = require(Actions.SetLeaderboardOpen)
local SetEmotesEnabled = require(Actions.SetEmotesEnabled)
local t1 = {
	open = false,
	backpackOpen = false,
	leaderboardOpen = false,
	emotesOpen = false,
	emotesEnabled = true
}

return (Rodux.createReducer(t1, {
	[SetMoreMenuOpen.name] = function(p1, p2) -- line: 30
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			open = p2.open
		})
	end,
	[SetBackpackOpen.name] = function(p3, p4) -- line: 36
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			open = false,
			backpackOpen = p4.open
		})
	end,
	[SetEmotesOpen.name] = function(p5, p6) -- line: 43
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			open = false,
			emotesOpen = p6.open
		})
	end,
	[SetEmotesEnabled.name] = function(p7, p8) -- line: 50
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			emotesEnabled = p8.enabled
		})
	end,
	[SetLeaderboardOpen.name] = function(p9, p10) -- line: 56
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p9, {
			open = false,
			leaderboardOpen = p10.open
		})
	end
}))
