local ContentPosition = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/ContentPosition")
local validateDetailsPageComponentList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/validateDetailsPageComponentList")

local getPlatformConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/getPlatformConfig")
local DetailsPageTitleContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/DetailsPageTitleContent")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/t")

local extended = Roact.PureComponent:extend("DetailsPageBody")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = { bodyClipsDescendants = true, showPageDetails = false }

function extended:init()
	self.state = { containerWidth = nil }
	self.containerFrameRef = Roact.createRef()

	self.mounted = false

	function self.onContainerSizeChange(p2)
		if not self.mounted then
			return
		end

		self:setState(function(p3, p4)
			if p3.containerWidth == p2.AbsoluteSize.x then
				return nil
			end

			return { containerWidth = p2.AbsoluteSize.x }
		end)
	end
end

function extended:renderSinglePanel()
	local children = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 24)
		}),
		UISizeConstraint = 0
	}

	local v5 = if self.props.maxContentWidth then Roact.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(self.props.maxContentWidth, 1e999)
	}) else nil
	children.UISizeConstraint = v5

	for k, component in pairs(self.props.componentList) do
		children[k .. "Container"] = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = component.portraitLayoutOrder,
			ZIndex = component.portraitZIndex
		}, { [k] = component.renderComponent() })
	end

	return {
		Panel = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromScale(1, 0),
			ClipsDescendants = false,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}, children)
	}
end

function extended:renderDualPanel()
	local v5 = self.state.containerWidth < 1920 and 48 or 96

	local v6 = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 24)
		})
	}

	local v7 = {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 24)
		})
	}

	for k, component in pairs(self.props.componentList) do
		local children = if component.landscapePosition == ContentPosition.Right then v7 else v6

		children[k .. "Container"] = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = component.landscapeLayoutOrder
			},
			{ [k] = component.renderComponent() }
		)
	end

	local element = Roact.createElement("Frame", {
		Size = UDim2.new(0.5, -v5 / 2, 0, 0),
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	}, v6)

	local element2 = Roact.createElement("Frame", {
		Size = UDim2.new(0.5, -v5 / 2, 0, 0),
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2
	}, v7)

	return {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v5)
		}),
		LeftPanel = element,
		RightPanel = element2
	}
end

function extended:renderBodyContent()
	local dualPanelBreakpoint = self.props.dualPanelBreakpoint or 1280

	if self.state.containerWidth and self.props.componentList then
		if self.state.containerWidth < dualPanelBreakpoint then
			return self:renderSinglePanel()
		end

		return self:renderDualPanel()
	end

	return {}
end

function extended:render()
	local v5 = getPlatformConfig(self.props.deviceType)

	local sideMargin = if self.props.sideMargin then self.props.sideMargin else v5.sideMargin

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = self.props.bodyClipsDescendants,
		AutomaticSize = Enum.AutomaticSize.Y,
		[Roact.Ref] = self.containerFrameRef,
		[Roact.Change.AbsoluteSize] = self.onContainerSizeChange
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		}),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, sideMargin),
			PaddingRight = UDim.new(0, sideMargin)
		}),
		TitleInfo = self.props.showPageDetails and Roact.createElement(DetailsPageTitleContent, {
			titleText = self.props.titleText,
			subTitleText = self.props.subTitleText,
			renderInfoContent = self.props.renderInfoContent,
			verticalAlignment = Enum.VerticalAlignment.Top,
			layoutOrder = 1
		} or nil),
		Padding = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, not self.props.showPageDetails and 24 or sideMargin),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}),
		ContentFrame = Roact.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 3
			},
			self:renderBodyContent()
		),
		BottomPadding = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, self.props.bottomPadding or 3 * sideMargin),
			BackgroundTransparency = 1,
			LayoutOrder = 4
		})
	})
end

function extended:didMount()
	self.mounted = true

	if self.containerFrameRef.current then
		self.onContainerSizeChange(self.containerFrameRef.current)
	end
end

function extended:willUnmount()
	self.mounted = false
end

return extended
