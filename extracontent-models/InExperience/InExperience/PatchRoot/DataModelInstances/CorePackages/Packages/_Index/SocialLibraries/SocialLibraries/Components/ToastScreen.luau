local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local t = dependencies.t

local images = uiBlox.App.ImageSet.Images
local iconSize = uiBlox.App.Constant.IconSize
local toast = uiBlox.App.Dialog.Toast
local validateColorInfo = uiBlox.Style.Validator.validateColorInfo

local extended = roact.PureComponent:extend("ToastScreen")

extended.defaultProps = { navigation = nil }

local strictInterface = t.strictInterface({
	toastTitle = t.optional(t.string),
	toastSubtitle = t.optional(t.string),
	iconColorStyle = t.optional(validateColorInfo),
	iconImage = t.optional(t.union(t.table, t.string)),
	iconSize = t.optional(t.Vector2),
	swipeUpDismiss = t.optional(t.boolean),
	onAppeared = t.optional(t.callback),
	onActivated = t.optional(t.callback),
	onDismissed = t.optional(t.callback),
	hideIcon = t.optional(t.boolean)
})

local strictInterface2 = t.strictInterface({
	toastContent = t.optional(t.table),
	anchorPoint = t.optional(t.Vector2),
	duration = t.optional(t.integer),
	layoutOrder = t.optional(t.integer),
	position = t.optional(t.UDim2),
	size = t.optional(t.UDim2),
	show = t.optional(t.boolean)
})

function extended:init()
	self.hasToastChanged = false

	function self.getToastProps(data)
		local toastContent = data.toastContent or {}

		assert(strictInterface2(data))
		assert(strictInterface(toastContent))

		local toastContent2 = {
			toastTitle = toastContent.toastTitle or "",
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

		if not toastContent.hideIcon then
			iconImage = toastContent.iconImage or images["icons/status/alert"]
		end

		toastContent2.iconImage = iconImage
		local iconSize2

		if not toastContent.hideIcon then
			iconSize2 = toastContent.iconSize or Vector2.new(iconSize.Regular, iconSize.Regular)
		end

		toastContent2.iconSize = iconSize2

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
	return roact.createElement(toast, toastProps)
end

function extended:didUpdate(_, _)
	self.hasToastChanged = true
end

return extended
