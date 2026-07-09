local TenFootUiContainer = require(script.Components.TenFootUiContainer)
local TenFootUiGlobalEffects = require(script.Components.TenFootUiGlobalEffects)
local TenFootUiOverflowScreen = require(script.Components.TenFootUiOverflowScreen)
local getOrCreateSurfaceGuiContainer = require(script.getOrCreateSurfaceGuiContainer)
local getOrCreateWorkSpaceContainer = require(script.getOrCreateWorkSpaceContainer)
local Constants = require(script.Constants)

return {
	["jest.config"] = script["jest.config"],
	TenFootUiContainer = TenFootUiContainer,
	TenFootUiOverflowScreen = TenFootUiOverflowScreen,
	TenFootUiGlobalEffects = TenFootUiGlobalEffects,
	Constants = Constants,
	getOrCreateSurfaceGuiContainer = getOrCreateSurfaceGuiContainer,
	getOrCreateWorkSpaceContainer = getOrCreateWorkSpaceContainer,
	Views = require(script.ReactNavigationExtend.Views)
}
