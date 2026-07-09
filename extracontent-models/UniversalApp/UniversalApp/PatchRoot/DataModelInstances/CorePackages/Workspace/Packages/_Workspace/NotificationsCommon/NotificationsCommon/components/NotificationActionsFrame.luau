local ParentParent = script.Parent.Parent
local context = ParentParent.context
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local useStyle = UIBlox.Core.Style.useStyle
local type = require(ParentParent.type)
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local constants = require(ParentParent.constants)
local DefaultContentPadding = constants.DefaultContentPadding
local DefaultButtonHeight = constants.DefaultButtonHeight
local useNotificationCardState = require(context.useNotificationCardState)
local useNotificationCardData = require(context.useNotificationCardData)

local function v15(p1, p2, p3) -- line: 31
	-- upvalues: useStyle (copy), type (copy), ButtonType (copy)
	local CaptionHeader = useStyle().Font.CaptionHeader
	local t1 = {}

	if p1 then
		for _, v in ipairs(p1) do
			local t2 = {}
			local buttonStyle = v.buttonStyle

			t2.buttonType = if buttonStyle ~= type.SENDERButtonStyleEnum.Growth then if buttonStyle ~= type.SENDERButtonStyleEnum.Primary then if buttonStyle ~= type.SENDERButtonStyleEnum.Secondary then if buttonStyle ~= type.SENDERButtonStyleEnum.Alert then ButtonType.Secondary else ButtonType.Alert else ButtonType.Secondary else ButtonType.PrimarySystem else ButtonType.PrimaryContextual
			t2.props = {
				text = v.label.text,
				fontStyle = CaptionHeader,
				onActivated = function() -- line: 47
					-- upvalues: p2 (copy), p3 (copy), v (copy)
					if p2 and p3 then
						p2(v, p3)
					end
				end
			}
			table.insert(t1, t2)
		end
	end

	return t1
end

return function() -- line: 60
	-- upvalues: useNotificationCardState (copy), useNotificationCardData (copy), v15 (copy), React (copy), DefaultContentPadding (copy), ButtonStack (copy), DefaultButtonHeight (copy)
	local v26 = useNotificationCardState("button")
	local v27 = useNotificationCardData()
	local handleActions = v27.handleActions
	local v29 = v15(v26, handleActions, v27.notificationPayload)

	if #v29 > 0 then
		return (React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, DefaultContentPadding)
			}),
			ActionButtons = v29 and React.createElement(ButtonStack, {
				buttonHeight = DefaultButtonHeight,
				buttons = v29,
				marginBetween = DefaultContentPadding
			})
		}))
	end

	return nil
end
