require("@luauforge/deferred/fUR")

local module = require("@luauforge/deferred/fUU")
local useDispatch = require("@luauforge/deferred/fVE").Hooks.RoactRodux.useDispatch
local useEffect = module.useEffect
local useRef = module.useRef

local module2 = require("@luauforge/deferred/fUV")
local view = module2.View
local scrollView = module2.ScrollView
local scrollBarVisibility = module2.Enums.ScrollBarVisibility

local renderPageItemsFromList = require("@luauforge/deferred/fUY").renderPageItemsFromList

local usePageNavigation = require("@luauforge/deferred/fVa").usePageNavigation

local function PageItemsFromConfigs(p2)
	local v5 = useDispatch()
	local v6 = useRef(nil)

	local moderationDetail = p2.moderationDetail

	local v7 = usePageNavigation()
	local currentPage = v7.currentPage

	local v8 = renderPageItemsFromList(
		v7.currentPageConfigs,
		moderationDetail,
		v5,
		v7.currentPage,
		v7.hasEducationalPages,
		v7.isFirstPage,
		v7.currentPageName,
		p2.commutationEligibility
	)

	useEffect(function()
		local scrollingFrame = v6.current and v6.current:FindFirstChildWhichIsA("ScrollingFrame", true)

		if scrollingFrame then
			scrollingFrame.CanvasPosition = Vector2.new(0, 0)
		end
	end, { currentPage })

	return module.createElement(scrollView, {
		tag = "size-full",
		ref = v6,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(1, 0, 1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			scrollBarVisibility = scrollBarVisibility.Always
		}
	}, {
		Content = module.createElement(view, { tag = "size-full-0 auto-y col" }, {
			PageItemsContent = module.createElement(
				view,
				{
					tag = "size-full-0 auto-y col gap-xlarge padding-x-xxlarge",
					LayoutOrder = 2
				},
				unpack(v8)
			)
		})
	})
end

return module.memo(PageItemsFromConfigs)
