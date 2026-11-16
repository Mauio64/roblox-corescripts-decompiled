local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local module = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/constants")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Logger")
local cryo = dependencies.Cryo
local timeTrigger = dependencies.ToastNotificationProtocolEnums.TimeTrigger
local fFlagFriendshipNotifsUseSendrExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/SharedFlags").FFlagFriendshipNotifsUseSendrExperiment

local function fn(data)
	if not data then
		return nil
	end

	local v5 = {
		button = nil,
		textBody = nil,
		thumbnail = nil,
		metaAction = nil,
		singleMetaAction = nil
	}

	for i, visualItem in ipairs(data.visualItems) do
		local v6 = visualItem.button == nil
			and (visualItem.textBody == nil and (visualItem.thumbnail == nil and (visualItem.metaAction == nil and (visualItem.singleMetaAction == nil and "unknown" or "singleMetaAction") or "metaAction") or "thumbnail") or "textBody")
			or "button"

		if v6 == "unknown" then
			continue
		end

		local v7 = v5[v6]
		local v8 = visualItem[v6]

		if v7 then
			table.insert(v7, v8)
		else
			v7 = { v8 }
		end

		v5[v6] = v7
	end

	return {
		layoutKey = data.layoutKey,
		name = data.name,
		timeOnScreenMs = data.timeOnScreenMs,
		visualItems = v5
	}
end

local v5 = {
	positionX = 1,
	positionXOffset = -5,
	positionY = 0,
	anchorX = 1,
	anchorY = 0
}

local v6 = {
	positionX = 1,
	positionXOffset = 20,
	positionY = 0,
	anchorX = 0,
	anchorY = 0
}

local v7 = {
	positionX = 0.5,
	positionXOffset = 0,
	positionY = 0,
	anchorX = 0.5,
	anchorY = 0
}

local v8 = {
	positionX = 0.5,
	positionXOffset = 0,
	positionY = 0,
	anchorX = 0.5,
	anchorY = 1
}

local vector2 = Vector2.new(800, 600)

local function fn2(p2, p3, p4)
	local notificationRightInset = constants.FRRToastPosition.NotificationRightInset
	local v9 = p4.Y * (constants.FRRToastPosition.NotificationFrameTopScale + constants.FRRToastPosition.NotificationFrameHeightScale) - notificationRightInset - p4.Y
	local v10 = {
		positionX = 1,
		positionXOffset = -constants.FRRToastPosition.NotificationRightInset,
		positionY = 1,
		positionYOffset = v9,
		anchorX = 1,
		anchorY = 1
	}

	if p2 or p3 then
		return v10
	end

	return {
		positionX = 1,
		positionXOffset = 20,
		positionY = 1,
		positionYOffset = v9,
		anchorX = 0,
		anchorY = 1
	}
end

return {
	calculateToastPosition = function(p2, p3, p4, p5, p6, p7)
		if fFlagFriendshipNotifsUseSendrExperiment and p6 == "legacyBottomRight" then
			return fn2(
				p2,
				p5,
				p7 or workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or vector2
			)
		end

		local v9 = if GuiService then GuiService:GetGuiInset() else Vector2.new(0, 0)
		local v10 = not GuiService and 60 or v9.Y + 20

		if p2 then
			if p3 then
				return cryo.Dictionary.union(v5, { positionYOffset = p4 })
			end

			return cryo.Dictionary.union(v7, {
				positionYOffset = p4 + v9.Y
			})
		elseif p3 then
			if p5 then
				return cryo.Dictionary.union(v5, { positionYOffset = p4 })
			end

			return cryo.Dictionary.union(v6, { positionYOffset = p4 })
		elseif p5 then
			return cryo.Dictionary.union(v7, {
				positionYOffset = p4 + v9.Y
			})
		else
			return cryo.Dictionary.union(v8, {
				positionYOffset = -1 * v10
			})
		end
	end,
	getNotificationScript2LegacyToastOffsets = fFlagFriendshipNotifsUseSendrExperiment and function(p2)
		local notificationRightInset = constants.FRRToastPosition.NotificationRightInset
		local v9 = p2.Y * (constants.FRRToastPosition.NotificationFrameTopScale + constants.FRRToastPosition.NotificationFrameHeightScale) - notificationRightInset - p2.Y
		return -constants.FRRToastPosition.NotificationRightInset, v9
	end or nil,
	calculateTimeRemaining = function(p2, p3, p4)
		local v9 = p3 or DateTime.now().UnixTimestampMillis
		local v10 = p4 or DateTime.now().UnixTimestampMillis
		local v11 = 0

		if p2.trigger == timeTrigger.OnReceive then
			v11 = p2.timespanMs - (DateTime.now().UnixTimestampMillis - v9)
		elseif p2.trigger == timeTrigger.OnDisplay then
			v11 = p2.timespanMs - (DateTime.now().UnixTimestampMillis - v10)
		end

		return ((math.max)(v11, 0))
	end,
	getDeviceOrientation = function(p2)
		if p2.X > p2.Y then
			return module.DeviceOrientationEnum.Landscape
		end

		return module.DeviceOrientationEnum.Portrait
	end,
	getNotificationSize = function(p2, p3)
		if p3 < constants.FullWidthDeviceThreshold then
			return UDim2.new(0, p3 - 24, 0, 0)
		end

		if not p2 then
			return UDim2.new(0, constants.InAppToastWidth, 0, 0)
		end

		if p3 < constants.CompactCardThreashold then
			return UDim2.new(0, constants.InExperienceToastWidth, 0, 0)
		end

		return UDim2.new(0, constants.InAppToastWidth, 0, 0)
	end,
	marshalNotificationData = function(data)
		local v9 = {
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
			v9.state = fn(data.content.states[data.content.currentState])
		end

		return v9
	end,
	isToastToRight = function(p2): boolean
		return p2 == module.DeviceOrientationEnum.Landscape
	end,
	isDesktopDevice = function(): boolean
		local v9 = Enum.Platform.None
		pcall(function()
			v9 = UserInputService:GetPlatform()
		end)
		return v9 == Enum.Platform.Windows or v9 == Enum.Platform.OSX or v9 == Enum.Platform.UWP
	end,
	getNearestWholeNumber = function(p2)
		if p2 % 1 < 0.5 then
			return (math.floor(p2))
		end

		return (math.ceil(p2))
	end,
	getTimerFromCardData = function(p2, p3)
		if p2 and p2.timers and p2.timers[p3] then
			return p2.timers[p3]
		end

		Logger:warning("timerKey {} not found in list of timers. Using default.", p3)
		return { timespanMs = 0, trigger = timeTrigger.OnDisplay }
	end,
	fireEvent = function(p2, p3)
		p2.sendEventDeferred("ToastNotification", "toastNotificationClientEvent", p3)
	end,
	isUserThumbnail = function(p2): boolean
		return p2.idType == module.SENDERThumbnailTypeEnum.User
			or p2.idType == module.SENDERThumbnailTypeEnum.AvatarImageUrl
	end
}
