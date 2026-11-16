local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)

local toast = UIBlox.App.Dialog.Toast
local Images = UIBlox.App.ImageSet.Images

local extended = Roact.PureComponent:extend("Toast")

extended.validateProps = t.strictInterface({
	toastTitle = t.optional(t.string),
	toastSubtitle = t.optional(t.string)
})

function extended.render(p)
	if p.props.toastTitle then
		return Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 100 },
			{
				Toast = Roact.createElement(toast, {
					duration = 3,
					toastContent = {
						iconImage = Images["icons/status/success"],
						toastTitle = p.props.toastTitle,
						toastSubtitle = p.props.toastSubtitle
					}
				})
			}
		)
	end

	return nil
end

return RoactRodux.UNSTABLE_connect2(function(p, _)
	return { toastTitle = p.common.toastTitle, toastSubtitle = p.common.toastSubtitle }
end, nil)(extended)
