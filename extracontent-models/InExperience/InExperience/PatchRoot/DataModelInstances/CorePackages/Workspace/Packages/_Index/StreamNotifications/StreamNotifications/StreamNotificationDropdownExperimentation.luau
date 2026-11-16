local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local parent = StreamNotifications.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagStreamNotificationUXDropdown = SharedFlags.FFlagStreamNotificationUXDropdown
local NotificationsCommon = require(parent.NotificationsCommon)
local ixpHelper = NotificationsCommon.ixpHelper
local constants = require(StreamNotifications.constants)

local defineFastString = game:DefineFastString(
	"StreamNotificationUXExposureLayer",
	"Notifications.StreamNotificationUXExposure"
)

local defineFastString2 = game:DefineFastString("StreamNotificationUXDropdownVariant", "enableStreamDropdown")

local function getIsLargeScreen() -- 2 equivalent calls inferred from this helper
	local currentCamera = workspace.CurrentCamera
	local isLargeScreen

	if currentCamera == nil then
		isLargeScreen = false
	else
		isLargeScreen = currentCamera.ViewportSize.X >= constants.Modal.WidthLimit
	end

	return isLargeScreen
end

local function getIsUserInTreatment(): boolean
	local ixpLayerData = ixpHelper.getIxpLayerData(defineFastString)

	if ixpLayerData and ixpLayerData[defineFastString2] ~= nil then
		return ixpLayerData[defineFastString2] == true
	end

	return false
end

local StreamNotificationDropdownExperimentation = {}

function StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v = FFlagStreamNotificationUXDropdown

	if not v then
		return v
	end

	v = getIsLargeScreen() -- inferred equivalent call

	if not v then
		return v
	end

	local ixpLayerData = ixpHelper.getIxpLayerData(defineFastString)

	if ixpLayerData and ixpLayerData[defineFastString2] ~= nil then
		return ixpLayerData[defineFastString2] == true
	end

	v = false
	return false
end

function StreamNotificationDropdownExperimentation.logExposure()
	if FFlagStreamNotificationUXDropdown and getIsLargeScreen() then -- inferred equivalent call
		local ixpLayerData = ixpHelper.getIxpLayerData(defineFastString)

		if ixpLayerData and ixpLayerData[defineFastString2] ~= nil then
			ixpHelper.logUserLayerExposure(defineFastString)
		end
	end
end

return StreamNotificationDropdownExperimentation
