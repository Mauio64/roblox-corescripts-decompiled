local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FoundationText = Foundation.Text
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local useProperty = require(Parent.GuiObjectUtils).useProperty
local useTokens = Foundation.Hooks.useTokens
local SignalsReact = require(Parent.SignalsReact)
local TextSize = require(Parent.TextSize)
local Cryo = require(Parent.Cryo)
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport
local v14 = game:DefineFastFlag("LuaAppExpandableTextNewLineStrip", true)
local v15 = game:DefineFastFlag("LuaAppExpandableTextAdjustClipToContent", false)
local t1 = {
	Selectable = true
}

local function v17() -- line: 24
end

local t2 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function getCompactLineMeasureText(n1: number) -- line: 52
	if n1 <= 0 then
		return ""
	end

	local t3 = {}

	for _ = 1, n1 do
		table.insert(t3, "A")
	end

	return (table.concat(t3, "\n"))
end
local function calculateBlankLineAdjustedHeight(n2: number, n3: number, n4: number, n5: number) -- line: 67
	local v29 = (not (n3 > 0) or not (n2 > 0)) and 0 or n2 / n3

	if v29 > 0 and (n4 > 0 and n3 == math.floor(n4 / v29 + 0.5) + 1) then
		local v30 = n2 + v29

		if v30 < n5 then
			return (math.ceil(v30))
		end
	end

	return n2
end
local function ExpandableText(t4: {[any]: any}) -- line: 87
	-- upvalues: v14 (copy), SignalsReact (copy), TextSize (copy), useTokens (copy), Cryo (copy), React (copy), ControlState (copy), useLocalization (copy), useProperty (copy), v15 (copy), View (copy), FFlagSduiExperienceDetailsSupport (copy), t1 (copy), v17 (copy), t2 (copy), FoundationText (copy), getCompactLineMeasureText (copy)
	local v32 = if not v14 then t4.text else (t4.text or ""):gsub("[\r\n]+$", "")
	local v33 = SignalsReact.useSignalState(function(p1) -- line: 91
		-- upvalues: TextSize (copy)
		return TextSize.getTextSizeStore(p1).getTextSizeOffset(p1)
	end)
	local v34 = useTokens()
	local v35 = t4.fontStyle or v34.Typography.CaptionLarge
	local v36 = Cryo.Dictionary.join(v35, {
		FontSize = v35.FontSize + v33
	})
	local v37 = t4.textStyle or v34.Color.Content.Default
	local v38 = t4.compactNumberOfLines or 3
	local v39 = t4.pressedTextStyle or v34.Color.Content.Muted
	local v40, v41 = React.useBinding(ControlState.Default)
	local v42 = v40:map(function(s1: string) -- line: 108
		-- upvalues: ControlState (copy), v39 (copy), v37 (copy)
		if s1 == ControlState.Pressed or s1 == ControlState.SelectedPressed then
			return v39
		end

		return v37
	end)
	local v43, v44 = React.useState(t4.expandedInitially or false)
	local v45 = React.useCallback(function() -- line: 117
		-- upvalues: v44 (copy), t4 (copy)
		v44(function(p2) -- line: 118
			-- upvalues: t4 (copy)
			local v71 = not p2

			if t4.onExpandChanged then
				t4.onExpandChanged(v71)
			end

			return v71
		end)
	end, { t4.onExpandChanged })
	local v46 = useLocalization({
		moreText = "CommonUI.Features.Action.MoreLowercase",
		lessText = "CommonUI.Features.Action.LessLowercase"
	})
	local v47 = React.useRef(nil)
	local v48 = useProperty(v47, "AbsoluteSize")
	local v49 = React.useRef(nil)
	local v50 = useProperty(v49, "AbsoluteSize")
	local v51 = React.useRef(nil)
	local v52 = useProperty(v51, "AbsoluteSize")
	local v53 = v48 and v48.X > 0
	local v54 = v52 and v52.Y or 0
	local v55 = v50 and v50.Y or 0
	local v56 = nil
	local v57 = nil
	local g59

	if v15 then
		v56 = React.useRef(nil)

		local v58 = useProperty(v56, "AbsoluteSize")

		v57 = React.useMemo(function() -- line: 155
			-- upvalues: t4 (copy), v32 (copy)
			if not t4.avoidBlankLineClip then
				return nil
			end

			local v69 = v32:find("\n\n")

			if not v69 then
				return nil
			end

			return v32:sub(1, v69 - 1)
		end, {
			v32,
			t4.avoidBlankLineClip
		})
		g59 = nil

		if not v57 then
			g59 = true
		end

		if not g59 then
			local v60 = v58 and v58.Y or 0
			local v61 = (not (v38 > 0) or not (v55 > 0)) and 0 or v55 / v38

			if v61 > 0 and v60 > 0 and v38 == math.floor(v60 / v61 + 0.5) + 1 then
				local v62 = v55 + v61

				if v62 < v54 then
					v55 = math.ceil(v62)
					g59 = true
				end
			end

			if not g59 then
				g59 = true
			end
		end
	end

	g59 = false

	local v63 = not t4.expandedInitially and v54 > v55 + 1
	local v64 = v43 or not v63
	local lessText = v46.lessText

	if v63 and not v43 then
		v54 = v55
		lessText = v46.moreText
	end

	if v32 == "" then
		return nil
	end

	local v66 = if not v64 then {
		Size = UDim2.new(1, 0, 0, (math.ceil(v54)))
	} else {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = t4.LayoutOrder,
		selection = if not FFlagSduiExperienceDetailsSupport or t4.selectable == false then nil else t1,
		onActivated = if not FFlagSduiExperienceDetailsSupport or t4.selectable == false then nil else v17,
		stateLayer = if not FFlagSduiExperienceDetailsSupport or t4.selectable == false then nil else t2,
		ref = v47
	}, {
		TextContent = if not v53 or not v64 and not (v54 > 0) then nil else React.createElement(FoundationText, Cryo.Dictionary.join({
			LayoutOrder = 1,
			TextWrapped = true,
			Text = v32,
			fontStyle = v36,
			textStyle = if not v63 then v37 else v42,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			ClipsDescendants = if not v63 then nil else not v43,
			onActivated = if not v63 then nil else v45,
			onStateChanged = if not v63 then nil else v41,
			selection = if not v63 then nil else {
				Selectable = false
			},
			stateLayer = if not v63 then nil else t2
		}, v66)),
		ToggleExpandButton = if not v63 then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy radius-small",
			RichText = true,
			Text = `<u><b>{ lessText }</b></u>`,
			fontStyle = v36,
			textStyle = v34.Color.Content.Emphasis,
			onActivated = v45
		}),
		CompactTextMeasure = React.createElement(FoundationText, {
			Visible = false,
			IgnoreLayout = true,
			LayoutOrder = 3,
			TextWrapped = true,
			ref = v49,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = getCompactLineMeasureText(v38),
			fontStyle = v36,
			textStyle = v37,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}),
		FullTextMeasure = React.createElement(FoundationText, {
			Visible = false,
			IgnoreLayout = true,
			LayoutOrder = 4,
			TextWrapped = true,
			ref = v51,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v32,
			fontStyle = v36,
			textStyle = v37,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}),
		PrefixMeasure = if not v15 or not v57 then nil else React.createElement(FoundationText, {
			Visible = false,
			IgnoreLayout = true,
			LayoutOrder = 5,
			textColor = nil,
			TextWrapped = true,
			ref = v56,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v57,
			fontStyle = v36,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end

return React.memo(ExpandableText)
