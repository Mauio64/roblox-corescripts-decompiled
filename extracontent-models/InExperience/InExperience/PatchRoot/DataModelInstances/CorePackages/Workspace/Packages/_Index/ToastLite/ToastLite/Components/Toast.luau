local parent = script:FindFirstAncestor("ToastLite").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local ToastRodux = require(parent.ToastRodux)
local UIBlox = require(parent.UIBlox)

local toast = UIBlox.App.Dialog.Toast
local Images = UIBlox.App.ImageSet.Images
local ToastType = ToastRodux.Enums.ToastType
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStyle = UIBlox.Core.Style.useStyle

local v = {
	Info = Images["icons/logo/block"],
	Warning = Images["icons/status/alert"],
	Success = Images["icons/actions/accept"]
}

local v2 = {
	[ToastType.InformationMessage] = v.Info,
	[ToastType.SuccessConfirmation] = v.Success,
	[ToastType.NetworkingError] = v.Warning
}

local v3 = {
	duration = 3,
	springOptions = { frequency = 4, damping = 1 }
}

local function selectCurrentMessage(p)
	return p.currentToastMessages[1]
end

local function Toast(p)
	local joined = Cryo.Dictionary.join(v3, p)

	local v4 = useDispatch()
	local v5 = useSelector(selectCurrentMessage)
	local tokens = useStyle().Tokens

	local onDismissed = React.useCallback(function()
		v4(ToastRodux.Actions.RemoveCurrentToastMessage())
	end, { v4 })

	local function onActivated()
		if v5 then
			onDismissed()
		end
	end

	React.useEffect(function()
		if v5 and not (next(v5) and v5.toastTitle) then
			onDismissed()
		end
	end, { v5, onDismissed })

	if v5 == nil then
		return nil
	end

	local toastType = v5.toastType

	if toastType ~= ToastType.QuickLaunchError then
		onActivated = nil
	end

	local iconImage

	if toastType ~= nil then
		iconImage = v2[toastType]
	end

	local udim = UDim2.new(0.5, 0, 0, tokens.Size.Size_500)

	return React.createElement(toast, {
		duration = joined.duration,
		position = udim,
		show = true,
		springOptions = joined.springOptions,
		toastContent = {
			iconImage = iconImage,
			onActivated = onActivated,
			onDismissed = onDismissed,
			sequenceNumber = v5.sequenceNumber,
			toastSubtitle = v5.toastSubtitle,
			toastTitle = v5.toastTitle
		}
	})
end

return Toast
