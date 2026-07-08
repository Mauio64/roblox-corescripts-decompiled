local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local t = dependencies.t
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local Toast = UIBlox.App.Dialog.Toast
local validateColorInfo = UIBlox.Style.Validator.validateColorInfo
local v10 = Roact.PureComponent:extend("ToastScreen")

v10.defaultProps = {
	navigation = nil
}

local v11 = t.strictInterface({
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
local v12 = t.strictInterface({
	toastContent = t.optional(t.table),
	anchorPoint = t.optional(t.Vector2),
	duration = t.optional(t.integer),
	layoutOrder = t.optional(t.integer),
	position = t.optional(t.UDim2),
	size = t.optional(t.UDim2),
	show = t.optional(t.boolean)
})

function v10.init(p1) -- line: 41
	-- upvalues: v12 (copy), v11 (copy), Images (copy), IconSize (copy)
	p1.hasToastChanged = false

	function p1.getToastProps(p2) -- line: 44
		-- upvalues: v12 (copy), v11 (copy), Images (copy), IconSize (copy), p1 (copy)
		local v20 = p2.toastContent or {}

		assert(v12(p2))
		assert(v11(v20))

		return {
			toastContent = {
				toastTitle = v20.toastTitle or "",
				toastSubtitle = v20.toastSubtitle,
				iconColorStyle = v20.iconColorStyle,
				iconImage = if v20.hideIcon then nil else v20.iconImage or Images["icons/status/alert"],
				iconSize = if v20.hideIcon then nil else v20.iconSize or Vector2.new(IconSize.Regular, IconSize.Regular),
				swipeUpDismiss = v20.swipeUpDismiss,
				onAppeared = function() -- line: 62
					-- upvalues: v20 (copy), p1 (copy)
					if v20.onAppeared then
						v20.onAppeared()
					end

					p1.hasToastChanged = false
				end,
				onActivated = v20.onActivated,
				onDismissed = function() -- line: 69
					-- upvalues: v20 (copy), p1 (copy)
					if v20.onDismissed then
						v20.onDismissed()
					end

					if not p1.hasToastChanged then
						p1.props.navigation.goBack()
					end
				end
			},
			anchorPoint = p2.anchorPoint,
			duration = p2.duration or 2,
			layoutOrder = p2.layoutOrder,
			position = p2.position,
			size = p2.size,
			show = p2.show
		}
	end
end
function v10.render(p3) -- line: 90
	-- upvalues: Roact (copy), Toast (copy)
	assert(type(p3.props.navigation) ~= "nil", "ToastScreen should be wrapped with Roact Navigation")

	local v15 = p3.getToastProps(p3.props.navigation.getParam("toastProps", {}))

	return Roact.createElement(Toast, v15)
end
function v10.didUpdate(p4, _, _) -- line: 98
	p4.hasToastChanged = true
end

return v10
