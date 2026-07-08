local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Actions = script.Parent.Parent.Actions
local UpdateHealth = require(Actions.UpdateHealth)
local SetIsDead = require(Actions.SetIsDead)

if require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeHealthBar then
	return nil
end

local t1 = {
	isDead = false,
	currentHealth = 100,
	maxHealth = 100
}

return (Rodux.createReducer(t1, {
	[UpdateHealth.name] = function(p1, p2) -- line: 25
		return {
			isDead = p1.isDead,
			currentHealth = p2.health,
			maxHealth = p2.maxHealth
		}
	end,
	[SetIsDead.name] = function(p3, p4) -- line: 33
		return {
			isDead = p4.isDead,
			currentHealth = p3.currentHealth,
			maxHealth = p3.maxHealth
		}
	end
}))
