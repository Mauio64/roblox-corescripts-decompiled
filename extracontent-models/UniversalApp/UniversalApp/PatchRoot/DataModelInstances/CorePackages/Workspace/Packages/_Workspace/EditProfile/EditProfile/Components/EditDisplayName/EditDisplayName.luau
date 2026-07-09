local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local Foundation = require(EditProfileParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local TextInput = Foundation.TextInput
local IconName = Foundation.Enums.IconName
local TextKeys = require(EditProfile.Common.TextKeys)
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local Constants = require(EditProfile.Common.Constants)
local useDisplayNameText = require(EditProfile.Hooks.useDisplayNameText)
local LuauPolyfill = require(EditProfileParent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local AnalyticsServiceV2 = require(EditProfile.Analytics.AnalyticsServiceV2)
local v17 = game:DefineFastInt("MaxDisplayNameCharacters", 20)
local v18 = game:DefineFastInt("MinDisplayNameCharacters", 3)
local v19 = game:DefineFastInt("DisplayNameValidationNetworkDelay", 500)

return function(t1: {[any]: any}) -- line: 33
	-- upvalues: useLocalization (copy), TextKeys (copy), useDisplayNameText (copy), React (copy), setTimeout (copy), v19 (copy), Constants (copy), clearTimeout (copy), v18 (copy), AnalyticsServiceV2 (copy), v17 (copy), View (copy), FoundationText (copy), TextInput (copy), IconName (copy)
	local v21 = useLocalization({
		DisplayNameCaption = TextKeys.DisplayNameCaption
	})
	local v22 = useDisplayNameText()
	local v23, v24 = React.useState(t1.initialDisplayName)
	local v25, v26 = React.useState(false)
	local v27, v28 = React.useState(v22.displayNameChangeError)
	local v29, v30 = React.useState(false)
	local v31 = React.useRef(setTimeout(function() -- line: 42
	end, v19))

	React.useEffect(function() -- line: 44
		-- upvalues: t1 (copy), v25 (copy), v29 (copy)
		if t1.updateErrorState then
			t1.updateErrorState(v25 or v29)
		end
	end, {
		v25,
		v29
	})
	React.useEffect(function() -- line: 50
		-- upvalues: v24 (copy), t1 (copy)
		v24(t1.initialDisplayName)
	end, { t1.initialDisplayName })

	local function getErrorMessage(n1: number) -- line: 54
		-- upvalues: Constants (copy), v22 (copy)
		return ({
			[Constants.DisplayNameValidationErrorCodes.TooShort] = v22.nameTooShortError,
			[Constants.DisplayNameValidationErrorCodes.TooLong] = v22.nameTooLongError,
			[Constants.DisplayNameValidationErrorCodes.InvalidCharacters] = v22.nameUnsupportedCharsError,
			[Constants.DisplayNameValidationErrorCodes.Moderated] = v22.nameInappropriateError,
			[Constants.DisplayNameValidationErrorCodes.Throttled] = v22.nameHasChangedError,
			[Constants.DisplayNameValidationErrorCodes.InvalidCharacterSetCombination] = v22.displayNameChangeMixedCharactersError,
			[Constants.DisplayNameValidationErrorCodes.NameNotAvailable] = v22.nameNotAvailableError
		})[n1] or v22.displayNameChangeError
	end
	local function textChanged(s1: string) -- line: 67
		-- upvalues: clearTimeout (copy), v31 (copy), v24 (copy), v26 (copy), v30 (copy), v18 (copy), AnalyticsServiceV2 (copy), v28 (copy), v22 (copy), v17 (copy), setTimeout (copy), t1 (copy), getErrorMessage (copy), v19 (copy)
		clearTimeout(v31.current)

		local u36 = s1 or ""
		local v37 = utf8.len(u36) or 0

		v24(u36)
		v26(false)
		v30(false)

		if v37 < v18 then
			AnalyticsServiceV2.sendDisplayNameTooShort(u36)
			v28(v22.nameTooShortError)
			v26(true)

			return
		end

		if v37 > v17 then
			v28(v22.nameTooLongError)
			v26(true)

			return
		end

		v30(true)
		v31.current = setTimeout(function() -- line: 88
			-- upvalues: t1 (copy), u36 (ref), v26 (copy), v30 (copy), AnalyticsServiceV2 (copy), v28 (copy), getErrorMessage (copy)
			t1.validateDisplayName(u36):andThen(function(_) -- line: 91
				-- upvalues: v26 (copy), v30 (copy), t1 (copy), u36 (ref)
				v26(false)
				v30(false)
				t1.onDataChange(u36)
			end):catch(function(p2) -- line: 96
				-- upvalues: AnalyticsServiceV2 (copy), u36 (ref), v28 (copy), getErrorMessage (copy), v26 (copy), v30 (copy)
				local n2 = -1

				if p2 and (p2.errors and p2.errors[1]) then
					n2 = p2.errors[1].code or -1
				end

				AnalyticsServiceV2.sendFilteredDisplayName(u36)
				v28((getErrorMessage(n2)))
				v26(true)
				v30(false)
			end)
		end, v19)
	end

	return React.createElement(View, {
		tag = "auto-y col gap-medium bg-transparent",
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}, {
		Caption = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "text-body-medium text-wrap size-full-0 auto-y text-align-x-left",
			Text = v21.DisplayNameCaption
		}),
		DisplayNameInput = React.createElement(TextInput, {
			LayoutOrder = 2,
			label = "",
			tag = "text-body-medium text-wrap size-full-0 auto-y text-align-x-left",
			text = v23,
			width = UDim.new(1, 0),
			placeholder = t1.initialDisplayName,
			hint = if not v25 then string.format("%d/%d", utf8.len(v23 or "") or 0, v17) else v27,
			onChanged = function(s2: string) -- line: 131
				-- upvalues: textChanged (copy)
				textChanged(s2)
			end,
			hasError = v25,
			iconTrailing = if not v23 or not (#v23 > 0) then nil else {
				name = IconName.CircleX,
				onActivated = function() -- line: 138
					-- upvalues: textChanged (copy)
					textChanged("")
				end
			},
			textBoxRef = t1.textBoxRef
		})
	})
end
