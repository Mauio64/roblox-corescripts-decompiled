local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local t = require(CorePackages.Packages.t)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local withStyle = UIBlox.Style.withStyle
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CategorySubButton = require(Modules.AvatarExperience.Common.Components.NavBar.CategorySubButton)
local NewItemNotification = require(Modules.AvatarExperience.Common.Components.NavBar.NewItemNotification)
local v17 = Roact.PureComponent:extend("TextCategoryButton")
local NavButtonElementPadding = Constants.NavButtonElementPadding
local NavButtonElementMargin = Constants.NavButtonElementMargin
local NavInnerPadding = Constants.NavInnerPadding
local NavCornerSize = Constants.NavCornerSize
local NavButtonBorderSize = Constants.NavButtonBorderSize
local NavSubButtonInnerPadding = Constants.NavSubButtonInnerPadding

v17.validateProps = t.strictInterface({
	categoryTitle = t.string,
	layoutOrder = t.number,
	isSelected = t.boolean,
	hasNewItemNotification = t.optional(t.boolean),
	frameRef = t.table,
	onActivate = t.callback,
	subButtons = t.optional(t.table),
	onSubButtonSelected = t.optional(t.callback),
	subcatIndex = t.optional(t.number),
	forwardRef = t.table,
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	inputBindings = t.optional(t.table)
})

function v17.init(p1) -- line: 58
	-- upvalues: RoactGamepad (copy)
	if p1.props.subButtons and #p1.props.subButtons > 0 then
		p1.subButtonRefs = RoactGamepad.createRefCache()
	end
end
function v17.getDefaultChild(p2) -- line: 64
	if p2.props.subButtons == nil or #p2.props.subButtons == 0 then
		return nil
	end

	return p2.subButtonRefs[1]
end
function v17.getSubButtonNextSelectionLeft(p3, p4) -- line: 71
	if p4 > 1 then
		return p3.subButtonRefs[p4 - 1]
	end

	return nil
end
function v17.getSubButtonNextSelectionRight(p5, p6) -- line: 80
	if p6 < #p5.props.subButtons then
		return p5.subButtonRefs[p6 + 1]
	end

	return nil
end
function v17.getInnerFrameChildren(p7, p8, p9, p10, p11, p12, p13) -- line: 89
	-- upvalues: NavCornerSize (copy), NavButtonBorderSize (copy), Roact (copy), NavButtonElementMargin (copy), NavButtonElementPadding (copy), CategorySubButton (copy)
	local t1 = {}
	local isSelected = p7.props.isSelected
	local v39 = if not isSelected then NavCornerSize else NavCornerSize - NavButtonBorderSize
	local Theme = p9.Theme
	local v41 = isSelected and Theme.TextEmphasis.Transparency or Theme.TextMuted.Transparency
	local Header2Font = p9.Font.Header2.Font

	t1.UICorner = Roact.createElement("UICorner", {
		CornerRadius = UDim.new(0, v39)
	})
	t1.UIPadding = Roact.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, 0),
		PaddingTop = UDim.new(0, 0),
		PaddingLeft = UDim.new(0, NavButtonElementMargin),
		PaddingRight = UDim.new(0, NavButtonElementMargin)
	})
	t1.UIListLayout = Roact.createElement("UIListLayout", {
		Padding = UDim.new(0, NavButtonElementPadding),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center
	})
	t1.TextLabel = Roact.createElement("TextLabel", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, p10, 1, 0),
		Text = p8.title,
		TextSize = p13,
		TextColor3 = p12,
		TextTransparency = v41,
		Font = Header2Font
	})

	local subButtons = p7.props.subButtons

	if subButtons then
		for v44, v45 in subButtons do
			local v46 = p7:getSubButtonNextSelectionLeft(v44)
			local v47 = p7:getSubButtonNextSelectionRight(v44)

			t1[v45.Name] = Roact.createElement(CategorySubButton, {
				title = p8[v45.Name],
				width = p11[v44],
				layoutOrder = v44 + 1,
				index = v44,
				onSubButtonSelected = function(p14) -- line: 149
					-- upvalues: isSelected (copy), p7 (copy)
					if not isSelected then
						p7.props.onActivate()
					end

					p7.props.onSubButtonSelected(p14)
				end,
				parentButtonSelected = isSelected,
				buttonRef = p7.subButtonRefs[v44],
				NextSelectionLeft = v46,
				NextSelectionRight = v47
			})
		end
	end

	return t1
