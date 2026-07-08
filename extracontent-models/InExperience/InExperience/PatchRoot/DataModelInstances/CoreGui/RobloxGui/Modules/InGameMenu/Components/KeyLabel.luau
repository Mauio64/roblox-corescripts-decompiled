local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local withStyle = UIBlox.Core.Style.withStyle
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local GlobalConfig = require(ParentParent.GlobalConfig)
local ThemedTextLabel = require(ParentParent.Components.ThemedTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local t1 = {
	[Enum.KeyCode.Escape] = {
		text = "ESC",
		fontKey = "Footer",
		width = 36
	},
	[Enum.KeyCode.Space] = {
		text = "Space",
		width = 92
	},
	[Enum.KeyCode.LeftShift] = {
		text = "Shift",
		width = 66,
		alignment = Enum.TextXAlignment.Left
	},
	[Enum.KeyCode.LeftControl] = {
		text = "Ctrl",
		width = 66,
		alignment = Enum.TextXAlignment.Left
	},
	[Enum.KeyCode.LeftSuper] = {
		text = "Command"
	},
	[Enum.KeyCode.LeftMeta] = {
		text = "fn"
	},
	[Enum.KeyCode.LeftAlt] = {
		text = "Opt"
	},
	[Enum.KeyCode.Tilde] = {
		text = "~",
		fontKey = "CaptionHeader"
	},
	[Enum.KeyCode.F10] = {
		fontKey = "CaptionHeader",
		width = 36
	},
	[Enum.KeyCode.F11] = {
		fontKey = "CaptionHeader",
		width = 36
	},
	[Enum.KeyCode.Up] = {
		image = Assets.Images.UpArrow
	},
	[Enum.KeyCode.Down] = {
		image = Assets.Images.DownArrow
	},
	[Enum.KeyCode.Left] = {
		image = Assets.Images.LeftArrow
	},
	[Enum.KeyCode.Right] = {
		image = Assets.Images.RightArrow
	}
}
local v15 = t.strictInterface({
	input = t.enum(Enum.KeyCode),
	borderThemeKey = t.optional(t.string),
	textThemeKey = t.optional(t.string),
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.integer),
	ZIndex = t.optional(t.integer)
})

local function getLabelWidthAndContent(p1, p2, p3) -- line: 71
	-- upvalues: t1 (copy), Roact (copy), ImageSetLabel (copy), UserInputService (copy), TextService (copy), ThemedTextLabel (copy)
	local v21 = t1[p1]

	if v21 and v21.image then
		return 36, (Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = v21.image,
			ImageColor3 = p2.Theme.IconEmphasis.Color,
			ImageTransparency = p2.Theme.IconEmphasis.Transparency,
			Position = UDim2.new(0.5, 0, 0.5, -1),
			Size = UDim2.new(0, 16, 0, 16)
		}))
	end

	local alignment = nil
	local StringForKeyCode = UserInputService:GetStringForKeyCode(p1)
	local v24 = if not v21 or not v21.text then if not StringForKeyCode or StringForKeyCode == "" then p1.Name else StringForKeyCode else v21.text
	local v25 = v24:len() < 3
	local v26 = if not v21 or not v21.fontKey then not v25 and "Footer" or "CaptionHeader" else v21.fontKey
	local width

	if v21 and v21.width then
		width = v21.width
	elseif v25 then
		width = 36
	else
		local v28 = p2.Font[v26]
		local v29 = v28.RelativeSize * p2.Font.BaseSize
		local Font = v28.Font

		width = TextService:GetTextSize(v24, v29, Font, Vector2.new(1e999, 36)).X + 28
	end

	if v21 and v21.alignment then
		alignment = v21.alignment
	end

	return width, Roact.createElement(ThemedTextLabel, {
		fontKey = v26,
		themeKey = p3 or "TextEmphasis",
		Text = v24,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, -1),
		TextXAlignment = alignment
	}), alignment
end
local function KeyLabel(p4) -- line: 142
	-- upvalues: GlobalConfig (copy), v15 (copy), withStyle (copy), getLabelWidthAndContent (copy), Roact (copy), ImageSetLabel (copy), Assets (copy)
	if GlobalConfig.propValidation then
		assert(v15(p4))
	end

	return withStyle(function(p5) -- line: 147
		-- upvalues: p4 (copy), getLabelWidthAndContent (copy), Roact (copy), ImageSetLabel (copy), Assets (copy)
		local v33 = p5.Theme[p4.borderThemeKey or "UIEmphasis"]
		local v34, v35, v36 = getLabelWidthAndContent(p4.input, p5, p4.textThemeKey)
		local n1 = nil

		if v36 then
			n1 = 9
		end

		return Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ImageTransparency = v33.Transparency,
			ImageColor3 = v33.Color,
			Image = Assets.Images.KeyBorder,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(Vector2.new(9, 7), Vector2.new(26, 26)),
			Size = UDim2.new(0, v34, 0, 36),
			Position = p4.Position,
			AnchorPoint = p4.AnchorPoint,
			LayoutOrder = p4.LayoutOrder,
			ZIndex = p4.ZIndex
		}, {
			Padding = n1 and Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, n1),
				PaddingRight = UDim.new(0, n1)
			}),
			LabelContent = v35
		})
	end)
end

return KeyLabel
