local CorePackages = game:GetService("CorePackages")
local TelemetryService = game:GetService("TelemetryService")

local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/egY")
local module2 = require("@luauforge/bundled/fCM")
local module3 = require("@luauforge/bundled/egZ")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local Foundation = require(CorePackages.Packages.Foundation)
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize

local module4 = require("@luauforge/bundled/dzD")
local defineFastFlag = game:DefineFastFlag("UpdateCopyAndDesignOfSurveyPrompt", false)

local extended = Roact.PureComponent:extend("SurveyPrompt")

local v5 = {
	eventName = "SurveyPrompt",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("SurveyPromptEventThrottleHunderedthsPercent", 0),
	lastUpdated = { 2025, 10, 29 },
	description = "Interactions with the qualtrics survey prompt"
}

local v6 = { "addSessionId", "addOSInfo", "addSessionInfo" }

local function getPromptText(p2, p3)
	if p3 and p3 ~= "" then
		return p3
	end

	return p2
end

function extended:init()
	function self.closePrompt()
		TelemetryService:LogEvent(v5, {
			standardizedFields = v6,
			customFields = { action = "closeButton" }
		})

		self.props.closeAlert()
		self.props.closeFunc()
	end

	function self.openSurvey()
		TelemetryService:LogEvent(v5, {
			standardizedFields = v6,
			customFields = { action = "openButton" }
		})

		self.props.closeAlert()
		self.props.continueFunc()
	end
end

function extended.render(data)
	return module3({
		titleText = "Feature.QualtricsSurveyPrompt.Heading.Title",
		cancelButtonText = "Feature.QualtricsSurveyPrompt.Action.Close",
		confirmButtonText = "CommonUI.Features.Action.Go",
		titleText2 = "Feature.QualtricsSurveyPrompt.Heading.GiveUsFeedback",
		bodyText2 = "Feature.QualtricsSurveyPrompt.Description.TakeAQuickSurvey",
		cancelButtonText2 = "Feature.QualtricsSurveyPrompt.Action.Cancel",
		confirmButtonText2 = "Feature.QualtricsSurveyPrompt.Action.Continue"
	})(function(props)
		local titleText = props.titleText
		local v7 = data.props.titleText

		if v7 then
			if v7 == "" then
				v7 = titleText
			end
		else
			v7 = titleText
		end

		local formatted = data.props.localization:Format(
			"Feature.QualtricsSurveyPrompt.Description.PromptText",
			data.props.displayName
		)
		local v8 = data.props.bodyText

		if v8 then
			if v8 == "" then
				v8 = formatted
			end
		else
			v8 = formatted
		end

		local cancelButtonText = props.cancelButtonText
		local v9 = data.props.cancelButtonText

		if v9 then
			if v9 == "" then
				v9 = cancelButtonText
			end
		else
			v9 = cancelButtonText
		end

		local confirmButtonText = props.confirmButtonText
		local v10 = data.props.confirmButtonText

		if v10 then
			if v10 == "" then
				v10 = confirmButtonText
			end
		else
			v10 = confirmButtonText
		end

		if defineFastFlag then
			return (React.createElement(
				dialog.Root,
				{
					size = dialogSize.Small,
					hasBackdrop = true,
					onClose = data.closePrompt
				},
				{
					DialogTitle = React.createElement(dialog.Title, {
						text = props.titleText2
					}),
					DialogContent = React.createElement(dialog.Content, {
						LayoutOrder = 2
					}, {
						DialogText = React.createElement(dialog.Text, {
							Text = props.bodyText2
						})
					}),
					DialogActions = React.createElement(dialog.Actions, {
						LayoutOrder = 3,
						actions = {
							{
								text = props.cancelButtonText2,
								variant = buttonVariant.Standard,
								onActivated = data.closePrompt
							},
							{
								text = props.confirmButtonText2,
								variant = buttonVariant.Emphasis,
								onActivated = data.openSurvey
							}
						}
					})
				}
			))
		end

		return (Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = module4.Color.BLACK,
			BackgroundTransparency = 0.5,
			Active = true,
			Selectable = false
		}, {
			AlertWindow = Roact.createElement(interactiveAlert, {
				bodyText = v8,
				title = v7,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = buttonType.Secondary,
							props = { onActivated = data.closePrompt, text = v9 }
						},
						{
							buttonType = buttonType.PrimarySystem,
							props = { onActivated = data.openSurvey, text = v10 }
						}
					}
				},
				screenSize = data.props.screenSize
			})
		}))
	end)
end

local v7 = RoactRodux.connect(function(data, p2)
	local user = data.Users[data.LocalUserId]
	return {
		screenSize = data.ScreenSize,
		displayName = not user and "Robloxian" or user.displayName or user.name
	}
end, function(callback)
	return {
		closeAlert = function()
			return callback(module2())
		end
	}
end)(extended)

return (roactServices.connect({ localization = module })(v7))
