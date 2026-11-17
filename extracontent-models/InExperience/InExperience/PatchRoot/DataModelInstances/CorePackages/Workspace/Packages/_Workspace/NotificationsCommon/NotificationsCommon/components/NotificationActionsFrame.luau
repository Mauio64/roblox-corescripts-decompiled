local parent = script.Parent.Parent
local context = parent.context
local dependencies = require(parent.dependencies)
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local Foundation = require(parent.Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local kind = require(parent.type)
local buttonStack = uiBlox.App.Button.ButtonStack
local buttonType = uiBlox.App.Button.Enum.ButtonType
local constants = require(parent.constants)
local defaultContentPadding = constants.DefaultContentPadding
local defaultButtonHeight = constants.DefaultButtonHeight

local useNotificationCardState = require(context.useNotificationCardState)
local useNotificationCardData = require(context.useNotificationCardData)

local function fn(buttonStyle) -- 1 equivalent call inferred from this helper
	if buttonStyle == kind.SENDERButtonStyleEnum.Growth then
		return buttonType.PrimaryContextual
	end

	if buttonStyle == kind.SENDERButtonStyleEnum.Primary then
		return buttonType.PrimarySystem
	end

	if buttonStyle == kind.SENDERButtonStyleEnum.Secondary then
		return buttonType.Secondary
	end

	if buttonStyle == kind.SENDERButtonStyleEnum.Alert then
		return buttonType.Alert
	end

	return buttonType.Secondary
end

local function fn2(list, handleActions, notificationPayload)
	local captionLarge = useTokens().Typography.CaptionLarge
	local result = {}

	if not list then
		return result
	end

	for _, item in ipairs(list) do
		local v = {
			buttonType = fn(item.buttonStyle), -- inferred equivalent call
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

		table.insert(result, v)
	end

	return result
end

return function()
	local v = useNotificationCardState("button")
	local v2 = useNotificationCardData()
	local buttons = fn2(v, v2.handleActions, v2.notificationPayload)

	if #buttons > 0 then
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
				ActionButtons = buttons and react.createElement(buttonStack, {
					buttonHeight = defaultButtonHeight,
					buttons = buttons,
					marginBetween = defaultContentPadding
				})
			}
		))
	end

	return nil
end
