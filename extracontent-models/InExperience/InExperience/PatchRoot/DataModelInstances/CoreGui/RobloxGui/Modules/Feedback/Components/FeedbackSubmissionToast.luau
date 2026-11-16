local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local Toast = UIBlox.App.Dialog.Toast

local Images = UIBlox.App.ImageSet.Images

local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization

local extended = Roact.PureComponent:extend("FeedbackSubmissionToast")

extended.validateProps = t.strictInterface({ numFeedbackSubmissionAttempts = t.optional(t.number) })

function extended.render(p)
	if p.props.numFeedbackSubmissionAttempts == nil then
		return nil
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 100
	}, {
		Toast = withLocalization({
			toastTitle = "CoreScripts.Feedback.SubmissionToastHeader",
			toastSubtitle = "CoreScripts.Feedback.SubmissionToastBody"
		})(function(p2)
			local toastTitle = p2.toastTitle
			local toastSubtitle = p2.toastSubtitle

			if p.props.numFeedbackSubmissionAttempts % 2 == 0 then
				toastTitle = p2.toastTitle .. " "
				toastSubtitle = p2.toastSubtitle .. " "
			end

			return Roact.createElement(Toast, {
				duration = 3,
				toastContent = {
					iconImage = Images["icons/status/success"],
					toastTitle = toastTitle,
					toastSubtitle = toastSubtitle
				}
			})
		end)
	})
end

return RoactRodux.connect(function(p)
	return { numFeedbackSubmissionAttempts = p.common.numFeedbackSubmissionAttempts }
end, nil)(extended)
