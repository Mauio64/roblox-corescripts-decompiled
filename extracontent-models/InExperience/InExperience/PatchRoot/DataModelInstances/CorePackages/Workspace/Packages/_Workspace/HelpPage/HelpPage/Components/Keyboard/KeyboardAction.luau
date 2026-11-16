local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
require(parent.Configs.ConfigTypes)
local ExtraKeysEnum = require(parent.Enums.ExtraKeysEnum)
local Localization = require(parent2.Localization)
local Constants = require(parent.Constants)
local FFlagHelpPageCCL = require(parent.Flags.FFlagHelpPageCCL)
local useLocalizedLabels = require(parent.Hooks.useLocalizedLabels)

local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local KEYCODE_ORDER = Constants.HELP_PAGE.KEYCODE_ORDER

local function getKeyCodeName(p)
	if Constants.HELP_PAGE.KEYCODES_LOCALIZED[p] then
		return { needsLocalization = true, keyCodeName = Constants.HELP_PAGE.KEYCODES_LOCALIZED[p] }
	end

	if Constants.HELP_PAGE.KEYCODES_UNLOCALIZED[p] then
		return {
			needsLocalization = false,
			keyCodeName = Constants.HELP_PAGE.KEYCODES_UNLOCALIZED[p]
		}
	end

	return {
		needsLocalization = false,
		keyCodeName = UserInputService:GetStringForKeyCode(p)
	}
end

local function getKeycodeLayoutOrder(p) -- 4 equivalent calls inferred from this helper
	if KEYCODE_ORDER[p] then
		return KEYCODE_ORDER[p]
	end

	if p == ExtraKeysEnum.DPad or p == ExtraKeysEnum.TouchPad then
		return 1e999
	end

	return p.Value
end

local function getDisplayableKeyCodes(list)
	local displayableKeyCodes = {}

	for i = 1, #list do
		local item = list[i]

		if item ~= Enum.KeyCode.None and getKeyCodeName(item).keyCodeName ~= "" then
			table.insert(displayableKeyCodes, item)
		end
	end

	return displayableKeyCodes
end

local function KeyCodeComponent(props)
	local v = useTokens()
	local keyCodeName = getKeyCodeName(props.keyCode)

	local keyCodeNamesByKeyCodeName = {}

	if keyCodeName.needsLocalization then
		keyCodeNamesByKeyCodeName[keyCodeName.keyCodeName] = keyCodeName.keyCodeName
	end

	local v2 = useLocalization(keyCodeNamesByKeyCodeName)

	local text = keyCodeName.needsLocalization and v2[keyCodeName.keyCodeName] or keyCodeName.keyCodeName

	if props.addSeparator then
		text = Constants.HELP_PAGE.SEPARATORS.COMBO .. text
	end

	local createElement = React.createElement
	local textStyle

	if FFlagHelpPageCCL and props.disabled then
		textStyle = v.Color.Extended.White.White_50
	else
		textStyle = v.Color.Extended.White.White_100
	end

	return createElement(Text, {
		tag = "auto-xy text-body-small text-wrap text-align-x-left",
		textStyle = textStyle,
		Text = text
	})
end

local function KeyCodeComboComponent(props)
	local v = useTokens()
	local displayableKeyCodes = getDisplayableKeyCodes(props.combo)

	local v2 = React.useMemo(function()
		local children = {}

		if props.addSeparator then
			local createElement = React.createElement
			local v2 = { tag = "auto-xy", LayoutOrder = -1e999, key = "separator" }

			local createElement2 = React.createElement
			local textStyle

			if FFlagHelpPageCCL and props.disabled then
				textStyle = v.Color.Extended.White.White_50
			else
				textStyle = v.Color.Extended.White.White_100
			end

			local v3 = {
				Separator = createElement2(Text, {
					tag = "auto-xy text-body-small text-align-x-left text-truncate-end",
					textStyle = textStyle,
					Text = Constants.HELP_PAGE.SEPARATORS.ALTERNATIVE
				})
			}
			table.insert(children, createElement(View, v2, v3))
		end

		for i, displayableKeyCode in ipairs(displayableKeyCodes) do
			local addSeparator = i ~= 1
			table.insert(children, React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = i,
				key = i
			}, {
				KeyCodeComponent = React.createElement(KeyCodeComponent, {
					keyCode = displayableKeyCode,
					addSeparator = addSeparator,
					disabled = props.disabled
				})
			}))
		end

		return children
	end, {
		displayableKeyCodes,
		props.addSeparator,
		props.disabled,
		v.Color.Extended.White.White_50,
		v.Color.Extended.White.White_100
	})

	return React.createElement(View, { tag = "row wrap auto-xy" }, v2)
