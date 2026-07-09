local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Dialog = Foundation.Dialog
local TextInput = Foundation.TextInput
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local v8 = game:DefineFastInt("AXOutfitTextBoxCharacterLimit", 80)

local function BaseDialogWithTextbox(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), v8 (copy), ButtonVariant (copy), Dialog (copy), DialogSize (copy), TextInput (copy)
	local v11, v12 = React.useState(t1.defaultText or "")
	local v13 = React.useRef(nil)
	local v14 = React.useCallback(function(s1: string) -- line: 28
		-- upvalues: v8 (copy), v13 (copy), v11 (copy), v12 (copy)
		if #s1 > v8 then
			if v13.current then
				local TextBox = v13.current:FindFirstChild("TextBox", true)

				if TextBox then
					TextBox.Text = v11

					return
				end
			end
		else
			v12(s1)
		end
	end, {
		v12,
		v11
	})
	local v15, v16 = React.useMemo(function() -- line: 41
		-- upvalues: t1 (copy), v11 (copy)
		return t1.isTextValid(v11)
	end, {
		v11,
		t1.isTextValid
	})
	local v17 = React.useCallback(function() -- line: 45
		-- upvalues: t1 (copy), v11 (copy)
		t1.onConfirm(v11)
	end, {
		t1.onConfirm,
		v11
	})
	local v18 = React.useMemo(function() -- line: 49
		-- upvalues: t1 (copy), ButtonVariant (copy), v15 (copy), v17 (copy)
		return {
			{
				text = t1.cancelButtonText,
				variant = ButtonVariant.Standard,
				onActivated = t1.onClose
			},
			{
				text = t1.confirmButtonText,
				variant = ButtonVariant.Emphasis,
				isDisabled = not v15 or nil,
				onActivated = v17
			}
		}
	end, {
		t1.cancelButtonText,
		t1.onClose,
		t1.confirmButtonText,
		v15,
		v17
	})

	return React.createElement("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Selectable = false,
		[React.Event.Activated] = t1.onClose
	}, React.createElement(Dialog.Root, {
		hasBackdrop = false,
		onClose = nil,
		size = DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = t1.titleText
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2,
			tag = "col gap-medium size-full-0"
		}, {
			OutfitNameInput = React.createElement(TextInput, {
				label = "",
				LayoutOrder = 2,
				text = v11,
				width = UDim.new(1, 0),
				hasError = v16 ~= nil,
				hint = v16,
				onChanged = v14,
				ref = v13
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = v18
		})
	}))
end

return BaseDialogWithTextbox
