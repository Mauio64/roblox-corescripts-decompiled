local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local parent = script.Parent.Parent
local parent2 = parent.Parent
local kind = require(parent.type)
local constants = require(parent.constants)
local dependencies = require(parent.dependencies)
local Logger = require(parent.Logger)
local cryo = dependencies.Cryo
local timeTrigger = dependencies.ToastNotificationProtocolEnums.TimeTrigger
local SharedFlags = require(parent2.SharedFlags)
local FFlagFriendshipNotifsUseSendrExperiment = SharedFlags.FFlagFriendshipNotifsUseSendrExperiment

local function fn(list, p) -- 1 equivalent call inferred from this helper
	if not list then
		return { p }
	end

	table.insert(list, p)
	return list
end

local function fn2(visualItem): string -- 1 equivalent call inferred from this helper
	if visualItem.button ~= nil then
		return "button"
	end

	if visualItem.textBody ~= nil then
		return "textBody"
	end

	if visualItem.thumbnail ~= nil then
		return "thumbnail"
	end

	if visualItem.metaAction ~= nil then
		return "metaAction"
	end

	if visualItem.singleMetaAction == nil then
		return "unknown"
	end

	return "singleMetaAction"
end

local function fn3(data)
	if not data then
		return nil
	end

	local visualItems = {
		button = nil,
		textBody = nil,
		thumbnail = nil,
		metaAction = nil,
		singleMetaAction = nil
	}

	for _, visualItem in ipairs(data.visualItems) do
		local v = fn2(visualItem) -- inferred equivalent call

		if v ~= "unknown" then
			visualItems[v] = fn(visualItems[v], visualItem[v]) -- inferred equivalent call
		end
	end

	return {
		layoutKey = data.layoutKey,
		name = data.name,
		timeOnScreenMs = data.timeOnScreenMs,
		visualItems = visualItems
	}
end

local v = {
	positionX = 1,
	positionXOffset = -5,
	positionY = 0,
	anchorX = 1,
	anchorY = 0
}

local v2 = {
	positionX = 1,
	positionXOffset = 20,
	positionY = 0,
	anchorX = 0,
	anchorY = 0
}

local v3 = {
	positionX = 0.5,
	positionXOffset = 0,
	positionY = 0,
	anchorX = 0.5,
	anchorY = 0
}

local v4 = {
	positionX = 0.5,
	positionXOffset = 0,
	positionY = 0,
	anchorX = 0.5,
	anchorY = 1
}

local vector2 = Vector2.new(800, 600)

local function fn4(vector2_2: Vector2) -- 2 equivalent calls inferred from this helper
	local notificationRightInset = constants.FRRToastPosition.NotificationRightInset
	return vector2_2.Y * (constants.FRRToastPosition.NotificationFrameTopScale + constants.FRRToastPosition.NotificationFrameHeightScale) - notificationRightInset
end

local function fn5(flag: boolean, flag2: boolean?, vector2_2: Vector2)
	local positionYOffset = fn4(vector2_2) - vector2_2.Y -- inferred equivalent call
	local v5 = {
		positionX = 1,
		positionXOffset = -constants.FRRToastPosition.NotificationRightInset,
		positionY = 1,
		positionYOffset = positionYOffset,
		anchorX = 1,
		anchorY = 1
	}

	if flag or flag2 then
		return v5
	end

	return {
		positionX = 1,
		positionXOffset = 20,
		positionY = 1,
		positionYOffset = positionYOffset,
		anchorX = 0,
		anchorY = 1
	}
end

local ToastNotificationHelper = {}

function ToastNotificationHelper.calculateToastPosition(flag: boolean, flag2: boolean, positionYOffset: number, flag3: boolean?, p: string?, vector2_2: Vector2?)
	if FFlagFriendshipNotifsUseSendrExperiment and p == "legacyBottomRight" then
		return fn5(
			flag,
			flag3,
			vector2_2 or workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or vector2
		)
	end

	local v5

	if GuiService then
		v5 = GuiService:GetGuiInset()
	else
		v5 = Vector2.new(0, 0)
	end

	local v6 = not GuiService and 60 or v5.Y + 20

	if flag then
		if flag2 then
			return cryo.Dictionary.union(v, { positionYOffset = positionYOffset })
		end

		return cryo.Dictionary.union(v3, {
			positionYOffset = positionYOffset + v5.Y
		})
	elseif flag2 then
		if flag3 then
			return cryo.Dictionary.union(v, { positionYOffset = positionYOffset })
		end

		return cryo.Dictionary.union(v2, { positionYOffset = positionYOffset })
	elseif flag3 then
		return cryo.Dictionary.union(v3, {
			positionYOffset = positionYOffset + v5.Y
		})
	else
		return cryo.Dictionary.union(v4, {
			positionYOffset = -1 * v6
		})
	end
