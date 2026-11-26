local module = require("@luauforge/bundled/ecq")

return {
	get = function(p2)
		local v5 = module.get(p2)

		return {
			inviteePageLoad = function(p3, p4)
				v5.EventStream:setRBXEventStream("profileShareLink", "luaPageLoad", {
					target = "mobile",
					referringUserId = p3,
					page = p4
				})
			end,
			inviterButtonClick = function(p3)
				v5.EventStream:setRBXEventStream("profileShareLink", "buttonClick", {
					btn = "userShareProfileLink",
					target = "mobile",
					page = p3
				})
			end
		}
	end
}
