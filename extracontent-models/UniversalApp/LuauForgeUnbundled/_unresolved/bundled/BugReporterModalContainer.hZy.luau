local module = require("@luauforge/bundled/hYU")
local module2 = require("@luauforge/bundled/hYV")
require("@luauforge/bundled/hZg")
require("@luauforge/bundled/hZf")

local module3 = require("@luauforge/bundled/hZz")
local module4 = require("@luauforge/bundled/hZC")
require("@luauforge/bundled/hZk")

local defineFastInt = game:DefineFastInt("InAppBugReporterMinCommentLength", 15)

local function BugReporterModalContainer(p2)
	local v5 = module4(module.assign(p2, { minCommentLength = defineFastInt }))

	return module2.createElement(module3, v5)
end

return BugReporterModalContainer
