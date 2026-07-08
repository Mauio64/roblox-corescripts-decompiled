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
local SharedFlags = require(Parent.SharedFlags)
local FFlagSduiExperienceDetailsSupport = SharedFlags.FFlagSduiExperienceDetailsSupport
local v15 = game:DefineFastFlag("LuaAppExpandableTextNewLineStrip", true)
local v16 = game:DefineFastFlag("LuaAppExpandableTextAdjustClipToContent", false)
local FFlagLuaAppExpandableTextTappableText = SharedFlags.FFlagLuaAppExpandableTextTappableText
local t1 = {
	Selectable = true
}

local function v19() -- line: 25
end

local t2 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function getCompactLineMeasureText(n1: number) -- line: 53
	if n1 <= 0 then
		return ""
	end

	local t3 = {}

	for _ = 1, n1 do
		table.insert(t3, "A")
	end

	return (table.concat(t3, "\n"))
end
local function calculateBlankLineAdjustedHeight(n2: number, n3: number, n4: number, n5: number) -- line: 68
	local v31 = (not (n3 > 0) or not (n2 > 0)) and 0 or n2 / n3

	if v31 > 0 and (n4 > 0 and n3 == math.floor(n4 / v31 + 0.5) + 1) then
		local v32 = n2 + v31

		if v32 < n5 then
			return (math.ceil(v32))
		end
	end

	return n2
