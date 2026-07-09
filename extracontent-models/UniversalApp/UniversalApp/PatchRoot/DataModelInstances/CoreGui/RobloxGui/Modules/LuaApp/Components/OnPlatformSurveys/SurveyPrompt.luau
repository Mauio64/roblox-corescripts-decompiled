local CorePackages = game:GetService("CorePackages")
local TelemetryService = game:GetService("TelemetryService")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local withLocalization = require(Modules.LuaApp.withLocalization)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Foundation = require(CorePackages.Packages.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local Constants = require(Modules.LuaApp.Constants)
local v19 = game:DefineFastFlag("EnableSurveyPromptTelemetry", false)
local v20 = game:DefineFastFlag("UpdateCopyAndDesignOfSurveyPrompt", false)
local v21 = Roact.PureComponent:extend("SurveyPrompt")
local t1 = {
	eventName = "SurveyPrompt",
	description = "Interactions with the qualtrics survey prompt",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("SurveyPromptEventThrottleHunderedthsPercent", 0),
	lastUpdated = {
		2025,
		10,
		29
	}
}
local t2 = {
	"addSessionId",
	"addOSInfo",
	"addSessionInfo"
}

local function getPromptText(p1, p2) -- line: 39
	if p2 and p2 ~= "" then
		return p2
	end

	return p1
end

function v21.init(p3) -- line: 47
	-- upvalues: v19 (copy), TelemetryService (copy), t1 (copy), t2 (copy)
	function p3.closePrompt() -- line: 48
		-- upvalues: v19 (copy), TelemetryService (copy), t1 (copy), t2 (copy), p3 (copy)
		if v19 then
			TelemetryService:LogEvent(t1, {
				standardizedFields = t2,
				customFields = {
					action = "closeButton"
				}
			})
		end

		p3.props.closeAlert()
		p3.props.closeFunc()
	end
	function p3.openSurvey() -- line: 62
		-- upvalues: v19 (copy), TelemetryService (copy), t1 (copy), t2 (copy), p3 (copy)
		if v19 then
			TelemetryService:LogEvent(t1, {
				standardizedFields = t2,
				customFields = {
					action = "openButton"
				}
			})
		end

		p3.props.closeAlert()
		p3.props.continueFunc()
	end
end
function v21.render(p4) -- line: 77
	-- upvalues: withLocalization (copy), v20 (copy), React (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy), Roact (copy), Constants (copy), InteractiveAlert (copy), ButtonType (copy)
	return withLocalization({
		titleText = "Feature.QualtricsSurveyPrompt.Heading.Title",
		cancelButtonText = "Feature.QualtricsSurveyPrompt.Action.Close",
		confirmButtonText = "CommonUI.Features.Action.Go",
		titleText2 = "Feature.QualtricsSurveyPrompt.Heading.GiveUsFeedback",
		bodyText2 = "Feature.QualtricsSurveyPrompt.Description.TakeAQuickSurvey",
		cancelButtonText2 = "Feature.QualtricsSurveyPrompt.Action.Cancel",
		confirmButtonText2 = "Feature.QualtricsSurveyPrompt.Action.Continue"
	})(function(p5) -- line: 89
		-- upvalues: p4 (copy), v20 (copy), React (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy), Roact (copy), Constants (copy), InteractiveAlert (copy), ButtonType (copy)
		local titleText = p5.titleText
		local titleText2 = p4.props.titleText
		local v37 = if not titleText2 or titleText2 == "" then titleText else titleText2
		local v38 = p4.props.localization:Format("Feature.QualtricsSurveyPrompt.Description.PromptText", p4.props.displayName)
		local bodyText = p4.props.bodyText
		local v40 = if not bodyText or bodyText == "" then v38 else bodyText
		local cancelButtonText = p5.cancelButtonText
		local cancelButtonText2 = p4.props.cancelButtonText
		local v43 = if not cancelButtonText2 or cancelButtonText2 == "" then cancelButtonText else cancelButtonText2
		local confirmButtonText = p5.confirmButtonText
		local confirmButtonText2 = p4.props.confirmButtonText
		local v46 = if not confirmButtonText2 or confirmButtonText2 == "" then confirmButtonText else confirmButtonText2

		if v20 then
			return (React.createElement(Dialog.Root, {
				hasBackdrop = true,
				size = DialogSize.Small,
				onClose = p4.closePrompt
			}, {
				DialogTitle = React.createElement(Dialog.Title, {
					text = p5.titleText2
				}),
				DialogContent = React.createElement(Dialog.Content, {
					LayoutOrder = 2
				}, {
					DialogText = React.createElement(Dialog.Text, {
						Text = p5.bodyText2
					})
				}),
				DialogActions = React.createElement(Dialog.Actions, {
					LayoutOrder = 3,
					actions = {
						{
							text = p5.cancelButtonText2,
							variant = ButtonVariant.Standard,
							onActivated = p4.closePrompt
						},
						{
							text = p5.confirmButtonText2,
							variant = ButtonVariant.Emphasis,
							onActivated = p4.openSurvey
						}
					}
				})
			}))
		end

		return (Roact.createElement("Frame", {
			BackgroundTransparency = 0.5,
			Active = true,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Constants.Color.BLACK
		}, {
			AlertWindow = Roact.createElement(InteractiveAlert, {
				bodyText = v40,
				title = v37,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = ButtonType.Secondary,
							props = {
								onActivated = p4.closePrompt,
								text = v43
							}
						},
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								onActivated = p4.openSurvey,
								text = v46
							}
						}
					}
				},
				screenSize = p4.props.screenSize
			})
		}))
	end)
end

local v25 = RoactRodux.connect(function(p6, _) -- line: 164
	local v32 = p6.Users[p6.LocalUserId]

	return {
		screenSize = p6.ScreenSize,
		displayName = not v32 and "Robloxian" or (v32.displayName or v32.name)
	}
end, function(p8) -- line: 170
	-- upvalues: CloseCentralOverlay (copy)
	return {
		closeAlert = function() -- line: 172
			-- upvalues: p8 (copy), CloseCentralOverlay (copy)
			return p8(CloseCentralOverlay())
		end
	}
end)(v21)

return (RoactServices.connect({
	localization = RoactLocalization
})(v25))
