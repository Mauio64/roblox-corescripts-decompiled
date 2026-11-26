local module = require("@luauforge/bundled/dFu")

local function shouldHideAuthTopCloseButton(p2, p3): boolean
	return p2 == module.Landing and p3 == 1
end

return shouldHideAuthTopCloseButton
