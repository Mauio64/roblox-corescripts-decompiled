local module = require("@luauforge/bundled/hOn")
local module2 = require("@luauforge/bundled/hOo")
require("@luauforge/bundled/hOz")
require("@luauforge/bundled/hOy")

local module3 = require("@luauforge/bundled/hOS")
local module4 = require("@luauforge/bundled/hOV")
require("@luauforge/bundled/hOD")

local defineFastInt = game:DefineFastInt("InAppBugReporterMinCommentLength", 15)

local function BugReporterModalContainer(p2)
	local v5 = module4(module.assign(p2, { minCommentLength = defineFastInt }))

	return module2.createElement(module3, v5)
end

return BugReporterModalContainer
