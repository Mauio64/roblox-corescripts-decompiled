local parent = script:FindFirstAncestor("SocialToast").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps

local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local Toast = UIBlox.App.Dialog.Toast

return function()
	local ref = React.useRef(false)
	local v = useNavigation()
	local v2 = useNavigationProps(function(_, data)
		return {
			toastContent = data.toastContent,
			anchorPoint = data.anchorPoint,
			duration = data.duration,
			layoutOrder = data.layoutOrder,
			position = data.position,
			size = data.size,
			show = data.show
		}
	end)

	local toastContent = React.useMemo(function()
		local v3 = {
			toastTitle = v2.toastContent.toastTitle or "",
			toastSubtitle = v2.toastContent.toastSubtitle,
			iconColorStyle = v2.toastContent.iconColorStyle,
			iconImage = 0,
			iconSize = 0,
			swipeUpDismiss = 0,
			onAppeared = 0,
			onActivated = 0,
			onDismissed = 0
		}
		local iconImage

		if not v2.toastContent.shouldHideIcon then
			iconImage = v2.toastContent.iconImage or Images["icons/status/alert"]
		end

		v3.iconImage = iconImage
		local iconSize

		if not v2.toastContent.shouldHideIcon then
			iconSize = v2.toastContent.iconSize or Vector2.new(IconSize.Regular, IconSize.Regular)
		end

		v3.iconSize = iconSize

		v3.swipeUpDismiss = v2.toastContent.swipeUpDismiss
		function v3.onAppeared()
			if v2.toastContent.onAppeared then
				v2.toastContent.onAppeared()
			end

			ref.current = false
		end
		v3.onActivated = v2.toastContent.onActivated
		function v3.onDismissed()
			if v2.toastContent.onDismissed then
				v2.toastContent.onDismissed()
			end

			if not ref.current then
				v.goBack()
			end
		end

		return v3
	end, { v2.toastContent })

	React.useEffect(function()
		ref.current = true
	end)

	return React.createElement(Toast, {
		toastContent = toastContent,
		anchorPoint = v2.anchorPoint,
		duration = v2.duration or 2,
		layoutOrder = v2.layoutOrder,
		position = v2.position,
		size = v2.size,
		show = v2.show
	})
end
