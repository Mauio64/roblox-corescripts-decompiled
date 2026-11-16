local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)

local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local Toast = UIBlox.App.Dialog.Toast
local Logger = require(script.Parent.Logger)

local extended = Roact.PureComponent:extend("ToastScreen")
extended.defaultProps = { navigation = nil }

function extended:init()
	self.hasToastChanged = false

	function self.getToastProps(data)
		local toastContent = data.toastContent

		local toastContent2 = {
			toastTitle = toastContent.toastTitle,
			toastSubtitle = toastContent.toastSubtitle,
			iconColorStyle = toastContent.iconColorStyle,
			iconImage = 0,
			iconSize = 0,
			swipeUpDismiss = 0,
			onAppeared = 0,
			onActivated = 0,
			onDismissed = 0
		}
		local iconImage

		if not data.shouldHideIcon then
			iconImage = toastContent.iconImage or Images["icons/status/alert"]
		end

		toastContent2.iconImage = iconImage

		toastContent2.iconSize = toastContent.iconSize or Vector2.new(IconSize.Regular, IconSize.Regular)
		toastContent2.swipeUpDismiss = toastContent.swipeUpDismiss
		function toastContent2.onAppeared()
			if toastContent.onAppeared then
				toastContent.onAppeared()
			end

			self.hasToastChanged = false
		end
		toastContent2.onActivated = toastContent.onActivated
		function toastContent2.onDismissed()
			if toastContent.onDismissed then
				toastContent.onDismissed()
			end

			if not self.hasToastChanged then
				self.props.navigation.goBack()
			end
		end

		return {
			toastContent = toastContent2,
			anchorPoint = data.anchorPoint,
			duration = data.duration or 2,
			layoutOrder = data.layoutOrder,
			position = data.position,
			size = data.size,
			show = data.show
		}
	end
end

function extended.render(p)
	assert(type(p.props.navigation) ~= "nil", "ToastScreen should be wrapped with Roact Navigation")

	local toastProps = p.getToastProps(p.props.navigation.getParam("toastProps", {}))
	return Roact.createElement(Toast, toastProps)
end

function extended:didUpdate(_, _)
	self.hasToastChanged = true
end

function extended.didMount(_)
	Logger:info("{screen} mounted")
end

return extended
