local module = require("@luauforge/deferred/gpn")

local module2 = require("@luauforge/deferred/gpx")
local module3 = require("@luauforge/deferred/gpB")

return {
	Constants = require("@luauforge/deferred/gpG"),
	Components = {
		PhotoboothMomentsButton = module,
		PhotoboothMomentsFullViewButton = module2,
		PhotoboothMomentsPage = module3
	},
	Stores = { GetPhotoboothMomentsStore = require("@luauforge/deferred/gpN") },
	Utils = {
		buildAvatarMomentLookRequest = require("@luauforge/deferred/gqd"),
		playPhotoboothMomentsR6Wave = require("@luauforge/deferred/gqe")
	}
}
