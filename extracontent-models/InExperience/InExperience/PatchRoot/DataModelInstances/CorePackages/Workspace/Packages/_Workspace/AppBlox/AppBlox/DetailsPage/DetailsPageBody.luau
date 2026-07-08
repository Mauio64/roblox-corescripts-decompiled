local Parent = script:FindFirstAncestor("AppBlox").Parent
local ContentPosition = require(script.Parent.ContentPosition)
local validateDetailsPageComponentList = require(script.Parent.validateDetailsPageComponentList)
local getPlatformConfig = require(script.Parent.getPlatformConfig)
local DetailsPageTitleContent = require(script.Parent.DetailsPageTitleContent)
local Roact = require(Parent.Roact)
local t = require(Parent.t)
local FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex = require(Parent.SharedFlags).FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex
local v9 = Roact.PureComponent:extend("DetailsPageBody")

v9.validateProps = t.strictInterface({
	titleText = t.optional(t.string),
	subTitleText = t.optional(t.string),
	renderInfoContent = t.optional(t.callback),
	componentList = t.optional(validateDetailsPageComponentList),
	dualPanelBreakpoint = t.optional(t.number),
	sideMargin = t.optional(t.number),
	bodyClipsDescendants = t.optional(t.boolean),
	maxContentWidth = t.optional(t.number),
	showPageDetails = t.optional(t.boolean),
	deviceType = t.optional(t.string),
	bottomPadding = t.optional(t.number)
})
v9.defaultProps = {
	bodyClipsDescendants = true,
	showPageDetails = false
}

function v9.init(p1) -- line: 51
	-- upvalues: Roact (copy)
	p1.state = {
		containerWidth = nil
	}
	p1.containerFrameRef = Roact.createRef()
	p1.mounted = false

	function p1.onContainerSizeChange(p2) -- line: 57
		-- upvalues: p1 (copy)
		if not p1.mounted then
			return
		end

		p1:setState(function(p3, _) -- line: 62
			-- upvalues: p2 (copy)
			if p3.containerWidth ~= p2.AbsoluteSize.x then
				return {
					containerWidth = p2.AbsoluteSize.x
				}
			end

			return nil
		end)
	end
end
function v9.renderSinglePanel(p5) -- line: 73
	-- upvalues: Roact (copy), FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex (copy)
	local t1 = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 24)
		}),
		UISizeConstraint = if not p5.props.maxContentWidth then nil else Roact.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(p5.props.maxContentWidth, 1e999)
		})
	}

	for k, v in pairs(p5.props.componentList) do
		t1[k .. "Container"] = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = v.portraitLayoutOrder,
			ZIndex = if not FFlagLuaAppFixEdpRecommendedCarouselHoverZIndex then nil else v.portraitZIndex
		}, {
			[k] = v.renderComponent()
		})
	end

	return {
		Panel = Roact.createElement("Frame", {
			ClipsDescendants = false,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, t1)
	}
end
function v9.renderDualPanel(p6) -- line: 113
	-- upvalues: Roact (copy), ContentPosition (copy)
	local v16 = not (p6.state.containerWidth < 1920) and 96 or 48
	local t2 = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 24)
		})
	}
	local t3 = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 24)
		})
	}

	for k, v in pairs(p6.props.componentList) do
		local v21 = t2

		if v.landscapePosition == ContentPosition.Right then
			v21 = t3
		end

		v21[k .. "Container"] = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = v.landscapeLayoutOrder
		}, {
			[k] = v.renderComponent()
		})
	end

	local v22 = Roact.createElement("Frame", {
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Size = UDim2.new(0.5, -v16 / 2, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, t2)
	local v23 = Roact.createElement("Frame", {
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(0.5, -v16 / 2, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, t3)

	return {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v16)
		}),
		LeftPanel = v22,
		RightPanel = v23
	}
end
function v9.renderBodyContent(p7) -- line: 180
	local v25 = p7.props.dualPanelBreakpoint or 1280

	if p7.state.containerWidth and p7.props.componentList then
		if v25 > p7.state.containerWidth then
			return p7:renderSinglePanel()
		end

		return p7:renderDualPanel()
	end

	return {}
end
function v9.render(p8) -- line: 193
	-- upvalues: getPlatformConfig (copy), Roact (copy), DetailsPageTitleContent (copy)
	local v27 = getPlatformConfig(p8.props.deviceType)
	local v28 = if not p8.props.sideMargin then v27.sideMargin else p8.props.sideMargin

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = p8.props.bodyClipsDescendants,
		AutomaticSize = Enum.AutomaticSize.Y,
		[Roact.Ref] = p8.containerFrameRef,
		[Roact.Change.AbsoluteSize] = p8.onContainerSizeChange
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v28),
			PaddingRight = UDim.new(0, v28)
		}),
		TitleInfo = p8.props.showPageDetails and Roact.createElement(DetailsPageTitleContent, {
			layoutOrder = 1,
			titleText = p8.props.titleText,
			subTitleText = p8.props.subTitleText,
			renderInfoContent = p8.props.renderInfoContent,
			verticalAlignment = Enum.VerticalAlignment.Top
		} or nil),
		Padding = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, if p8.props.showPageDetails then v28 else 24)
		}),
		ContentFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, p8:renderBodyContent()),
		BottomPadding = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, p8.props.bottomPadding or 3 * v28)
		})
	})
end
function v9.didMount(p9) -- line: 243
	p9.mounted = true

	if p9.containerFrameRef.current then
		p9.onContainerSizeChange(p9.containerFrameRef.current)
	end
end
function v9.willUnmount(p10) -- line: 251
	p10.mounted = false
end

return v9
