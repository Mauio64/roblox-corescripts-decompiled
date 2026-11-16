local parent = script.Parent.Parent
local parent2 = parent.Parent
local addRawValueMethodToEnum = require(parent.Utility.addRawValueMethodToEnum)
local enumerate = require(parent2.enumerate)

local v = {
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

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
