local enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").enumerate

local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/addRawValueMethodToEnum")

local v5 = {
	None = "None",
	Apple = "Apple",
	Google = "Google",
	Amazon = "Amazon",
	Xbox = "Xbox",
	UWP = "UWP",
	Midas = "Midas",
	Web = "Web",
	Maquettes = "Maquettes",
	Palisades = "Palisades",
	Microsoft = "Microsoft",
	MilkyWay = "MilkyWay",
	Pioneer = "Pioneer"
}

local v6 = enumerate("PaymentPlatform", v5)

addRawValueMethodToEnum(v6, v5)

return v6
