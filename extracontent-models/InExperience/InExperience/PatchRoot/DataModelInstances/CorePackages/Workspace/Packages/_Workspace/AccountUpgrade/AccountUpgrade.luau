local AccountUpgradeAppShellFlow = require(script.AppShell.AccountUpgradeAppShellFlow)
local AccountUpgradeField = require(script.AccountUpgradeField)
local AccountUpgradeError = require(script.AccountUpgradeError)
local AccountUpgradeFlow = require(script.AccountUpgradeFlow)
local Eligibility = require(script.Eligibility)
local FlowSpec = require(script.FlowSpec)
local InExperienceController = require(script.InExperience.InExperienceController)
require(script.Components.useAccountUpgradeViewModel)

return {
	AccountUpgradeAppShellFlow = AccountUpgradeAppShellFlow,
	AccountUpgradeField = AccountUpgradeField,
	AccountUpgradeError = AccountUpgradeError,
	AccountUpgradeFlow = AccountUpgradeFlow,
	Components = require(script.Components),
	Eligibility = Eligibility,
	FlowSpec = FlowSpec,
	Hooks = require(script.Hooks),
	InExperienceController = InExperienceController,
	Utils = require(script.Utils),
	SuccessModal = require(script.SuccessModal),
	["jest.config"] = script["jest.config"]
}
