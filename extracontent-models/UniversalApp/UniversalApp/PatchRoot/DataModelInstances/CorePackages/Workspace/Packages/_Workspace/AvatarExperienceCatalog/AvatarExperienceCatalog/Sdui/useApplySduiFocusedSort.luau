local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)

require(Parent.AvatarExperienceRodux)

local Logging = require(Parent.AppCommonLib).Logging
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local buildFocusedSortWidgetInfo = require(script.Parent.buildFocusedSortWidgetInfo)
local hydrateCatalogSortById = require(script.Parent.hydrateCatalogSortById)

local function buildAlreadyHydratedSet(p1) -- line: 57
	if not p1 then
		return nil
	end

	local t1 = {}

	for v12, v13 in p1 do
		if typeof(v13) == "table" then
			local t2 = {}

			for v15, v16 in v13 do
				if typeof(v16) == "table" and v16.failedToHydrate ~= true then
					t2[tostring(v15)] = true
				end
			end

			if next(t2) ~= nil then
				t1[tostring(v12)] = t2
			end
		end
	end

	if next(t1) == nil then
		return nil
	end

	return t1
end
local function useApplySduiFocusedSort(t3: {[any]: any}) -- line: 86
	-- upvalues: useDispatch (copy), React (copy), Logging (copy), buildFocusedSortWidgetInfo (copy), buildAlreadyHydratedSet (copy), hydrateCatalogSortById (copy)
	local v18 = useDispatch()

	return React.useCallback(function(t4: {[any]: any}, s1: string?, p2) -- line: 89
		-- upvalues: Logging (copy), buildFocusedSortWidgetInfo (copy), v18 (copy), t3 (copy), buildAlreadyHydratedSet (copy), hydrateCatalogSortById (copy)
		if not s1 or s1 == "" then
			Logging.warn("useApplySduiFocusedSort: missing context for sortId=" .. tostring(t4 and t4.sortId) .. "; SDUI catalog isn't propagating context to ResultsList. " .. "Verify FFlagAXMigrateAllTabToSduiDevV3 is on.")

			return false
		end

		local v22 = buildFocusedSortWidgetInfo(t4.sortId, s1, {
			title = t4.title,
			description = t4.description,
			tooltipText = t4.tooltipText
		})

		if not v22 then
			Logging.warn("useApplySduiFocusedSort: synthesizer returned nil for sortId=" .. tostring(t4.sortId) .. " context=" .. tostring(s1))

			return false
		end

		v18(t3.SetWidgetInfo(v22.widgetInfo, v22.requestId, nil, s1))

		local v23 = nil

		if t3.getHydratedWidgetData then
			v23 = buildAlreadyHydratedSet(t3.getHydratedWidgetData())
		end

		hydrateCatalogSortById(v18, p2, t3.SetHydratedWidgetData, t3.CatalogWebApi, t4.sortId, v23)

		return true
	end, {
		v18,
		t3.SetWidgetInfo,
		t3.SetHydratedWidgetData,
		t3.CatalogWebApi,
		t3.getHydratedWidgetData
	})
end

return useApplySduiFocusedSort
