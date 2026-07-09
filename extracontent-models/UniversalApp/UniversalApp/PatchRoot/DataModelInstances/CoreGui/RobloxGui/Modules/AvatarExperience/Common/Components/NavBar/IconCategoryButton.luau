local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local Images = UIBlox.App.ImageSet.Images
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local t = require(CorePackages.Packages.t)
local Otter = require(CorePackages.Packages.Otter)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withStyle = UIBlox.Style.withStyle
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CategorySubButton = require(Modules.AvatarExperience.Common.Components.NavBar.CategorySubButton)
local NewItemNotification = require(Modules.AvatarExperience.Common.Components.NavBar.NewItemNotification)
local NavInnerPadding = Constants.NavInnerPadding
local NavCornerSize = Constants.NavCornerSize
local NavSubButtonInnerPadding = Constants.NavSubButtonInnerPadding
local NavButtonElementPadding = Constants.NavButtonElementPadding
local NavButtonElementMargin = Constants.NavButtonElementMargin
local t1 = {
	frequency = 3.0303030303030303,
	dampingRatio = 1
}
local v26 = Roact.PureComponent:extend("IconCategoryButton")

v26.validateProps = t.strictInterface({
	categoryTitle = t.string,
	iconOn = t.string,
	iconOff = t.string,
	navHeight = t.number,
	isSubNavigationButton = t.boolean,
	layoutOrder = t.number,
	isSelected = t.boolean,
	hasNewItemNotification = t.optional(t.boolean),
	frameRef = t.table,
	forwardRef = t.table,
	onActivate = t.callback,
	subButtons = t.optional(t.table),
	onSubButtonSelected = t.optional(t.callback),
	subcatIndex = t.optional(t.number),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	inputBindings = t.optional(t.table)
})

function v26.init(p1) -- line: 69
	-- upvalues: Roact (copy), Otter (copy), RoactGamepad (copy)
	local v28 = not p1.props.isSelected and 0 or 1
	local v29, v30 = Roact.createBinding(v28)

	p1.nonIconSizeMultiplierBinding = v29
	p1.nonIconSizeMultiplierBindingUpdate = v30
	p1.motor = Otter.createSingleMotor(v28)
	p1.motor:onStep(p1.nonIconSizeMultiplierBindingUpdate)

	if p1.props.subButtons and #p1.props.subButtons > 0 then
		p1.subButtonRefs = RoactGamepad.createRefCache()
	end
end
function v26.didUpdate(p2, p3, _) -- line: 81
	-- upvalues: Otter (copy), t1 (copy)
	if p2.props.isSelected ~= p3.isSelected then
		local v34 = not p2.props.isSelected and 0 or 1

		p2.motor:setGoal(Otter.spring(v34, t1))
	end
end
function v26.willUnmount(p5) -- line: 88
	p5.motor:destroy()
end
function v26.getDefaultChild(p6) -- line: 92
	if not p6.props.isSelected then
		return nil
	end

	if p6.props.subButtons == nil or #p6.props.subButtons == 0 then
		return nil
	end

	return p6.subButtonRefs[1]
end
function v26.getSubButtonNextSelectionLeft(p7, p8) -- line: 104
	if p8 > 1 then
		return p7.subButtonRefs[p8 - 1]
	end

	return p7.props.NextSelectionLeft
end
function v26.getSubButtonNextSelectionRight(p9, p10) -- line: 112
	if p10 < #p9.props.subButtons then
		return p9.subButtonRefs[p10 + 1]
	end

	return p9.props.NextSelectionRight
