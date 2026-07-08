local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local PromptRequestReducer = require(script.PromptRequestReducer)

return (Rodux.combineReducers({
	promptRequest = PromptRequestReducer
}))
