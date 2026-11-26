local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastLite/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastLite/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastLite/RoactUtils")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/ToastLite/ToastRodux")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastLite/UIBlox")

local toast = UIBlox.App.Dialog.Toast
local images = UIBlox.App.ImageSet.Images
local toastType = ToastRodux.Enums.ToastType
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStyle = UIBlox.Core.Style.useStyle

local v5 = {
	Info = images["icons/logo/block"],
	Warning = images["icons/status/alert"],
	Success = images["icons/actions/accept"]
}

local v6 = {
	[toastType.InformationMessage] = v5.Info,
	[toastType.SuccessConfirmation] = v5.Success,
	[toastType.NetworkingError] = v5.Warning
}

local v7 = {
	duration = 3,
	springOptions = { frequency = 4, damping = 1 }
}

local function selectCurrentMessage(p2)
	return p2.currentToastMessages[1]
end

local function Toast(p2)
	local joined = Cryo.Dictionary.join(v7, p2)

	local v8 = useDispatch()
	local v9 = useSelector(selectCurrentMessage)
	local tokens = useStyle().Tokens

	local v10 = React.useCallback(function()
		v8(ToastRodux.Actions.RemoveCurrentToastMessage())
	end, { v8 })

	local function onActivated()
		if v9 then
			v10()
		end
	end

	React.useEffect(function()
		if v9 and not (next(v9) and v9.toastTitle) then
			v10()
		end
	end, { v9, v10 })

	if v9 == nil then
		return nil
	end

	local toastType2 = v9.toastType

	if toastType2 ~= toastType.QuickLaunchError then
		onActivated = nil
	end

	local v11 = if toastType2 ~= nil then v6[toastType2] else nil
	local udim = UDim2.new(0.5, 0, 0, tokens.Size.Size_500)

	return React.createElement(toast, {
		duration = joined.duration,
		position = udim,
		show = true,
		springOptions = joined.springOptions,
		toastContent = {
			iconImage = v11,
			onActivated = onActivated,
			onDismissed = v10,
			sequenceNumber = v9.sequenceNumber,
			toastSubtitle = v9.toastSubtitle,
			toastTitle = v9.toastTitle
		}
	})
end

return Toast
