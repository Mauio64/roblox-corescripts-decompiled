local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/Dash")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppStartup/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local linkButton = UIBlox.App.Button.LinkButton

local engineFeature = game:GetEngineFeature("StartupMessageActionButtonEnabled")

local function StartupMessage(props)
	local localizedStrings = props.localizedStrings
	local message = props.message
	local overlayColor = props.overlayColor
	local onDismissed = props.onDismissed
	local onActionButtonActivated = props.onActionButtonActivated
	local screenSize = props.screenSize

	local actionButtonText = if engineFeature then localizedStrings.actionButtonText else nil
	local v5

	if engineFeature then
		local v6 = {}

		if actionButtonText then
			table.insert(v6, {
				buttonType = buttonType.PrimaryContextual,
				props = {
					onActivated = onActionButtonActivated,
					text = actionButtonText
				}
			})
		end

		if not message.isBlocking then
			local v8 = if actionButtonText then buttonType.Secondary else buttonType.PrimarySystem
			local v7 = {
				buttonType = v8,
				props = {
					onActivated = onDismissed,
					text = localizedStrings.buttonText
				}
			}
			table.insert(v6, v7)
		end

		v5 = #v6 > 0 and { buttons = v6 } or nil
	end

	local mapped = Dash.map(props.localizedLinks, function(p2)
		return React.createElement(linkButton, {
			text = p2.label,
			onActivated = function()
				props.onOpenUrl(p2.url, p2.label)
			end
		})
	end)

	local createElement = React.createElement
	local v7 = {
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
	local v10 = {
		screenSize = screenSize,
		title = localizedStrings.titleText or "",
		bodyText = localizedStrings.bodyText or "",
		titleIcon = images["icons/status/error_large"],
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
		v5 = not message.isBlocking and {
			buttons = {
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = onDismissed,
						text = localizedStrings.buttonText
					}
				}
			}
		} or nil
	end

	v10.buttonStackInfo = v5
	return createElement("Frame", v7, {
		InteractiveAlert = createElement2(interactiveAlert, v10)
	})
end

return StartupMessage