end
function v17.renderButtonWithText(p15, p16, p17, p18) -- line: 166
	-- upvalues: Text (copy), NavSubButtonInnerPadding (copy), NavButtonElementPadding (copy), NavButtonElementMargin (copy), Roact (copy), Focusable (copy), NavButtonBorderSize (copy), NavInnerPadding (copy), CursorKind (copy), NavCornerSize (copy)
	local p17Font = p17.Font
	local Header2Font = p17Font.Header2.Font
	local v54 = p17Font.BaseSize * p17Font.Header2.RelativeSize
	local v55 = Text.GetTextWidth(p16.title, Header2Font, v54)
	local Theme = p17.Theme
	local isSelected = p15.props.isSelected
	local v58 = isSelected and Theme.TextEmphasis.Color or Theme.TextMuted.Color
	local t2 = {}
	local n1 = 0

	if p15.props.subButtons then
		for _, v62 in p15.props.subButtons do
			local v63 = Text.GetTextWidth(p16[v62.Name], Header2Font, v54) + 2 * NavSubButtonInnerPadding

			table.insert(t2, v63)
			n1 = n1 + NavButtonElementPadding + v63
		end
	end

	local v64 = NavButtonElementMargin + v55 + n1 + NavButtonElementMargin
	local v65 = p15:getDefaultChild()

	if isSelected then
		return Roact.createElement(Focusable.TextButton, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(0, v64 + NavButtonBorderSize * 2, 1, -NavInnerPadding),
			BackgroundTransparency = 0,
			BackgroundColor3 = v58,
			[Roact.Event.Activated] = function() -- line: 198
				-- upvalues: p15 (copy)
				p15.props.onActivate()
			end,
			[Roact.Ref] = p15.props.forwardRef,
			NextSelectionLeft = p15.props.NextSelectionLeft,
			NextSelectionRight = p15.props.NextSelectionRight,
			SelectionImageObject = p18(CursorKind.NavHighlight),
			defaultChild = v65
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, NavCornerSize)
			}),
			InnerFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -NavButtonBorderSize * 2, 1, -NavButtonBorderSize * 2),
				Position = UDim2.fromOffset(NavButtonBorderSize, NavButtonBorderSize),
				BackgroundColor3 = Theme.BackgroundUIDefault.Color
			}, p15:getInnerFrameChildren(p16, p17, v55, t2, v58, v54))
		})
	end

	return Roact.createElement(Focusable.TextButton, {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, v64, 1, -NavInnerPadding),
		BackgroundTransparency = 0,
		BackgroundColor3 = Theme.BackgroundUIDefault.Color,
		BorderSizePixel = 0,
		[Roact.Event.Activated] = function() -- line: 227
			-- upvalues: p15 (copy)
			p15.props.onActivate()
		end,
		[Roact.Ref] = p15.props.forwardRef,
		NextSelectionLeft = p15.props.NextSelectionLeft,
		NextSelectionRight = p15.props.NextSelectionRight,
		SelectionImageObject = p18(CursorKind.NavHighlight),
		defaultChild = v65
	}, p15:getInnerFrameChildren(p16, p17, v55, t2, v58, v54))
end
function v17.renderWithProviders(p19, p20, p21, p22) -- line: 240
	-- upvalues: Roact (copy), NewItemNotification (copy)
	local isSelected = p19.props.isSelected
	local hasNewItemNotification = p19.props.hasNewItemNotification
	local frameRef = p19.props.frameRef
	local v73 = p19:renderButtonWithText(p20, p21, p22)

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		LayoutOrder = p19.props.layoutOrder,
		[Roact.Ref] = frameRef
	}, {
		Button = v73,
		NewItemNotification = hasNewItemNotification and Roact.createElement(NewItemNotification, {
			isSelected = isSelected
		})
	})
end
function v17.render(p23) -- line: 261
	-- upvalues: withLocalization (copy), withStyle (copy), withSelectionCursorProvider (copy)
	local t3 = {
		title = p23.props.categoryTitle
	}

	if p23.props.subButtons then
		for _, v77 in p23.props.subButtons do
			t3[v77.Name] = v77.Title
		end
	end

	return withLocalization(t3)(function(p24) -- line: 270
		-- upvalues: withStyle (copy), withSelectionCursorProvider (copy), p23 (copy)
		return withStyle(function(p25) -- line: 271
			-- upvalues: withSelectionCursorProvider (copy), p23 (copy), p24 (copy)
			return withSelectionCursorProvider(function(p26) -- line: 272
				-- upvalues: p23 (copy), p24 (copy), p25 (copy)
				return p23:renderWithProviders(p24, p25, p26)
			end)
		end)
	end)
end

return Roact.forwardRef(function(p27, p28) -- line: 279
	-- upvalues: Roact (copy), v17 (copy), Cryo (copy)
	return Roact.createElement(v17, Cryo.Dictionary.join(p27, {
		forwardRef = p28
	}))
end)
