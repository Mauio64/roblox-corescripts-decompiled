local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialToast/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialToast/UIBlox")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialToast/Navigation").useNavigation
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialToast/RobloxAppNavigation").useNavigationProps

local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.Constant.IconSize
local toast = UIBlox.App.Dialog.Toast

return function()
	local ref = React.useRef(false)
	local v5 = useNavigation()
	local v6 = useNavigationProps(function(p2, data)
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

	local v7 = React.useMemo(function()
		local v8 = {
			toastTitle = v6.toastContent.toastTitle or "",
			toastSubtitle = v6.toastContent.toastSubtitle,
			iconColorStyle = v6.toastContent.iconColorStyle,
			iconImage = 0,
			iconSize = 0,
			swipeUpDismiss = 0,
			onAppeared = 0,
			onActivated = 0,
			onDismissed = 0
		}
		local v9 = if not v6.toastContent.shouldHideIcon then v6.toastContent.iconImage or images["icons/status/alert"] else nil
		v8.iconImage = v9

		local v10 = if not v6.toastContent.shouldHideIcon then v6.toastContent.iconSize or Vector2.new(iconSize.Regular, iconSize.Regular) else nil
		v8.iconSize = v10

		v8.swipeUpDismiss = v6.toastContent.swipeUpDismiss
		function v8.onAppeared()
			if v6.toastContent.onAppeared then
				v6.toastContent.onAppeared()
			end

			ref.current = false
		end
		v8.onActivated = v6.toastContent.onActivated
		function v8.onDismissed()
			if v6.toastContent.onDismissed then
				v6.toastContent.onDismissed()
			end

			if not ref.current then
				v5.goBack()
			end
		end

		return v8
	end, { v6.toastContent })

	React.useEffect(function()
		ref.current = true
	end)

	return React.createElement(toast, {
		toastContent = v7,
		anchorPoint = v6.anchorPoint,
		duration = v6.duration or 2,
		layoutOrder = v6.layoutOrder,
		position = v6.position,
		size = v6.size,
		show = v6.show
	})
end
