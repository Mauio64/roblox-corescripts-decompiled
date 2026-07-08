local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local CloseReportSentDialog = require(ParentParent.Actions.CloseReportSentDialog)
local Constants = require(ParentParent.Resources.Constants)
local withLocalization = require(ParentParent.Localization.withLocalization)
local InfoDialog = require(ParentParent.Components.InfoDialog)
local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)
local v15 = t.strictInterface({
	isReportSentOpen = t.boolean,
	onDismiss = t.callback,
	inputType = t.optional(t.string)
})
local v16 = Roact.PureComponent:extend("ReportSentDialog")

v16.validateProps = v15

function v16.init(p1) -- line: 34
	-- upvalues: Roact (copy)
	p1.buttonRef = Roact.createRef()
end
function v16.renderFocusHandler(p2) -- line: 38
	-- upvalues: Roact (copy), FocusHandler (copy), Constants (copy), GuiService (copy), ContextActionService (copy)
	return Roact.createElement(FocusHandler, {
		isFocused = p2.props.inputType == Constants.InputType.Gamepad and p2.props.isReportSentOpen,
		didFocus = function() -- line: 41
			-- upvalues: GuiService (copy), p2 (copy), ContextActionService (copy)
			GuiService:RemoveSelectionGroup("ReportSentDialogGroup")
			GuiService:AddSelectionParent("ReportSentDialogGroup", p2.buttonRef:getValue())
			GuiService.SelectedCoreObject = p2.buttonRef:getValue()
			ContextActionService:BindCoreAction("ReporSentDialogSinkAction", function(_, _) -- line: 47
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonY, Enum.KeyCode.ButtonX)
		end,
		didBlur = function() -- line: 51
			-- upvalues: ContextActionService (copy), GuiService (copy)
			ContextActionService:UnbindCoreAction("ReporSentDialogSinkAction")
			GuiService:RemoveSelectionGroup("ReportSentDialogGroup")
		end
	})
end
function v16.render(p5) -- line: 58
	-- upvalues: withLocalization (copy), Roact (copy), InfoDialog (copy), Assets (copy)
	return withLocalization({
		titleText = "CoreScripts.InGameMenu.Report.ThanksForReport",
		bodyText = "CoreScripts.InGameMenu.Report.WillReviewBody",
		dismissText = "CoreScripts.InGameMenu.Ok"
	})(function(p6) -- line: 63
		-- upvalues: Roact (copy), InfoDialog (copy), Assets (copy), p5 (copy)
		return Roact.createFragment({
			Dialog = Roact.createElement(InfoDialog, {
				titleText = p6.titleText,
				bodyText = p6.bodyText,
				dismissText = p6.dismissText,
				iconImage = Assets.Images.SuccessTick,
				buttonRef = p5.buttonRef,
				onDismiss = p5.props.onDismiss,
				visible = p5.props.isReportSentOpen
			}),
			FocusHandler = p5:renderFocusHandler()
		})
	end)
end

return RoactRodux.UNSTABLE_connect2(function(p7, _) -- line: 79
	return {
		isReportSentOpen = p7.report.reportSentOpen,
		inputType = p7.displayOptions.inputType
	}
end, function(p9) -- line: 84
	-- upvalues: CloseReportSentDialog (copy)
	return {
		onDismiss = function() -- line: 86
			-- upvalues: p9 (copy), CloseReportSentDialog (copy)
			p9(CloseReportSentDialog())
		end
	}
end)(v16)
