local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local Actions = script.Parent.Parent.Actions
local UpdateHealth = require(Actions.UpdateHealth)
local SetIsDead = require(Actions.SetIsDead)

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)

if CoreGuiCommon.Flags.FFlagTopBarSignalizeHealthBar then
	return nil
end

return (Rodux.createReducer({ isDead = false, currentHealth = 100, maxHealth = 100 }, {
	[UpdateHealth.name] = function(p, p2)
		return { isDead = p.isDead, currentHealth = p2.health, maxHealth = p2.maxHealth }
	end,
	[SetIsDead.name] = function(p, p2)
		return { isDead = p2.isDead, currentHealth = p.currentHealth, maxHealth = p.maxHealth }
	end
}))
