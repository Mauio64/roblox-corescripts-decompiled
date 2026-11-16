local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local TextInput = Foundation.TextInput
local IconName = Foundation.Enums.IconName

local TextKeys = require(EditProfile.Common.TextKeys)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Constants = require(EditProfile.Common.Constants)
local useDisplayNameText = require(EditProfile.Hooks.useDisplayNameText)
local LuauPolyfill = require(parent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local AnalyticsServiceV2 = require(EditProfile.Analytics.AnalyticsServiceV2)

local defineFastInt = game:DefineFastInt("MaxDisplayNameCharacters", 20)
local defineFastInt2 = game:DefineFastInt("MinDisplayNameCharacters", 3)
local defineFastInt3 = game:DefineFastInt("DisplayNameValidationNetworkDelay", 500)

return function(props)
	local v = useLocalization({ DisplayNameCaption = TextKeys.DisplayNameCaption })

	local v2 = useDisplayNameText()
	local state, setState = React.useState(props.initialDisplayName)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(v2.displayNameChangeError)
	local state4, setState4 = React.useState(false)
	local ref = React.useRef(setTimeout(function() end, defineFastInt3))

	React.useEffect(function()
		if props.updateErrorState then
			props.updateErrorState(state2 or state4)
		end
	end, { state2, state4 })

	React.useEffect(function()
		setState(props.initialDisplayName)
	end, { props.initialDisplayName })

	local function getErrorMessage(p: number)
		return ({
			[Constants.DisplayNameValidationErrorCodes.TooShort] = v2.nameTooShortError,
			[Constants.DisplayNameValidationErrorCodes.TooLong] = v2.nameTooLongError,
			[Constants.DisplayNameValidationErrorCodes.InvalidCharacters] = v2.nameUnsupportedCharsError,
			[Constants.DisplayNameValidationErrorCodes.Moderated] = v2.nameInappropriateError,
			[Constants.DisplayNameValidationErrorCodes.Throttled] = v2.nameHasChangedError,
			[Constants.DisplayNameValidationErrorCodes.InvalidCharacterSetCombination] = v2.displayNameChangeMixedCharactersError,
			[Constants.DisplayNameValidationErrorCodes.NameNotAvailable] = v2.nameNotAvailableError
		})[p] or v2.displayNameChangeError
	end

	local function textChanged(value: string)
		clearTimeout(ref.current)
		local v3 = value or ""
		local v4 = utf8.len(v3) or 0

		setState(v3)
		setState2(false)
		setState4(false)

		if v4 < defineFastInt2 then
			AnalyticsServiceV2.sendDisplayNameTooShort(v3)
			setState3(v2.nameTooShortError)
			setState2(true)
		elseif defineFastInt < v4 then
			setState3(v2.nameTooLongError)
			setState2(true)
		else
			setState4(true)
			ref.current = setTimeout(function()
				props.validateDisplayName(v3):andThen(function(_)
					setState2(false)
					setState4(false)
					props.onDataChange(v3)
				end):catch(function(p)
					local v5 = -1
					v5 = p and p.errors and p.errors[1] and (p.errors[1].code or -1) or v5

					AnalyticsServiceV2.sendFilteredDisplayName(v3)
					setState3(getErrorMessage(v5))
					setState2(true)
					setState4(false)
				end)
			end, defineFastInt3)
		end
	end

	local createElement = React.createElement
	local v3 = {
		tag = "auto-y col gap-medium bg-transparent",
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v4 = {
		Caption = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v.DisplayNameCaption,
			tag = "text-body-medium text-wrap size-full-0 auto-y text-align-x-left"
		}),
		DisplayNameInput = 0
	}

	local createElement2 = React.createElement
	local v5 = {
		text = state,
		LayoutOrder = 2,
		label = "",
		tag = "text-body-medium text-wrap size-full-0 auto-y text-align-x-left",
		width = UDim.new(1, 0),
		placeholder = props.initialDisplayName,
		hint = 0,
		onChanged = 0,
		hasError = 0,
		iconTrailing = 0,
		textBoxRef = 0
	}

	if not state2 then
		state3 = string.format("%d/%d", utf8.len(state or "") or 0, defineFastInt)
	end

	v5.hint = state3

	function v5.onChanged(p: string)
		textChanged(p)
	end
	v5.hasError = state2
	v5.iconTrailing = state and #state > 0 and {
		name = IconName.CircleX,
		onActivated = function()
			textChanged("")
		end
	} or nil

	v5.textBoxRef = props.textBoxRef
	v4.DisplayNameInput = createElement2(TextInput, v5)
	return createElement(View, v3, v4)
end
