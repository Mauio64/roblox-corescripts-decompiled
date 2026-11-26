local module = require("@luauforge/deferred/eil")
local module2 = require("@luauforge/deferred/eiE")

local function SectionsView(props)
	local showLoadingView = props.showLoadingView or props.showEmptyView

	local createElement = module.createElement

	local joined = module2.Dictionary.join(props.feedProps or {}, {
		Name = "SectionsView",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})

	local v6 = {
		Layout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Content = module.createElement("Frame", {
			Name = "SectionsContent",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Visible = not showLoadingView,
			LayoutOrder = 1
		}, module2.Dictionary.join(props.renderedSections, {
			ContentLayout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		})),
		LoadingView = 0,
		emptyView = 0
	}

	local v7 = if props.showLoadingView then module.createElement(props.loadingView, {
		LayoutOrder = 2
	}) else nil
	v6.LoadingView = v7

	local v8 = if props.showEmptyView then module.createElement(props.emptyView, {
		LayoutOrder = 2
	}) else nil
	v6.emptyView = v8
	return createElement("Frame", joined, v6)
end

return SectionsView
