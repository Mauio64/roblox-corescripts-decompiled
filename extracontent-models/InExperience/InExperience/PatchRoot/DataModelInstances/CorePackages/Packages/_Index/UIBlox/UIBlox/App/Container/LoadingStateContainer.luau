local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local RetrievalStatus = require(ParentParent.App.Loading.Enum.RetrievalStatus)
local LoadingStatePage = require(ParentParent.App.Container.LoadingStatePage)
local FailedStatePage = require(ParentParent.App.Container.FailedStatePage)
local v8 = Roact.PureComponent:extend("LoadingStateContainer")

v8.validateProps = t.strictInterface({
	dataStatus = RetrievalStatus.isEnumValue,
	renderOnLoaded = t.callback,
	renderOnFailed = t.optional(t.callback),
	onRetry = t.optional(t.callback),
	renderOnLoading = t.optional(t.callback),
	renderOnEmpty = t.optional(t.callback)
})

function v8.init(p1) -- line: 30
	-- upvalues: RetrievalStatus (copy), Roact (copy), LoadingStatePage (copy), FailedStatePage (copy)
	p1.statePages = {
		[RetrievalStatus.NotStarted] = function() -- line: 32
			-- upvalues: p1 (copy), Roact (copy), LoadingStatePage (copy)
			if p1.props.renderOnEmpty then
				return p1.props.renderOnEmpty()
			end

			if p1.props.renderOnLoading then
				return p1.props.renderOnLoading()
			end

			return Roact.createElement(LoadingStatePage)
		end,
		[RetrievalStatus.Fetching] = function() -- line: 43
			-- upvalues: p1 (copy), Roact (copy), LoadingStatePage (copy)
			if p1.props.renderOnLoading then
				return p1.props.renderOnLoading()
			end

			return Roact.createElement(LoadingStatePage)
		end,
		[RetrievalStatus.Failed] = function() -- line: 50
			-- upvalues: p1 (copy), Roact (copy), FailedStatePage (copy)
			if p1.props.renderOnFailed then
				return p1.props.renderOnFailed()
			end

			return Roact.createElement(FailedStatePage, {
				onRetry = p1.props.onRetry
			})
		end,
		[RetrievalStatus.Done] = function() -- line: 59
			-- upvalues: p1 (copy)
			return p1.props.renderOnLoaded()
		end
	}
end
function v8.render(p2) -- line: 65
	return p2.statePages[p2.props.dataStatus]()
end

return v8
