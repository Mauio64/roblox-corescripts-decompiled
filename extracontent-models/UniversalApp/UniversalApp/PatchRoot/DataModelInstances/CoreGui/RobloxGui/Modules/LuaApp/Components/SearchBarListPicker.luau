local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local withStyle = UIBlox.Style.withStyle
local SearchConstants = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.Search.SearchConstants
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FitChildren = require(Modules.LuaApp.FitChildren)
local SearchBarListPickerItem = require(Modules.LuaApp.Components.SearchBarListPickerItem)
local v16 = game:DefineFastFlag("LuaAppSearchListFramesSelectable", false)
local FFlagBoldSearchListPickerSuggestions = require(Modules.LuaApp.Flags.FFlagBoldSearchListPickerSuggestions)
local FFlagSearchOmniAutocompletePage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchOmniAutocompletePage
local v19 = Roact.PureComponent:extend("SearchBarListPicker")
local v20 = not FFlagSearchOmniAutocompletePage and 24 or SearchConstants.SEARCH_MARGIN

v19.validateProps = t.strictInterface({
	items = t.array(t.any),
	width = t.UDim,
	height = if not FFlagSearchOmniAutocompletePage then t.optional(t.number) else t.optional(t.UDim),
	layoutOrder = t.optional(t.integer),
	forwardRef = t.optional(t.table),
	BackgroundTransparency = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.number),
	removeAdditionalMargins = if not FFlagSearchOmniAutocompletePage then nil else t.optional(t.boolean),
	currentKeyword = if not FFlagBoldSearchListPickerSuggestions then nil else t.optional(t.string),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	formFactor = t.optional(t.string),
	screenHeight = t.optional(t.integer),
	topBarHeight = t.optional(t.number),
	globalGuiInset = t.optional(t.table)
})

function v19.init(p1) -- line: 54
	-- upvalues: RoactGamepad (copy)
	p1.focusableRefs = RoactGamepad.createRefCache()
