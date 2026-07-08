local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Toast = UIBlox.App.Dialog.Toast
local Images = UIBlox.App.ImageSet.Images
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local v9 = Roact.PureComponent:extend("FeedbackSubmissionToast")

v9.validateProps = t.strictInterface({
	numFeedbackSubmissionAttempts = t.optional(t.number)
})

function v9.render(p1) -- line: 26
	-- upvalues: Roact (copy), withLocalization (copy), Toast (copy), Images (copy)
	if p1.props.numFeedbackSubmissionAttempts == nil then
		return nil
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 100,
		Size = UDim2.fromScale(1, 1)
	}, {
		Toast = withLocalization({
			toastTitle = "CoreScripts.Feedback.SubmissionToastHeader",
			toastSubtitle = "CoreScripts.Feedback.SubmissionToastBody"
		})(function(t1: {[any]: any}) -- line: 40
			-- upvalues: p1 (copy), Roact (copy), Toast (copy), Images (copy)
			local toastTitle = t1.toastTitle
			local toastSubtitle = t1.toastSubtitle

			if p1.props.numFeedbackSubmissionAttempts % 2 == 0 then
				toastTitle = t1.toastTitle .. " "
				toastSubtitle = t1.toastSubtitle .. " "
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

return RoactRodux.connect(function(p2) -- line: 65
	return {
		numFeedbackSubmissionAttempts = p2.common.numFeedbackSubmissionAttempts
	}
end, nil)(v9)
