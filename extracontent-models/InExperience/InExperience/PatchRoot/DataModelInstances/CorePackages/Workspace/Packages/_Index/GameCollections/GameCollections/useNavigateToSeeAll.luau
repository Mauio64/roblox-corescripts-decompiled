local parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
require(parent.DiscoveryTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function useNavigateToSeeAll(p, isOmni: boolean, p2: number?, sortPageId: string?, p3: string?, pageContext: string?)
	local v = useDispatch()

	return (React.useCallback(function()
		if p == nil then
			return
		end

		local v2 = { name = AppPage.GamesList, detail = p3, extraProps = 0 }

		local extraProps = {
			sortPageId = sortPageId,
			sortName = p3,
			pageContext = pageContext,
			isOmni = isOmni,
			sortIndex = nil
		}
		local sortIndex

		if isOmni then
			sortIndex = p2
		end

		extraProps.sortIndex = sortIndex
		v2.extraProps = extraProps

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v2))
		else
			v(NavigateDown(v2))
		end
	end, { v, isOmni, p, p2, p3, pageContext, sortPageId }))
end

return useNavigateToSeeAll
