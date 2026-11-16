local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")

local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.Constant.IconSize
local toast = UIBlox.App.Dialog.Toast
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Toast/Logger")

local extended = Roact.PureComponent:extend("ToastScreen")
extended.defaultProps = { navigation = nil }

function extended:init()
	self.hasToastChanged = false

	function self.getToastProps(data)
		local toastContent = data.toastContent

		local v6 = {
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
		local v7 = if not data.shouldHideIcon then toastContent.iconImage or images["icons/status/alert"] else nil
		v6.iconImage = v7

		v6.iconSize = toastContent.iconSize or Vector2.new(iconSize.Regular, iconSize.Regular)
		v6.swipeUpDismiss = toastContent.swipeUpDismiss
		function v6.onAppeared()
			if toastContent.onAppeared then
				toastContent.onAppeared()
			end

			self.hasToastChanged = false
		end
		v6.onActivated = toastContent.onActivated
		function v6.onDismissed()
			if toastContent.onDismissed then
				toastContent.onDismissed()
			end

			if not self.hasToastChanged then
				self.props.navigation.goBack()
			end
		end

		return {
			toastContent = v6,
			anchorPoint = data.anchorPoint,
			duration = data.duration or 2,
			layoutOrder = data.layoutOrder,
			position = data.position,
			size = data.size,
			show = data.show
		}
	end
end

function extended.render(p2)
	assert(type(p2.props.navigation) ~= "nil", "ToastScreen should be wrapped with Roact Navigation")

	local toastProps = p2.getToastProps(p2.props.navigation.getParam("toastProps", {}))
	return Roact.createElement(toast, toastProps)
end

function extended:didUpdate(p3, p4)
	self.hasToastChanged = true
end

function extended.didMount(p2)
	Logger:info("{screen} mounted")
end

return extended
