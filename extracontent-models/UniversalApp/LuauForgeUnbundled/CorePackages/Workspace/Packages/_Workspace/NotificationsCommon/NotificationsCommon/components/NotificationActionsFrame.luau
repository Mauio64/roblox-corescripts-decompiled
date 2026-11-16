local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/dependencies")
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Foundation")
local useStyle = uiBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type")
local buttonStack = uiBlox.App.Button.ButtonStack
local buttonType = uiBlox.App.Button.Enum.ButtonType
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/constants")
local defaultContentPadding = constants.DefaultContentPadding
local defaultButtonHeight = constants.DefaultButtonHeight

local useNotificationCardState = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/useNotificationCardState")
local useNotificationCardData = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/useNotificationCardData")

local function fn(list, handleActions, notificationPayload)
	local v5 = useStyle()
	local v6 = if foundationFontFaceMigration then useTokens() else nil
	local v7 = if foundationFontFaceMigration then v6.Typography.CaptionLarge else v5.Font.CaptionHeader

	local result = {}

	if not list then
		return result
	end

	for i, item in ipairs(list) do
		local buttonStyle = item.buttonStyle
		local v9

		if buttonStyle == module3.SENDERButtonStyleEnum.Growth then
			v9 = buttonType.PrimaryContextual
		elseif buttonStyle == module3.SENDERButtonStyleEnum.Primary then
			v9 = buttonType.PrimarySystem
		elseif buttonStyle == module3.SENDERButtonStyleEnum.Secondary then
			v9 = buttonType.Secondary
		elseif buttonStyle == module3.SENDERButtonStyleEnum.Alert then
			v9 = buttonType.Alert
		else
			v9 = buttonType.Secondary
		end

		local v8 = {
			buttonType = v9,
			props = {
				text = item.label.text,
				fontStyle = v7,
				onActivated = function()
					if handleActions and notificationPayload then
						handleActions(item, notificationPayload)
					end
				end
			}
		}

		table.insert(result, v8)
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
