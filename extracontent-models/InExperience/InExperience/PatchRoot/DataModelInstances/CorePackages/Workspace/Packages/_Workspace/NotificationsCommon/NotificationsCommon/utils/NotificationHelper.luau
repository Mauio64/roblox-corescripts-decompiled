local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local NotificationsCommon = script:FindFirstAncestor("NotificationsCommon")
local NotificationsCommonParent = NotificationsCommon.Parent
local Cryo = require(NotificationsCommonParent.Cryo)
local type = require(NotificationsCommon.type)
local constants = require(NotificationsCommon.constants)
local v8 = game:DefineFastFlag("FFlagLuaAppFixToastNotificationClosePosition", false)

return {
	calculateToastPosition = function(b1: boolean, b2: boolean, n1: number) -- line: 67
		-- upvalues: v8 (copy), GuiService (copy)
		local n2 = 60

		if v8 and GuiService then
			n2 = GuiService:GetGuiInset().Y + 20
		end

		if b1 then
			if b2 then
				return {
					positionX = 1,
					positionXOffset = -20,
					positionY = 0,
					anchorX = 1,
					anchorY = 0,
					positionYOffset = n1
				}
			end

			return {
				positionX = 0.5,
				positionXOffset = 0,
				positionY = 0,
				anchorX = 0.5,
				anchorY = 0,
				positionYOffset = n1
			}
		end

		if b2 then
			return {
				positionX = 1,
				positionXOffset = 20,
				positionY = 0,
				anchorX = 0,
				anchorY = 0,
				positionYOffset = n1
			}
		end

		return {
			positionX = 0.5,
			positionXOffset = 0,
			positionY = 0,
			anchorX = 0.5,
			anchorY = 1,
			positionYOffset = not v8 and -50 or n2 * -1
		}
	end,
	getDeviceOrientation = function(vector2: Vector2) -- line: 22
		-- upvalues: type (copy)
		if vector2.X > vector2.Y then
			return type.DeviceOrientationEnum.Landscape
		end

		return type.DeviceOrientationEnum.Portrait
	end,
	getNotificationSize = function(b3: boolean, n3: number) -- line: 28
		-- upvalues: constants (copy)
		if n3 < constants.FullWidthDeviceThreshold then
			return UDim2.new(0, n3 - 24, 0, 0)
		end

		if b3 then
			if n3 < constants.CompactCardThreashold then
				return UDim2.new(0, constants.InExperienceToastWidth, 0, 0)
			end

			return UDim2.new(0, constants.InAppToastWidth, 0, 0)
		end

		return UDim2.new(0, constants.InAppToastWidth, 0, 0)
	end,
	marshalStreamNotificationData = function(p1, _: number?) -- line: 42
		local t1 = {
			currentState = p1.content.currentState,
			notificationType = p1.content.notificationType,
			id = p1.id
		}

		if p1.content.states then
			local v15 = p1.content.states[p1.content.currentState]

			t1.state = {
				layoutKey = v15.layoutKey,
				name = v15.name,
				visualItems = v15.visualItems
			}
		end

		return t1
	end,
	isToastToRight = function(p2) -- line: 63
		-- upvalues: type (copy)
		if p2 == type.DeviceOrientationEnum.Landscape then
			return true
		end

		return false
	end,
	isDesktopDevice = function() -- line: 141
		-- upvalues: UserInputService (copy)
		local None = Enum.Platform.None

		pcall(function() -- line: 143
			-- upvalues: None (ref), UserInputService (copy)
			None = UserInputService:GetPlatform()
		end)

		return None == Enum.Platform.Windows or (None == Enum.Platform.OSX or None == Enum.Platform.UWP)
	end,
	fireEvent = function(p3, s1: string, s2: string, t2: {[any]: any}?) -- line: 121
		-- upvalues: constants (copy), Cryo (copy)
		local t3 = {
			streamContext = "InApp"
		}

		if s2 == nil or s2 == "" then
			s2 = constants.NotificationsClientEventNameDefault
		end

		p3.sendEventDeferred(s1, s2, Cryo.Dictionary.join(t2, t3))
	end
}
