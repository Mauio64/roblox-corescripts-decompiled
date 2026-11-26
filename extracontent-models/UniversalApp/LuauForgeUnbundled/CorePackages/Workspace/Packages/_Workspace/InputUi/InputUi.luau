local module = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/InputUi/getSafeAreaSize")

return {
	Gamepad = {
		useGamepadDisconnectOverlayEffect = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/InputUi/Gamepad/useGamepadDisconnectOverlayEffect"),
		GamepadDisconnectedModal = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/InputUi/Gamepad/GamepadDisconnectedModal"),
		GamepadDisconnectedModalView = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/InputUi/Gamepad/GamepadDisconnectedModalView"),
		GamepadDisconnectTokenMapper = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/InputUi/Gamepad/GamepadDisconnectTokenMapper"),
		GamepadUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/InputUi/Gamepad/GamepadUtils")
	},
	getSafeAreaSize = module
}