end
function v19.renderWithProviders(p2, p3) -- line: 58
	-- upvalues: FFlagSearchOmniAutocompletePage (copy), Roact (copy), v16 (copy), Focusable (copy), SearchBarListPickerItem (copy), FFlagBoldSearchListPickerSuggestions (copy), CursorKind (copy), withStyle (copy), v20 (copy), FitChildren (copy)
	local items = p2.props.items
	local layoutOrder = p2.props.layoutOrder
	local screenHeight = p2.props.screenHeight
	local topBarHeight = p2.props.topBarHeight
	local globalGuiInset = p2.props.globalGuiInset
	local height = p2.props.height
	local u31 = if not height then UDim2.new(p2.props.width.Scale, p2.props.width.Offset, 0, screenHeight - globalGuiInset.top - topBarHeight - globalGuiInset.bottom) else if not FFlagSearchOmniAutocompletePage then UDim2.new(p2.props.width.Scale, p2.props.width.Offset, 0, height) else UDim2.new(p2.props.width.Scale, p2.props.width.Offset, height.Scale, height.Offset)
	local t1 = {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TopPadding = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 0,
			Size = UDim2.new(1, 0, 0, 5)
		})
	}

	local function getAdjacentIndexRef(n1: number, n2: number) -- line: 97
		-- upvalues: p2 (copy), items (copy)
		local v54 = n1 + n2

		if v54 < 1 then
			return p2.props.NextSelectionUp
		end

		if v54 > #items then
			return p2.props.NextSelectionDown or p2.focusableRefs[n1]
		end

		return p2.focusableRefs[v54]
	end
	local function getItemIndexRef(p4) -- line: 108
		-- upvalues: items (copy), p2 (copy)
		return p4 >= 1 and p4 <= #items and p2.focusableRefs[p4] or nil
	end

	local forwardRef = p2.props.forwardRef

	if v16 and #p2.props.items > 0 then
		p2.focusableRefs[1] = forwardRef
	end

	for i, v in ipairs(items) do
		local createElement = Roact.createElement
		local v39 = Focusable[SearchBarListPickerItem]
		local t2 = {
			item = v,
			layoutOrder = i,
			separatorEnabled = i < #items,
			currentKeyword = if not FFlagBoldSearchListPickerSuggestions then nil else p2.props.currentKeyword
		}
		local v42

		if v16 then
			local v41 = i + -1

			v42 = if not (v41 < 1) then if not (v41 > #items) then p2.focusableRefs[v41] else p2.props.NextSelectionDown or p2.focusableRefs[i] else p2.props.NextSelectionUp
		else
			local v43 = i - 1

			v42 = v43 >= 1 and v43 <= #items and p2.focusableRefs[v43] or nil
		end

		t2.NextSelectionUp = v42

		local v45

		if v16 then
			local v44 = i + 1

			v45 = if not (v44 < 1) then if not (v44 > #items) then p2.focusableRefs[v44] else p2.props.NextSelectionDown or p2.focusableRefs[i] else p2.props.NextSelectionUp
		else
			local v46 = math.min(#items, i + 1)

			v45 = v46 >= 1 and v46 <= #items and p2.focusableRefs[v46] or nil
		end

		t2.NextSelectionDown = v45
		t2.NextSelectionRight = if not v16 then i >= 1 and i <= #items and p2.focusableRefs[i] or nil else p2.props.NextSelectionRight
		t2.NextSelectionLeft = if not v16 then i >= 1 and i <= #items and p2.focusableRefs[i] or nil else p2.props.NextSelectionLeft
		t2.SelectionImageObject = p3(CursorKind.RoundedRectNoInset)
		t2[Roact.Ref] = i >= 1 and i <= #items and p2.focusableRefs[i] or nil
		t1[i] = createElement(v39, t2)
	end

	return withStyle(function(p5) -- line: 142
		-- upvalues: FFlagSearchOmniAutocompletePage (copy), p2 (copy), u31 (ref), v20 (copy), Roact (copy), Focusable (copy), layoutOrder (copy), v16 (copy), items (copy), forwardRef (copy), FitChildren (copy), t1 (copy)
		local v57 = if not FFlagSearchOmniAutocompletePage then p5.Theme.BackgroundDefault.Transparency else p2.props.BackgroundTransparency or p5.Theme.BackgroundDefault.Transparency
		local v58 = if not FFlagSearchOmniAutocompletePage or not p2.props.removeAdditionalMargins then u31 + UDim2.fromOffset(v20 * 2, 0) else u31
		local v59 = if not FFlagSearchOmniAutocompletePage or not p2.props.removeAdditionalMargins then u31 - UDim2.new(0, v20 * 2, 0, 0) else UDim2.new(1, 0, 1, 0)

		return Roact.createElement(Focusable.Frame, {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = if not FFlagSearchOmniAutocompletePage then u31 + UDim2.fromOffset(v20 * 2, 0) else v58,
			BackgroundColor3 = p5.Theme.BackgroundDefault.Color,
			BackgroundTransparency = if not FFlagSearchOmniAutocompletePage then p5.Theme.BackgroundDefault.Transparency else v57,
			BorderSizePixel = 0,
			LayoutOrder = if not FFlagSearchOmniAutocompletePage then nil else layoutOrder,
			NextSelectionLeft = if not v16 then p2.props.NextSelectionLeft else nil,
			NextSelectionRight = if not v16 then p2.props.NextSelectionRight else nil,
			NextSelectionUp = if not v16 then p2.props.NextSelectionUp else nil,
			NextSelectionDown = if not v16 then p2.props.NextSelectionDown else nil,
			defaultChild = if not items or not (#items > 0) then nil else p2.focusableRefs[1],
			[Roact.Ref] = if not v16 then forwardRef else nil,
			SelectionGroup = not not v16 or nil,
			SelectionBehaviorDown = if not v16 then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = if not v16 then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = if not v16 then nil else Enum.SelectionBehavior.Stop
		}, {
			list = Roact.createElement(FitChildren.FitScrollingFrame, {
				BorderSizePixel = 0,
				ScrollBarThickness = 0,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0),
				BackgroundColor3 = p5.Theme.BackgroundDefault.Color,
				BackgroundTransparency = if not FFlagSearchOmniAutocompletePage then p5.Theme.BackgroundDefault.Transparency else v57,
				LayoutOrder = layoutOrder,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				Size = if not FFlagSearchOmniAutocompletePage then u31 - UDim2.new(0, v20 * 2, 0, 0) else v59,
				fitFields = {
					CanvasSize = FitChildren.FitAxis.Height
				},
				Selectable = not v16 and nil
			}, t1)
		})
	end)
end
function v19.render(p6) -- line: 201
	-- upvalues: withSelectionCursorProvider (copy)
	return withSelectionCursorProvider(function(p7) -- line: 202
		-- upvalues: p6 (copy)
		return p6:renderWithProviders(p7)
	end)
end

local u21 = RoactRodux.connect(function(p8, _) -- line: 207
	return {
		formFactor = p8.FormFactor,
		screenHeight = p8.ScreenSize.Y,
		topBarHeight = p8.TopBar.topBarHeight,
		globalGuiInset = p8.GlobalGuiInset
	}
end)(v19)

return Roact.forwardRef(function(p10, p11) -- line: 216
	-- upvalues: Roact (copy), u21 (ref), Cryo (copy)
	return Roact.createElement(u21, Cryo.Dictionary.join(p10, {
		forwardRef = p11
	}))
end)
