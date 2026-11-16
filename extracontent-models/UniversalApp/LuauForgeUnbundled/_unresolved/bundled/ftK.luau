local module = require("@luauforge/bundled/ftL")

local module2 = require("@luauforge/bundled/ftM")

return { GetRobuxVirtualItemStore = module.createComputed(module2) }
