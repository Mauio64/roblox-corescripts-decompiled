local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local module = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module2 = require("@luauforge/bundled/fuD")

local textButton = UIBlox.App.Button.TextButton
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local withStyle = UIBlox.Style.withStyle

local images = UIBlox.App.ImageSet.Images
local controlState = UIBlox.Core.Control.Enum.ControlState
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local interactable = UIBlox.Core.Control.Interactable

local iconsactionstruncationExpand = images["icons/actions/truncationExpand"]

local activateTitleDropDownsByButtonA = {
	[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.ActivateTitleDropDown
}

local function useTitleDropDownFocusNavigationBindings(p2, p3)
	local v5 = ReactFocusNavigation.useEventMap(activateTitleDropDownsByButtonA, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.ActivateTitleDropDown] = {
				handler = InputHandlers.onRelease(p3)
			}
		}
	end, { p3 })
	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

local extended = Roact.PureComponent:extend("TitleDropDown")

extended.validateProps = t.strictInterface({
	onActivated = t.callback,
	Text = t.string,
	NextSelectionRight = t.optional(t.table),
	forwardRef = t.optional(t.table),
	inputBindings = t.optional(t.table)
})

function extended:init()
	self:setState({ wrappingFrameAbsoluteSizeX = 0 })

	function self.absoluteSizeChanged(p2)
		self:setState({ wrappingFrameAbsoluteSizeX = p2.AbsoluteSize.X })
	end

	self.wrappingFrameRef = Roact.createRef()

	local binding, v5 = Roact.createBinding(false)
	self.useBackgroundTransparency = binding
	self.updateUseBackgroundTransparency = v5

	function self.onStateChanged(p2, p3)
		if p3 == controlState.Pressed or p3 == controlState.Hover then
			self.updateUseBackgroundTransparency(true)
		else
			self.updateUseBackgroundTransparency(false)
		end
	end
end

function extended:render()
	return withStyle(function(p2)
		return withSelectionCursorProvider(function(p3)
			return self:renderWithProviders(p2, p3)
		end)
	end)
end

function extended.renderLabel(p2, p3, p4)
	return Roact.createElement(textButton, {
		size = UDim2.fromScale(0, 1),
		layoutOrder = 1,
		onActivated = p2.props.onActivated,
		text = p2.props.Text,
		fontStyle = "Header1"
	})
end

function extended:renderButton(p2, p3, p4)
	local text = self.props.Text
	local textEmphasis = p2.TextEmphasis
	local header1 = p3.Header1
	local v5 = 28 * header1.RelativeSize

	local v6 = p3.BaseSize * header1.RelativeSize
	local color = p2.BackgroundOnHover.Color
	local wrappingFrameAbsoluteSizeX = self.state.wrappingFrameAbsoluteSizeX
	local v7 = wrappingFrameAbsoluteSizeX > 0
	local v8 = math.max(wrappingFrameAbsoluteSizeX - v5, 0)
	local v9 = if foundationFontFaceMigration then p4.HeadingSmall else header1

	local largestPossibleOneLineTextSize, v10 = module2.getLargestPossibleOneLineTextSize(text, v6, v9, v8)

	if largestPossibleOneLineTextSize == nil then
		return nil
	end

	local udim = UDim2.fromOffset(largestPossibleOneLineTextSize.X, largestPossibleOneLineTextSize.Y)
	local v11

	if v7 then
		v11 = { nil }
		local children = {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8)
			}),
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			TextLabel = 0,
			Icon = 0
		}

		local createElement = Roact.createElement
		local v13 = {
			TextColor3 = textEmphasis.Color,
			TextTransparency = textEmphasis.Transparency,
			Font = 0,
			FontFace = 0,
			LayoutOrder = 1,
			TextWrapped = 1,
			Text = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			Size = 0,
			TextSize = 0,
			BackgroundTransparency = 1
		}
		local v14 = if not foundationFontFaceMigration then header1.Font else nil
		v13.Font = v14

		local v15 = if foundationFontFaceMigration then normalizeFontFace(p4.HeadingSmall.Font) else nil
		v13.FontFace = v15

		v13.Text = text
		v13.TextXAlignment = Enum.TextXAlignment.Center
		v13.TextYAlignment = Enum.TextYAlignment.Center
		v13.Size = udim
		v13.TextSize = v10
		children.TextLabel = createElement("TextLabel", v13)

		children.Icon = Roact.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = iconsactionstruncationExpand,
			ImageColor3 = textEmphasis.Color,
			LayoutOrder = 2,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(v5, v5)
		})
		v11[1] = children
	else
		v11 = {}
	end

	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			[Roact.Change.AbsoluteSize] = self.absoluteSizeChanged,
			[Roact.Ref] = self.wrappingFrameRef
		},
		{
			Interactable = Roact.createElement(interactable, {
				onStateChanged = self.onStateChanged,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				[Roact.Event.Activated] = self.props.onActivated,
				Size = UDim2.fromScale(1, 1)
			}, {
				ButtonContentFrame = Roact.createElement("Frame", {
					BackgroundColor3 = color,
					BackgroundTransparency = self.useBackgroundTransparency:map(function(p5)
						if p5 then
							return p2.BackgroundOnHover.Transparency
						end

						return 1
					end),
					AutomaticSize = Enum.AutomaticSize.XY,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				}, v11)
			})
		}
	)
end

function extended.didUpdate(p2)
	if p2.wrappingFrameRef.current then
		local absoluteSize = p2.wrappingFrameRef.current.AbsoluteSize
	end
end

function extended:renderWithProviders(props, callback)
	local theme = props.Theme
	local font = props.Font

	local forwardRef = self.props.forwardRef

	local createElement = Roact.createElement
	local forwardRefsByRef = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		SelectionImageObject = callback(cursorKind.RoundedRectNoInset),
		NextSelectionRight = self.props.NextSelectionRight,
		[Roact.Ref] = forwardRef
	}
	local v6 = {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 8)
		}),
		Button = 0
	}

	local v7 = if foundationFontFaceMigration then props.Tokens.Typography else nil
	v6.Button = self:renderButton(theme, font, v7)
	return createElement("Frame", forwardRefsByRef, v6)
end

return Roact.forwardRef(function(p2, p3)
	local v5 = useTableWrappedCallbackRef((useTitleDropDownFocusNavigationBindings(
		p3,
		React.useCallback(function()
			p2.onActivated()
		end, { p2.onActivated })
	)))

	return Roact.createElement(extended, Cryo.Dictionary.join(p2, { forwardRef = v5 }))
end)
