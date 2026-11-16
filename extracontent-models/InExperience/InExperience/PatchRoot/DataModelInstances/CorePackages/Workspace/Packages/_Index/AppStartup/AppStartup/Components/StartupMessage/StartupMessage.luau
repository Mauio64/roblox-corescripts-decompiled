local parent = script:FindFirstAncestor("AppStartup").Parent
local Dash = require(parent.Dash)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local LinkButton = UIBlox.App.Button.LinkButton

local engineFeature = game:GetEngineFeature("StartupMessageActionButtonEnabled")

local function StartupMessage(props)
	local localizedStrings = props.localizedStrings
	local message = props.message
	local overlayColor = props.overlayColor
	local onDismissed = props.onDismissed
	local onActionButtonActivated = props.onActionButtonActivated
	local screenSize = props.screenSize
	local actionButtonText

	if engineFeature then
		actionButtonText = localizedStrings.actionButtonText
	end

	local buttonStackInfo

	if engineFeature then
		local buttons = {}

		if actionButtonText then
			table.insert(buttons, {
				buttonType = ButtonType.PrimaryContextual,
				props = { onActivated = onActionButtonActivated, text = actionButtonText }
			})
		end

		if not message.isBlocking then
			local buttonType

			if actionButtonText then
				buttonType = ButtonType.Secondary
			else
				buttonType = ButtonType.PrimarySystem
			end

			local v = {
				buttonType = buttonType,
				props = { onActivated = onDismissed, text = localizedStrings.buttonText }
			}
			table.insert(buttons, v)
		end

		buttonStackInfo = #buttons > 0 and { buttons = buttons } or nil
	end

	local mapped = Dash.map(props.localizedLinks, function(p)
		return React.createElement(LinkButton, {
			text = p.label,
			onActivated = function()
				props.onOpenUrl(p.url, p.label)
			end
		})
	end)

	local createElement = React.createElement
	local v = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = message.isBlocking and 0 or overlayColor.Transparency,
		BackgroundColor3 = overlayColor.Color3,
		Active = true,
		ref = props.focusNavRef,
		SelectionGroup = true,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	}

	local createElement2 = React.createElement
	local v2 = {
		screenSize = screenSize,
		title = localizedStrings.titleText or "",
		bodyText = localizedStrings.bodyText or "",
		titleIcon = Images["icons/status/error_large"],
		middleContent = function()
			return React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BorderSizePixel = 0,
					BackgroundTransparency = 1
				},
				Dash.append({
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					})
				}, mapped)
			)
		end,
		buttonStackInfo = 0
	}

	if not engineFeature then
		buttonStackInfo = not message.isBlocking and {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onDismissed, text = localizedStrings.buttonText }
				}
			}
		} or nil
	end

	v2.buttonStackInfo = buttonStackInfo
	return createElement("Frame", v, {
		InteractiveAlert = createElement2(InteractiveAlert, v2)
	})
end

return StartupMessage
