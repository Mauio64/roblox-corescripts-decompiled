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
local Flags = require(InExperienceSideSheet.Flags)
local FFlagSideSheetEmphasizeLeave = Flags.FFlagSideSheetEmphasizeLeave

local ButtonWidth = Enums.ButtonWidth

local signal = Signals.createSignal(nil)

local function fn(transparency: number) -- 1 equivalent call inferred from this helper
	return transparency + (1 - transparency) * 0.5
end

local function ShortcutButton(props)
	local v = useTokens()

	local label = useLocalization({ label = props.label }).label

	local v2 = SignalsReact.useSignalState(props.getIsEnabled)

	local name = SignalsReact.useSignalState(props.getShortcutIcon or signal)

	local onActivated = React.useCallback(function()
		props.getOnActivated()()
	end, { props.getOnActivated })

	local size = IconSize.Medium
	local v3 = v.Gap.XSmall

	if isBuilderIcon(name) then
		size = IconSize.XLarge
		v3 = v.Gap.Small
	end

	local v4 = FFlagSideSheetEmphasizeLeave and props.isEmphasized == true
	local background

	if v4 then
		background = v.Color.ActionSoftEmphasis.Background
	else
		background = v.Color.ActionStandard.Background
	end

	local foreground

	if v4 then
		foreground = v.Color.ActionSoftEmphasis.Foreground
	else
		foreground = v.Color.ActionStandard.Foreground
	end

	local sizefull = (props.width or ButtonWidth.Full) == ButtonWidth.Full

	local createElement = React.createElement
	local v5 = {
		tag = {
			["row align-x-center align-y-center gap-small radius-medium"] = true,
			["bg-action-standard"] = not v4,
			["size-full-1000"] = sizefull,
			["fill size-0-1000"] = not sizefull
		},
		layout = { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, v3) },
		isDisabled = not v2,
		backgroundStyle = 0,
		onActivated = 0,
		testId = 0,
		LayoutOrder = 0
	}
	local backgroundStyle

	if v2 then
		backgroundStyle = background
	else
		backgroundStyle = { Color3 = background.Color3, Transparency = 0 }
		backgroundStyle.Transparency = fn(background.Transparency) -- inferred equivalent call
	end

	v5.backgroundStyle = backgroundStyle

	v5.onActivated = onActivated
	local testId

	if FFlagSideSheetEmphasizeLeave then
		testId = props.testId
	end

	v5.testId = testId
	v5.LayoutOrder = props.layoutOrder
	local shortcutIcon

	if name then
		shortcutIcon = React.createElement(Icon, { name = name, size = size, LayoutOrder = 1 })
	end

	return createElement(View, v5, {
		ShortcutIcon = shortcutIcon,
		Text = React.createElement(Text, {
			tag = {
				["auto-x text-label-medium"] = true,
				["content-action-standard"] = not v4
			},
			Text = label,
			textStyle = not v2 and { Color3 = foreground.Color3, Transparency = 0.5 } or foreground,
			LayoutOrder = 2
		})
	})
end

return React.memo(ShortcutButton)
