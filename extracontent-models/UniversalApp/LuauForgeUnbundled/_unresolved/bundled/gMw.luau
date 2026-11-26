require("@luauforge/bundled/gMx")
local module = require("@luauforge/bundled/gMz")
local module2 = require("@luauforge/bundled/gMA")
local module3 = require("@luauforge/bundled/gMD")
local module4 = require("@luauforge/bundled/gMI")
return {
	Constants = module,
	UIConfiguration = module3,
	ReactServerUIView = module2,
	Navigation = require("@luauforge/bundled/gMK"),
	Hooks = { useNavigator = module4 }
}
