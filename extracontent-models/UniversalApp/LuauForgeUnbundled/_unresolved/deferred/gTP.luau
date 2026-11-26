local module = require("@luauforge/deferred/gTQ")

local module2 = require("@luauforge/deferred/gUa")
local module3 = require("@luauforge/deferred/gUe")

return {
	Constants = require("@luauforge/deferred/gUj"),
	Components = {
		PhotoboothMomentsButton = module,
		PhotoboothMomentsFullViewButton = module2,
		PhotoboothMomentsPage = module3
	},
	Stores = { GetPhotoboothMomentsStore = require("@luauforge/deferred/gUq") },
	Utils = {
		buildAvatarMomentLookRequest = require("@luauforge/deferred/gUG"),
		playPhotoboothMomentsR6Wave = require("@luauforge/deferred/gUH")
	}
}
