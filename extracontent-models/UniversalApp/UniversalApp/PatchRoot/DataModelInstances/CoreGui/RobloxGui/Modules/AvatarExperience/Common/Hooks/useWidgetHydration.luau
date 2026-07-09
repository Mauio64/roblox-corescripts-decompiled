local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local WidgetConstants = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).WidgetConstants

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local FetchHydratedWidgetContent = require(Modules.AvatarExperience.Catalog.Thunks.FetchHydratedWidgetContent)
local getContentToHyderate = require(Modules.AvatarExperience.Common.Components.WidgetList.Utils.getContentToHyderate)

local function useWidgetHydration(t1: {[any]: any}) -- line: 32
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), React (copy), RetrievalStatus (copy), getContentToHyderate (copy), WidgetConstants (copy), FetchHydratedWidgetContent (copy)
	local widgetInfo = t1.widgetInfo
	local hydratedWidgetData = t1.hydratedWidgetData
	local hydrationCount = t1.hydrationCount
	local v17 = useDispatch()
	local v18 = useRoactService(RoactNetworking)
	local v19, v20 = React.useState(RetrievalStatus.NotStarted)
	local v21 = React.useMemo(function() -- line: 41
		-- upvalues: getContentToHyderate (copy), widgetInfo (copy), hydratedWidgetData (copy), hydrationCount (copy)
		return getContentToHyderate(widgetInfo, hydratedWidgetData, hydrationCount)
	end, {
		hydratedWidgetData,
		widgetInfo,
		hydrationCount
	})

	React.useEffect(function() -- line: 45
		-- upvalues: widgetInfo (copy), WidgetConstants (copy), v21 (copy), v19 (copy), RetrievalStatus (copy), v20 (copy), v17 (copy), FetchHydratedWidgetContent (copy), v18 (copy)
		if widgetInfo.type ~= WidgetConstants.Types.MySharedAvatarsWidget and (v21 and #v21 > 0 and v19 == RetrievalStatus.NotStarted) then
			v20(RetrievalStatus.Fetching)
			v17(FetchHydratedWidgetContent(v18, v21, widgetInfo.id))
		end
	end, {
		v21,
		widgetInfo,
		v19,
		v17,
		v18
	})
end

return useWidgetHydration