end
local function ExpandableText(t4: {[any]: any}) -- line: 88
	-- upvalues: v15 (copy), SignalsReact (copy), TextSize (copy), useTokens (copy), Cryo (copy), FFlagLuaAppExpandableTextTappableText (copy), React (copy), ControlState (copy), useLocalization (copy), useProperty (copy), v16 (copy), View (copy), FFlagSduiExperienceDetailsSupport (copy), t1 (copy), v19 (copy), t2 (copy), FoundationText (copy), getCompactLineMeasureText (copy)
	local v34 = if not v15 then t4.text else (t4.text or ""):gsub("[\r\n]+$", "")
	local v35 = SignalsReact.useSignalState(function(p1) -- line: 92
		-- upvalues: TextSize (copy)
		return TextSize.getTextSizeStore(p1).getTextSizeOffset(p1)
	end)
	local v36 = useTokens()
	local v37 = t4.fontStyle or v36.Typography.CaptionLarge
	local v38 = Cryo.Dictionary.join(v37, {
		FontSize = v37.FontSize + v35
	})
	local v39 = if FFlagLuaAppExpandableTextTappableText then nil else t4.textColor or v36.Color.Content.Default.Color3
	local v40 = t4.textStyle or v36.Color.Content.Default
	local v41 = t4.compactNumberOfLines or 3
	local v42 = nil
	local v43 = nil
	local g62 = nil

	if FFlagLuaAppExpandableTextTappableText then
		local v44 = t4.pressedTextStyle or v36.Color.Content.Muted
		local v45

		v45, v42 = React.useBinding(ControlState.Default)
		v43 = v45:map(function(s1: string) -- line: 112
			-- upvalues: ControlState (copy), v44 (copy), v40 (copy)
			if s1 == ControlState.Pressed or s1 == ControlState.SelectedPressed then
				return v44
			end

			return v40
		end)
	end

	local v46, v47 = React.useState(t4.expandedInitially or false)
	local v48 = React.useCallback(function() -- line: 122
		-- upvalues: v47 (copy), t4 (copy)
		v47(function(p2) -- line: 123
			-- upvalues: t4 (copy)
			local v74 = not p2

			if t4.onExpandChanged then
				t4.onExpandChanged(v74)
			end

			return v74
		end)
	end, { t4.onExpandChanged })
	local v49 = useLocalization({
		moreText = "CommonUI.Features.Action.MoreLowercase",
		lessText = "CommonUI.Features.Action.LessLowercase"
	})
	local v50 = React.useRef(nil)
	local v51 = useProperty(v50, "AbsoluteSize")
	local v52 = React.useRef(nil)
	local v53 = useProperty(v52, "AbsoluteSize")
	local v54 = React.useRef(nil)
	local v55 = useProperty(v54, "AbsoluteSize")
	local v56 = v51 and v51.X > 0
	local v57 = v55 and v55.Y or 0
	local v58 = v53 and v53.Y or 0
	local v59 = nil
	local v60 = nil

	if v16 then
		v59 = React.useRef(nil)

		local v61 = useProperty(v59, "AbsoluteSize")

		v60 = React.useMemo(function() -- line: 160
			-- upvalues: t4 (copy), v34 (copy)
			if not t4.avoidBlankLineClip then
				return nil
			end

			local v72 = v34:find("\n\n")

			if not v72 then
				return nil
			end

			return v34:sub(1, v72 - 1)
		end, {
			v34,
			t4.avoidBlankLineClip
		})

		if not v60 then
			g62 = true
		end

		if not g62 then
			local v63 = v61 and v61.Y or 0
			local v64 = (not (v41 > 0) or not (v58 > 0)) and 0 or v58 / v41

			if v64 > 0 and v63 > 0 and v41 == math.floor(v63 / v64 + 0.5) + 1 then
				local v65 = v58 + v64

				if v65 < v57 then
					v58 = math.ceil(v65)
					g62 = true
				end
			end

			if not g62 then
				g62 = true
			end
		end
	end

	g62 = false

	local v66 = not t4.expandedInitially and v57 > v58 + 1
	local v67 = v46 or not v66
	local lessText = v49.lessText

	if v66 and not v46 then
		v57 = v58
		lessText = v49.moreText
	end

	if v34 == "" then
		return nil
	end

	local v69 = if not v67 then {
		Size = UDim2.new(1, 0, 0, (math.ceil(v57)))
	} else {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}

	return React.createElement(View, {
		tag = "col size-full-0 auto-y",
		LayoutOrder = t4.LayoutOrder,
		selection = if not FFlagSduiExperienceDetailsSupport or t4.selectable == false then nil else t1,
		onActivated = if not FFlagSduiExperienceDetailsSupport or t4.selectable == false then nil else v19,
		stateLayer = if not FFlagSduiExperienceDetailsSupport or t4.selectable == false then nil else t2,
		ref = v50
	}, {
		TextContent = if not v56 or not v67 and not (v57 > 0) then nil else React.createElement(FoundationText, Cryo.Dictionary.join({
			LayoutOrder = 1,
			TextWrapped = true,
			Text = v34,
			fontStyle = v38,
			textStyle = if not FFlagLuaAppExpandableTextTappableText then nil else if not v66 then v40 else v43,
			textColor = if FFlagLuaAppExpandableTextTappableText then nil else v39,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			ClipsDescendants = if not FFlagLuaAppExpandableTextTappableText or not v66 then nil else not v46,
			onActivated = if not FFlagLuaAppExpandableTextTappableText or not v66 then nil else v48,
			onStateChanged = if not FFlagLuaAppExpandableTextTappableText or not v66 then nil else v42,
			selection = if not FFlagLuaAppExpandableTextTappableText or not v66 then nil else {
				Selectable = false
			},
			stateLayer = if not FFlagLuaAppExpandableTextTappableText or not v66 then nil else t2
		}, v69)),
		ToggleExpandButton = if not v66 then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy radius-small",
			RichText = true,
			Text = `<u><b>{ lessText }</b></u>`,
			fontStyle = v38,
			textStyle = if not FFlagLuaAppExpandableTextTappableText then nil else v36.Color.Content.Emphasis,
			textColor = if FFlagLuaAppExpandableTextTappableText then nil else v36.Color.Content.Emphasis.Color3,
			onActivated = v48
		}),
		CompactTextMeasure = React.createElement(FoundationText, {
			Visible = false,
			IgnoreLayout = true,
			LayoutOrder = 3,
			TextWrapped = true,
			ref = v52,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = getCompactLineMeasureText(v41),
			fontStyle = v38,
			textStyle = if not FFlagLuaAppExpandableTextTappableText then nil else v40,
			textColor = if FFlagLuaAppExpandableTextTappableText then nil else v39,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}),
		FullTextMeasure = React.createElement(FoundationText, {
			Visible = false,
			IgnoreLayout = true,
			LayoutOrder = 4,
			TextWrapped = true,
			ref = v54,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v34,
			fontStyle = v38,
			textStyle = if not FFlagLuaAppExpandableTextTappableText then nil else v40,
			textColor = if FFlagLuaAppExpandableTextTappableText then nil else v39,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		}),
		PrefixMeasure = if not v16 or not v60 then nil else React.createElement(FoundationText, {
			Visible = false,
			IgnoreLayout = true,
			LayoutOrder = 5,
			TextWrapped = true,
			ref = v59,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v60,
			fontStyle = v38,
			textColor = v39,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end

return React.memo(ExpandableText)
