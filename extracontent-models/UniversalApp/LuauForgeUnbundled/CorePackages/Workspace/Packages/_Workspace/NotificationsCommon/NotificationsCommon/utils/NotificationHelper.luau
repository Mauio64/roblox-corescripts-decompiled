local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Cryo")

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/constants")

local defineFastFlag = game:DefineFastFlag("FFlagLuaAppFixToastNotificationClosePosition", false)

return {
	calculateToastPosition = function(p2, p3, p4)
		local v5 = not (defineFastFlag and GuiService) and 60 or GuiService:GetGuiInset().Y + 20

		if p2 then
			if p3 then
				return {
					positionX = 1,
					positionXOffset = -20,
					positionY = 0,
					positionYOffset = p4,
					anchorX = 1,
					anchorY = 0
				}
			end

			return {
				positionX = 0.5,
				positionXOffset = 0,
				positionY = 0,
				positionYOffset = p4,
				anchorX = 0.5,
				anchorY = 0
			}
		elseif p3 then
			return {
				positionX = 1,
				positionXOffset = 20,
				positionY = 0,
				positionYOffset = p4,
				anchorX = 0,
				anchorY = 0
			}
		else
			return {
				positionX = 0.5,
				positionXOffset = 0,
				positionY = 0,
				positionYOffset = not defineFastFlag and -50 or v5 * -1,
				anchorX = 0.5,
				anchorY = 1
			}
		end
	end,
	getDeviceOrientation = function(p2)
		if p2.X > p2.Y then
			return module2.DeviceOrientationEnum.Landscape
		end

		return module2.DeviceOrientationEnum.Portrait
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
	marshalStreamNotificationData = function(p2, p3)
		local v5 = {
			currentState = p2.content.currentState,
			notificationType = p2.content.notificationType,
			id = p2.id
		}

		if p2.content.states then
			local state = p2.content.states[p2.content.currentState]
			v5.state = {
				layoutKey = state.layoutKey,
				name = state.name,
				visualItems = state.visualItems
			}
		end

		return v5
	end,
	isToastToRight = function(p2): boolean
		return p2 == module2.DeviceOrientationEnum.Landscape
	end,
	isDesktopDevice = function(): boolean
		local v5 = Enum.Platform.None
		pcall(function()
			v5 = UserInputService:GetPlatform()
		end)
		return v5 == Enum.Platform.Windows or v5 == Enum.Platform.OSX or v5 == Enum.Platform.UWP
	end,
	fireEvent = function(p2, p3, p4, p5)
		if p4 == nil or p4 == "" then
			p4 = constants.NotificationsClientEventNameDefault
		end

		p2.sendEventDeferred(p3, p4, Cryo.Dictionary.join(p5, {
			streamContext = "InApp"
		}))
	end
}
