local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceModel").Enums.ItemTypeEnum

local fIntAXLookImpressionDeferTimeoutMs = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FIntAXLookImpressionDeferTimeoutMs

local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useStore

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")
local selectHydratedLookType = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Selectors/selectHydratedLookType")

local function useDeferLooksWithoutHydrationFilter(p2)
	local v5 = useStore()
	local content = if p2 then p2.content else nil

	local ref = React.useRef(false)

	React.useEffect(function()
		ref.current = false

		local v6 = math.max(0, fIntAXLookImpressionDeferTimeoutMs) / 1000
		local thread = task.delay(v6, function()
			ref.current = true
		end)

		return function()
			task.cancel(thread)
		end
	end, {})

	return React.useCallback(function(p3): boolean
		if ref.current then
			return true
		end

		local v6 = content and content[p3] or nil

		if not (v6 ~= nil and v6.type == itemTypeEnum.Look) then
			return true
		end

		local id = v6.id

		if id == nil then
			return true
		end

		return selectHydratedLookType(v5:getState(), (tostring(id))) ~= nil
	end, { content, v5 })
end

return useDeferLooksWithoutHydrationFilter
