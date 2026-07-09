local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local type = require(ParentParent.type)
local constants = require(ParentParent.constants)
local dependencies = require(ParentParent.dependencies)
local Logger = require(ParentParent.Logger)
local Cryo = dependencies.Cryo
local TimeTrigger = dependencies.ToastNotificationProtocolEnums.TimeTrigger
local FFlagFriendshipNotifsUseSendrExperiment = require(ParentParentParent.SharedFlags).FFlagFriendshipNotifsUseSendrExperiment

local function v12(p1) -- line: 70
	if p1 then
		local t1 = {
			button = nil,
			textBody = nil,
			thumbnail = nil,
			metaAction = nil,
			singleMetaAction = nil
		}

		for _, v in ipairs(p1.visualItems) do
			local v29 = if v.button == nil then if v.textBody == nil then if v.thumbnail == nil then if v.metaAction == nil then v.singleMetaAction == nil and "unknown" or "singleMetaAction" else "metaAction" else "thumbnail" else "textBody" else "button"

			if v29 ~= "unknown" then
				local v30 = t1[v29]
				local v31 = v[v29]

				if v30 then
					table.insert(v30, v31)
				else
					v30 = { v31 }
				end

				t1[v29] = v30
			end
		end

		return {
			layoutKey = p1.layoutKey,
			name = p1.name,
			timeOnScreenMs = p1.timeOnScreenMs,
			visualItems = t1
		}
	end

	return nil
end

local t2 = {
	positionX = 1,
	positionXOffset = -5,
	positionY = 0,
	anchorX = 1,
	anchorY = 0
}
local t3 = {
	positionX = 1,
	positionXOffset = 20,
	positionY = 0,
	anchorX = 0,
	anchorY = 0
}
local t4 = {
	positionX = 0.5,
	positionXOffset = 0,
	positionY = 0,
	anchorX = 0.5,
	anchorY = 0
}
local t5 = {
	positionX = 0.5,
	positionXOffset = 0,
	positionY = 0,
	anchorX = 0.5,
	anchorY = 1
}
local vector2 = Vector2.new(800, 600)

local function v18(b1: boolean, b2: boolean?, vector2_2: Vector2) -- line: 176
	-- upvalues: constants (copy)
	local NotificationRightInset = constants.FRRToastPosition.NotificationRightInset
	local v44 = vector2_2.Y * (constants.FRRToastPosition.NotificationFrameTopScale + constants.FRRToastPosition.NotificationFrameHeightScale) - NotificationRightInset - vector2_2.Y
	local v45 = -constants.FRRToastPosition.NotificationRightInset
	local t6 = {
		positionX = 1,
		positionY = 1,
		anchorX = 1,
		anchorY = 1,
		positionXOffset = v45,
		positionYOffset = v44
	}
	local t7 = {
		positionX = 1,
		positionXOffset = 20,
		positionY = 1,
		anchorX = 0,
		anchorY = 1,
		positionYOffset = v44
	}

	if b1 then
		return t6
	end

	if b2 then
		return t6
	end

	return t7
end

