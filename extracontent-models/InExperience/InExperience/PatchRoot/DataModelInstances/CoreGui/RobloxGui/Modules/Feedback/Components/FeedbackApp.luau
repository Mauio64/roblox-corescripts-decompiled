local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent
local withStyle = UIBlox.Core.Style.withStyle
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Dark = UIBlox.App.Style.Constants.ThemeName.Dark
local SetFeedbackFlowState = require(ParentParent.Actions.SetFeedbackFlowState)
local SetScreenSize = require(ParentParent.Actions.SetScreenSize)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local Assets = require(ParentParent.Resources.Assets)
local FeedbackReportDialog = require(ParentParent.Components.FeedbackReportDialog)
local RefinedFeedbackBar = require(ParentParent.Components.RefinedFeedbackBar)
local FeedbackSubmissionToast = require(ParentParent.Components.FeedbackSubmissionToast)
local HelpModal = require(ParentParent.Components.HelpModal)
local OnboardingModal = require(ParentParent.Components.OnboardingModal)
local FFlagInExperienceUseAppStyleProvider = require(CorePackages.Workspace.Packages.SharedFlags).FFlagInExperienceUseAppStyleProvider
local v20 = Roact.PureComponent:extend("FeedbackApp")

v20.validateProps = t.strictInterface({
	setScreenGuiSize = t.callback
})

function v20.render(p1) -- line: 46
	-- upvalues: Roact (copy), FFlagInExperienceUseAppStyleProvider (copy), AppStyleProvider (copy), UIBlox (copy), Dark (copy), FeedbackSubmissionToast (copy), HelpModal (copy), OnboardingModal (copy), FeedbackReportDialog (copy), withLocalization (copy), withStyle (copy), RefinedFeedbackBar (copy), Assets (copy)
	return Roact.createElement(if not FFlagInExperienceUseAppStyleProvider then UIBlox.Core.Style.Provider else AppStyleProvider, if not FFlagInExperienceUseAppStyleProvider then {} else {
		style = {
			themeName = Dark
		}
	}, {
		Gui = Roact.createElement("ScreenGui", {
			AutoLocalize = false,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			[Roact.Change.AbsoluteSize] = p1.props.setScreenGuiSize
		}, {
			ScreenFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 10,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				FeedbackSubmissionToast = Roact.createElement(FeedbackSubmissionToast),
				HelpModal = Roact.createElement(HelpModal),
				OnboardingModal = Roact.createElement(OnboardingModal),
				FeedbackReportDialog = Roact.createElement(FeedbackReportDialog)
			}),
			RefinedFeedbackBar = withLocalization({
				feedbackBarText = "CoreScripts.Feedback.FeedbackBar.MainLabel"
			})(function(p2) -- line: 78
				-- upvalues: withStyle (copy), Roact (copy), RefinedFeedbackBar (copy), Assets (copy)
				return withStyle(function(p3) -- line: 79
					-- upvalues: Roact (copy), RefinedFeedbackBar (copy), p2 (copy), Assets (copy)
					local p3Font = p3.Font

					return Roact.createElement(RefinedFeedbackBar, {
						leftHint = {
							maxWidth = 200,
							text = p2.feedbackBarText,
							hintTextSize = p3Font.BaseSize * p3Font.Body.RelativeSize,
							icon = Assets.Images.FeedbackBarHintIcon
						}
					}, {})
				end)
			end)
		})
	})
end

return RoactRodux.connect(function() -- line: 96
end, function(p4) -- line: 96
	-- upvalues: SetScreenSize (copy), SetFeedbackFlowState (copy)
	return {
		setScreenGuiSize = function(p5) -- line: 98
			-- upvalues: p4 (copy), SetScreenSize (copy)
			p4(SetScreenSize(p5.AbsoluteSize))
		end,
		setFeedbackFlowState = function(p6) -- line: 101
			-- upvalues: p4 (copy), SetFeedbackFlowState (copy)
			p4(function(p7) -- line: 102
				-- upvalues: SetFeedbackFlowState (copy), p6 (copy)
				p7:dispatch(SetFeedbackFlowState(p6))
			end)
		end
	}
end)(v20)
