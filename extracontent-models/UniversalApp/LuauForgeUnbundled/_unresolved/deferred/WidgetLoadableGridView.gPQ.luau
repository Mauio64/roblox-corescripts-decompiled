local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local module = require("@luauforge/bundled/fvF")

local module2 = require("@luauforge/deferred/gPP")
local screenSizeImpressionsDetector = require("@luauforge/bundled/edd").ScreenSizeImpressionsDetector
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local module3 = require("@luauforge/bundled/eeH")
local grid = require("@luauforge/deferred/gkN").GridComponents.Grid
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums
local fFlagAXFixSeeAllSpacing = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixSeeAllSpacing

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local set = {}

local function WidgetLoadableGridView(props)
	local widgetInfo = props.widgetInfo
	local v5 = module3(module)
	local ref = React.useRef(signal.new())

	local ref2 = React.useRef(nil)
	local v6 = useTokens()

	React.useEffect(function()
		local absolutePositionChangedConnection

		if ref2.current then
			absolutePositionChangedConnection = ref2.current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				ref.current:fire()
			end)
		else
			absolutePositionChangedConnection = nil
		end

		ref.current:fire()

		return function()
			if absolutePositionChangedConnection then
				absolutePositionChangedConnection:Disconnect()
			end
		end
	end, {})

	local element = React.createElement(screenSizeImpressionsDetector, {
		onRequestImpressionsSignal = ref.current,
		onImpressionsDetected = function(items)
			for k, item in items do
				local v7 = props.widgetInfo.id .. "_" .. item

				if set[v7] then
					continue
				end

				local v8 = widgetInfo.content and widgetInfo.content[item] or {}
				module2(v5, {
					widgetId = props.widgetInfo.id,
					itemPosition = item,
					itemId = v8.id,
					itemType = v8.type,
					uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.WIDGET_SEE_ALL
				})
				set[v7] = true
			end
		end,
		impressionsTag = props.impressionsTag
	})

	local createElement = React.createElement
	local v8 = {
		itemsPerRow = props.itemsPerRow or 1,
		renderItem = function(data)
			local item = data.item
			return props.renderItem(
				{
					id = item.id,
					type = item.type,
					gridInformation = data.gridInformation
				},
				data.index
			)
		end,
		getItemId = function(p2)
			return p2.id .. props.itemsPerRow
		end,
		items = props.items or {},
		gapVertical = 0,
		gapHorizontal = 0,
		Size = 0,
		AutomaticSize = 0,
		ref = 0
	}
	local v9 = if fFlagAXFixSeeAllSpacing then v6.Gap.Medium else v6.Gap.Large
	v8.gapVertical = v9
	local v10 = if fFlagAXFixSeeAllSpacing then v6.Gap.Medium else v6.Gap.Small
	v8.gapHorizontal = v10
	v8.Size = UDim2.fromScale(1, 0)
	v8.AutomaticSize = Enum.AutomaticSize.Y
	v8.ref = ref2
	local element2 = createElement(grid, v8)

	return React.createElement(React.Fragment, {}, {
		GridView = element2,
		ImpressionsDetector = element
	})
end

return WidgetLoadableGridView
