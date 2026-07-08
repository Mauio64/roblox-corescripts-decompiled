local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)

require(ParentParent.Configs.ConfigTypes)

local Constants = require(ParentParent.Constants)
local useLocalization = require(ParentParentParent.Localization).Hooks.useLocalization
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local useTokens = Foundation.Hooks.useTokens
local ExtraKeysEnum = require(ParentParent.Enums.ExtraKeysEnum)
local v13 = React.memo(function(t1: {[any]: any}) -- line: 45
	-- upvalues: useLocalization (copy), React (copy), FoundationText (copy)
	local v17 = useLocalization({
		action = t1.action
	})

	return React.createElement(FoundationText, {
		tag = "auto-xy text-align-x-center text-align-y-center text-title-large",
		Text = v17.action
	})
end)
local v14 = React.memo(function(t2: {[any]: any}) -- line: 56
	-- upvalues: useTokens (copy), React (copy), ExtraKeysEnum (copy), Constants (copy), View (copy), Icon (copy), Enums (copy)
	local v19 = useTokens()
	local v20 = React.useMemo(function() -- line: 60
		-- upvalues: t2 (copy), ExtraKeysEnum (copy), Constants (copy)
		local t3 = {}

		for _, v in ipairs(t2.buttons) do
			if v ~= ExtraKeysEnum.TouchPad then
				t3[v] = if not t2.isSpatial then if not Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[t2.platform] then Constants.HELP_PAGE.GAMEPAD_ICON_MAP_XBOX[v] else if t2.platform ~= Enum.Platform.PS5 or Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION_5[v] == nil then Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION[v] else Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION_5[v] else Constants.HELP_PAGE.GAMEPAD_ICON_MAP_SPATIAL[v]
			elseif Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[t2.platform] then
				if t2.platform == Enum.Platform.PS5 and Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION_5[v] ~= nil then
					t3[v] = Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION_5[v]
				else
					t3[v] = Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION[v]
				end
			end
		end

		return t3
	end, { t2.buttons })
	local v21 = React.useMemo(function() -- line: 102
		-- upvalues: t2 (copy), React (copy), View (copy), v19 (copy), v20 (copy), Constants (copy), Icon (copy), Enums (copy)
		local t4 = {}

		if t2.addBlankIcon and t2.layoutOrderReversed then
			table.insert(t4, React.createElement(View, {
				BackgroundTransparency = 1,
				LayoutOrder = -1,
				key = "BlankIconBefore",
				Size = UDim2.fromOffset(v19.Size.Size_600, v19.Size.Size_600)
			}))
		end

		for v29, v30 in v20 do
			table.insert(t4, React.createElement(View, {
				tag = "align-x-center align-y-center auto-xy",
				LayoutOrder = Constants.HELP_PAGE.GAMEPAD_LAYOUT_ORDER[v29],
				key = Constants.HELP_PAGE.GAMEPAD_LAYOUT_ORDER[v29]
			}, {
				Icon = React.createElement(Icon, {
					name = v30,
					size = Enums.IconSize.Large
				})
			}))
		end

		return t4
	end, {
		v20,
		t2.addBlankIcon,
		t2.layoutOrderReversed
	})

	return React.createElement(View, {
		tag = "align-x-center align-y-center auto-xy gap-xsmall row"
	}, v21)
end)
local v15 = React.memo(function(t5: {[any]: any}) -- line: 141
	-- upvalues: React (copy), Constants (copy), View (copy), v13 (copy), v14 (copy)
	local v23, v24 = React.useMemo(function() -- line: 142
		-- upvalues: t5 (copy), Constants (copy), React (copy), View (copy), v13 (copy), v14 (copy)
		local t6 = {}
		local t7 = {}

		for v33, v34 in t5.controls do
			if v34.gamepadInput then
				local gamepadInput = v34.gamepadInput
				local input = gamepadInput.input

				if input == nil then
					input = if not t5.isSpatial then if not Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[t5.platform] then gamepadInput.xboxInput else gamepadInput.playstationInput else gamepadInput.spatialGamepadInput
				end

				if input ~= nil and #input > 0 then
					local v37 = Constants.HELP_PAGE.GAMEPAD_LAYOUT_ORDER[input[1]]

					if t5.layoutOrderReversed then
						v37 = -v37
					end

					table.insert(t6, React.createElement(View, {
						tag = "align-y-center auto-x col size-0-1000",
						LayoutOrder = v37,
						key = "Text-" .. v33
					}, {
						ActionText = React.createElement(v13, {
							action = v34.label
						})
					}))
					table.insert(t7, React.createElement(View, {
						tag = "align-y-center auto-x col size-0-1000",
						LayoutOrder = v37,
						key = "Icon-" .. v33
					}, {
						IconContainer = React.createElement(v14, {
							buttons = input,
							platform = t5.platform,
							addBlankIcon = t5.addBlankIcon,
							layoutOrderReversed = t5.layoutOrderReversed,
							isSpatial = t5.isSpatial
						})
					}))
				end
			end
		end

		return t6, t7
	end, {
		t5.controls,
		t5.platform,
		t5.addBlankIcon,
		t5.layoutOrderReversed
	})

	return React.createElement(View, {
		tag = "row auto-xy gap-small"
	}, {
		TextCol = React.createElement(View, {
			tag = {
				["col auto-xy align-x-right"] = not t5.layoutOrderReversed,
				["col auto-xy align-x-left"] = t5.layoutOrderReversed
			},
			LayoutOrder = not t5.layoutOrderReversed and 1 or 3
		}, v23),
		IconCol = React.createElement(View, {
			tag = "col auto-xy",
			LayoutOrder = 2
		}, v24)
	})
end)

return React.memo(v15)
