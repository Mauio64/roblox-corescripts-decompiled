local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)

local RetrievalStatus = require(parent.App.Loading.Enum.RetrievalStatus)
local LoadingStatePage = require(parent.App.Container.LoadingStatePage)
local FailedStatePage = require(parent.App.Container.FailedStatePage)

local extended = Roact.PureComponent:extend("LoadingStateContainer")

extended.validateProps = t.strictInterface({
	dataStatus = RetrievalStatus.isEnumValue,
	renderOnLoaded = t.callback,
	renderOnFailed = t.optional(t.callback),
	onRetry = t.optional(t.callback),
	renderOnLoading = t.optional(t.callback),
	renderOnEmpty = t.optional(t.callback)
})

function extended:init()
	self.statePages = {
		[RetrievalStatus.NotStarted] = function()
			if self.props.renderOnEmpty then
				return self.props.renderOnEmpty()
			end

			if self.props.renderOnLoading then
				return self.props.renderOnLoading()
			end

			return Roact.createElement(LoadingStatePage)
		end,
		[RetrievalStatus.Fetching] = function()
			if self.props.renderOnLoading then
				return self.props.renderOnLoading()
			end

			return Roact.createElement(LoadingStatePage)
		end,
		[RetrievalStatus.Failed] = function()
			if self.props.renderOnFailed then
				return self.props.renderOnFailed()
			end

			return Roact.createElement(FailedStatePage, { onRetry = self.props.onRetry })
		end,
		[RetrievalStatus.Done] = function()
			return self.props.renderOnLoaded()
		end
	}
end

function extended.render(p)
	return p.statePages[p.props.dataStatus]()
end

return extended
