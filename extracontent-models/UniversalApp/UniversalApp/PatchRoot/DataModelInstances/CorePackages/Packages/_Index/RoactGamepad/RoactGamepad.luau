local createFocusableCache = require(script.createFocusableCache)

local RoactGamepad = {
	createRefCache = require(script.createRefCache),
	Focusable = createFocusableCache(),
	Input = 0,
	withFocusController = 0,
	createFocusController = 0,
	useRootFocusController = 0,
	useFocusController = 0,
	useRefCache = 0,
	FocusContext = 0,
	Config = 0
}
local Input = require(script.Input)
RoactGamepad.Input = Input.PublicInterface

RoactGamepad.withFocusController = require(script.withFocusController)
local FocusController = require(script.FocusController)
RoactGamepad.createFocusController = FocusController.createPublicApiWrapper

RoactGamepad.useRootFocusController = require(script.useRootFocusController)
RoactGamepad.useFocusController = require(script.useFocusController)
RoactGamepad.useRefCache = require(script.useRefCache)

RoactGamepad.FocusContext = require(script.FocusContext)

RoactGamepad.Config = require(script.Config)

return RoactGamepad
