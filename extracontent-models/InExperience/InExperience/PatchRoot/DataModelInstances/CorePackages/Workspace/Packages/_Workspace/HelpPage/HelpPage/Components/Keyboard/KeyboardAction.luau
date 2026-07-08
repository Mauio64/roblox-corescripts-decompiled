local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)

require(ParentParent.Configs.ConfigTypes)

local ExtraKeysEnum = require(ParentParent.Enums.ExtraKeysEnum)
local Localization = require(ParentParentParent.Localization)
local Constants = require(ParentParent.Constants)
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local KEYCODE_ORDER = Constants.HELP_PAGE.KEYCODE_ORDER

local function getKeyCodeName(p1) -- line: 45
	-- upvalues: Constants (copy), UserInputService (copy)
	if Constants.HELP_PAGE.KEYCODES_LOCALIZED[p1] then
		return {
			needsLocalization = true,
			keyCodeName = Constants.HELP_PAGE.KEYCODES_LOCALIZED[p1]
		}
	end

	if Constants.HELP_PAGE.KEYCODES_UNLOCALIZED[p1] then
		return {
			needsLocalization = false,
			keyCodeName = Constants.HELP_PAGE.KEYCODES_UNLOCALIZED[p1]
		}
	end

	local StringForKeyCode = UserInputService:GetStringForKeyCode(p1)

	return {
		needsLocalization = false,
		keyCodeName = StringForKeyCode
	}
end
local function getKeycodeLayoutOrder(p2) -- line: 65
	-- upvalues: KEYCODE_ORDER (copy), ExtraKeysEnum (copy)
	if KEYCODE_ORDER[p2] then
		return KEYCODE_ORDER[p2]
	end

	if p2 ~= ExtraKeysEnum.DPad and p2 ~= ExtraKeysEnum.TouchPad then
		return p2.Value
	end

	return 1e999
end
local function KeyCodeComponent(t1: {[any]: any}) -- line: 75
	-- upvalues: useTokens (copy), getKeyCodeName (copy), useLocalization (copy), Constants (copy), React (copy), FoundationText (copy)
	local v23 = useTokens()
	local v24 = getKeyCodeName(t1.keyCode)
	local t2 = {}

	if v24.needsLocalization then
		t2[v24.keyCodeName] = v24.keyCodeName
	end

	local v26 = useLocalization(t2)
	local v27 = v24.needsLocalization and v26[v24.keyCodeName] or v24.keyCodeName

	if t1.addSeparator then
		v27 = Constants.HELP_PAGE.SEPARATORS.COMBO .. v27
	end

	return React.createElement(FoundationText, {
		tag = "auto-xy text-align-x-left text-wrap text-body-small",
		textStyle = v23.Color.Extended.White.White_100,
		Text = v27
	})
end
local function KeyCodeComboComponent(t3: {[any]: any}) -- line: 97
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationText (copy), Constants (copy), KeyCodeComponent (copy)
	local v29 = useTokens()
	local v30 = React.useMemo(function() -- line: 100
		-- upvalues: t3 (copy), React (copy), View (copy), FoundationText (copy), v29 (copy), Constants (copy), KeyCodeComponent (copy)
		local t4 = {}

		if t3.addSeparator then
			table.insert(t4, React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = -1e999,
				key = "separator"
			}, {
				Separator = React.createElement(FoundationText, {
					tag = "auto-xy text-align-x-left text-truncate text-body-small",
					textStyle = v29.Color.Extended.White.White_100,
					Text = Constants.HELP_PAGE.SEPARATORS.ALTERNATIVE
				})
			}))
		end

		for i, v in ipairs(t3.combo) do
			local v41 = i ~= 1

			table.insert(t4, React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = i,
				key = i
			}, {
				KeyCodeComponent = React.createElement(KeyCodeComponent, {
					keyCode = v,
					addSeparator = v41
				})
			}))
		end

		return t4
	end, {
		t3.combo,
		t3.addSeparator
	})

	return React.createElement(View, {
		tag = "row auto-xy wrap"
	}, v30)
