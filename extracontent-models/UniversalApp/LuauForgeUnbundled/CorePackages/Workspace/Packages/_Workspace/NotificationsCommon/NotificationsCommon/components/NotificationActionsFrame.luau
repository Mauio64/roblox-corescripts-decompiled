local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/dependencies")
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Foundation").Hooks.useTokens
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type")
local buttonStack = uiBlox.App.Button.ButtonStack
local buttonType = uiBlox.App.Button.Enum.ButtonType
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/constants")
local defaultContentPadding = constants.DefaultContentPadding
local defaultButtonHeight = constants.DefaultButtonHeight

local useNotificationCardState = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/useNotificationCardState")
local useNotificationCardData = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/useNotificationCardData")

local function fn(list, handleActions, notificationPayload)
	local captionLarge = useTokens().Typography.CaptionLarge
	local result = {}

	if not list then
		return result
	end

	for i, item in ipairs(list) do
		local buttonStyle = item.buttonStyle
		local v6

		if buttonStyle == module2.SENDERButtonStyleEnum.Growth then
			v6 = buttonType.PrimaryContextual
		elseif buttonStyle == module2.SENDERButtonStyleEnum.Primary then
			v6 = buttonType.PrimarySystem
		elseif buttonStyle == module2.SENDERButtonStyleEnum.Secondary then
			v6 = buttonType.Secondary
		elseif buttonStyle == module2.SENDERButtonStyleEnum.Alert then
			v6 = buttonType.Alert
		else
			v6 = buttonType.Secondary
		end

		local v5 = {
			buttonType = v6,
			props = {
				text = item.label.text,
				fontStyle = captionLarge,
				onActivated = function()
					if handleActions and notificationPayload then
						handleActions(item, notificationPayload)
					end
				end
			}
		}

		table.insert(result, v5)
	end

	return result
end

return function()
	local v5 = useNotificationCardState("button")
	local v6 = useNotificationCardData()
	local v7 = fn(v5, v6.handleActions, v6.notificationPayload)

	if #v7 > 0 then
		return (react.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 3
			},
			{
				UIPadding = react.createElement("UIPadding", {
					PaddingTop = UDim.new(0, defaultContentPadding)
				}),
				ActionButtons = v7 and react.createElement(buttonStack, {
					buttonHeight = defaultButtonHeight,
					buttons = v7,
					marginBetween = defaultContentPadding
				})
			}
		))
	end

	return nil
end
