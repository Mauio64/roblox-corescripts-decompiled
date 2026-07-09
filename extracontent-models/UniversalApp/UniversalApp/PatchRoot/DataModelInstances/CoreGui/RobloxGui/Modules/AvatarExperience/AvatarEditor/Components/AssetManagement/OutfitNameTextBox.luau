local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local FitFrame = require(CorePackages.Packages.FitFrame)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local FitFrameVertical = FitFrame.FitFrameVertical
local FitTextLabel = FitFrame.FitTextLabel
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FFlagAXMigrateSaveOutfitPromptFromRoactGamepad = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSaveOutfitPromptFromRoactGamepad
local v17 = Images["component_assets/circle_17_stroke_1"]
local rect = Rect.new(8, 8, 8, 8)
local v19 = Roact.PureComponent:extend("OutfitNameTextBox")

v19.validateProps = t.strictInterface({
	onOutfitNameUpdated = t.callback
})

local function stringTooLongOrInvalid(p1, p2) -- line: 41
	local v23 = utf8.len(p1)

	if v23 == nil then
		return true
	end

	if v23 <= p2 then
		return false
	end

	return p2 < utf8.len(utf8.nfcnormalize(p1))
end

function v19.init(p3) -- line: 54
	-- upvalues: Roact (copy)
	p3:setState({
		lastValidName = "",
		isNameInvalid = true,
		outfitName = ""
	})
	p3.textBoxRef = Roact.createRef()
	p3.wasInitiallyFocused = false

	function p3.tryFocusTextBox() -- line: 64
		-- upvalues: p3 (copy)
		if p3.wasInitiallyFocused then
			return
		end

		local v34 = p3.textBoxRef:getValue()

		if v34 and v34:IsDescendantOf(game) then
			v34:CaptureFocus()
			p3.wasInitiallyFocused = true
		end
	end
	function p3.onTextChanged(p4) -- line: 76
		-- upvalues: p3 (copy)
		local p4Text = p4.Text
		local v37 = utf8.len(p4Text)

		if v37 == nil or not (v37 <= 99) and utf8.len(utf8.nfcnormalize(p4Text)) > 99 then
			p4Text = p3.state.lastValidName
			p4.Text = p4Text
		end

		local v38 = not string.match(p4Text, "^[0-9a-zA-Z%s]+$")
		local lastValidName = p3.state.lastValidName

		if not v38 then
			lastValidName = p4.Text
		end

		p3:setState({
			lastValidName = lastValidName,
			isNameInvalid = v38,
			outfitName = p4Text
		})
		p3.props.onOutfitNameUpdated(p4Text, v38)
	end
end
function v19.renderWithProviders(p5, p6, p7, p8) -- line: 101
	-- upvalues: Roact (copy), FitFrameVertical (copy), ImageSetLabel (copy), v17 (copy), rect (copy), FFlagAXMigrateSaveOutfitPromptFromRoactGamepad (copy), Focusable (copy), CursorKind (copy), FitTextLabel (copy)
	local p7Font = p7.Font
	local Theme = p7.Theme
	local v31 = p5.state.isNameInvalid and p5.state.outfitName ~= ""

	return Roact.createElement(FitFrameVertical, {
		BackgroundTransparency = 1,
		width = UDim.new(1, 0)
	}, {
		TextboxContainer = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = v17,
			ImageColor3 = Theme.UIDefault.Color,
			ImageTransparency = Theme.UIDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 0, 30),
			SliceCenter = rect
		}, {
			Textbox = Roact.createElement(if not FFlagAXMigrateSaveOutfitPromptFromRoactGamepad then Focusable.TextBox else "TextBox", {
				Text = "",
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				Font = p7Font.Header2.Font,
				TextSize = p7Font.BaseSize * p7Font.CaptionBody.RelativeSize,
				PlaceholderColor3 = Theme.PlaceHolder.Color,
				PlaceholderText = p6.placeholderText,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, -12, 1, 0),
				TextColor3 = Theme.TextDefault.Color,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				OverlayNativeInput = true,
				Selectable = true,
				[Roact.Change.Text] = p5.onTextChanged,
				SelectionImageObject = p8(CursorKind.InputFields),
				[Roact.Ref] = p5.textBoxRef,
				[Roact.Event.AncestryChanged] = p5.tryFocusTextBox
			})
		}),
		WarningText = v31 and Roact.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			TextWrapped = true,
			width = UDim.new(1, 0),
			Text = p6.warningText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 20),
			TextColor3 = Theme.Alert.Color,
			Font = p7Font.Body.Font,
			TextSize = p7Font.Body.RelativeSize * p7Font.BaseSize
		})
	})
end
function v19.render(p9) -- line: 165
	-- upvalues: withLocalization (copy), withStyle (copy), withSelectionCursorProvider (copy)
	return withLocalization({
		placeholderText = "Feature.Avatar.Label.Name",
		warningText = "Feature.Avatar.Label.CostumeWarning"
	})(function(p10) -- line: 169
		-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), p9 (copy)
		return withStyle(function(p11) -- line: 170
			-- upvalues: withSelectionCursorProvider (copy), p9 (copy), p10 (copy)
			return withSelectionCursorProvider(function(p12) -- line: 171
				-- upvalues: p9 (copy), p10 (copy), p11 (copy)
				return p9:renderWithProviders(p10, p11, p12)
			end)
		end)
	end)
end
function v19.didMount(p13) -- line: 178
	p13.tryFocusTextBox()
end

return v19