end

local function InputComponent(p)
	local v = React.useMemo(function()
		for _, list in ipairs(p.input) do
			table.sort(list, function(a, b): boolean
				return getKeycodeLayoutOrder(a) < getKeycodeLayoutOrder(b) -- inferred equivalent call
			end)
		end

		table.sort(p.input, function(a, b): boolean
			if #a ~= #b then
				return #a < #b
			end

			for i = 1, #a do
				if a[i] ~= b[i] then
					return getKeycodeLayoutOrder(a[i]) < getKeycodeLayoutOrder(b[i]) -- inferred equivalent call
				end
			end

			return false
		end)

		local children = {}

		for i, combo in ipairs(p.input) do
			if #getDisplayableKeyCodes(combo) == 0 then
				continue
			end

			local addSeparator = #children ~= 0

			table.insert(children, React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = i,
				key = i
			}, {
				KeyCodeComboComponent = React.createElement(KeyCodeComboComponent, {
					combo = combo,
					addSeparator = addSeparator,
					layoutOrder = i,
					disabled = p.disabled
				})
			}))
		end

		return children
	end, { p.input, p.disabled })

	return React.createElement(View, { tag = "row wrap auto-xy" }, v)
end

return React.memo(function(p)
	local v = useTokens()
	local control = p.control
	local v2 = useLocalizedLabels({ actionText = control.label })

	local keyboardInput = control.keyboardInput

	local input = React.useMemo(function()
		if keyboardInput == nil then
			return nil
		end

		local input = keyboardInput.input

		if input ~= nil then
			return input
		end

		if UserInputService:GetPlatform() == Enum.Platform.OSX then
			return keyboardInput.macInput
		end

		return keyboardInput.winInput
	end, { keyboardInput })

	if keyboardInput == nil or input == nil then
		return nil
	end

	local disabled = control.disabled
	local textStyle

	if FFlagHelpPageCCL and disabled then
		textStyle = v.Color.Extended.White.White_50
	else
		textStyle = v.Color.Extended.White.White_100
	end

	local backgroundStyle

	if FFlagHelpPageCCL and disabled then
		backgroundStyle = v.Color.Extended.Gray.Gray_1000
	else
		backgroundStyle = v.Color.Extended.Gray.Gray_800
	end

	return React.createElement(View, {
		tag = {
			["row wrap flex-x-fill align-x-left align-y-center gap-small size-full-0 auto-y padding-small radius-xsmall clip"] = FFlagHelpPageCCL,
			["row wrap flex-fill align-x-left align-y-center gap-small size-full-1100 padding-x-small radius-xsmall clip"] = not FFlagHelpPageCCL
		},
		backgroundStyle = backgroundStyle,
		LayoutOrder = keyboardInput.layoutOrder
	}, {
		ActionLabelContainer = React.createElement(View, {
			tag = {
				["col align-x-left align-y-center auto-y"] = FFlagHelpPageCCL,
				["col align-x-left align-y-center"] = not FFlagHelpPageCCL
			},
			LayoutOrder = 1
		}, {
			ActionLabel = React.createElement(Text, {
				tag = "auto-xy text-title-small text-wrap text-align-x-left",
				textStyle = textStyle,
				Text = v2.actionText
			})
		}),
		InputLabelContainer = React.createElement(View, {
			tag = {
				["col align-x-left align-y-center auto-y"] = FFlagHelpPageCCL,
				["col align-x-left align-y-center"] = not FFlagHelpPageCCL
			},
			LayoutOrder = 2,
			testId = "input-label-container"
		}, {
			InputLabel = React.createElement(InputComponent, { input = input, disabled = disabled })
		})
	})
end)
