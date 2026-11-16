local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent
local Foundation = require(parent4.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local React = require(parent4.React)
local LuauPolyfill = require(parent4.LuauPolyfill)

require(parent.Types)
local Constants = require(parent.Constants)
local Utilities = require(parent.Utilities)
local useStyle = require(parent3.Core.Style.useStyle)
local GetFontFromFontStyle = require(parent3.Core.Text.GetFontFromFontStyle)
local Images = require(parent2.ImageSet.Images)
local ImageSetComponent = require(parent3.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label

local function KeyLabel(data)
	local v = useStyle()

	local v2 = v.Theme[data.iconThemeKey or Constants.DEFAULT_ICON_THEME]
	local keyCodeContent = Utilities.getKeyCodeContent(data.keyCode)
	local widthFromContent = Utilities.getWidthFromContent(keyCodeContent, v.Font)

	local v3 = {
		AnchorPoint = data.AnchorPoint,
		Position = data.Position,
		LayoutOrder = data.LayoutOrder,
		ZIndex = data.ZIndex,
		[React.Change.AbsoluteSize] = data[React.Change.AbsoluteSize],
		Size = UDim2.fromOffset(widthFromContent, Constants.HEIGHT)
	}

	if keyCodeContent.inputType == "keyboard" then
		local v4 = v.Theme[data.textThemeKey or Constants.DEFAULT_TEXT_THEME]
		local font = v.Font
		local baseSize = font.BaseSize

		local captionHeader = font.CaptionHeader
		local textSize = baseSize * captionHeader.RelativeSize

		local text = ""
		local icon = nil

		if type(keyCodeContent.content) == "string" then
			text = keyCodeContent.content
		else
			local v5 = keyCodeContent.content.ImageRectSize / Images.ImagesResolutionScale
			icon = React.createElement(Label, {
				Image = keyCodeContent.content,
				ImageColor3 = v4.Color,
				ImageTransparency = v4.Transparency,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(v5.X, v5.Y),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		end

		return React.createElement(Label, LuauPolyfill.Object.assign(v3, {
			BackgroundTransparency = 1,
			ImageTransparency = v2.Transparency,
			ImageColor3 = v2.Color,
			Image = Images["icons/controls/keys/key_single"],
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(Vector2.new(10, 9), Vector2.new(25, 25))
		}), {
			LabelContent = React.createElement("TextLabel", {
				Text = text,
				BackgroundTransparency = 1,
				TextColor3 = v4.Color,
				TextTransparency = v4.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = textSize,
				FontFace = normalizeFontFace(GetFontFromFontStyle(captionHeader)),
				RichText = false,
				Position = UDim2.fromOffset(0, Constants.TEXT_CENTER_OFFSET),
				Size = UDim2.fromScale(1, 1)
			}, { Icon = icon })
		})
	end

	if keyCodeContent.inputType == "gamepad" then
		return React.createElement(
			Label,
			LuauPolyfill.Object.assign(v3, {
				Image = keyCodeContent.content,
				ImageColor3 = v2.Color,
				ImageTransparency = v2.Transparency,
				BackgroundTransparency = 1
			})
		)
	end

	assert(false, string.format("Unreachable: Invalid inputType value: \"%s\"", keyCodeContent.inputType))
end

return KeyLabel
