local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local Toast = UIBlox.App.Dialog.Toast
local Images = UIBlox.App.ImageSet.Images
local v8 = Roact.PureComponent:extend("Toast")

v8.validateProps = t.strictInterface({
	toastTitle = t.optional(t.string),
	toastSubtitle = t.optional(t.string)
})

function v8.render(p1) -- line: 18
	-- upvalues: Roact (copy), Toast (copy), Images (copy)
	if not p1.props.toastTitle then
		return nil
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 100,
		Size = UDim2.fromScale(1, 1)
	}, {
		Toast = Roact.createElement(Toast, {
			duration = 3,
			toastContent = {
				iconImage = Images["icons/status/success"],
				toastTitle = p1.props.toastTitle,
				toastSubtitle = p1.props.toastSubtitle
			}
		})
	})
end

return RoactRodux.UNSTABLE_connect2(function(p2, _) -- line: 38
	return {
		toastTitle = p2.common.toastTitle,
		toastSubtitle = p2.common.toastSubtitle
	}
end, nil)(v8)
