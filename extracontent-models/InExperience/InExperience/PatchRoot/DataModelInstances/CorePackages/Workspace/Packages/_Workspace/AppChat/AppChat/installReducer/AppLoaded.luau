local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Rodux = require(parent.Rodux)

local SetAppLoaded = require(AppChat.Actions.SetAppLoaded)

return Rodux.createReducer(false, {
	[SetAppLoaded.name] = function(_, p)
		return p.value
	end
})
