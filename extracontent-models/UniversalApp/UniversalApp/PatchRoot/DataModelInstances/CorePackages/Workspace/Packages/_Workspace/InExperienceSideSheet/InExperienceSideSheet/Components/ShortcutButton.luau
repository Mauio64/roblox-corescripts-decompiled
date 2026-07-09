local Parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local React = require(Parent.React)

require(Parent.Signals)

local SignalsReact = require(Parent.SignalsReact)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local isBuilderIcon = Foundation.Utility.isBuilderIcon
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local FoundationText = Foundation.Text
local View = Foundation.View

local function ShortcutButton(t1: {[any]: any}) -- line: 37
	-- upvalues: useTokens (copy), useLocalization (copy), SignalsReact (copy), React (copy), IconSize (copy), isBuilderIcon (copy), View (copy), Icon (copy), FoundationText (copy)
	local v15 = useTokens()
	local v16 = useLocalization({
		label = t1.label
	})
	local v17 = SignalsReact.useSignalState(t1.getIsEnabled)
	local v18 = SignalsReact.useSignalState(t1.getShortcutIcon)
	local v19 = React.useCallback(function() -- line: 48
		-- upvalues: t1 (copy)
		t1.getOnActivated()()
	end, { t1.getOnActivated })
	local Medium = IconSize.Medium
	local XSmall = v15.Gap.XSmall

	if isBuilderIcon(v18) then
		Medium = IconSize.XLarge
		XSmall = v15.Gap.Small
	end

	local v22 = if not t1.isEmphasis then v15.Color.ActionStandard.Background else v15.Color.ActionSoftEmphasis.Background
	local v23 = if not t1.isEmphasis then v15.Color.ActionStandard.Foreground else v15.Color.ActionSoftEmphasis.Foreground
	local createElement = React.createElement
	local v25 = View
	local t2 = {
		tag = {
			["fill row gap-small align-y-center align-x-center radius-medium"] = true,
			["size-0-1000"] = not t1.isSmall,
			["size-0-800"] = t1.isSmall,
			["bg-action-standard"] = not t1.isEmphasis,
			["bg-action-soft-emphasis"] = t1.isEmphasis
		},
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, XSmall)
		},
		isDisabled = not v17
	}
	local t3 = {
		Color3 = v22.Color3
	}
	local Transparency

	if v17 then
		Transparency = v22.Transparency
	else
		local Transparency2 = v22.Transparency

		Transparency = Transparency2 + (1 - Transparency2) * 0.5
	end

	t3.Transparency = Transparency
	t2.backgroundStyle = t3
	t2.onActivated = v19
	t2.LayoutOrder = t1.layoutOrder

	return createElement(v25, t2, {
		ShortcutIcon = if not v18 then nil else React.createElement(Icon, {
			LayoutOrder = 1,
			name = v18,
			size = Medium
		}),
		Text = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = {
				["auto-x"] = true,
				["text-title-medium"] = not t1.isSmall,
				["text-title-small"] = t1.isSmall,
				["content-action-standard"] = not t1.isEmphasis,
				["content-action-soft-emphasis"] = t1.isEmphasis
			},
			Text = v16.label,
			textStyle = {
				Color3 = v23.Color3,
				Transparency = not v17 and 0.5 or v23.Transparency
			}
		})
	})
end

return React.memo(ShortcutButton)
