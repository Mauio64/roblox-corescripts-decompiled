local Parent = script:FindFirstAncestor("ToastLite").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local ToastRodux = require(Parent.ToastRodux)
local UIBlox = require(Parent.UIBlox)
local Toast = UIBlox.App.Dialog.Toast
local Images = UIBlox.App.ImageSet.Images
local ToastType = ToastRodux.Enums.ToastType
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStyle = UIBlox.Core.Style.useStyle
local t1 = {
	Info = Images["icons/logo/block"],
	Warning = Images["icons/status/alert"],
	Success = Images["icons/actions/accept"]
}
local t2 = {
	[ToastType.InformationMessage] = t1.Info,
	[ToastType.SuccessConfirmation] = t1.Success,
	[ToastType.NetworkingError] = t1.Warning
}
local t3 = {
	duration = 3,
	springOptions = {
		frequency = 4,
		damping = 1
	}
}

local function selectCurrentMessage(p1) -- line: 49
	return p1.currentToastMessages[1]
end
local function Toast2(t4: {[any]: any}) -- line: 53
	-- upvalues: Cryo (copy), t3 (copy), useDispatch (copy), useSelector (copy), selectCurrentMessage (copy), useStyle (copy), React (copy), ToastRodux (copy), ToastType (copy), t2 (copy), Toast (copy)
	local v20 = Cryo.Dictionary.join(t3, t4)
	local v21 = useDispatch()
	local v22 = useSelector(selectCurrentMessage)
	local Tokens = useStyle().Tokens
	local v24 = React.useCallback(function() -- line: 61
		-- upvalues: v21 (copy), ToastRodux (copy)
		v21(ToastRodux.Actions.RemoveCurrentToastMessage())
	end, { v21 })

	React.useEffect(function() -- line: 73
		-- upvalues: v22 (copy), v24 (copy)
		if v22 and (not next(v22) or not v22.toastTitle) then
			v24()
		end
	end, {
		v22,
		v24
	})

	if v22 == nil then
		return nil
	end

	local toastType = v22.toastType
	local v26 = if toastType ~= ToastType.QuickLaunchError then nil else function() -- line: 66
		-- upvalues: v22 (copy), v24 (copy)
		if v22 then
			v24()
		end
	end
	local v27 = if toastType == nil then nil else t2[toastType]
	local uDim2 = UDim2.new(0.5, 0, 0, Tokens.Size.Size_500)

	return React.createElement(Toast, {
		show = true,
		duration = v20.duration,
		position = uDim2,
		springOptions = v20.springOptions,
		toastContent = {
			iconImage = v27,
			onActivated = v26,
			onDismissed = v24,
			sequenceNumber = v22.sequenceNumber,
			toastSubtitle = v22.toastSubtitle,
			toastTitle = v22.toastTitle
		}
	})
end

return Toast2
