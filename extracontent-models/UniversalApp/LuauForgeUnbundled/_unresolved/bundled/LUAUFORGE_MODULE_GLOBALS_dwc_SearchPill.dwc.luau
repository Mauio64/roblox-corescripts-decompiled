local TextService = game:GetService("TextService")

local impressionsTagUtility = require("@luauforge/bundled/dsb").ImpressionsTagUtility
local module = require("@luauforge/bundled/drY")
local module2 = require("@luauforge/bundled/dsg")
local normalizeFontFace = module2.Utility.normalizeFontFace
local foundationFontFaceMigration = module2.Utility.Flags.FoundationFontFaceMigration

local module3 = require("@luauforge/bundled/dsj")
local getTextSize = module3.GetTextSize
local useDesignTokens = module3.useDesignTokens

function LUAUFORGE_MODULE_GLOBALS_dwc_SearchPill(props)
	local v5 = useDesignTokens()

	local font = props.font or v5.Typography.BodyLarge.Font
	local textColor = props.textColor or v5.Color.Content.Emphasis.Color3
	local textSize = props.textSize
	local v6 = module.useMemo(function()
		if foundationFontFaceMigration then
			return (getTextSize(props.text, textSize, font, Vector2.new(1e999, textSize), {
				addTemporaryPadding = false
			}))
		end

		return (TextService:GetTextSize(props.text, textSize, font, Vector2.new(1e999, textSize)))
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

	local createElement = module.createElement
	local onActivatedsByActivated = {
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
	}

	local createElement2 = module.createElement
	local v9 = {
		Size = UDim2.fromOffset(v6.X, v6.Y),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = if not foundationFontFaceMigration then font else nil,
		FontFace = 0,
		Text = 0,
		TextSize = 0,
		TextColor3 = 0
	}

	local v11 = if foundationFontFaceMigration then normalizeFontFace(font) else nil
	v9.FontFace = v11
	v9.Text = props.text
	v9.TextSize = textSize
	v9.TextColor3 = textColor
	return createElement("TextButton", onActivatedsByActivated, {
		PillText = createElement2("TextLabel", v9),
		Corner = module.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
	})
end

return LUAUFORGE_MODULE_GLOBALS_dwc_SearchPill
