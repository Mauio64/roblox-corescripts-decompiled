local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t

local withStyle = UIBlox.Core.Style.withStyle

local parent = script.Parent.Parent

local Assets = require(parent.Resources.Assets)

local GlobalConfig = require(parent.GlobalConfig)

local ThemedTextLabel = require(parent.Components.ThemedTextLabel)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local v = {
	[Enum.KeyCode.Escape] = { text = "ESC", fontKey = "Footer", width = 36 },
	[Enum.KeyCode.Space] = { text = "Space", width = 92 },
	[Enum.KeyCode.LeftShift] = { text = "Shift", width = 66, alignment = Enum.TextXAlignment.Left },
	[Enum.KeyCode.LeftControl] = { text = "Ctrl", width = 66, alignment = Enum.TextXAlignment.Left },
	[Enum.KeyCode.LeftSuper] = { text = "Command" },
	[Enum.KeyCode.LeftMeta] = { text = "fn" },
	[Enum.KeyCode.LeftAlt] = { text = "Opt" },
	[Enum.KeyCode.Tilde] = { text = "~", fontKey = "CaptionHeader" },
	[Enum.KeyCode.F10] = { fontKey = "CaptionHeader", width = 36 },
	[Enum.KeyCode.F11] = { fontKey = "CaptionHeader", width = 36 },
	[Enum.KeyCode.Up] = { image = Assets.Images.UpArrow },
	[Enum.KeyCode.Down] = { image = Assets.Images.DownArrow },
	[Enum.KeyCode.Left] = { image = Assets.Images.LeftArrow },
	[Enum.KeyCode.Right] = { image = Assets.Images.RightArrow }
}

local strictInterface = t.strictInterface({
	input = t.enum(Enum.KeyCode),
	borderThemeKey = t.optional(t.string),
	textThemeKey = t.optional(t.string),
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer),
	ZIndex = t.optional(t.integer)
})

local function getLabelWidthAndContent(input, p, textThemeKey)
	local v2 = v[input]

	if v2 and v2.image then
		return 36, (Roact.createElement(ImageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = v2.image,
			ImageColor3 = p.Theme.IconEmphasis.Color,
			ImageTransparency = p.Theme.IconEmphasis.Transparency,
			Position = UDim2.new(0.5, 0, 0.5, -1),
			Size = UDim2.new(0, 16, 0, 16)
		}))
	end

	local alignment = nil

	local text = UserInputService:GetStringForKeyCode(input)

	if v2 and v2.text then
		text = v2.text
	elseif not text or text == "" then
		text = input.Name
	end

	local v3 = text:len() < 3

	local fontKey = not (v2 and v2.fontKey) and (v3 and "CaptionHeader" or "Footer") or v2.fontKey
	local v4

	if v2 and v2.width then
		v4 = v2.width
	elseif v3 then
		v4 = 36
	else
		local v5 = p.Font[fontKey]

		v4 = TextService:GetTextSize(text, v5.RelativeSize * p.Font.BaseSize, v5.Font, Vector2.new(1e999, 36)).X + 28
	end

	if v2 and v2.alignment then
		alignment = v2.alignment
	end

	return v4, Roact.createElement(ThemedTextLabel, {
		fontKey = fontKey,
		themeKey = textThemeKey or "TextEmphasis",
		Text = text,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, -1),
		TextXAlignment = alignment
	}), alignment
end

local function KeyLabel(data)
	if GlobalConfig.propValidation then
		assert(strictInterface(data))
	end

	return withStyle(function(p)
		local v2 = p.Theme[data.borderThemeKey or "UIEmphasis"]

		local labelWidthAndContent, labelContent, v3 = getLabelWidthAndContent(data.input, p, data.textThemeKey)
		local v4 = v3 and 9 or nil
		return Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ImageTransparency = v2.Transparency,
			ImageColor3 = v2.Color,
			Image = Assets.Images.KeyBorder,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(Vector2.new(9, 7), Vector2.new(26, 26)),
			Size = UDim2.new(0, labelWidthAndContent, 0, 36),
			Position = data.Position,
			AnchorPoint = data.AnchorPoint,
			LayoutOrder = data.LayoutOrder,
			ZIndex = data.ZIndex
		}, {
			Padding = v4 and Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v4),
				PaddingRight = UDim.new(0, v4)
			}),
			LabelContent = labelContent
		})
	end)
end

return KeyLabel
