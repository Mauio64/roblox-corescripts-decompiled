local installReducer = require(script.installReducer)
require(script.types)
return {
	RoduxKey = "VirtualEvents",
	installReducer = installReducer,
	enums = require(script.enums),
	network = require(script.network),
	ExperienceDetailsModel = require(script.Models.ExperienceDetailsModel),
	ExperienceMediaModel = require(script.Models.ExperienceMediaModel),
	["jest.config"] = script["jest.config"]
}
