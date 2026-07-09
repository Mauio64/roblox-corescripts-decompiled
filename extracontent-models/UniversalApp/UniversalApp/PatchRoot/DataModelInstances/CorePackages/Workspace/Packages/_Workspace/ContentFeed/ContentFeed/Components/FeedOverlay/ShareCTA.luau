local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local Foundation = require(ParentParentParent.Foundation)
local Icon = Foundation.Icon
local View = Foundation.View
local EventNames = require(ParentParent.Analytics.EventNames)
local FeedContext = require(ParentParent.App.FeedContext)
local SharePost = require(ParentParent.Thunks.SharePost)
local useAnalytics = require(ParentParent.Hooks.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useTokens = Foundation.Hooks.useTokens
local uDim2 = UDim2.fromOffset(1, 1)

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: useAnalytics (copy), useDispatch (copy), useTokens (copy), React (copy), FeedContext (copy), View (copy), EventNames (copy), SharePost (copy), Icon (copy), uDim2 (copy)
	local v16 = useAnalytics()
	local v17 = useDispatch()
	local v18 = useTokens()
	local v19 = React.useContext(FeedContext)

	return React.createElement(View, {
		tag = "radius-medium auto-xy padding-small bg-action-subtle",
		isDisabled = v19.isZooming,
		LayoutOrder = t1.layoutOrder,
		onActivated = function() -- line: 39
			-- upvalues: v16 (copy), EventNames (copy), t1 (copy), v17 (copy), SharePost (copy)
			v16.fireEvent(EventNames.ContentFeedShareCtaPressed, {
				postId = t1.postId
			})
			v17(SharePost(t1.creatorUserId, t1.postId))
		end
	}, {
		ShareIcon = React.createElement(Icon, {
			name = "icons/actions/shareArrowOn",
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			style = v18.Color.ActionEmphasis.Foreground
		}),
		ShareIconShadow = React.createElement(Icon, {
			name = "icons/actions/shareArrowOn",
			ZIndex = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5) + uDim2,
			style = v18.Color.Common.Shadow
		})
	})
end
