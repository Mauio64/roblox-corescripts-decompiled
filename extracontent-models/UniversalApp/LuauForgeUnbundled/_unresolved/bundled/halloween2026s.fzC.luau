local module = require("@luauforge/bundled/ful")
local module2 = require("@luauforge/bundled/fzD")

local module3 = require("@luauforge/bundled/fup")

local halloween2026s = {}

if module and module2 then
	table.insert(halloween2026s, module3.Halloween2026)
end

return halloween2026s