end

ToastNotificationHelper.getNotificationScript2LegacyToastOffsets = FFlagFriendshipNotifsUseSendrExperiment
	and function(vector2_2: Vector2)
		local v5 = fn4(vector2_2) - vector2_2.Y -- inferred equivalent call
		return -constants.FRRToastPosition.NotificationRightInset, v5
	end
	or nil

function ToastNotificationHelper.calculateTimeRemaining(p, p2: number?, p3: number?)
	local v5 = p2 or DateTime.now().UnixTimestampMillis
	local v6 = p3 or DateTime.now().UnixTimestampMillis
	local v7 = 0

	if p.trigger == timeTrigger.OnReceive then
		v7 = p.timespanMs - (DateTime.now().UnixTimestampMillis - v5)
	elseif p.trigger == timeTrigger.OnDisplay then
		v7 = p.timespanMs - (DateTime.now().UnixTimestampMillis - v6)
	end

	return (math.max(v7, 0))
end

function ToastNotificationHelper.getDeviceOrientation(vector2_2: Vector2)
	if vector2_2.X > vector2_2.Y then
		return kind.DeviceOrientationEnum.Landscape
	end

	return kind.DeviceOrientationEnum.Portrait
end

function ToastNotificationHelper.getNotificationSize(flag: boolean, p: number)
	if p < constants.FullWidthDeviceThreshold then
		return UDim2.new(0, p - 24, 0, 0)
	end

	if not flag then
		return UDim2.new(0, constants.InAppToastWidth, 0, 0)
	end

	if p < constants.CompactCardThreashold then
		return UDim2.new(0, constants.InExperienceToastWidth, 0, 0)
	end

	return UDim2.new(0, constants.InAppToastWidth, 0, 0)
end

function ToastNotificationHelper.marshalNotificationData(data)
	local v5 = {
		currentState = data.content.currentState,
		notificationType = data.content.notificationType,
		id = data.content.id,
		priority = data.content.priority,
		clientEventsPayload = data.content.clientEventsPayload,
		deliverTimestamp = data.deliverTimestamp,
		notificationReceivedTimestampMs = data.notificationReceivedTimestampMs,
		timers = data.content.timers,
		luaNotifInfo = data.luaNotifInfo
	}

	if data.content.states then
		v5.state = fn3(data.content.states[data.content.currentState])
	end

	return v5
end

function ToastNotificationHelper.isToastToRight(p): boolean
	return p == kind.DeviceOrientationEnum.Landscape
end

function ToastNotificationHelper.isDesktopDevice(): boolean
	local v5 = Enum.Platform.None
	pcall(function()
		v5 = UserInputService:GetPlatform()
	end)
	return v5 == Enum.Platform.Windows or v5 == Enum.Platform.OSX or v5 == Enum.Platform.UWP
end

function ToastNotificationHelper.getNearestWholeNumber(p: number)
	if p % 1 < 0.5 then
		return (math.floor(p))
	end

	return (math.ceil(p))
end

function ToastNotificationHelper.getTimerFromCardData(p, p2: string)
	if p and p.timers and p.timers[p2] then
		return p.timers[p2]
	end

	Logger:warning("timerKey {} not found in list of timers. Using default.", p2)
	return { timespanMs = 0, trigger = timeTrigger.OnDisplay }
end

function ToastNotificationHelper.fireEvent(p, p2)
	p.sendEventDeferred("ToastNotification", "toastNotificationClientEvent", p2)
end

function ToastNotificationHelper.isUserThumbnail(p): boolean
	return p.idType == kind.SENDERThumbnailTypeEnum.User or p.idType == kind.SENDERThumbnailTypeEnum.AvatarImageUrl
end

return ToastNotificationHelper
