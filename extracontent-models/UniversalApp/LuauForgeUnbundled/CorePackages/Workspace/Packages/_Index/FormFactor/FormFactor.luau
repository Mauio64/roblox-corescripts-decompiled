local module = require("@game/CorePackages/Workspace/Packages/_Index/FormFactor/FormFactor/FormFactor")
return {
	FormFactorReducer = require("@game/CorePackages/Workspace/Packages/_Index/FormFactor/FormFactor/FormFactorReducer"),
	Enums = { FormFactor = module },
	Actions = { SetFormFactor = require("@game/CorePackages/Workspace/Packages/_Index/FormFactor/FormFactor/SetFormFactor") }
}
