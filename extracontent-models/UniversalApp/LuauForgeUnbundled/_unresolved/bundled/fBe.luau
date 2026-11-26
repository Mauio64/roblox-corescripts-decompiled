local module = require("@luauforge/bundled/fBf")

local module2 = require("@luauforge/bundled/fBg")

return { GetRobuxVirtualItemStore = module.createComputed(module2) }
