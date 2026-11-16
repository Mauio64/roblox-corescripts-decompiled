local ExpChat = script:FindFirstAncestor("ExpChat")
local TextChatService = game:GetService("TextChatService")
local parent = ExpChat.Parent
local React = require(parent.React)
local ExpChatShared = require(parent.ExpChatShared)
local Foundation = require(parent.Foundation)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local llama = require(parent.llama)
local list = llama.List
local llama2 = require(parent.llama)
local dictionary = llama2.Dictionary

local Config = require(ExpChat.Config)
local AutocompleteEntry = require(script.Parent.AutocompleteEntry)
local v = require(script.Parent.AutocompleteEntryV2)
local Constants = require(ExpChat.PresetChat.Constants)
local FFlagExpChatAutocompleteDropdownRedesign = require(ExpChat.Flags.FFlagExpChatAutocompleteDropdownRedesign)
local FFlagExpChatEmojiDropdownShowAnalytics = require(ExpChat.Flags.FFlagExpChatEmojiDropdownShowAnalytics)

local FFlagExpChatEmojiDropdownDismissAnalytics = require(ExpChat.Flags.FFlagExpChatEmojiDropdownDismissAnalytics)
local useEmojiDropdownDismissAnalytics = require(script.Parent.useEmojiDropdownDismissAnalytics)

if not FFlagExpChatAutocompleteDropdownRedesign then
	v = AutocompleteEntry
end

