local impressionsTagUtility = require("@luauforge/bundled/dvd").ImpressionsTagUtility
local module = require("@luauforge/bundled/dva")
local normalizeFontFace = require("@luauforge/bundled/dvi").Utility.normalizeFontFace

local module2 = require("@luauforge/bundled/dvl")
local getTextSize = module2.GetTextSize
local useDesignTokens = module2.useDesignTokens

function LUAUFORGE_MODULE_GLOBALS_dzf_SearchPill(props)
	local v5 = useDesignTokens()

	local font = props.font or v5.Typography.BodyLarge.Font
	local textColor = props.textColor or v5.Color.Content.Emphasis.Color3
	local textSize = props.textSize
	local v6 = module.useMemo(function()
		return getTextSize(props.text, textSize, font, Vector2.new(1e999, textSize), {
			addTemporaryPadding = false
		})
	end, { props.text, textSize, font })

	local ref = module.useRef(nil)
	module.useEffect(function()
		local impressionsTag = props.impressionsTag
		local index = props.index

		if props.impressionsTag and index then
			impressionsTagUtility.AddTag(ref, impressionsTag, index)
		end

		return function()
			if props.impressionsTag and index then
				impressionsTagUtility.RemoveTag(ref, impressionsTag, index)
			end
		end
	end, { props.impressionsTag, props.index })

	return module.createElement("TextButton", {
		LayoutOrder = props.layoutOrder or 1,
		Size = UDim2.new(0, v6.X + props.horizontalPadding * 2, 0, textSize + props.verticalPadding * 2),
		BackgroundColor3 = props.backgroundColor,
		BackgroundTransparency = props.backgroundTransparency,
		BorderSizePixel = 0,
		TextTransparency = 1,
		Text = "",
		Selectable = true,
		[module.Event.Activated] = props.onActivated,
		ref = ref
	}, {
		PillText = module.createElement("TextLabel", {
			Size = UDim2.fromOffset(v6.X, v6.Y),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			FontFace = normalizeFontFace(font),
			Text = props.text,
			TextSize = textSize,
			TextColor3 = textColor
		}),
		Corner = module.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
	})
end

return LUAUFORGE_MODULE_GLOBALS_dzf_SearchPill
