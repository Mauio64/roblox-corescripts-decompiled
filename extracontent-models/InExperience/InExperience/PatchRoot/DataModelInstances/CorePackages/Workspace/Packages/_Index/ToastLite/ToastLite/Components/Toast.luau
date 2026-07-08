local Parent = script:FindFirstAncestor("ToastLite").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local ToastRodux = require(Parent.ToastRodux)
local UIBlox = require(Parent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
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

local function selectCurrentMessage(p1) -- line: 51
	return p1.currentToastMessages[1]
end
local function Toast2(t4: {[any]: any}) -- line: 55
	-- upvalues: Cryo (copy), t3 (copy), useDispatch (copy), useSelector (copy), selectCurrentMessage (copy), useStyle (copy), React (copy), ToastRodux (copy), ToastType (copy), t2 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Toast (copy)
	local v21 = Cryo.Dictionary.join(t3, t4)
	local v22 = useDispatch()
	local v23 = useSelector(selectCurrentMessage)
	local Tokens = useStyle().Tokens
	local v25 = React.useCallback(function() -- line: 63
		-- upvalues: v22 (copy), ToastRodux (copy)
		v22(ToastRodux.Actions.RemoveCurrentToastMessage())
	end, { v22 })

	React.useEffect(function() -- line: 75
		-- upvalues: v23 (copy), v25 (copy)
		if v23 and (not next(v23) or not v23.toastTitle) then
			v25()
		end
	end, {
		v23,
		v25
	})

	if v23 == nil then
		return nil
	end

	local toastType = v23.toastType
	local v27 = if toastType ~= ToastType.QuickLaunchError then nil else function() -- line: 68
		-- upvalues: v23 (copy), v25 (copy)
		if v23 then
			v25()
		end
	end
	local v28 = if toastType == nil then nil else t2[toastType]
	local uDim2 = UDim2.new(0.5, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then Tokens.Global.Space_250 else Tokens.Size.Size_500)

	return React.createElement(Toast, {
		show = true,
		duration = v21.duration,
		position = uDim2,
		springOptions = v21.springOptions,
		toastContent = {
			iconImage = v28,
			onActivated = v27,
			onDismissed = v25,
			sequenceNumber = v23.sequenceNumber,
			toastSubtitle = v23.toastSubtitle,
			toastTitle = v23.toastTitle
		}
	})
end

return Toast2
