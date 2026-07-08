local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo
local Rodux = InGameMenuDependencies.Rodux
local ParentParent = script.Parent.Parent
local SetRespawning = require(ParentParent.Actions.SetRespawning)
local SetRespawnBehavior = require(ParentParent.Actions.SetRespawnBehavior)
local SetMenuOpen = require(ParentParent.Actions.SetMenuOpen)
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)

return Rodux.createReducer({
	dialogOpen = false,
	enabled = true,
	customCallback = nil
}, {
	[SetRespawning.name] = function(p1, p2) -- line: 20
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			dialogOpen = p2.respawning
		})
	end,
	[SetMenuOpen.name] = function(p3, p4) -- line: 25
		-- upvalues: Cryo (copy)
		if not p4.menuOpen then
			return Cryo.Dictionary.join(p3, {
				dialogOpen = false
			})
		end

		return p3
	end,
	[SetCurrentPage.name] = function(p5, _) -- line: 35
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			dialogOpen = false
		})
	end,
	[SetRespawnBehavior.name] = function(p7, p8) -- line: 40
		local dialogOpen = p7.dialogOpen

		if not p8.respawnEnabled then
			dialogOpen = false
		end

		return {
			customCallback = p8.customCallback,
			enabled = p8.respawnEnabled,
			dialogOpen = dialogOpen
		}
	end
})
