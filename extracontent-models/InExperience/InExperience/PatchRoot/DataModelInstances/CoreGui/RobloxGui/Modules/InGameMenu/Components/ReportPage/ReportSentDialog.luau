local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent.Parent
local Assets = require(parent.Resources.Assets)
local CloseReportSentDialog = require(parent.Actions.CloseReportSentDialog)
local Constants = require(parent.Resources.Constants)

local withLocalization = require(parent.Localization.withLocalization)

local InfoDialog = require(parent.Components.InfoDialog)

local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)

local strictInterface = t.strictInterface({
	isReportSentOpen = t.boolean,
	onDismiss = t.callback,
	inputType = t.optional(t.string)
})

local extended = Roact.PureComponent:extend("ReportSentDialog")

extended.validateProps = strictInterface

function extended:init()
	self.buttonRef = Roact.createRef()
end

function extended:renderFocusHandler()
	return Roact.createElement(FocusHandler, {
		isFocused = self.props.inputType == Constants.InputType.Gamepad and self.props.isReportSentOpen,
		didFocus = function()
			GuiService:RemoveSelectionGroup("ReportSentDialogGroup")
			GuiService:AddSelectionParent("ReportSentDialogGroup", self.buttonRef:getValue())
			GuiService.SelectedCoreObject = self.buttonRef:getValue()

			ContextActionService:BindCoreAction("ReporSentDialogSinkAction", function(_, _)
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonY, Enum.KeyCode.ButtonX)
		end,
		didBlur = function()
			ContextActionService:UnbindCoreAction("ReporSentDialogSinkAction")
			GuiService:RemoveSelectionGroup("ReportSentDialogGroup")
		end
	})
end

function extended:render()
	return withLocalization({
		titleText = "CoreScripts.InGameMenu.Report.ThanksForReport",
		bodyText = "CoreScripts.InGameMenu.Report.WillReviewBody",
		dismissText = "CoreScripts.InGameMenu.Ok"
	})(function(props)
		return Roact.createFragment({
			Dialog = Roact.createElement(InfoDialog, {
				titleText = props.titleText,
				bodyText = props.bodyText,
				dismissText = props.dismissText,
				iconImage = Assets.Images.SuccessTick,
				buttonRef = self.buttonRef,
				onDismiss = self.props.onDismiss,
				visible = self.props.isReportSentOpen
			}),
			FocusHandler = self:renderFocusHandler()
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { isReportSentOpen = p.report.reportSentOpen, inputType = p.displayOptions.inputType }
end, function(callback)
	return {
		onDismiss = function()
			callback(CloseReportSentDialog())
		end
	}
end)(extended)
