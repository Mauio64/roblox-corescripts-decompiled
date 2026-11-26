local module = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/ExternalEventConnection")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/validatePropsWithForwardRef")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/isGamepadInput")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/wasLastInputGamepad")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/withIsGamepadInput")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Components")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Hooks")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Profiling")
require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/types")
local TestIdUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/TestIdUtils")
local TagUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/TagUtils")

return {
	Components = module6,
	Hooks = module7,
	Profiling = module8,
	ExternalEventConnection = module,
	validatePropsWithForwardRef = module2,
	isGamepadInput = module3,
	wasLastInputGamepad = module4,
	withIsGamepadInput = module5,
	getTestId = TestIdUtils.getTestId,
	combineReactTags = TagUtils.combineReactTags
}
