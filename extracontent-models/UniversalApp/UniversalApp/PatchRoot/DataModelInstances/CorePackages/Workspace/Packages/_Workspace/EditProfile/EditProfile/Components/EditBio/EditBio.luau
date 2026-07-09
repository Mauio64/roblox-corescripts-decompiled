local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local Foundation = require(EditProfileParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local TextArea = Foundation.TextArea
local TextKeys = require(EditProfile.Common.TextKeys)
local Constants = require(EditProfile.Common.Constants)
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization

return function(t1: {[any]: any}) -- line: 23
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), Constants (copy), View (copy), FoundationText (copy), TextArea (copy)
	local v12 = useLocalization({
		AboutModalCaption = TextKeys.AboutModalCaption,
		AboutPlaceholder = TextKeys.AboutPlaceholder,
		PinLocked = TextKeys.PinLocked,
		ThrottleError = TextKeys.TooManyAttemptsTryAgainLater
	})
	local v13, v14 = React.useState(t1.bioText)
	local v15, v16 = React.useState(string.len(t1.bioText) >= 1000)

	local function textChanged(s1: string) -- line: 34
		-- upvalues: v14 (copy), v16 (copy), t1 (copy)
		local v20 = string.len(s1)

		v14(s1)
		v16(v20 > 1000)

		if t1.onDataChange then
			t1.onDataChange((string.sub(s1, 1, 1000)))
		end
	end

	local v18 = if t1.errorCode ~= Constants.DescriptionErrorCodes.PinLocked then v12.ThrottleError else v12.PinLocked

	return React.createElement(View, {
		tag = "col size-full-0 auto-y gap-large"
	}, {
		Caption = React.createElement(FoundationText, {
			tag = "text-body-medium text-wrap size-full-0 auto-y text-align-x-left",
			Text = v12.AboutModalCaption
		}),
		BioTextArea = React.createElement(TextArea, {
			label = "",
			numLines = 4,
			text = v13,
			width = UDim.new(1, 0),
			onChanged = function(p1) -- line: 60
				-- upvalues: v14 (copy), v16 (copy), t1 (copy)
				local v22 = string.len(p1)

				v14(p1)
				v16(v22 > 1000)

				if t1.onDataChange then
					t1.onDataChange((string.sub(p1, 1, 1000)))
				end
			end,
			hint = if not t1.errorCode then string.format("%d/%d", string.len(v13), 1000) else v18,
			placeholder = v12.AboutPlaceholder,
			hasError = v15 or t1.errorCode ~= nil,
			textBoxRef = t1.textBoxRef
		})
	})
end
