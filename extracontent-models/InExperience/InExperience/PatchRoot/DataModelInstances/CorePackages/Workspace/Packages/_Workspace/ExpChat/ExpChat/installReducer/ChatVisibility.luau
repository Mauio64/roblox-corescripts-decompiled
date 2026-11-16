local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.combineReducers({
	isChatInputBarEnabled = require(script.isChatInputBarEnabled),
	isChatWindowEnabled = require(script.isChatWindowEnabled),
	isChatHotkeyEnabled = require(script.isChatHotkeyEnabled),
	isChannelBarEnabled = require(script.isChannelBarEnabled),
	transparency = require(script.transparency)
})
