local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local view = Foundation.View
local text = Foundation.Text
local textInput = Foundation.TextInput
local iconName = Foundation.Enums.IconName

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Constants")
local useDisplayNameText = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Hooks/useDisplayNameText")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/LuauPolyfill")
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local AnalyticsServiceV2 = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/AnalyticsServiceV2")

local defineFastInt = game:DefineFastInt("MaxDisplayNameCharacters", 20)
local defineFastInt2 = game:DefineFastInt("MinDisplayNameCharacters", 3)
local defineFastInt3 = game:DefineFastInt("DisplayNameValidationNetworkDelay", 500)

return function(props)
	local v5 = useLocalization({ DisplayNameCaption = TextKeys.DisplayNameCaption })

	local v6 = useDisplayNameText()
	local state, setState = React.useState(props.initialDisplayName)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(v6.displayNameChangeError)
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

	local function getErrorMessage(p2)
		return ({
			[Constants.DisplayNameValidationErrorCodes.TooShort] = v6.nameTooShortError,
			[Constants.DisplayNameValidationErrorCodes.TooLong] = v6.nameTooLongError,
			[Constants.DisplayNameValidationErrorCodes.InvalidCharacters] = v6.nameUnsupportedCharsError,
			[Constants.DisplayNameValidationErrorCodes.Moderated] = v6.nameInappropriateError,
			[Constants.DisplayNameValidationErrorCodes.Throttled] = v6.nameHasChangedError,
			[Constants.DisplayNameValidationErrorCodes.InvalidCharacterSetCombination] = v6.displayNameChangeMixedCharactersError,
			[Constants.DisplayNameValidationErrorCodes.NameNotAvailable] = v6.nameNotAvailableError
		})[p2] or v6.displayNameChangeError
	end

	local function textChanged(value)
		clearTimeout(ref.current)
		local v7 = value or ""
		local v8 = utf8.len(v7) or 0

		setState(v7)
		setState2(false)
		setState4(false)

		if v8 < defineFastInt2 then
			AnalyticsServiceV2.sendDisplayNameTooShort(v7)
			setState3(v6.nameTooShortError)
			setState2(true)
		elseif defineFastInt < v8 then
			setState3(v6.nameTooLongError)
			setState2(true)
		else
			setState4(true)
			ref.current = setTimeout(function()
				props.validateDisplayName(v7):andThen(function(p2)
					setState2(false)
					setState4(false)
					props.onDataChange(v7)
				end):catch(function(p2)
					local v9 = -1
					v9 = p2 and p2.errors and p2.errors[1] and (p2.errors[1].code or -1) or v9

					AnalyticsServiceV2.sendFilteredDisplayName(v7)
					setState3(getErrorMessage(v9))
					setState2(true)
					setState4(false)
				end)
			end, defineFastInt3)
		end
	end

	local createElement = React.createElement
	local v8 = {
		tag = "auto-y col gap-medium bg-transparent",
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v9 = {
		Caption = React.createElement(text, {
			LayoutOrder = 1,
			Text = v5.DisplayNameCaption,
			tag = "text-body-medium text-wrap size-full-0 auto-y text-align-x-left"
		}),
		DisplayNameInput = 0
	}

	local createElement2 = React.createElement
	local v11 = {
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

	v11.hint = state3

	function v11.onChanged(p2)
		textChanged(p2)
	end
	v11.hasError = state2
	v11.iconTrailing = state and #state > 0 and {
		name = iconName.CircleX,
		onActivated = function()
			textChanged("")
		end
	} or nil

	v11.textBoxRef = props.textBoxRef
	v9.DisplayNameInput = createElement2(textInput, v11)
	return createElement(view, v8, v9)
end