return {
	calculateToastPosition = function(b3: boolean, b4: boolean, n1: number, b5: boolean?, s1: string?, vector2_3: Vector2?) -- line: 210
		-- upvalues: FFlagFriendshipNotifsUseSendrExperiment (copy), vector2 (copy), v18 (copy), GuiService (copy), Cryo (copy), t2 (copy), t4 (copy), t3 (copy), t5 (copy)
		if FFlagFriendshipNotifsUseSendrExperiment and s1 == "legacyBottomRight" then
			local v54 = vector2_3 or (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or vector2)

			return (v18(b3, b5, v54))
		end

		local v55 = if not GuiService then Vector2.new(0, 0) else GuiService:GetGuiInset()
		local v56 = not GuiService and 60 or v55.Y + 20

		if b3 then
			if b4 then
				return Cryo.Dictionary.union(t2, {
					positionYOffset = n1
				})
			end

			return Cryo.Dictionary.union(t4, {
				positionYOffset = n1 + v55.Y
			})
		end

		if b4 then
			if b5 then
				return Cryo.Dictionary.union(t2, {
					positionYOffset = n1
				})
			end

			return Cryo.Dictionary.union(t3, {
				positionYOffset = n1
			})
		end

		if b5 then
			return Cryo.Dictionary.union(t4, {
				positionYOffset = n1 + v55.Y
			})
		end

		return Cryo.Dictionary.union(t5, {
			positionYOffset = -1 * v56
		})
	end,
	getNotificationScript2LegacyToastOffsets = if not FFlagFriendshipNotifsUseSendrExperiment then nil else function(vector2_4: Vector2) -- line: 169
		-- upvalues: constants (copy)
		local NotificationRightInset = constants.FRRToastPosition.NotificationRightInset
		local v39 = vector2_4.Y * (constants.FRRToastPosition.NotificationFrameTopScale + constants.FRRToastPosition.NotificationFrameHeightScale) - NotificationRightInset - vector2_4.Y

		return -constants.FRRToastPosition.NotificationRightInset, v39
	end,
	calculateTimeRemaining = function(p2, n2: number?, n3: number?) -- line: 307
		-- upvalues: TimeTrigger (copy)
		local v66 = n2 or DateTime.now().UnixTimestampMillis
		local v67 = n3 or DateTime.now().UnixTimestampMillis
		local n4 = 0

		if p2.trigger == TimeTrigger.OnReceive then
			n4 = p2.timespanMs - (DateTime.now().UnixTimestampMillis - v66)
		elseif p2.trigger == TimeTrigger.OnDisplay then
			n4 = p2.timespanMs - (DateTime.now().UnixTimestampMillis - v67)
		end

		return (math.max(n4, 0))
	end,
	getDeviceOrientation = function(vector2_5: Vector2) -- line: 23
		-- upvalues: type (copy)
		if vector2_5.X > vector2_5.Y then
			return type.DeviceOrientationEnum.Landscape
		end

		return type.DeviceOrientationEnum.Portrait
	end,
	getNotificationSize = function(b6: boolean, n5: number) -- line: 29
		-- upvalues: constants (copy)
		if n5 < constants.FullWidthDeviceThreshold then
			return UDim2.new(0, n5 - 24, 0, 0)
		end

		if b6 then
			if n5 < constants.CompactCardThreashold then
				return UDim2.new(0, constants.InExperienceToastWidth, 0, 0)
			end

			return UDim2.new(0, constants.InAppToastWidth, 0, 0)
		end

		return UDim2.new(0, constants.InAppToastWidth, 0, 0)
	end,
	marshalNotificationData = function(p3) -- line: 97
		-- upvalues: v12 (copy)
		local t8 = {
			currentState = p3.content.currentState,
			notificationType = p3.content.notificationType,
			id = p3.content.id,
			priority = p3.content.priority,
			clientEventsPayload = p3.content.clientEventsPayload,
			deliverTimestamp = p3.deliverTimestamp,
			notificationReceivedTimestampMs = p3.notificationReceivedTimestampMs,
			timers = p3.content.timers,
			luaNotifInfo = p3.luaNotifInfo
		}

		if p3.content.states then
			t8.state = v12(p3.content.states[p3.content.currentState])
		end

		return t8
	end,
	isToastToRight = function(p4) -- line: 120
		-- upvalues: type (copy)
		if p4 == type.DeviceOrientationEnum.Landscape then
			return true
		end

		return false
	end,
	isDesktopDevice = function() -- line: 261
		-- upvalues: UserInputService (copy)
		local None = Enum.Platform.None

		pcall(function() -- line: 263
			-- upvalues: None (ref), UserInputService (copy)
			None = UserInputService:GetPlatform()
		end)

		return None == Enum.Platform.Windows or (None == Enum.Platform.OSX or None == Enum.Platform.UWP)
	end,
	getNearestWholeNumber = function(n6: number) -- line: 274
		if n6 % 1 < 0.5 then
			return (math.floor(n6))
		end

		return (math.ceil(n6))
	end,
	getTimerFromCardData = function(p5, s2: string) -- line: 289
		-- upvalues: Logger (copy), TimeTrigger (copy)
		if p5 and (p5.timers and p5.timers[s2]) then
			return p5.timers[s2]
		end

		Logger:warning("timerKey {} not found in list of timers. Using default.", s2)

		return {
			timespanMs = 0,
			trigger = TimeTrigger.OnDisplay
		}
	end,
	fireEvent = function(p6, t9: {[any]: any}?) -- line: 255
		p6.sendEventDeferred("ToastNotification", "toastNotificationClientEvent", t9)
	end,
	isUserThumbnail = function(p7) -- line: 326
		-- upvalues: type (copy)
		return p7.idType == type.SENDERThumbnailTypeEnum.User or p7.idType == type.SENDERThumbnailTypeEnum.AvatarImageUrl
	end
}
