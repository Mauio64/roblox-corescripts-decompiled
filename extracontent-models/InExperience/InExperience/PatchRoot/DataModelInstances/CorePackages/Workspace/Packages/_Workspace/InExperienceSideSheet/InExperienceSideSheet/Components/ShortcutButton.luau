local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local isBuilderIcon = Foundation.Utility.isBuilderIcon
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local Text = Foundation.Text
local View = Foundation.View

local Enums = require(InExperienceSideSheet.Common.Enums)

local ButtonWidth = Enums.ButtonWidth

local signal = Signals.createSignal(nil)

local function fn(transparency: number) -- 1 equivalent call inferred from this helper
	return transparency + (1 - transparency) * 0.5
end

local function ShortcutButton(props)
	local v = useTokens()

	local v2 = useLocalization({ label = props.label })

	local v3 = SignalsReact.useSignalState(props.getIsEnabled)

	local name = SignalsReact.useSignalState(props.getShortcutIcon or signal)

	local onActivated = React.useCallback(function()
		props.getOnActivated()()
	end, { props.getOnActivated })

	local size = IconSize.Medium
	local v4 = v.Gap.XSmall

	if isBuilderIcon(name) then
		size = IconSize.XLarge
		v4 = v.Gap.Small
	end

	local background = v.Color.ActionStandard.Background
	local foreground = v.Color.ActionStandard.Foreground

	local sizefull = (props.width or ButtonWidth.Full) == ButtonWidth.Full

	local createElement = React.createElement
	local v5 = {
		tag = {
			["row align-x-center align-y-center gap-small radius-medium bg-action-standard"] = true,
			["size-full-1000"] = sizefull,
			["fill size-0-1000"] = not sizefull
		},
		layout = { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, v4) },
		isDisabled = not v3,
		backgroundStyle = 0,
		onActivated = 0,
		LayoutOrder = 0
	}

	local backgroundStyle = { Color3 = background.Color3, Transparency = 0 }
	local transparency

	if v3 then
		transparency = background.Transparency
	else
		transparency = fn(background.Transparency) -- inferred equivalent call
	end

	backgroundStyle.Transparency = transparency
	v5.backgroundStyle = backgroundStyle

	v5.onActivated = onActivated
	v5.LayoutOrder = props.layoutOrder
	local shortcutIcon

	if name then
		shortcutIcon = React.createElement(Icon, { name = name, size = size, LayoutOrder = 1 })
	end

	return createElement(View, v5, {
		ShortcutIcon = shortcutIcon,
		Text = React.createElement(Text, {
			tag = "auto-x text-label-medium content-action-standard",
			Text = v2.label,
			textStyle = {
				Color3 = foreground.Color3,
				Transparency = not v3 and 0.5 or foreground.Transparency
			},
			LayoutOrder = 2
		})
	})
end

return React.memo(ShortcutButton)
