local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local WidgetEventImpressionsReporter = require(Modules.AvatarExperience.Common.Components.Impressions.WidgetEventImpressionsReporter)
local ScreenSizeImpressionsDetector = require(CorePackages.Workspace.Packages.Impressions).ScreenSizeImpressionsDetector
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Grid = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).GridComponents.Grid
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local FFlagAXFixSeeAllSpacing = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXFixSeeAllSpacing

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local t1 = {}

local function WidgetLoadableGridView(t2: {[any]: any}) -- line: 47
	-- upvalues: useRoactService (copy), Analytics (copy), React (copy), Signal (copy), useTokens (copy), ScreenSizeImpressionsDetector (copy), t1 (copy), UnifiedEventLogEnums (copy), WidgetEventImpressionsReporter (copy), Grid (copy), FFlagAXFixSeeAllSpacing (copy)
	local widgetInfo = t2.widgetInfo
	local v17 = useRoactService(Analytics)
	local v18 = React.useRef(Signal.new())
	local v19 = React.useRef(nil)
	local v20 = useTokens()

	React.useEffect(function() -- line: 55
		-- upvalues: v19 (copy), v18 (copy)
		local connection = nil

		if v19.current then
			connection = v19.current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 59
				-- upvalues: v18 (copy)
				v18.current:fire()
			end)
		end

		v18.current:fire()

		return function() -- line: 66
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, {})

	local v21 = React.createElement(ScreenSizeImpressionsDetector, {
		onRequestImpressionsSignal = v18.current,
		onImpressionsDetected = function(p1) -- line: 75
			-- upvalues: t2 (copy), t1 (copy), widgetInfo (copy), UnifiedEventLogEnums (copy), WidgetEventImpressionsReporter (copy), v17 (copy)
			for _, v26 in p1 do
				local v27 = t2.widgetInfo.id .. "_" .. v26

				if not t1[v27] then
					local v28 = widgetInfo.content and widgetInfo.content[v26] or {}
					local t3 = {
						widgetId = t2.widgetInfo.id,
						itemPosition = v26,
						itemId = v28.id,
						itemType = v28.type,
						uiTreatmentType = UnifiedEventLogEnums.WidgetUiTreatment.WIDGET_SEE_ALL
					}

					WidgetEventImpressionsReporter(v17, t3)
					t1[v27] = true
				end
			end
		end,
		impressionsTag = t2.impressionsTag
	})
	local v22 = React.createElement(Grid, {
		itemsPerRow = t2.itemsPerRow or 1,
		renderItem = function(p2) -- line: 97
			-- upvalues: t2 (copy)
			local item = p2.item

			return t2.renderItem({
				id = item.id,
				type = item.type,
				gridInformation = p2.gridInformation
			}, p2.index)
		end,
		getItemId = function(p3) -- line: 104
			-- upvalues: t2 (copy)
			return p3.id .. t2.itemsPerRow
		end,
		items = t2.items or {},
		gapVertical = if not FFlagAXFixSeeAllSpacing then v20.Gap.Large else v20.Gap.Medium,
		gapHorizontal = if not FFlagAXFixSeeAllSpacing then v20.Gap.Small else v20.Gap.Medium,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = v19
	})

	return React.createElement(React.Fragment, {}, {
		GridView = v22,
		ImpressionsDetector = v21
	})
end

return WidgetLoadableGridView
