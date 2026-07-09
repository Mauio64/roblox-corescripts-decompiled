local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)

require(CorePackages.Packages.React)

local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local FitTextLabel = require(CorePackages.Packages.AvatarExperienceDeps).RoactFitComponents.FitTextLabel
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local Interactable = UIBlox.Core.Control.Interactable
local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local v20 = Images["component_assets/circle_17"]
local v21 = Roact.PureComponent:extend("ActionButton")

v21.validateProps = t.strictInterface({
	NextSelectionLeft = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	Size = t.UDim2,
	Position = t.optional(t.UDim2),
	LayoutOrder = t.optional(t.number),
	AnchorPoint = t.optional(t.Vector2),
	buttonProps = t.table,
	Font = t.table,
	forwardRef = t.optional(t.table)
})

function v21.init(p1) -- line: 54
	p1.state = {
		isButtonPressed = false
	}

	function p1.onInputBegan() -- line: 59
		-- upvalues: p1 (copy)
		p1:setState({
			isButtonPressed = true
		})
	end
	function p1.onInputEnded() -- line: 65
		-- upvalues: p1 (copy)
		p1:setState({
			isButtonPressed = false
		})
	end
end
function v21.renderWithStyle(p2, p3, p4) -- line: 72
	-- upvalues: CatalogConstants (copy), Roact (copy), Skeleton (copy), EnumsRadius (copy), ImageSetLabel (copy), FitTextLabel (copy), FFlagAXMISEnableMultiShopping (copy), Focusable (copy), Interactable (copy), v20 (copy), CursorKind (copy)
	local propsSize = p2.props.Size
	local propsPosition = p2.props.Position
	local propsAnchorPoint = p2.props.AnchorPoint
	local propsLayoutOrder = p2.props.LayoutOrder
	local propsFont = p2.props.Font
	local buttonProps = p2.props.buttonProps
	local isButtonPressed = p2.state.isButtonPressed
	local Theme = p3.Theme
	local n1 = 0

	if buttonProps.buttonIsDisabled then
		n1 = CatalogConstants.ActionBar.DisabledButtonTransparency
	elseif isButtonPressed then
		n1 = Theme.Overlay.Transparency
	end

	local v35 = if not buttonProps.buttonIsLoading then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, buttonProps.buttonIconPadding)
		}),
		Icon = buttonProps.buttonIcon and Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0, buttonProps.buttonIconSize, 0, buttonProps.buttonIconSize),
			Image = buttonProps.buttonIcon,
			ImageTransparency = n1,
			ImageColor3 = buttonProps.buttonTextColor
		}),
		Text = Roact.createElement(FitTextLabel, {
			BackgroundTransparency = 1,
			TextWrapped = false,
			LayoutOrder = 2,
			width = FitTextLabel.Width.FitToText,
			Size = UDim2.new(0, 0, 0, propsFont.BaseSize * propsFont.Header1.RelativeSize),
			Text = buttonProps.buttonText or "",
			Font = if not FFlagAXMISEnableMultiShopping then propsFont.Header1.Font else propsFont.Header2.Font,
			TextSize = if not FFlagAXMISEnableMultiShopping then propsFont.BaseSize * propsFont.Header1.RelativeSize else (propsFont.BaseSize - 2) * propsFont.Header2.RelativeSize,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextColor3 = buttonProps.buttonTextColor,
			TextTransparency = n1
		})
	}) else Roact.createElement(Skeleton, {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		radius = EnumsRadius.Medium
	})
	local forwardRef = p2.props.forwardRef

	return Roact.createElement(Focusable[Interactable], {
		Size = propsSize,
		Position = propsPosition,
		AnchorPoint = propsAnchorPoint,
		LayoutOrder = propsLayoutOrder,
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Image = v20,
		ImageColor3 = buttonProps.buttonColor,
		ImageTransparency = n1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9),
		ClipsDescendants = true,
		[Roact.Event.InputBegan] = p2.onInputBegan,
		[Roact.Event.InputEnded] = p2.onInputEnded,
		[Roact.Event.Activated] = function() -- line: 155
			-- upvalues: buttonProps (copy)
			if buttonProps.onActivated ~= nil and not buttonProps.buttonIsLoading then
				buttonProps.onActivated()
			end
		end,
		NextSelectionLeft = p2.props.NextSelectionLeft,
		NextSelectionDown = p2.props.NextSelectionDown,
		NextSelectionUp = p2.props.NextSelectionUp,
		NextSelectionRight = p2.props.NextSelectionRight,
		[Roact.Ref] = forwardRef,
		SelectionImageObject = p4(CursorKind.RoundedRectNoInset)
	}, {
		ButtonInfo = v35
	})
end
function v21.render(p5) -- line: 172
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy)
	return withStyle(function(p6) -- line: 173
		-- upvalues: withSelectionCursorProvider (copy), p5 (copy)
		return withSelectionCursorProvider(function(p7) -- line: 174
			-- upvalues: p5 (copy), p6 (copy)
			return p5:renderWithStyle(p6, p7)
		end)
	end)
end

return Roact.forwardRef(function(p8, p9) -- line: 180
	-- upvalues: Roact (copy), v21 (copy), Cryo (copy)
	return Roact.createElement(v21, Cryo.Dictionary.join(p8, {
		forwardRef = p9
	}))
end)
