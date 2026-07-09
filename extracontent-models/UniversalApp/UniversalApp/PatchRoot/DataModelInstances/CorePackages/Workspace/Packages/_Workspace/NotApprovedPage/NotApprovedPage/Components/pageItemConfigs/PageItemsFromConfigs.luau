local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")

require(NotApprovedPage.Common.Types)

local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local useDispatch = require(NotApprovedPageParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useRef = React.useRef
local Foundation = require(NotApprovedPageParent.Foundation)
local View = Foundation.View
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local renderPageItemsFromList = require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils).renderPageItemsFromList
local usePageNavigation = require(NotApprovedPage.Contexts.PageNavigationContext).usePageNavigation

local function PageItemsFromConfigs(t1: {[any]: any}) -- line: 38
	-- upvalues: useDispatch (copy), useRef (copy), usePageNavigation (copy), renderPageItemsFromList (copy), useEffect (copy), React (copy), ScrollView (copy), ScrollBarVisibility (copy), View (copy)
	local v15 = useDispatch()
	local v16 = useRef(nil)
	local moderationDetail = t1.moderationDetail
	local v18 = usePageNavigation()
	local currentPage = v18.currentPage
	local v20 = renderPageItemsFromList(v18.currentPageConfigs, moderationDetail, v15, v18.currentPage, v18.hasEducationalPages, v18.isFirstPage, v18.currentPageName, t1.commutationEligibility)

	useEffect(function() -- line: 59
		-- upvalues: v16 (copy)
		if v16.current then
			local ScrollingFrame = v16.current:FindFirstChildWhichIsA("ScrollingFrame", true)

			if ScrollingFrame then
				ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
			end
		end
	end, { currentPage })

	return React.createElement(ScrollView, {
		tag = "size-full",
		ref = v16,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			scrollBarVisibility = ScrollBarVisibility.Always
		}
	}, {
		Content = React.createElement(View, {
			tag = "size-full-0 auto-y col"
		}, {
			PageItemsContent = React.createElement(View, {
				tag = "size-full-0 auto-y col gap-xlarge padding-x-xxlarge",
				LayoutOrder = 2
			}, unpack(v20))
		})
	})
end

return React.memo(PageItemsFromConfigs)
