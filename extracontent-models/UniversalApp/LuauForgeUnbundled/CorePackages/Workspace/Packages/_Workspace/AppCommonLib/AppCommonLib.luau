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
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/nextWrappedInteger")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/OrderedMap")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Text")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Symbol")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Release/ThrottleUserId")
local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Release/rolloutByApplicationId")
local utils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/utils")
local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/getDeviceType")
local module19 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Create")
local module20 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Logging")
local module21 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/GenerateStringId")
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
	nextWrappedInteger = module11,
	OrderedMap = module12,
	Text = module13,
	Symbol = module14,
	ThrottleUserId = module15,
	rolloutByApplicationId = module16,
	AsyncQueue = module5,
	Utils = utils,
	isRunningInStudio = module8,
	getDeviceType = module18,
	Create = module19,
	Logging = module20,
	GenerateStringId = module21,
	isPlatformSingleSignOnSupported = function(object)
		return object and object.IsSingleSignOnSupported and object:IsSingleSignOnSupported() and true
			or false
	end
}