end
function v26.getInnerFrameChildren(p11, p12, p13, p14, p15, p16, p17, p18, p19) -- line: 120
	-- upvalues: Roact (copy), NavButtonElementPadding (copy), CategorySubButton (copy), NavCornerSize (copy), NavButtonElementMargin (copy), ImageSetLabel (copy), Images (copy)
	local t2 = {}
	local t3 = {}
	local Theme = p13.Theme
	local isSelected = p11.props.isSelected
	local v54 = isSelected and Theme.TextEmphasis.Color or Theme.TextMuted.Color
	local v55 = isSelected and Theme.TextEmphasis.Transparency or Theme.TextMuted.Transparency
	local Header2Font = p13.Font.Header2.Font

	t3.UIPadding = Roact.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, 0),
		PaddingTop = UDim.new(0, 0),
		PaddingLeft = UDim.new(0, NavButtonElementPadding),
		PaddingRight = UDim.new(0, 0)
	})
	t3.UIListLayout = Roact.createElement("UIListLayout", {
		Padding = UDim.new(0, NavButtonElementPadding),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center
	})
	t3.TextLabel = Roact.createElement("TextLabel", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, p14, 1, 0),
		Text = p12.title,
		TextSize = p17,
		TextColor3 = v54,
		TextTransparency = v55,
		Font = Header2Font
	})

	local subButtons = p11.props.subButtons

	if subButtons then
		for v58, v59 in subButtons do
			local v60 = p11:getSubButtonNextSelectionLeft(v58)
			local v61 = p11:getSubButtonNextSelectionRight(v58)

			t3[v59.Name] = Roact.createElement(CategorySubButton, {
				isClippedWhenParentUnselected = true,
				title = p12[v59.Name],
				width = p15[v58],
				layoutOrder = v58 + 1,
				index = v58,
				onSubButtonSelected = function(p20) -- line: 179
					-- upvalues: isSelected (copy), p11 (copy)
					if not isSelected then
						p11.props.onActivate()
					end

					p11.props.onSubButtonSelected(p20)
				end,
				parentButtonSelected = isSelected,
				buttonRef = p11.subButtonRefs[v58],
				NextSelectionLeft = v60,
				NextSelectionRight = v61
			})
		end
	end

	t2.UICorner = Roact.createElement("UICorner", {
		CornerRadius = UDim.new(0, NavCornerSize)
	})
	t2.UIPadding = Roact.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, 0),
		PaddingTop = UDim.new(0, 0),
		PaddingLeft = UDim.new(0, NavButtonElementMargin),
		PaddingRight = UDim.new(0, NavButtonElementMargin)
	})
	t2.Icon = Roact.createElement(ImageSetLabel, {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		Image = if not isSelected then Images[p11.props.iconOff] else Images[p11.props.iconOn],
		ImageColor3 = Theme.IconEmphasis.Color,
		Size = UDim2.new(0, p16, 1, -p18),
		ScaleType = Enum.ScaleType.Fit,
		Position = UDim2.new(0, 0, 0, 0)
	})
	t2.ScaledFrame = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = p11.nonIconSizeMultiplierBinding:map(function(n1: number) -- line: 219
			-- upvalues: p19 (copy), p18 (copy)
			return UDim2.new(0, n1 * p19, 1, -p18)
		end),
		Position = UDim2.fromOffset(p16, 0)
	}, t3)

	return t2
end
function v26.renderButtonWithTextAndIcon(p21, p22, p23, p24, p25, p26, p27, p28, p29) -- line: 228
	-- upvalues: Roact (copy), Focusable (copy), NavInnerPadding (copy), CursorKind (copy)
	local p23Font = p23.Font
	local v72 = p23Font.BaseSize * p23Font.Header2.RelativeSize
	local Theme = p23.Theme
	local forwardRef = p21.props.forwardRef
	local isSubNavigationButton = p21.props.isSubNavigationButton
	local v76 = p21:getDefaultChild()

	return Roact.createElement(Focusable.ImageButton, {
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 0, 0, NavInnerPadding),
		Size = UDim2.new(1, 0, 1, -NavInnerPadding + p25),
		BackgroundTransparency = if not isSubNavigationButton then Theme.BackgroundDefault.Transparency else Theme.BackgroundUIDefault.Transparency,
		BackgroundColor3 = if not isSubNavigationButton then Theme.BackgroundDefault.Color else Theme.BackgroundUIDefault.Color,
		[Roact.Event.Activated] = p21.props.onActivate,
		[Roact.Ref] = forwardRef,
		NextSelectionLeft = p21.props.NextSelectionLeft,
		NextSelectionRight = p21.props.NextSelectionRight,
		SelectionImageObject = p24(CursorKind.NavHighlight),
		restorePreviousChildFocus = true,
		defaultChild = v76
	}, p21:getInnerFrameChildren(p22, p23, p26, p27, p28, v72, p25, p29))
