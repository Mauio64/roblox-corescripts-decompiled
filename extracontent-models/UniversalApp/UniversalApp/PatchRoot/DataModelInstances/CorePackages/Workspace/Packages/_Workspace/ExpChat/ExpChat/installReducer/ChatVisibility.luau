local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).combineReducers({
	isChatInputBarEnabled = require(script.isChatInputBarEnabled),
	isChatWindowEnabled = require(script.isChatWindowEnabled),
	isChatHotkeyEnabled = require(script.isChatHotkeyEnabled),
	isChannelBarEnabled = require(script.isChannelBarEnabled),
	transparency = require(script.transparency)
})
