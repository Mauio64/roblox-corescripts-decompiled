local FormFactor = require(script.FormFactor)
return {
	FormFactorReducer = require(script.FormFactorReducer),
	Enums = { FormFactor = FormFactor },
	Actions = { SetFormFactor = require(script.SetFormFactor) }
}
