local module = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Experiments/useAuthEntryVariant")

return {
	enrolledInLuafiedRecoveryExperiment = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Experiments/enrolledInLuafiedRecoveryExperiment"),
	AuthEntryVariant = module.AuthEntryVariant,
	resolveAuthEntryVariant = module.resolveAuthEntryVariant,
	useAuthEntryVariant = module.useAuthEntryVariant
}
