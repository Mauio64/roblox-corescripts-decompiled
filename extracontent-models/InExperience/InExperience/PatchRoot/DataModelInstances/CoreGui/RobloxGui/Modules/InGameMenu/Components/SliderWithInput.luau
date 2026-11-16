local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local t = InGameMenuDependencies.t

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local parent = script.Parent.Parent

local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)
local FocusHandler = require(script.Parent.Connection.FocusHandler)
local Slider = require(script.Parent.Slider)
local AssetImage = require(script.Parent.AssetImage)

local extended = Roact.PureComponent:extend("SliderWithInput")
extended.defaultProps = { width = UDim.new(1, 0) }

extended.validateProps = t.intersection(t.strictInterface({
	min = t.number,
	max = t.number,
	stepInterval = t.numberPositive,
	keyboardInputStepInterval = t.optional(t.numberPositive),
	value = t.number,
	valueChanged = t.callback,
	disabled = t.optional(t.boolean),
	width = t.optional(t.UDim),
	AnchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	canCaptureFocus = t.optional(t.boolean),
	isMenuOpen = t.optional(t.boolean),
	sliderDotRef = t.optional(t.table),
	onSelectionLost = t.callback,
	onSelectionGained = t.callback
}), function(data)
	if data.min > data.max then
		return false, "min must be less than or equal to max"
	end

	if data.value > data.max or data.value < data.min then
		return false, "value must be within min and max"
	end

	return true
end)

function extended:init()
	self.textBoxRef = Roact.createRef()

	self.state = { textEntryMode = false }
end

function extended:renderFocusHandler()
	local createElement = Roact.createElement
	local isFocused

	if self.props.canCaptureFocus then
		isFocused = self.state.textEntryMode or false
	else
		isFocused = false
	end

	return createElement(FocusHandler, {
		isFocused = isFocused,
		didFocus = function()
			GuiService.CoreGuiNavigationEnabled = false

			local text = self.props.value

			ContextActionService:BindCoreAction("LeaveTextEntryMode", function(_, p)
				if p ~= Enum.UserInputState.End then
					return Enum.ContextActionResult.Pass
				end

				self:setState({ textEntryMode = false })
				local current = self.textBoxRef.current
				current.Text = text
				current:ReleaseFocus()
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonB)
		end,
		didBlur = function()
			GuiService.CoreGuiNavigationEnabled = true
			ContextActionService:UnbindCoreAction("LeaveTextEntryMode")
		end
	}) or nil
end

function extended:renderWithSelectionCursor(callback)
	local props = self.props
	local joined = Cryo.Dictionary.join(props, {
		width = UDim.new(1, -80),
		LayoutOrder = Cryo.None,
		Position = Cryo.None,
		AnchorPoint = Cryo.None,
		keyboardInputStepInterval = Cryo.None,
		NextSelectionRight = self.textBoxRef
	})

	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(props.width.Scale, props.width.Offset, 0, 36),
			Position = props.Position,
			LayoutOrder = props.LayoutOrder
		},
		{
			Slider = Roact.createElement(Slider, joined),
			TextContainer = withFoundationOrUIBloxStyle(function(p)
				local tokens

				if FoundationFontFaceMigration then
					tokens = p
				end

				return {
					Tokens = tokens,
					Theme = {
						TextMuted = {
							Color = p.Color.Content.Muted.Color3,
							Transparency = p.Color.Content.Muted.Transparency
						},
						TextDefault = {
							Color = p.Color.Content.Default.Color3,
							Transparency = p.Color.Content.Default.Transparency
						},
						BackgroundUIContrast = {
							Color = p.Color.OverMedia.OverMedia_0.Color3,
							Transparency = p.Color.OverMedia.OverMedia_0.Transparency
						}
					},
					Font = {
						BaseSize = 1,
						Body = {
							Font = p.Typography.BodyLarge.Font,
							RelativeSize = p.Typography.BodyLarge.FontSize,
							RelativeMinSize = p.Typography.BodyLarge.FontSize
						}
					}
				}
			end, function(props2)
				local textMuted = props.disabled and props2.Theme.TextMuted or props2.Theme.TextDefault

				local createElement = Roact.createElement
				local label = AssetImage.Label
				local v3 = {
					BackgroundTransparency = 1,
					imageKey = "RoundedRect",
					ImageTransparency = props2.Theme.BackgroundUIContrast.Transparency,
					ImageColor3 = props2.Theme.BackgroundUIContrast.Color,
					Size = UDim2.new(0, 64, 0, 36),
					Position = UDim2.new(1, 0, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5)
				}
				local v4 = { FocusHandler = self:renderFocusHandler(), Box = 0 }
				local createElement2 = Roact.createElement
				local v5 = {
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					["BackgroundTransparency"] = nil,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				}
				local font

				if not FoundationFontFaceMigration then
					font = props2.Font.Body.Font
				end

				v5.Font = font
				local fontFace

				if FoundationFontFaceMigration then
					fontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font)
				end

				v5.FontFace = fontFace

				v5.TextScaled = true
				v5.ClearTextOnFocus = false
				v5.TextEditable = not props.disabled
				v5.TextColor3 = textMuted.Color
				v5.TextTransparency = textMuted.Transparency
				v5.Text = tostring(props.value)
				v5.NextSelectionLeft = self.props.sliderDotRef
				v5.SelectionImageObject = callback(v2.InputFields)
				v5[Roact.Event.SelectionLost] = self.props.onSelectionLost
				v5[Roact.Event.SelectionGained] = self.props.onSelectionGained
				v5[Roact.Ref] = self.textBoxRef
				v5[Roact.Event.Focused] = props.disabled and function(object)
					object:ReleaseFocus(false)
				end or function()
					self:setState({ textEntryMode = true })
				end
				v5[Roact.Event.FocusLost] = function(p, _)
					self:setState({ textEntryMode = false })

					local text = tonumber(p.Text)

					if text ~= props.value then
						if text == nil then
							p.Text = tostring(props.value)
							return
						end

						local v6 = props.stepInterval

						if props.keyboardInputStepInterval then
							v6 = props.keyboardInputStepInterval
						end

						local v7 = math.clamp(math.floor(text / v6 + 0.5) * v6, props.min, props.max)

						p.Text = tostring(v7)

						if v7 ~= props.value then
							props.valueChanged(v7)
						end
					end
				end

				v4.Box = createElement2("TextBox", v5, {
					TextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
						MinTextSize = props2.Font.Body.RelativeMinSize * props2.Font.BaseSize,
						MaxTextSize = props2.Font.Body.RelativeSize * props2.Font.BaseSize
					})
				})
				return createElement(label, v3, v4)
			end),
			UserInputConnection = not props.disabled and Roact.createElement(ExternalEventConnection, {
				event = UserInputService.InputBegan,
				callback = function(p, _)
					if not (p.UserInputType == Enum.UserInputType.Keyboard and UserInputService:GetFocusedTextBox() == self.textBoxRef.current) then
						return
					end

					local v3 = p.KeyCode == Enum.KeyCode.Up and 1 or p.KeyCode == Enum.KeyCode.Down and -1 or 0

					if
						UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
						or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
					then
						v3 *= 10
					end

					if v3 ~= 0 then
						local v4 = math.clamp(
							math.floor((props.value + props.stepInterval * v3) / props.stepInterval + 0.5) * props.stepInterval,
							props.min,
							props.max
						)

						if v4 ~= props.value then
							props.valueChanged(v4)
						end
					end
				end
			})
		}
	)
end

function extended:render()
	return v(function(p)
		return self:renderWithSelectionCursor(p)
	end)
end

return extended
