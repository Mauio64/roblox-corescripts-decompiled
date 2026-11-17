local Signal = require(script.Signal)
local Immutable = require(script.Immutable)
local Color = require(script.Color)
local Functional = require(script.Functional)
local AsyncQueue = require(script.AsyncQueue.AsyncQueue)
require(script.AsyncQueue.AsyncQueueTypes)
local IsVRAppBuild = require(script.IsVRAppBuild)
local GetDefaultQualityLevel = require(script.GetDefaultQualityLevel)
local isRunningInStudio = require(script.isRunningInStudio)
local callOnce = require(script.callOnce)
local memoize = require(script.memoize)
local nextWrappedInteger = require(script.nextWrappedInteger)
local OrderedMap = require(script.OrderedMap)
local Text = require(script.Text)
local Symbol = require(script.Symbol)
local ThrottleUserId = require(script.Release.ThrottleUserId)
local rolloutByApplicationId = require(script.Release.rolloutByApplicationId)
local utils = require(script.utils)
local getDeviceType = require(script.getDeviceType)
local Create = require(script.Create)
local Logging = require(script.Logging)
local GenerateStringId = require(script.GenerateStringId)
local isSpatial = require(script.isSpatial)
local isTenFootInterface = require(script.isTenFootInterface)
local connectToIsSpatialChanged = require(script.connectToIsSpatialChanged)

return {
	["jest.config"] = script["jest.config"],
	Signal = Signal,
	Immutable = Immutable,
	IsVRAppBuild = IsVRAppBuild,
	isSpatial = isSpatial,
	isTenFootInterface = isTenFootInterface,
	connectToIsSpatialChanged = connectToIsSpatialChanged,
	GetDefaultQualityLevel = GetDefaultQualityLevel,
	Color = Color,
	Functional = Functional,
	callOnce = callOnce,
	memoize = memoize,
	nextWrappedInteger = nextWrappedInteger,
	OrderedMap = OrderedMap,
	Text = Text,
	Symbol = Symbol,
	ThrottleUserId = ThrottleUserId,
	rolloutByApplicationId = rolloutByApplicationId,
	AsyncQueue = AsyncQueue,
	Utils = utils,
	isRunningInStudio = isRunningInStudio,
	getDeviceType = getDeviceType,
	Create = Create,
	Logging = Logging,
	GenerateStringId = GenerateStringId,
	isPlatformSingleSignOnSupported = function(object)
		return object and object.IsSingleSignOnSupported and object:IsSingleSignOnSupported() and true or false
	end
}