end
function v26.renderWithProviders(p30, p31, p32, p33) -- line: 282
	-- upvalues: Text (copy), NavSubButtonInnerPadding (copy), NavButtonElementPadding (copy), NavCornerSize (copy), NavInnerPadding (copy), NavButtonElementMargin (copy), Roact (copy), NewItemNotification (copy)
	local isSelected = p30.props.isSelected
	local hasNewItemNotification = p30.props.hasNewItemNotification
	local frameRef = p30.props.frameRef
	local p32Font = p32.Font
	local Header2Font = p32Font.Header2.Font
	local v86 = p32Font.BaseSize * p32Font.Header2.RelativeSize
	local v87 = Text.GetTextWidth(p31.title, Header2Font, v86)
	local t4 = {}
	local n2 = 0

	if p30.props.subButtons then
		for _, v91 in p30.props.subButtons do
			local v92 = Text.GetTextWidth(p31[v91.Name], Header2Font, v86) + 2 * NavSubButtonInnerPadding

			table.insert(t4, v92)
			n2 = n2 + NavButtonElementPadding + v92
		end
	end

	local v93 = if not p30.props.isSubNavigationButton then NavCornerSize else 0
	local v94 = p30.props.navHeight - NavInnerPadding - 2 * NavButtonElementPadding
	local v95 = NavButtonElementPadding + v87 + n2
	local v96 = NavButtonElementMargin + v94 + NavButtonElementMargin
	local v97 = p30:renderButtonWithTextAndIcon(p31, p32, p33, v93, v87, t4, v94, v95)

	return Roact.createElement("Frame", {
		Size = p30.nonIconSizeMultiplierBinding:map(function(n3: number) -- line: 319
			-- upvalues: v96 (copy), v95 (copy), NavInnerPadding (copy), v93 (copy)
			return UDim2.new(0, v96 + n3 * v95, 1, -NavInnerPadding + v93)
		end),
		BackgroundTransparency = 1,
		LayoutOrder = p30.props.layoutOrder,
		[Roact.Ref] = frameRef
	}, {
		Button = v97,
		NewItemNotification = hasNewItemNotification and Roact.createElement(NewItemNotification, {
			isSelected = isSelected
		})
	})
end
function v26.render(p34) -- line: 339
	-- upvalues: withLocalization (copy), withStyle (copy), withSelectionCursorProvider (copy)
	local t5 = {
		title = p34.props.categoryTitle
	}

	if p34.props.subButtons then
		for _, v101 in p34.props.subButtons do
			t5[v101.Name] = v101.Title
		end
	end

	return withLocalization(t5)(function(p35) -- line: 348
		-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), p34 (copy)
		return withStyle(function(p36) -- line: 349
			-- upvalues: withSelectionCursorProvider (copy), p34 (copy), p35 (copy)
			return withSelectionCursorProvider(function(p37) -- line: 350
				-- upvalues: p34 (copy), p35 (copy), p36 (copy)
				return p34:renderWithProviders(p35, p36, p37)
			end)
		end)
	end)
end

return Roact.forwardRef(function(p38, p39) -- line: 357
	-- upvalues: Roact (copy), v26 (copy), Cryo (copy)
	return Roact.createElement(v26, Cryo.Dictionary.join(p38, {
		forwardRef = p39
	}))
end)
