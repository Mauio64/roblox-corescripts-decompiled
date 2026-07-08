local scriptParent = script.Parent

require(scriptParent.LuauPolyfill)

local React = require(script.React)

require(script.ReactLazy)
require(scriptParent.Shared)

return React
