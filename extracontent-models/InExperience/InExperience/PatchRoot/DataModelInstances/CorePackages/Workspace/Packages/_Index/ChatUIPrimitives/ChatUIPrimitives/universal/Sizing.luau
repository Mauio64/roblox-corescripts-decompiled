local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)

local FFlagExpChatMessageListScrollParity = require(ChatUIPrimitives.Flags.FFlagExpChatMessageListScrollParity)

local Keys = Responsive.Keys
local getMinWidthFor = Responsive.BreakpointConfig.getMinWidthFor

local v = {
	{ Key = Keys.Large, minWidth = getMinWidthFor(Keys.Large) },
	{ Key = Keys.Medium, minWidth = getMinWidthFor(Keys.Medium) },
	{ Key = "Regular", minWidth = 480 },
	{ Key = "Compact", minWidth = 1 }
}

local v2 = {
	[Keys.Large] = { density = "regular", widthUnits = 3 },
	[Keys.Medium] = { density = "regular", widthUnits = 2 },
	Regular = { density = "regular", widthUnits = 1 },
	Compact = { density = "compact", widthUnits = 1 }
}

local context = React.createContext(nil)

local function toFontStyle(data) -- 4 equivalent calls inferred from this helper
	return { Font = data.Font, FontSize = data.FontSize, LineHeight = data.LineHeight }
end

local function getLineHeight(p) -- 2 equivalent calls inferred from this helper
	return (math.round(p.FontSize * p.LineHeight))
end

