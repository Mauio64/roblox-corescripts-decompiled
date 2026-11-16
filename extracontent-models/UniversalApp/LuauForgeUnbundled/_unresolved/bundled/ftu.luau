local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/frD")
local enumerate = require(CorePackages.Packages.enumerate)

local v5 = {
	None = "None",
	Apple = "Apple",
	Google = "Google",
	Amazon = "Amazon",
	Xbox = "Xbox",
	UWP = "UWP",
	Web = "Web",
	Maquettes = "Maquettes",
	Palisades = "Palisades",
	Microsoft = "Microsoft",
	MilkyWay = "MilkyWay"
}

local v6 = enumerate("PaymentPlatform", v5)

module(v6, v5)

return v6
