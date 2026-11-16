local module = require("@game/CorePackages/Workspace/Packages/_Index/EconomyCommonCoreScriptHooks/EconomyCommonCoreScriptHooks/NetworkContext")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/EconomyCommonCoreScriptHooks/EconomyCommonCoreScriptHooks/ScreenSizeContext")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/EconomyCommonCoreScriptHooks/EconomyCommonCoreScriptHooks/useFocusNavigationSurface")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/EconomyCommonCoreScriptHooks/EconomyCommonCoreScriptHooks/useNetwork")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/EconomyCommonCoreScriptHooks/EconomyCommonCoreScriptHooks/useScreenSize")
return {
	NetworkContext = module,
	ScreenSizeContext = module2,
	FocusNavigationModalSurface = require("@game/CorePackages/Workspace/Packages/_Index/EconomyCommonCoreScriptHooks/EconomyCommonCoreScriptHooks/FocusNavigationModalSurface"),
	useFocusNavigationSurface = module3,
	useNetwork = module4,
	useScreenSize = module5
}
