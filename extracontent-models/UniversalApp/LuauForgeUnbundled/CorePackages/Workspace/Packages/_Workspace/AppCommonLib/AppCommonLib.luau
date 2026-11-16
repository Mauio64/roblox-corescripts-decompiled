local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Signal")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Immutable")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Color")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Functional")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/AsyncQueue/AsyncQueue")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/AsyncQueue/AsyncQueueTypes")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/IsVRAppBuild")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/GetDefaultQualityLevel")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/isRunningInStudio")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/callOnce")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/memoize")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/OrderedMap")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Text")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Symbol")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Release/ThrottleUserId")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Release/rolloutByApplicationId")
local utils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/utils")
local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/getDeviceType")
local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Create")
local module19 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Logging")
local module20 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/GenerateStringId")
return {
	Signal = module,
	Immutable = module2,
	IsVRAppBuild = module6,
	isSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/isSpatial"),
	isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/isTenFootInterface"),
	connectToIsSpatialChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/connectToIsSpatialChanged"),
	GetDefaultQualityLevel = module7,
	Color = module3,
	Functional = module4,
	callOnce = module9,
	memoize = module10,
	OrderedMap = module11,
	Text = module12,
	Symbol = module13,
	ThrottleUserId = module14,
	rolloutByApplicationId = module15,
	AsyncQueue = module5,
	Utils = utils,
	isRunningInStudio = module8,
	getDeviceType = module17,
	Create = module18,
	Logging = module19,
	GenerateStringId = module20,
	isPlatformSingleSignOnSupported = function(object)
		return object and object.IsSingleSignOnSupported and object:IsSingleSignOnSupported() and true
			or false
	end
}
