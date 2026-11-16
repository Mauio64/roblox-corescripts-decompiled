local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo
local Rodux = InGameMenuDependencies.Rodux

local parent = script.Parent.Parent

local SetRespawning = require(parent.Actions.SetRespawning)
local SetRespawnBehavior = require(parent.Actions.SetRespawnBehavior)
local SetMenuOpen = require(parent.Actions.SetMenuOpen)
local SetCurrentPage = require(parent.Actions.SetCurrentPage)

return Rodux.createReducer({ dialogOpen = false, enabled = true, customCallback = nil }, {
	[SetRespawning.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { dialogOpen = p2.respawning })
	end,
	[SetMenuOpen.name] = function(p, p2)
		if p2.menuOpen then
			return p
		end

		return Cryo.Dictionary.join(p, { dialogOpen = false })
	end,
	[SetCurrentPage.name] = function(p, _)
		return Cryo.Dictionary.join(p, { dialogOpen = false })
	end,
	[SetRespawnBehavior.name] = function(p, p2)
		local dialogOpen = p.dialogOpen

		if not p2.respawnEnabled then
			dialogOpen = false
		end

		return {
			customCallback = p2.customCallback,
			enabled = p2.respawnEnabled,
			dialogOpen = dialogOpen
		}
	end
})
