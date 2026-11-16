local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local ColorMode = Foundation.Enums.ColorMode
local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent

local withStyle = UIBlox.Core.Style.withStyle
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Dark = ColorMode.Dark

local SetFeedbackFlowState = require(parent.Actions.SetFeedbackFlowState)
local SetScreenSize = require(parent.Actions.SetScreenSize)

local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization

local Assets = require(parent.Resources.Assets)

local FeedbackReportDialog = require(parent.Components.FeedbackReportDialog)
local RefinedFeedbackBar = require(parent.Components.RefinedFeedbackBar)
local FeedbackSubmissionToast = require(parent.Components.FeedbackSubmissionToast)
local HelpModal = require(parent.Components.HelpModal)
local OnboardingModal = require(parent.Components.OnboardingModal)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagInExperienceUseAppStyleProvider = SharedFlags.FFlagInExperienceUseAppStyleProvider

local extended = Roact.PureComponent:extend("FeedbackApp")

extended.validateProps = t.strictInterface({ setScreenGuiSize = t.callback })

function extended.render(p)
	local createElement = Roact.createElement
	local v

	if FFlagInExperienceUseAppStyleProvider then
		v = AppStyleProvider
	else
		v = UIBlox.Core.Style.Provider
	end

	return createElement(v, FFlagInExperienceUseAppStyleProvider and {
		style = { themeName = Dark }
	} or {}, {
		Gui = Roact.createElement("ScreenGui", {
			AutoLocalize = false,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			[Roact.Change.AbsoluteSize] = p.props.setScreenGuiSize
		}, {
			ScreenFrame = Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 10 },
				{
					FeedbackSubmissionToast = Roact.createElement(FeedbackSubmissionToast),
					HelpModal = Roact.createElement(HelpModal),
					OnboardingModal = Roact.createElement(OnboardingModal),
					FeedbackReportDialog = Roact.createElement(FeedbackReportDialog)
				}
			),
			RefinedFeedbackBar = withLocalization({
				feedbackBarText = "CoreScripts.Feedback.FeedbackBar.MainLabel"
			})(function(p2)
				return withStyle(function(p3)
					local font = p3.Font
					return Roact.createElement(RefinedFeedbackBar, {
						leftHint = {
							text = p2.feedbackBarText,
							hintTextSize = font.BaseSize * font.Body.RelativeSize,
							maxWidth = 200,
							icon = Assets.Images.FeedbackBarHintIcon
						}
					}, {})
				end)
			end)
		})
	})
end

return RoactRodux.connect(function() end, function(callback)
	return {
		setScreenGuiSize = function(p)
			callback(SetScreenSize(p.AbsoluteSize))
		end,
		setFeedbackFlowState = function(p)
			callback(function(object)
				object:dispatch(SetFeedbackFlowState(p))
			end)
		end
	}
end)(extended)
