local module = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums")

return {
	Components = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components"),
	Common = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common"),
	Actions = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Actions"),
	Enums = module,
	Http = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http"),
	Models = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Models"),
	Thunks = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks"),
	Utils = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils"),
	Reducers = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Reducers"),
	Analytics = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Analytics"),
	installReducer = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Reducers/installReducer"),
	RoduxKey = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/Constants").RODUX_KEY,
	Hooks = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Hooks"),
	EventReceivers = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/EventReceivers"),
	Experiments = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Experiments"),
	Stores = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Stores"),
	DesignTokenMappers = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/DesignTokenMappers"),
	Flags = { FFlagEnableCrossDeviceApproverDialog = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/FFlagEnableCrossDeviceApproverDialog") }
}
