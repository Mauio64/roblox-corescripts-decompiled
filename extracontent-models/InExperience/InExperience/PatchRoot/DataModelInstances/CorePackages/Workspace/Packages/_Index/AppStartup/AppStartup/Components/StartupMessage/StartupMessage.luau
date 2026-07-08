local Parent = script:FindFirstAncestor("AppStartup").Parent
local Dash = require(Parent.Dash)
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local LinkButton = UIBlox.App.Button.LinkButton
local EngineFeature = game:GetEngineFeature("StartupMessageActionButtonEnabled")

local function StartupMessage(t1: {[any]: any}) -- line: 44
	-- upvalues: EngineFeature (copy), ButtonType (copy), Dash (copy), React (copy), LinkButton (copy), InteractiveAlert (copy), Images (copy)
	local localizedStrings = t1.localizedStrings
	local message = t1.message
	local overlayColor = t1.overlayColor
	local onDismissed = t1.onDismissed
	local onActionButtonActivated = t1.onActionButtonActivated
	local screenSize = t1.screenSize
	local v18 = if not EngineFeature then nil else localizedStrings.actionButtonText
	local v19 = nil

	if EngineFeature then
		local t2 = {}

		if v18 then
			table.insert(t2, {
				buttonType = ButtonType.PrimaryContextual,
				props = {
					onActivated = onActionButtonActivated,
					text = v18
				}
			})
		end

		if not message.isBlocking then
			table.insert(t2, {
				buttonType = if not v18 then ButtonType.PrimarySystem else ButtonType.Secondary,
				props = {
					onActivated = onDismissed,
					text = localizedStrings.buttonText
				}
			})
		end

		v19 = if not (#t2 > 0) then nil else {
			buttons = t2
		}
	end

	local v21 = Dash.map(t1.localizedLinks, function(p1) -- line: 80
		-- upvalues: React (copy), LinkButton (copy), t1 (copy)
		return React.createElement(LinkButton, {
			text = p1.label,
			onActivated = function() -- line: 83
				-- upvalues: t1 (copy), p1 (copy)
				t1.onOpenUrl(p1.url, p1.label)
			end
		})
	end)

	return React.createElement("Frame", {
		Active = true,
		SelectionGroup = true,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = if not message.isBlocking then overlayColor.Transparency else 0,
		BackgroundColor3 = overlayColor.Color3,
		ref = t1.focusNavRef,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	}, {
		InteractiveAlert = React.createElement(InteractiveAlert, {
			screenSize = screenSize,
			title = localizedStrings.titleText or "",
			bodyText = localizedStrings.bodyText or "",
			titleIcon = Images["icons/status/error_large"],
			middleContent = function() -- line: 107
				-- upvalues: React (copy), Dash (copy), v21 (copy)
				return React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, Dash.append({
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					})
				}, v21))
			end,
			buttonStackInfo = if not EngineFeature then if not message.isBlocking then {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = onDismissed,
						text = localizedStrings.buttonText
					}
				}}
			} else nil else v19
		})
	})
end

return StartupMessage
