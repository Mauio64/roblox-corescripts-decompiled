local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/addRawValueMethodToEnum")

local v5 = {
	None = "None",
	Apple = "Apple",
	Google = "Google",
	Amazon = "Amazon",
	Xbox = "Xbox",
	UWP = "UWP",
	Web = "Web",
	Maquettes = "Maquettes",
	Palisades = "Palisades"
}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/enumerate")("PaymentPlatform", v5)

addRawValueMethodToEnum(v6, v5)

return v6
