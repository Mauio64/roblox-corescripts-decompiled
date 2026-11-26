local module = require("@luauforge/deferred/eil")
local text = require("@luauforge/deferred/eiU").Text

local module2 = require("@luauforge/deferred/emm")

local function FriendingOSAEducationSubtitle(p2)
	local layoutOrder = p2.layoutOrder

	local v5 = module2()

	if v5 then
		return (module.createElement(text, {
			tag = "auto-y grow size-full-0 text-align-x-left text-wrap",
			Text = v5,
			LayoutOrder = layoutOrder
		}))
	end

	return nil
end

return FriendingOSAEducationSubtitle
