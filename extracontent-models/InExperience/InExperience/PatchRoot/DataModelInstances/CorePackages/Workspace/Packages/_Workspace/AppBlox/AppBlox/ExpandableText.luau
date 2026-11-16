local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Text = Foundation.Text
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local GuiObjectUtils = require(parent.GuiObjectUtils)
local useProperty = GuiObjectUtils.useProperty
local useTokens = Foundation.Hooks.useTokens
local SignalsReact = require(parent.SignalsReact)
local TextSize = require(parent.TextSize)
local Cryo = require(parent.Cryo)

local defineFastFlag = game:DefineFastFlag("LuaAppExpandableTextNewLineStrip", true)

local v = { Selectable = true }
local function fn() end

local v2 = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function getCompactLineMeasureText(compactNumberOfLines: number)
	if compactNumberOfLines <= 0 then
		return ""
	end

	local v3 = {}

	for _ = 1, compactNumberOfLines do
		table.insert(v3, "A")
	end

	return (table.concat(v3, "\n"))
end

local function calculateBlankLineAdjustedHeight(p: number, compactNumberOfLines: number, y: number, y2: number) -- 1 equivalent call inferred from this helper
	local v3 = not (compactNumberOfLines > 0 and p > 0) and 0 or p / compactNumberOfLines

	if v3 > 0 and y > 0 and math.floor(y / v3 + 0.5) + 1 == compactNumberOfLines then
		local v4 = p + v3

		if v4 < y2 then
			return (math.ceil(v4))
		end
	end

	return p
end

local function ExpandableText(props)
	local text

	if defineFastFlag then
		text = (props.text or ""):gsub("[\r\n]+$", "")
	else
		text = props.text
	end

	local v3 = SignalsReact.useSignalState(function(p)
		return TextSize.getTextSizeStore(p).getTextSizeOffset(p)
	end)

	local v4 = useTokens()

	local fontStyle = props.fontStyle or v4.Typography.CaptionLarge
	local joined = Cryo.Dictionary.join(fontStyle, {
		FontSize = fontStyle.FontSize + v3
	})

	local textStyle = props.textStyle or v4.Color.Content.Default
	local compactNumberOfLines = props.compactNumberOfLines or 3

	local pressedTextStyle = props.pressedTextStyle or v4.Color.Content.Muted
	local v5, onStateChanged = React.useBinding(ControlState.Default)
	local textStyle2 = v5:map(function(p: string)
		if p == ControlState.Pressed or p == ControlState.SelectedPressed then
			return pressedTextStyle
		end

		return textStyle
	end)

	local state, setState = React.useState(props.expandedInitially or false)

	local onActivated = React.useCallback(function()
		setState(function(p)
			local v6 = not p

			if props.onExpandChanged then
				props.onExpandChanged(v6)
			end

			return v6
		end)
	end, { props.onExpandChanged })

	local v6 = useLocalization({
		moreText = "CommonUI.Features.Action.MoreLowercase",
		lessText = "CommonUI.Features.Action.LessLowercase"
	})

	local ref = React.useRef(nil)
	local v7 = useProperty(ref, "AbsoluteSize")
	local ref2 = React.useRef(nil)
	local v8 = useProperty(ref2, "AbsoluteSize")
	local ref3 = React.useRef(nil)
	local v9 = useProperty(ref3, "AbsoluteSize")

	local v10 = v7 and v7.X > 0
	local y = v9 and v9.Y or 0
	local v11 = v8 and v8.Y or 0

	local ref4 = React.useRef(nil)
	local v12 = useProperty(ref4, "AbsoluteSize")

	local text2 = React.useMemo(function()
		if not props.avoidBlankLineClip then
			return nil
		end

		local v13 = text:find("\n\n")

		if v13 then
			return text:sub(1, v13 - 1)
		end

		return nil
	end, { text, props.avoidBlankLineClip })

	if text2 then
		v11 = calculateBlankLineAdjustedHeight(v11, compactNumberOfLines, v12 and v12.Y or 0, y) -- inferred equivalent call
	end

	local v13 = not props.expandedInitially and v11 + 1 < y
	local v14 = state or not v13
	local v15 = v6.lessText

	if v13 and not state then
		v15 = v6.moreText
	else
		v11 = y
	end

	if text == "" then
		return nil
	end

	local v16

	if v14 then
		v16 = { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y }
	else
		v16 = {
			Size = UDim2.new(1, 0, 0, (math.ceil(v11)))
		}
	end

	local createElement = React.createElement
	local v17 = {
		tag = "col size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		selection = 0,
		onActivated = 0,
		stateLayer = 0,
		ref = 0
	}
	local selection

	if props.selectable ~= false then
		selection = v
	end

	v17.selection = selection
	local onActivated2

	if props.selectable ~= false then
		onActivated2 = fn
	end

	v17.onActivated = onActivated2
	local stateLayer

	if props.selectable ~= false then
		stateLayer = v2
	end

	v17.stateLayer = stateLayer
	v17.ref = ref
	local textContent

	if v10 and (v14 or v11 > 0) then
		local createElement2 = React.createElement

		local join = Cryo.Dictionary.join
		local v18 = {
			LayoutOrder = 1,
			Text = text,
			fontStyle = joined,
			textStyle = nil,
			TextWrapped = true,
			TextXAlignment = 0,
			TextYAlignment = 0,
			ClipsDescendants = 0,
			onActivated = 0,
			onStateChanged = 0,
			selection = 0,
			stateLayer = 0
		}

		if not v13 then
			textStyle2 = textStyle
		end

		v18.textStyle = textStyle2

		v18.TextXAlignment = Enum.TextXAlignment.Left
		v18.TextYAlignment = Enum.TextYAlignment.Top
		local clipsDescendants

		if v13 then
			clipsDescendants = not state
		end

		v18.ClipsDescendants = clipsDescendants
		local onActivated3

		if v13 then
			onActivated3 = onActivated
		end

		v18.onActivated = onActivated3

		if not v13 then
			onStateChanged = nil
		end

		v18.onStateChanged = onStateChanged
		v18.selection = v13 and { Selectable = false } or nil
		local stateLayer2

		if v13 then
			stateLayer2 = v2
		end

		v18.stateLayer = stateLayer2
		textContent = createElement2(Text, join(v18, v16))
	end

	local toggleExpandButton

	if v13 then
		toggleExpandButton = React.createElement(Text, {
			LayoutOrder = 2,
			tag = "auto-xy radius-small",
			Text = `<u><b>{v15}</b></u>`,
			fontStyle = joined,
			textStyle = v4.Color.Content.Emphasis,
			onActivated = onActivated,
			RichText = true
		})
	end

	local children = {
		TextContent = textContent,
		ToggleExpandButton = toggleExpandButton,
		CompactTextMeasure = React.createElement(Text, {
			Visible = false,
			IgnoreLayout = true,
			ref = ref2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 3,
			Text = getCompactLineMeasureText(compactNumberOfLines),
			fontStyle = joined,
			textStyle = textStyle,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}),
		FullTextMeasure = React.createElement(Text, {
			Visible = false,
			IgnoreLayout = true,
			ref = ref3,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 4,
			Text = text,
			fontStyle = joined,
			textStyle = textStyle,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}),
		PrefixMeasure = 0
	}
	local prefixMeasure

	if text2 then
		prefixMeasure = React.createElement(Text, {
			Visible = false,
			IgnoreLayout = true,
			ref = ref4,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 5,
			Text = text2,
			fontStyle = joined,
			textColor = nil,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})
	end

	children.PrefixMeasure = prefixMeasure
	return createElement(View, v17, children)
end

return React.memo(ExpandableText)
