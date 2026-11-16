local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Wrappers = require(Foundation.Utility.Wrappers)
local UserInputService = Wrappers.Services.UserInputService

local Flags = require(Foundation.Utility.Flags)

local Constants = require(Foundation.Constants)
local Logger = require(Foundation.Utility.Logger)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverContext = require(Foundation.Components.Popover.PopoverContext)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)
local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local Popover = require(Foundation.Components.Popover)

local v = {
	align = PopoverAlign.Start,
	side = PopoverSide.Right,
	hasArrow = true,
	testId = "--foundation-tooltip"
}

local function AnchorWrapper(p)
	local v2 = React.useContext(PopoverContext)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if v2.anchor ~= nil then
			if typeof(v2.anchor) == "Instance" then
				ref.current = v2.anchor:GetPropertyChangedSignal("GuiState"):Connect(function()
					p.onHover(v2.anchor.GuiState == Enum.GuiState.Hover)
				end)
			else
				Logger:warning("MeasurableRef cannot be an anchor for the tooltip")
				return
			end
		end

		return function()
			if ref.current ~= nil then
				ref.current:Disconnect()
			end
		end
	end, { v2.anchor, p.onHover })

	return React.createElement(Popover.Anchor, withCommonProps(p, {}), p.children)
end

local function Tooltip(p)
	local v2 = withDefaults(p, v)
	local state, setState = React.useState(false)
	local v3 = useTokens()
	local textcaptionmedium

	if v2.text == nil then
		textcaptionmedium = false
	else
		textcaptionmedium = v2.text ~= ""
	end

	local v4 = useScaledValue(Constants.TOOLTIP_MAX_WIDTH)
	local padding

	if textcaptionmedium then
		padding = {
			top = UDim.new(0, v3.Size.Size_150),
			bottom = UDim.new(0, v3.Size.Size_200),
			left = UDim.new(0, v3.Size.Size_200),
			right = UDim.new(0, v3.Size.Size_200)
		}
	else
		padding = {
			top = UDim.new(0, v3.Size.Size_100),
			bottom = UDim.new(0, v3.Size.Size_150),
			left = UDim.new(0, v3.Size.Size_150),
			right = UDim.new(0, v3.Size.Size_150)
		}
	end

	local text = React.useMemo(function()
		if v2.shortcut == nil then
			return nil
		end

		local v5 = ""

		for k, v6 in v2.shortcut do
			local v7 = UserInputService:GetStringForKeyCode(v6)

			if v7 == nil or v7 == "" then
				v7 = v6.Name
			end

			if k > 1 then
				v5 ..= " + "
			end

			v5 ..= v7
		end

		return v5
	end, { v2.shortcut })

	local createElement = React.createElement
	local root = Popover.Root
	local v5 = { isOpen = state, testId = v2.testId }
	local v6 = {
		Anchor = React.createElement(AnchorWrapper, withCommonProps(v2, { onHover = setState }), v2.children),
		Content = 0
	}

	local createElement2 = React.createElement
	local content = Popover.Content
	local v7 = {
		hasArrow = v2.hasArrow,
		align = v2.align,
		side = { position = v2.side, offset = v3.Size.Size_200 },
		radius = Radius.Small,
		backgroundStyle = v3.Inverse.Surface.Surface_0,
		selectionGroup = false,
		onPressedOutside = Flags.FoundationTooltipPressedOutside and function()
			setState(false)
		end or nil
	}

	local createElement3 = React.createElement
	local v8 = {
		tag = { ["col gap-xsmall auto-xy"] = true },
		padding = padding,
		sizeConstraint = { MaxSize = Vector2.new(v4, 1e999) }
	}
	local header

	if not (v2.title == "" and not v2.shortcut) then
		local createElement4 = React.createElement
		local title

		if v2.title ~= "" then
			title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = v2.title,
				tag = {
					["shrink auto-xy text-truncate-end content-inverse-emphasis"] = true,
					["text-caption-medium"] = textcaptionmedium,
					["text-body-small"] = not textcaptionmedium
				},
				testId = `{v2.testId}--title`
			})
		end

		local shortcut

		if v2.shortcut then
			shortcut = React.createElement(Text, {
				LayoutOrder = 2,
				Text = text,
				tag = "auto-xy text-body-small content-inverse-muted",
				testId = `{v2.testId}--shortcut`
			})
		end

		header = createElement4(View, {
			LayoutOrder = 1,
			tag = "row flex-between gap-small size-full-0 auto-y"
		}, {
			Title = title,
			Shortcut = shortcut
		})
	end

	local text2

	if v2.text and v2.text ~= "" then
		text2 = React.createElement(Text, {
			LayoutOrder = 2,
			Text = v2.text,
			tag = "auto-xy text-body-small text-wrap text-align-x-left content-inverse-default",
			testId = `{v2.testId}--text`
		})
	end

	v6.Content = createElement2(content, v7, createElement3(View, v8, {
		Header = header,
		Text = text2
	}))
	return createElement(root, v5, v6)
end

return React.memo(Tooltip)