end
local function InputComponent(t5: {[any]: any}) -- line: 145
	-- upvalues: React (copy), KEYCODE_ORDER (copy), ExtraKeysEnum (copy), View (copy), KeyCodeComboComponent (copy)
	if t5.input == nil then
		return nil
	end

	React.useMemo(function() -- line: 153
		-- upvalues: t5 (copy), KEYCODE_ORDER (copy), ExtraKeysEnum (copy)
		for _, v in ipairs(t5.input) do
			table.sort(v, function(p3, p4) -- line: 155
				-- upvalues: KEYCODE_ORDER (copy), ExtraKeysEnum (copy)
				return ((if not KEYCODE_ORDER[p3] then (p3 == ExtraKeysEnum.DPad or p3 == ExtraKeysEnum.TouchPad) and 1e999 or p3.Value else KEYCODE_ORDER[p3])) < if not KEYCODE_ORDER[p4] then (p4 == ExtraKeysEnum.DPad or p4 == ExtraKeysEnum.TouchPad) and 1e999 or p4.Value else KEYCODE_ORDER[p4]
			end)
		end

		table.sort(t5.input, function(p5, p6) -- line: 160
			-- upvalues: KEYCODE_ORDER (copy), ExtraKeysEnum (copy)
			if #p5 == #p6 then
				for i = 1, #p5 do
					if p5[i] ~= p6[i] then
						local v54 = p5[i]
						local v55 = if not KEYCODE_ORDER[v54] then (v54 == ExtraKeysEnum.DPad or v54 == ExtraKeysEnum.TouchPad) and 1e999 or v54.Value else KEYCODE_ORDER[v54]
						local v56 = p6[i]

						return v55 < if not KEYCODE_ORDER[v56] then (v56 == ExtraKeysEnum.DPad or v56 == ExtraKeysEnum.TouchPad) and 1e999 or v56.Value else KEYCODE_ORDER[v56]
					end
				end

				return false
			end

			return #p5 < #p6
		end)
	end, { t5.input })

	local v32 = React.useMemo(function() -- line: 175
		-- upvalues: t5 (copy), React (copy), View (copy), KeyCodeComboComponent (copy)
		local t6 = {}

		for i, v in ipairs(t5.input) do
			local v47 = i ~= 1

			table.insert(t6, React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = i,
				key = i
			}, {
				KeyCodeComboComponent = React.createElement(KeyCodeComboComponent, {
					combo = v,
					addSeparator = v47,
					layoutOrder = i
				})
			}))
		end

		return t6
	end, { t5.input })

	return React.createElement(View, {
		tag = "row auto-xy wrap"
	}, v32)
end

return React.memo(function(t7: {[any]: any}) -- line: 205
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), UserInputService (copy), View (copy), FoundationText (copy), InputComponent (copy)
	local v34 = useTokens()
	local v35 = useLocalization({
		actionText = t7.control.label
	})
	local keyboardInput = t7.control.keyboardInput
	local v37 = React.useMemo(function() -- line: 216
		-- upvalues: keyboardInput (copy), UserInputService (copy)
		if keyboardInput == nil then
			return nil
		end

		local input = keyboardInput.input

		if input == nil then
			if UserInputService:GetPlatform() == Enum.Platform.OSX then
				return keyboardInput.macInput
			end

			input = keyboardInput.winInput
		end

		return input
	end, { keyboardInput })

	if keyboardInput == nil or v37 == nil then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full-1100 row align-y-center align-x-left wrap flex-fill padding-x-small gap-small radius-xsmall",
		ClipsDescendants = true,
		backgroundStyle = v34.Color.Extended.Gray.Gray_800,
		LayoutOrder = keyboardInput.layoutOrder
	}, {
		ActionLabelContainer = React.createElement(View, {
			tag = "align-y-center align-x-left col",
			LayoutOrder = 1
		}, {
			ActionLabel = React.createElement(FoundationText, {
				tag = "auto-xy text-align-x-left text-title-small text-wrap",
				textStyle = v34.Color.Extended.White.White_100,
				Text = v35.actionText
			})
		}),
		InputLabelContainer = React.createElement(View, {
			tag = "align-y-center align-x-left col",
			LayoutOrder = 2,
			testId = "input-label-container"
		}, {
			InputLabel = React.createElement(InputComponent, {
				input = v37
			})
		})
	})
end)
