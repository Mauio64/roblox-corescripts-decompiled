local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local NotificationsCommon = script:FindFirstAncestor("NotificationsCommon")
local parent = NotificationsCommon.Parent
local Cryo = require(parent.Cryo)

local kind = require(NotificationsCommon.type)
local constants = require(NotificationsCommon.constants)

local defineFastFlag = game:DefineFastFlag("FFlagLuaAppFixToastNotificationClosePosition", false)
local NotificationHelper = {}

function NotificationHelper.calculateToastPosition(flag: boolean, flag2: boolean, positionYOffset: number)
	local v = not (defineFastFlag and GuiService) and 60 or GuiService:GetGuiInset().Y + 20

	if flag then
		if flag2 then
			return {
				positionX = 1,
				positionXOffset = -20,
				positionY = 0,
				positionYOffset = positionYOffset,
				anchorX = 1,
				anchorY = 0
			}
		end

		return {
			positionX = 0.5,
			positionXOffset = 0,
			positionY = 0,
			positionYOffset = positionYOffset,
			anchorX = 0.5,
			anchorY = 0
		}
	elseif flag2 then
		return {
			positionX = 1,
			positionXOffset = 20,
			positionY = 0,
			positionYOffset = positionYOffset,
			anchorX = 0,
			anchorY = 0
		}
	else
		return {
			positionX = 0.5,
			positionXOffset = 0,
			positionY = 0,
			positionYOffset = not defineFastFlag and -50 or v * -1,
			anchorX = 0.5,
			anchorY = 1
		}
	end
end

function NotificationHelper.getDeviceOrientation(vector2: Vector2)
	if vector2.X > vector2.Y then
		return kind.DeviceOrientationEnum.Landscape
	end

	return kind.DeviceOrientationEnum.Portrait
end

function NotificationHelper.getNotificationSize(flag: boolean, p: number)
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

function NotificationHelper.marshalStreamNotificationData(p, _: number?)
	local v = {
		currentState = p.content.currentState,
		notificationType = p.content.notificationType,
		id = p.id
	}

	if p.content.states then
		local state = p.content.states[p.content.currentState]
		v.state = {
			layoutKey = state.layoutKey,
			name = state.name,
			visualItems = state.visualItems
		}
	end

	return v
end

function NotificationHelper.isToastToRight(p): boolean
	return p == kind.DeviceOrientationEnum.Landscape
end

function NotificationHelper.isDesktopDevice(): boolean
	local v = Enum.Platform.None
	pcall(function()
		v = UserInputService:GetPlatform()
	end)
	return v == Enum.Platform.Windows or v == Enum.Platform.OSX or v == Enum.Platform.UWP
end

function NotificationHelper.fireEvent(p, p2: string, p3: string, p4)
	if p3 == nil or p3 == "" then
		p3 = constants.NotificationsClientEventNameDefault
	end

	p.sendEventDeferred(p2, p3, Cryo.Dictionary.join(p4, { streamContext = "InApp" }))
end

return NotificationHelper
