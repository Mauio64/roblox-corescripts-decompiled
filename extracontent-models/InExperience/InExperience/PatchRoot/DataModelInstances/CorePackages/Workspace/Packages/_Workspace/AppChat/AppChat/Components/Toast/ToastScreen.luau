local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local Toast = UIBlox.App.Dialog.Toast
local Logger = require(script.Parent.Logger)
local v8 = Roact.PureComponent:extend("ToastScreen")

v8.defaultProps = {
	navigation = nil
}

function v8.init(p1) -- line: 17
	-- upvalues: Images (copy), IconSize (copy)
	p1.hasToastChanged = false

	function p1.getToastProps(p2) -- line: 20
		-- upvalues: Images (copy), IconSize (copy), p1 (copy)
		local toastContent = p2.toastContent

		return {
			toastContent = {
				toastTitle = toastContent.toastTitle,
				toastSubtitle = toastContent.toastSubtitle,
				iconColorStyle = toastContent.iconColorStyle,
				iconImage = if not p2.shouldHideIcon then toastContent.iconImage or Images["icons/status/alert"] else nil,
				iconSize = toastContent.iconSize or Vector2.new(IconSize.Regular, IconSize.Regular),
				swipeUpDismiss = toastContent.swipeUpDismiss,
				onAppeared = function() -- line: 33
					-- upvalues: toastContent (copy), p1 (copy)
					if toastContent.onAppeared then
						toastContent.onAppeared()
					end

					p1.hasToastChanged = false
				end,
				onActivated = toastContent.onActivated,
				onDismissed = function() -- line: 40
					-- upvalues: toastContent (copy), p1 (copy)
					if toastContent.onDismissed then
						toastContent.onDismissed()
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
function v8.render(p3) -- line: 61
	-- upvalues: Roact (copy), Toast (copy)
	assert(type(p3.props.navigation) ~= "nil", "ToastScreen should be wrapped with Roact Navigation")

	local v11 = p3.getToastProps(p3.props.navigation.getParam("toastProps", {}))

	return Roact.createElement(Toast, v11)
end
function v8.didUpdate(p4, _, _) -- line: 69
	p4.hasToastChanged = true
end
function v8.didMount(_) -- line: 73
	-- upvalues: Logger (copy)
	Logger:info("{screen} mounted")
end

return v8
