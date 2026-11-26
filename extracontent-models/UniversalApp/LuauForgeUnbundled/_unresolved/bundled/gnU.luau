local module = require("@luauforge/bundled/gnx")

require("@luauforge/bundled/gnD")

return module.createContext({ state = {}, dispatch = nil, parentNavigation = nil })
