local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Localization").Hooks.useLocalization

local text = Foundation.Text
local view = Foundation.View
local controlState = Foundation.Enums.ControlState
local useProperty = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/GuiObjectUtils").useProperty
local useTokens = Foundation.Hooks.useTokens
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SignalsReact")
local TextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/TextSize")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")

local v5 = { Selectable = true }
local function fn() end

local v6 = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function getCompactLineMeasureText(compactNumberOfLines)
	if compactNumberOfLines <= 0 then
		return ""
	end

	local v7 = {}

	for i = 1, compactNumberOfLines do
		table.insert(v7, "A")
	end

	return (table.concat(v7, "\n"))
end

local function calculateBlankLineAdjustedHeight(p2, p3, p4, p5)
	local v7 = not (p3 > 0 and p2 > 0) and 0 or p2 / p3

	if v7 > 0 and p4 > 0 and math.floor(p4 / v7 + 0.5) + 1 == p3 then
		local v8 = p2 + v7

		if v8 < p5 then
			return (math.ceil(v8))
		end
	end

	return p2
end

local function ExpandableText(props)
	local v7 = (props.text or ""):gsub("[\r\n]+$", "")
	local v8 = SignalsReact.useSignalState(function(p2)
		return TextSize.getTextSizeStore(p2).getTextSizeOffset(p2)
	end)

	local v9 = useTokens()

	local fontStyle = props.fontStyle or v9.Typography.CaptionLarge
	local joined = Cryo.Dictionary.join(fontStyle, {
		FontSize = fontStyle.FontSize + v8
	})

	local textStyle = props.textStyle or v9.Color.Content.Default
	local compactNumberOfLines = props.compactNumberOfLines or 3

	local pressedTextStyle = props.pressedTextStyle or v9.Color.Content.Muted
	local v10, v11 = React.useBinding(controlState.Default)
	local v12 = v10:map(function(p2)
		if p2 == controlState.Pressed or p2 == controlState.SelectedPressed then
			return pressedTextStyle
		end

		return textStyle
	end)

	local state, setState = React.useState(props.expandedInitially or false)

	local v13 = React.useCallback(function()
		setState(function(p2)
			local v14 = not p2

			if props.onExpandChanged then
				props.onExpandChanged(v14)
			end

			return v14
		end)
	end, { props.onExpandChanged })

	local v14 = useLocalization({
		moreText = "CommonUI.Features.Action.MoreLowercase",
		lessText = "CommonUI.Features.Action.LessLowercase"
	})

	local ref = React.useRef(nil)
	local v15 = useProperty(ref, "AbsoluteSize")
	local ref2 = React.useRef(nil)
	local v16 = useProperty(ref2, "AbsoluteSize")
	local ref3 = React.useRef(nil)
	local v17 = useProperty(ref3, "AbsoluteSize")

	local v18 = v15 and v15.X > 0
	local y = v17 and v17.Y or 0
	local v19 = v16 and v16.Y or 0

	local ref4 = React.useRef(nil)
	local v20 = useProperty(ref4, "AbsoluteSize")

	local v21 = React.useMemo(function()
		if not props.avoidBlankLineClip then
			return nil
		end

		local v22 = v7:find("\n\n")

		if v22 then
			return v7:sub(1, v22 - 1)
		end

		return nil
	end, { v7, props.avoidBlankLineClip })

	if v21 then
		local y2 = v20 and v20.Y or 0
		local v22 = not (compactNumberOfLines > 0 and v19 > 0) and 0 or v19 / compactNumberOfLines

		if v22 > 0 and y2 > 0 and math.floor(y2 / v22 + 0.5) + 1 == compactNumberOfLines then
			local v23 = v19 + v22

			if v23 < y then
				v19 = math.ceil(v23)
			end
		end
	end

	local v22 = not props.expandedInitially and v19 + 1 < y
	local v23 = state or not v22
	local v24 = v14.lessText

	if v22 and not state then
		v24 = v14.moreText
	else
		v19 = y
	end

	if v7 == "" then
		return nil
	end

	local v25

	if v23 then
		v25 = { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y }
	else
		v25 = {
			Size = UDim2.new(1, 0, 0, (math.ceil(v19)))
		}
	end

	local createElement = React.createElement
	local v27 = {
		tag = "col size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		selection = 0,
		onActivated = 0,
		stateLayer = 0,
		ref = 0
	}
	local v28 = if props.selectable ~= false then v5 else nil
	v27.selection = v28
	local v29 = if props.selectable ~= false then fn else nil
	v27.onActivated = v29
	local v30 = if props.selectable ~= false then v6 else nil
	v27.stateLayer = v30
	v27.ref = ref
	local v31

	if v18 and (v23 or v19 > 0) then
		local createElement2 = React.createElement

		local join = Cryo.Dictionary.join
		local v33 = {
			LayoutOrder = 1,
			Text = v7,
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

		if not v22 then
			v12 = textStyle
		end

		v33.textStyle = v12

		v33.TextXAlignment = Enum.TextXAlignment.Left
		v33.TextYAlignment = Enum.TextYAlignment.Top
		v33.ClipsDescendants = if v22 then not state else nil
		v33.onActivated = if v22 then v13 else nil

		if not v22 then
			v11 = nil
		end

		v33.onStateChanged = v11
		v33.selection = v22 and { Selectable = false } or nil
		v33.stateLayer = if v22 then v6 else nil
		v31 = createElement2(text, join(v33, v25))
	end

	local v32 = if v22 then React.createElement(text, {
		LayoutOrder = 2,
		tag = "auto-xy radius-small",
		Text = `<u><b>{v24}</b></u>`,
		fontStyle = joined,
		textStyle = v9.Color.Content.Emphasis,
		onActivated = v13,
		RichText = true
	}) else nil
	local children = {
		TextContent = v31,
		ToggleExpandButton = v32,
		CompactTextMeasure = React.createElement(text, {
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
		FullTextMeasure = React.createElement(text, {
			Visible = false,
			IgnoreLayout = true,
			ref = ref3,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 4,
			Text = v7,
			fontStyle = joined,
			textStyle = textStyle,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}),
		PrefixMeasure = 0
	}

	local v33 = if v21 then React.createElement(text, {
		Visible = false,
		IgnoreLayout = true,
		ref = ref4,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 5,
		Text = v21,
		fontStyle = joined,
		textColor = nil,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top
	}) else nil
	children.PrefixMeasure = v33
	return createElement(view, v27, children)
end

return React.memo(ExpandableText)