local function AutoCompleteDropdown(props)
	local ref = React.useRef(nil)
	local v2

	if FFlagExpChatAutocompleteDropdownRedesign then
		v2 = Foundation.Hooks.useTokens()
	else
		v2 = nil
	end

	local theme = useStyle().Theme

	if FFlagExpChatEmojiDropdownShowAnalytics then
		local v3 = props.activated

		if v3 then
			if #props.results > 0 and props.autocompleteType == "emojis" then
				v3 = props.isChatInputBarVisible ~= false
			else
				v3 = false
			end
		end

		React.useEffect(function()
			if v3 then
				ExpChatShared.Analytics:TelemetryLogEvent(
					ExpChatShared.Analytics.ExpChatPresetActionConfig,
					{
						event_type = Constants.Analytics.EventTypes.Show,
						component = Constants.Analytics.Components.EmojiDropdown
					},
					Constants.Analytics.ExtendedStandardizedFields
				)
			end
		end, { v3 })

		if FFlagExpChatEmojiDropdownDismissAnalytics then
			useEmojiDropdownDismissAnalytics(v3, props.results, props.chosenEmojiForAnalyticsRef)
		end
	end

	local v3 = React.useCallback(function(p)
		local mapped = dictionary.map(p, function(p2, layoutOrder)
			local createElement = React.createElement
			local query

			if FFlagExpChatAutocompleteDropdownRedesign then
				query = props.query
			end

			return createElement(v, {
				result = p2,
				query = query,
				layoutOrder = layoutOrder,
				chatInputBarSettings = props.chatInputBarSettings,
				setTransparency = props.setTransparency,
				transparencyValue = props.transparencyValue,
				isDividerVisible = list.count(p) ~= layoutOrder,
				selectedIndex = props.selectedIndex,
				autocompleteType = props.autocompleteType,
				onAutocompleteDropdownHover = props.onAutocompleteDropdownHover,
				onAutocompleteSelected = props.onAutocompleteSelected
			}), p2
		end)

		local createElement = React.createElement
		local padding

		if FFlagExpChatAutocompleteDropdownRedesign then
			padding = UDim.new(0, v2.Gap.XXSmall)
		end

		mapped["$layout"] = createElement("UIListLayout", {
			Padding = padding,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		return mapped
	end)

	local function setCanvasPosition()
		if not ref.current then
			return Vector2.new(0, 0)
		end

		local current = props.autocompleteDropdownRef.current
		local y = current and current.AbsoluteSize.Y or Config.AutocompleteFrameDefaultSizeY

		if FFlagExpChatAutocompleteDropdownRedesign then
			y = ref.current.AbsoluteSize.Y
		end

		local v4 = props.chatInputBarSettings.TextSize + 16
		local total = 0

		if
			current
			and current:FindFirstChild("ScrollBarFrame")
			and current.ScrollBarFrame:FindFirstChild("ScrollViewFrame")
			and current.ScrollBarFrame.ScrollViewFrame:FindFirstChild("ScrollView")
			and current.ScrollBarFrame.ScrollViewFrame.ScrollView:FindFirstChild("OffsetFrame")
		then
			local offsetFrame = current.ScrollBarFrame.ScrollViewFrame.ScrollView.OffsetFrame

			for _, child in ipairs(offsetFrame:GetChildren()) do
				if not (child.ClassName == "Frame" and child.LayoutOrder <= props.selectedIndex) then
					continue
				end

				total += child.AbsoluteSize.Y

				if child.LayoutOrder == props.selectedIndex then
					v4 = child.AbsoluteSize.Y
				end
			end
		end

		local y2 = ref.current.CanvasPosition.Y
		local v5 = y2 + y
		local v6 = total - v4

		if FFlagExpChatAutocompleteDropdownRedesign then
			local v7 = v2.Gap.XXSmall * math.max(props.selectedIndex - 1, 0)
			v6 += v7
			total += v7
		end

		local v7

		if v5 < total then
			v7 = total - y
		else
			v7 = y2
		end

		if v6 < y2 then
			v7 = v6
		end

		return Vector2.new(0, v7)
	end

	local chatWindowConfiguration = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
	local verticalAlignment, v4

	if chatWindowConfiguration then
		verticalAlignment = chatWindowConfiguration.VerticalAlignment
		v4 = chatWindowConfiguration.Enabled
	else
		v4 = false
	end

	local v5

	if verticalAlignment == Enum.VerticalAlignment.Top then
		v5 = not v4
	else
		v5 = false
	end

	local v6 = props.textBoxRef.current and props.textBoxRef.current.AbsoluteSize.Y + 20
	local chatWindow

	if
		props.autocompleteDropdownRef.current
		and props.autocompleteDropdownRef.current:FindFirstAncestor("appLayout")
	then
		chatWindow = props.autocompleteDropdownRef.current:FindFirstAncestor("appLayout"):FindFirstChild("chatWindow")
			or nil
	end

	local udim, udim2

	if FFlagExpChatAutocompleteDropdownRedesign then
		local v7 = math.min(#props.results, 3.5)
		local v8 = math.max(math.ceil(v7) - 1, 0)
		udim = UDim2.new(1, 0, 0, 2 * v2.Padding.Small + v7 * v2.Size.Size_1000 + v8 * v2.Gap.XXSmall)

		local xSmall = v2.Gap.XSmall
		local v9

		if v5 then
			v9 = (v6 or 0) + xSmall
		else
			v9 = -xSmall
		end

		udim2 = UDim2.new(0, 0, 0, v9)
	else
		udim = UDim2.new(
			0.95,
			0,
			0,
			#props.results > 3 and Config.AutocompleteFrameDefaultSizeY or #props.results * Config.AutocompleteEntryDefaultSizeY
		)

		udim2 = UDim2.new(0, 0, 0, v5 and v6 or 0)
	end

	local createElement = React.createElement
	local v7 = {
		AnchorPoint = v5 and Vector2.new(0, 0) or Vector2.new(0, 1),
		BackgroundTransparency = 1,
		Size = udim,
		Position = udim2,
		ZIndex = 2,
		Visible = props.activated and #props.results > 0,
		ref = props.autocompleteDropdownRef
	}
	local v8 = {
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(
				Config.ChatWindowMaxWidth,
				chatWindow and not v5 and chatWindow.AbsoluteSize.Y or 1e999
			)
		}),
		ScrollBarFrame = 0
	}

	local createElement2 = React.createElement
	local v9 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = props.setTransparency(0, props.transparencyValue),
		BackgroundColor3 = props.chatInputBarSettings.BackgroundColor3,
		ZIndex = 2
	}

	local createElement3 = React.createElement
	local v10 = { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = 0, Transparency = 0 }
	local color

	if FFlagExpChatAutocompleteDropdownRedesign then
		color = v2.Color.Stroke.Default.Color3
	else
		color = Config.ChatInputBarBorderColor3
	end

	v10.Color = color

	local setTransparency = props.setTransparency
	local v11

	if FFlagExpChatAutocompleteDropdownRedesign then
		v11 = v2.Color.Stroke.Default.Transparency
	else
		v11 = Config.ChatInputBarBorderTransparency
	end

	v10.Transparency = setTransparency(v11, props.transparencyValue)
	local children = {
		Border = createElement3("UIStroke", v10),
		Corner = 0,
		ScrollViewFrame = 0
	}

	local createElement4 = React.createElement
	local cornerRadius

	if FFlagExpChatAutocompleteDropdownRedesign then
		cornerRadius = UDim.new(0, v2.Radius.Large)
	else
		cornerRadius = UDim.new(0, 3)
	end

	children.Corner = createElement4("UICorner", { CornerRadius = cornerRadius })

	local createElement5 = React.createElement
	local v12 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 2
	}
	local uiPadding

	if FFlagExpChatAutocompleteDropdownRedesign then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v2.Padding.Small),
			PaddingRight = UDim.new(0, v2.Padding.Small),
			PaddingTop = UDim.new(0, v2.Padding.Small),
			PaddingBottom = UDim.new(0, v2.Padding.Small)
		})
	end

	local createElement6 = React.createElement
	local size

	if FFlagExpChatAutocompleteDropdownRedesign then
		size = UDim2.fromScale(1, 1)
	else
		size = UDim2.new(1, -4, 1, 0)
	end

	local v13 = {
		Size = size,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = 0,
		CanvasPosition = 0,
		BackgroundTransparency = 1,
		ScrollBarImageColor3 = 0,
		ScrollBarImageTransparency = 0,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		VerticalScrollBarInset = 0,
		ClipsDescendants = 0,
		Selectable = false,
		ZIndex = 2,
		ref = 0
	}
	local canvasSize

	if FFlagExpChatAutocompleteDropdownRedesign then
		canvasSize = UDim2.new()
	else
		canvasSize = UDim2.new(0, 0, 0, #props.results * Config.AutocompleteEntryDefaultSizeY)
	end

	v13.CanvasSize = canvasSize

	v13.CanvasPosition = setCanvasPosition()

	v13.ScrollBarImageColor3 = theme.UIEmphasis.Color
	v13.ScrollBarImageTransparency = props.setTransparency(0, props.transparencyValue)
	local verticalScrollBarInset

	if FFlagExpChatAutocompleteDropdownRedesign then
		verticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	else
		verticalScrollBarInset = Enum.ScrollBarInset.Always
	end

	v13.VerticalScrollBarInset = verticalScrollBarInset

	v13.ClipsDescendants = FFlagExpChatAutocompleteDropdownRedesign and true or false

	v13.ref = ref

	local createElement7 = React.createElement
	local automaticSize

	if FFlagExpChatAutocompleteDropdownRedesign then
		automaticSize = Enum.AutomaticSize.Y
	end

	local size2

	if FFlagExpChatAutocompleteDropdownRedesign then
		size2 = UDim2.fromScale(1, 0)
	else
		size2 = UDim2.new(1, 8, 1, 0)
	end

	children.ScrollViewFrame = createElement5("Frame", v12, {
		UIPadding = uiPadding,
		ScrollView = createElement6("ScrollingFrame", v13, {
			OffsetFrame = createElement7(
				"Frame",
				{ AutomaticSize = automaticSize, Size = size2, BackgroundTransparency = 1 },
				v3(props.results)
			)
		})
	})
	v8.ScrollBarFrame = createElement2("Frame", v9, children)
	return createElement("Frame", v7, v8)
end

return React.memo(AutoCompleteDropdown)
