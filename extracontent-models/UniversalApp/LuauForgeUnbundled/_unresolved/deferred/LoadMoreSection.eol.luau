local module = require("@luauforge/deferred/enn")
local module2 = require("@luauforge/deferred/enp")

local module3 = require("@luauforge/bundled/enl")

local button = module2.Button
local loading = module2.Loading
local view = module2.View
local inputSize = module2.Enums.InputSize
local loadMoreStatus = module3.LoadMoreStatus

local function LoadMoreSection(props)
	local loadMoreStatus2 = props.loadMoreStatus
	local v5

	if loadMoreStatus2 == loadMoreStatus.Failed then
		v5 = module.createElement(button, {
			onActivated = props.onLoadMore,
			size = inputSize.Small,
			text = "Retry"
		})

		return module.createElement(
			view,
			{
				LayoutOrder = props.layoutOrder,
				tag = "col align-x-center size-full-0 auto-y padding-large"
			},
			v5
		)
	end

	if not props.hasMore then
		return nil
	end

	if loadMoreStatus2 == loadMoreStatus.Loading then
		v5 = module.createElement(loading)

		return module.createElement(
			view,
			{
				LayoutOrder = props.layoutOrder,
				tag = "col align-x-center size-full-0 auto-y padding-large"
			},
			v5
		)
	end

	if props.enableContinuousLoad then
		return nil
	end

	v5 = module.createElement(button, {
		onActivated = props.onLoadMore,
		text = "Show More"
	})

	return module.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col align-x-center size-full-0 auto-y padding-large"
		},
		v5
	)
end

return LoadMoreSection
