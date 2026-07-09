local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local uDim2 = UDim2.new(0, 44, 0, 44)
local v13 = Images["icons/menu/more_on"]
local v14 = Images["icons/menu/more_off"]
local uDim2_2 = UDim2.new(0, 37, 0, 37)
local v16 = Images["component_assets/circle_17"]
local rect = Rect.new(8, 8, 9, 9)
local v18 = Roact.PureComponent:extend("ItemDetailMoreButton")
local Interactable = UIBlox.Core.Control.Interactable
local FFlagAXMISEnableMultiShopping = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShopping

v18.validateProps = t.strictInterface({
	NextSelectionRight = t.table,
	NextSelectionDown = t.optional(t.table),
	onActivated = t.callback,
	isSelected = t.optional(t.boolean),
	forwardRef = t.table,
	LayoutOrder = if not FFlagAXMISEnableMultiShopping then nil else t.optional(t.number)
})

function v18.init(p1) -- line: 42
	-- upvalues: Roact (copy)
	p1.isMounted = false
	p1.state = {
		isButtonPressed = false
	}

	function p1.onInputBegan() -- line: 49
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		p1:setState({
			isButtonPressed = true
		})
	end
	function p1.onInputEnded() -- line: 59
		-- upvalues: p1 (copy)
		if not p1.isMounted then
			return
		end

		p1:setState({
			isButtonPressed = false
		})
	end

	p1.moreButtonRef = Roact.createRef()
end
function v18.renderWithStyle(p2, p3, p4) -- line: 72
	-- upvalues: v13 (copy), v14 (copy), Roact (copy), Focusable (copy), Interactable (copy), uDim2 (copy), v16 (copy), rect (copy), FFlagAXMISEnableMultiShopping (copy), CursorKind (copy), ImageSetLabel (copy), uDim2_2 (copy)
	local Theme = p3.Theme
	local onActivated = p2.props.onActivated
	local isButtonPressed = p2.state.isButtonPressed
	local isSelected = p2.props.isSelected
	local BackgroundDefaultTransparency = Theme.BackgroundDefault.Transparency

	if isButtonPressed then
		BackgroundDefaultTransparency = Theme.Overlay.Transparency
	end

	local forwardRef = p2.props.forwardRef
	local v31 = if not isSelected then v14 else v13

	return Roact.createElement(Focusable[Interactable], {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = uDim2,
		Image = v16,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		ImageTransparency = BackgroundDefaultTransparency,
		ImageColor3 = Theme.BackgroundDefault.Color,
		LayoutOrder = not FFlagAXMISEnableMultiShopping and 1 or p2.props.LayoutOrder,
		ClipsDescendants = false,
		[Roact.Event.Activated] = onActivated,
		[Roact.Event.InputBegan] = p2.onInputBegan,
		[Roact.Event.InputEnded] = p2.onInputEnded,
		[Roact.Ref] = p2.moreButtonRef,
		NextSelectionRight = p2.props.NextSelectionRight,
		NextSelectionDown = p2.props.NextSelectionDown,
		[Roact.Ref] = forwardRef,
		SelectionImageObject = p4(CursorKind.RoundedRectNoInset)
	}, {
		Icon = Roact.createElement(ImageSetLabel, {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = uDim2_2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = v31,
			ImageTransparency = Theme.IconEmphasis.Transparency,
			ImageColor3 = Theme.IconEmphasis.Color
		})
	})
end
function v18.didMount(p5) -- line: 120
	p5.isMounted = true
end
function v18.willUnmount(p6) -- line: 124
	p6.isMounted = false
end
function v18.render(p7) -- line: 128
	-- upvalues: withStyle (copy), withSelectionCursorProvider (copy)
	return withStyle(function(p8) -- line: 129
		-- upvalues: withSelectionCursorProvider (copy), p7 (copy)
		return withSelectionCursorProvider(function(p9) -- line: 130
			-- upvalues: p7 (copy), p8 (copy)
			return p7:renderWithStyle(p8, p9)
		end)
	end)
end

return Roact.forwardRef(function(p10, p11) -- line: 136
	-- upvalues: Roact (copy), v18 (copy), Cryo (copy)
	return Roact.createElement(v18, Cryo.Dictionary.join(p10, {
		forwardRef = p11
	}))
end)