local function resolve(density: string, p: number, data)
	local v3 = density == "compact"
	local paddingX

	if v3 then
		paddingX = data.Padding.Small
	else
		paddingX = data.Padding.Medium
	end

	local maxWidth = data.Size.Size_3000 * (v3 and 2 or p)
	local contentMaxWidth = math.max(0, maxWidth - paddingX * 2)
	local v4

	if v3 then
		v4 = data.Typography.CaptionSmall
	else
		v4 = data.Typography.BodyMedium
	end

	local fontStyle = toFontStyle(v4) -- inferred equivalent call
	local size_100 = data.Size.Size_100
	local paddingY

	if v3 then
		paddingY = data.Padding.XSmall
	else
		paddingY = data.Padding.Small
	end

	local bubble = {
		paddingX = paddingX,
		paddingY = paddingY,
		minHeight = v3 and 0 or data.Size.Size_1000,
		cornerRadius = 0,
		maxWidth = 0,
		contentMaxWidth = 0,
		fontStyle = 0
	}
	local cornerRadius

	if v3 then
		cornerRadius = data.Size.Size_350
	else
		cornerRadius = data.Size.Size_500
	end

	bubble.cornerRadius = cornerRadius
	bubble.maxWidth = maxWidth
	bubble.contentMaxWidth = contentMaxWidth
	local v5

	if v3 then
		v5 = data.Typography.BodySmall
	else
		v5 = data.Typography.BodyLarge
	end

	bubble.fontStyle = toFontStyle(v5) -- inferred equivalent call
	local v6 = {
		density = density,
		bubble = bubble,
		avatar = {
			tag = {
				["size-500-500"] = v3,
				["size-700-700"] = not v3
			}
		},
		row = {
			tag = {
				["padding-x-small"] = v3,
				["padding-x-medium"] = not v3
			}
		},
		username = {
			tag = {
				["padding-left-small text-caption-small"] = v3,
				["padding-left-medium text-caption-medium"] = not v3
			}
		},
		timestamp = {
			tag = {
				["padding-top-small text-caption-small"] = v3,
				["text-body-large"] = not v3
			}
		},
		system = {
			tag = {
				["padding-top-medium text-caption-small"] = v3,
				["padding-bottom-xsmall padding-top-large text-caption-medium"] = not v3
			}
		},
		reply = {
			fontStyle = fontStyle,
			markerWidth = size_100,
			textMaxWidth = math.max(0, contentMaxWidth - size_100 - data.Gap.Small),
			textMaxHeight = math.ceil(fontStyle.FontSize * fontStyle.LineHeight * 3),
			leftLabelTag = {
				["padding-left-small text-align-x-left text-caption-small"] = v3,
				["padding-left-medium text-align-x-left text-caption-medium"] = not v3
			},
			rightLabelTag = {
				["padding-right-small text-align-x-right text-caption-small"] = v3,
				["padding-right-medium text-align-x-right text-caption-medium"] = not v3
			}
		},
		discussion = 0,
		list = 0
	}

	local discussion = {
		frameTag = v3 and "col size-full-0 auto-y padding-x-small" or "col size-full-0 auto-y padding-x-medium",
		headRowTag = v3 and "row align-x-left align-y-top size-full-0 auto-y gap-small padding-top-medium" or "row align-x-left align-y-top size-full-0 auto-y gap-medium padding-top-large",
		continuationRowTag = v3 and "row align-x-left align-y-top size-full-0 auto-y gap-small padding-top-xxsmall" or "row align-x-left align-y-top size-full-0 auto-y gap-medium padding-top-xxsmall",
		gutterTag = v3 and "size-600-0" or "size-800-0",
		avatarTag = v3 and "size-600-600" or "size-800-800",
		columnTag = "col grow size-0 auto-y gap-xsmall",
		topLineTag = "row align-y-center size-full-0 auto-y gap-xsmall",
		nameTag = v3 and "auto-xy text-align-x-left text-caption-small content-default" or "auto-xy text-align-x-left text-caption-large content-default",
		timestampTag = v3 and "auto-xy padding-x-xsmall text-caption-small content-muted" or "auto-xy padding-x-xsmall text-body-small content-muted",
		estimatedRowHeight = 0
	}

	local v7 = if v3 then data.Padding.Medium else data.Padding.Large
	local v8

	if v3 then
		v8 = data.Typography.CaptionSmall
	else
		v8 = data.Typography.CaptionLarge
	end

	discussion.estimatedRowHeight = v7 + getLineHeight(toFontStyle(v8)) + data.Gap.XSmall + getLineHeight(toFontStyle(data.Typography.BodyLarge)) -- inferred equivalent call
	v6.discussion = discussion

	local list = {
		scrollBarThickness = v3 and (FFlagExpChatMessageListScrollParity and 8 or 4) or 12,
		scrollBarInset = 0,
		scrollBarColor = 0
	}
	local scrollBarInset

	if FFlagExpChatMessageListScrollParity then
		scrollBarInset = Enum.ScrollBarInset.Always
	else
		scrollBarInset = Enum.ScrollBarInset.ScrollBar
	end

	list.scrollBarInset = scrollBarInset
	local scrollBarColor

	if FFlagExpChatMessageListScrollParity then
		scrollBarColor = data.Color.Shift.Shift_400.Color3
	end

	list.scrollBarColor = scrollBarColor
	v6.list = list
	return v6
end

local function useResolvedSizing(density: string, p: number)
	local v3 = Foundation.Hooks.useTokens()
	return React.useMemo(function()
		return resolve(density, p, v3)
	end, { density, p, v3 })
end

local function SizingProvider(props)
	local v3 = useResolvedSizing(props.density, props.widthUnits or 1)
	return React.createElement(context.Provider, { value = v3 }, props.children)
end

local Sizing = {}
Sizing.Context = context
Sizing.Provider = SizingProvider
Sizing.COMPACT_BELOW_WIDTH = 480
Sizing.resolve = resolve

function Sizing.useMeasured()
	local v3 = Responsive.useResponsive(v)
	local ref = React.useRef(nil)
	local current = v2[v3]

	if current ~= nil then
		ref.current = current
	end

	return ref.current
end

Sizing.useResolvedSizing = useResolvedSizing

function Sizing.useSizing()
	local v3 = React.useContext(context)
	local v4 = useResolvedSizing("regular", 1)
	return if v3 == nil then v4 else v3
end

return Sizing
