local Parent = script:FindFirstAncestor("SocialToast").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useNavigation = require(Parent.Navigation).useNavigation
local useNavigationProps = require(Parent.RobloxAppNavigation).useNavigationProps
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local Toast = UIBlox.App.Dialog.Toast

return function() -- line: 17
	-- upvalues: React (copy), useNavigation (copy), useNavigationProps (copy), Images (copy), IconSize (copy), Toast (copy)
	local v9 = React.useRef(false)
	local v10 = useNavigation()
	local v11 = useNavigationProps(function(_, p2) -- line: 20
		return {
			toastContent = p2.toastContent,
			anchorPoint = p2.anchorPoint,
			duration = p2.duration,
			layoutOrder = p2.layoutOrder,
			position = p2.position,
			size = p2.size,
			show = p2.show
		}
	end)
	local v12 = React.useMemo(function() -- line: 32
		-- upvalues: v11 (copy), Images (copy), IconSize (copy), v9 (copy), v10 (copy)
		return {
			toastTitle = v11.toastContent.toastTitle or "",
			toastSubtitle = v11.toastContent.toastSubtitle,
			iconColorStyle = v11.toastContent.iconColorStyle,
			iconImage = if v11.toastContent.shouldHideIcon then nil else v11.toastContent.iconImage or Images["icons/status/alert"],
			iconSize = if v11.toastContent.shouldHideIcon then nil else v11.toastContent.iconSize or Vector2.new(IconSize.Regular, IconSize.Regular),
			swipeUpDismiss = v11.toastContent.swipeUpDismiss,
			onAppeared = function() -- line: 44
				-- upvalues: v11 (copy), v9 (copy)
				if v11.toastContent.onAppeared then
					v11.toastContent.onAppeared()
				end

				v9.current = false
			end,
			onActivated = v11.toastContent.onActivated,
			onDismissed = function() -- line: 51
				-- upvalues: v11 (copy), v9 (copy), v10 (copy)
				if v11.toastContent.onDismissed then
					v11.toastContent.onDismissed()
				end

				if not v9.current then
					v10.goBack()
				end
			end
		}
	end, { v11.toastContent })

	React.useEffect(function() -- line: 62
		-- upvalues: v9 (copy)
		v9.current = true
	end)

	return React.createElement(Toast, {
		toastContent = v12,
		anchorPoint = v11.anchorPoint,
		duration = v11.duration or 2,
		layoutOrder = v11.layoutOrder,
		position = v11.position,
		size = v11.size,
		show = v11.show
	})
end
