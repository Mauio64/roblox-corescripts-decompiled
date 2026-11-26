local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local FitFrame = require(CorePackages.Packages.FitFrame)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local fitFrameVertical = FitFrame.FitFrameVertical
local fitTextLabel = FitFrame.FitTextLabel

local focusable = RoactGamepad.Focusable

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local fFlagAXMigrateSaveOutfitPromptFromRoactGamepad = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateSaveOutfitPromptFromRoactGamepad

local component_assetscircle_17_stroke_1 = images["component_assets/circle_17_stroke_1"]
local rect = Rect.new(8, 8, 8, 8)

local extended = Roact.PureComponent:extend("OutfitNameTextBox")

extended.validateProps = t.strictInterface({ onOutfitNameUpdated = t.callback })

local function stringTooLongOrInvalid(p2, p3): boolean
	local v5 = utf8.len(p2)

	if v5 == nil then
		return true
	end

	if v5 <= p3 then
		return false
	end

	return p3 < utf8.len(utf8.nfcnormalize(p2))
end

function extended:init()
	self:setState({ lastValidName = "", isNameInvalid = true, outfitName = "" })

	self.textBoxRef = Roact.createRef()
	self.wasInitiallyFocused = false

	function self.tryFocusTextBox()
		if self.wasInitiallyFocused then
			return
		end

		local value = self.textBoxRef:getValue()

		if value and value:IsDescendantOf(game) then
			value:CaptureFocus()
			self.wasInitiallyFocused = true
		end
	end

	function self.onTextChanged(p2)
		local v5 = p2.Text
		local v6 = utf8.len(v5)
		local v7 = v6 == nil or not (v6 <= 99) and utf8.len(utf8.nfcnormalize(v5)) > 99

		if v7 then
			v5 = self.state.lastValidName
			p2.Text = v5
		end

		local v8 = not string.match(v5, "^[0-9a-zA-Z%s]+$")

		local v9 = self.state.lastValidName

		if not v8 then
			v9 = p2.Text
		end

		self:setState({ lastValidName = v9, isNameInvalid = v8, outfitName = v5 })

		self.props.onOutfitNameUpdated(v5, v8)
	end
end

function extended:renderWithProviders(p2, p3, callback)
	local font = p3.Font
	local theme = p3.Theme

	local v5 = self.state.isNameInvalid and self.state.outfitName ~= ""

	return Roact.createElement(fitFrameVertical, {
		BackgroundTransparency = 1,
		width = UDim.new(1, 0)
	}, {
		TextboxContainer = Roact.createElement(imageSetLabel, {
			BackgroundTransparency = 1,
			Image = component_assetscircle_17_stroke_1,
			ImageColor3 = theme.UIDefault.Color,
			ImageTransparency = theme.UIDefault.Transparency,
			LayoutOrder = 1,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 0, 30),
			SliceCenter = rect
		}, {
			Textbox = Roact.createElement(
				fFlagAXMigrateSaveOutfitPromptFromRoactGamepad and "TextBox" or focusable.TextBox,
				{
					Text = "",
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					Font = font.Header2.Font,
					TextSize = font.BaseSize * font.CaptionBody.RelativeSize,
					PlaceholderColor3 = theme.PlaceHolder.Color,
					PlaceholderText = p2.placeholderText,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(1, -12, 1, 0),
					TextColor3 = theme.TextDefault.Color,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					OverlayNativeInput = true,
					Selectable = true,
					[Roact.Change.Text] = self.onTextChanged,
					SelectionImageObject = callback(cursorKind.InputFields),
					[Roact.Ref] = self.textBoxRef,
					[Roact.Event.AncestryChanged] = self.tryFocusTextBox
				}
			)
		}),
		WarningText = v5 and Roact.createElement(fitTextLabel, {
			width = UDim.new(1, 0),
			BackgroundTransparency = 1,
			Text = p2.warningText,
			LayoutOrder = 2,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 20),
			TextColor3 = theme.Alert.Color,
			TextWrapped = true,
			Font = font.Body.Font,
			TextSize = font.Body.RelativeSize * font.BaseSize
		})
	})
end

function extended:render()
	return withLocalization({
		placeholderText = "Feature.Avatar.Label.Name",
		warningText = "Feature.Avatar.Label.CostumeWarning"
	})(function(p2)
		return withStyle(function(p3)
			return withSelectionCursorProvider(function(p4)
				return self:renderWithProviders(p2, p3, p4)
			end)
		end)
	end)
end

function extended.didMount(p2)
	p2.tryFocusTextBox()
end

return extended
