local installReducer = require(script.installReducer)

require(script.types)

local enums = require(script.enums)
local network = require(script.network)
local ExperienceDetailsModel = require(script.Models.ExperienceDetailsModel)
local ExperienceMediaModel = require(script.Models.ExperienceMediaModel)

return {
	RoduxKey = "VirtualEvents",
	installReducer = installReducer,
	enums = enums,
	network = network,
	ExperienceDetailsModel = ExperienceDetailsModel,
	ExperienceMediaModel = ExperienceMediaModel,
	["jest.config"] = script["jest.config"]
}
