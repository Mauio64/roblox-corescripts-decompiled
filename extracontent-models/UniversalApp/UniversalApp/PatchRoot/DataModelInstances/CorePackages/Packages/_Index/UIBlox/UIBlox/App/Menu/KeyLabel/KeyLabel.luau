local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local React = require(ParentParentParentParent.React)
local LuauPolyfill = require(ParentParentParentParent.LuauPolyfill)

require(scriptParent.Types)

local Constants = require(scriptParent.Constants)
local Utilities = require(scriptParent.Utilities)
local useStyle = require(ParentParentParent.Core.Style.useStyle)
local Images = require(ParentParent.ImageSet.Images)
local Label = require(ParentParentParent.Core.ImageSet.ImageSetComponent).Label

local function KeyLabel(t1: {[any]: any}) -- line: 40
	-- upvalues: useStyle (copy), Constants (copy), Utilities (copy), React (copy), Images (copy), Label (copy), LuauPolyfill (copy)
	local v14 = useStyle()
	local v15 = v14.Theme[t1.iconThemeKey or Constants.DEFAULT_ICON_THEME]
	local v16 = Utilities.getKeyCodeContent(t1.keyCode)
	local v17 = Utilities.getWidthFromContent(v16, v14.Font)
	local t2 = {
		AnchorPoint = t1.AnchorPoint,
		Position = t1.Position,
		LayoutOrder = t1.LayoutOrder,
		ZIndex = t1.ZIndex,
		[React.Change.AbsoluteSize] = t1[React.Change.AbsoluteSize],
		Size = UDim2.fromOffset(v17, Constants.HEIGHT)
	}

	if v16.inputType == "keyboard" then
		local v19 = v14.Theme[t1.textThemeKey or Constants.DEFAULT_TEXT_THEME]
		local Font = v14.Font
		local BaseSize = Font.BaseSize
		local CaptionHeader = Font.CaptionHeader
		local v23 = BaseSize * CaptionHeader.RelativeSize
		local s1 = ""
		local v25 = nil

		if type(v16.content) == "string" then
			s1 = v16.content
		else
			local v26 = v16.content.ImageRectSize / Images.ImagesResolutionScale

			v25 = React.createElement(Label, {
				BackgroundTransparency = 1,
				Image = v16.content,
				ImageColor3 = v19.Color,
				ImageTransparency = v19.Transparency,
				Size = UDim2.fromOffset(v26.X, v26.Y),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		end

		return React.createElement(Label, LuauPolyfill.Object.assign(t2, {
			BackgroundTransparency = 1,
			ImageTransparency = v15.Transparency,
			ImageColor3 = v15.Color,
			Image = Images["icons/controls/keys/key_single"],
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(Vector2.new(10, 9), Vector2.new(25, 25))
		}), {
			LabelContent = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				RichText = false,
				Text = s1,
				TextColor3 = v19.Color,
				TextTransparency = v19.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = v23,
				Font = CaptionHeader.Font,
				Position = UDim2.fromOffset(0, Constants.TEXT_CENTER_OFFSET),
				Size = UDim2.fromScale(1, 1)
			}, {
				Icon = v25
			})
		})
	end

	if v16.inputType == "gamepad" then
		return React.createElement(Label, LuauPolyfill.Object.assign(t2, {
			BackgroundTransparency = 1,
			Image = v16.content,
			ImageColor3 = v15.Color,
			ImageTransparency = v15.Transparency
		}))
	end

	assert(false, string.format("Unreachable: Invalid inputType value: \"%s\"", v16.inputType))
end

return KeyLabel
