local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)

local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FIntAXLookImpressionDeferTimeoutMs = AvatarExperienceFlags.FIntAXLookImpressionDeferTimeoutMs

local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)
local selectHydratedLookType = require(AvatarExperienceCatalog.State.Selectors.selectHydratedLookType)

local function useDeferLooksWithoutHydrationFilter(p)
	local v = useStore()
	local content

	if p then
		content = p.content
	else
		content = nil
	end

	local ref = React.useRef(false)

	React.useEffect(function()
		ref.current = false

		local v2 = math.max(0, FIntAXLookImpressionDeferTimeoutMs) / 1000
		local thread = task.delay(v2, function()
			ref.current = true
		end)

		return function()
			task.cancel(thread)
		end
	end, {})

	return React.useCallback(function(p2: number): boolean
		if ref.current then
			return true
		end

		local v2 = content and content[p2] or nil

		if not (v2 ~= nil and v2.type == ItemTypeEnum.Look) then
			return true
		end

		local id = v2.id
		return id == nil or selectHydratedLookType(v:getState(), (tostring(id))) ~= nil
	end, { content, v })
end

return useDeferLooksWithoutHydrationFilter
