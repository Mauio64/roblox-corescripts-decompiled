local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Icon = Foundation.Icon
local InputLabel = Foundation.InputLabel
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local ControlState = Foundation.Enums.ControlState
local InputLabelSize = Foundation.Enums.InputLabelSize
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local function createButtons(t1: {[any]: any}, p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?, s1: string?) -- line: 30
	-- upvalues: useTokens (copy), React (copy), ControlState (copy), View (copy), InputLabel (copy), InputLabelSize (copy), Icon (copy), IconSize (copy)
	local v20 = useTokens()
	local t2 = {}
	local v22, v23 = React.useState(s1 or "")

	for k, v in pairs(t1) do
		local v26, v27 = React.useState(false)
		local v28 = React.useCallback(function() -- line: 43
			-- upvalues: v23 (copy), v (copy), p2 (copy), p3 (copy), p1 (copy), v27 (copy)
			v23(v.value)
			p2(v.value, v.text)

			if p3 then
				p3(p1[v.value])
			end

			v27(true)
		end, {
			p2,
			p3,
			v27
		})
		local v29 = React.useCallback(function(p4) -- line: 52
			-- upvalues: ControlState (copy), v27 (copy)
			if p4 == ControlState.Hover or p4 == ControlState.Pressed then
				v27(true)

				return
			end

			v27(false)
		end, {
			v27,
			v28
		})

		table.insert(t2, React.createElement(View, {
			tag = "auto-xy col gap-xsmall padding-bottom-xsmall"
		}, {
			ButtonContainer = React.createElement(View, {
				tag = "size-full-0 auto-y radius-medium row flex-between",
				onStateChanged = v29,
				onActivated = v28
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 4),
					PaddingRight = UDim.new(0, 4),
					PaddingTop = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 10)
				}),
				Button = React.createElement(InputLabel, {
					Text = v.text,
					textStyle = if not v26 then v20.Color.Content.Default else v20.Color.Content.Emphasis,
					onActivated = v28,
					onHover = v27,
					size = InputLabelSize.Medium
				}),
				Icon = if v22 ~= v.value then nil else React.createElement(Icon, {
					name = "icons/status/success_small",
					size = IconSize.Small
				})
			}),
			Divider = React.createElement(View, {
				tag = "size-full-0 auto-y",
				stroke = {
					Thickness = 0.5,
					Color = v20.Color.Content.Default.Color3,
					Transparency = next(t1, k) ~= nil and v20.Color.Content.Default.Transparency or 1
				}
			})
		}))
	end

	return t2
end
local function ButtonList(t3: {[any]: any}) -- line: 112
	-- upvalues: React (copy), Cryo (copy), useLocalization (copy), createButtons (copy), View (copy)
	local v31 = React.useMemo(function() -- line: 113
		-- upvalues: Cryo (copy), t3 (copy)
		return Cryo.Dictionary.map(t3.options, function(p5) -- line: 114
			return p5.localizationKey, p5.value
		end)
	end)
	local v32 = React.useMemo(function() -- line: 119
		-- upvalues: Cryo (copy), t3 (copy)
		return Cryo.Dictionary.map(t3.options, function(p6) -- line: 120
			return p6.descriptionLocalizationKey, p6.value
		end)
	end)
	local v33 = useLocalization(v31)
	local v34 = useLocalization(v32)
	local v35 = React.useMemo(function() -- line: 128
		-- upvalues: Cryo (copy), t3 (copy), v33 (copy)
		return Cryo.List.map(t3.options, function(p7) -- line: 129
			-- upvalues: v33 (copy)
			return {
				text = v33[p7.value] or "",
				value = p7.value
			}
		end)
	end, {
		t3.options,
		v33
	})
	local v36 = createButtons(v35, v34, t3.onSelected, t3.setDescription, t3.defaultValue)

	return React.createElement(View, {
		tag = "size-full col"
	}, { v36 })
end

return ButtonList
