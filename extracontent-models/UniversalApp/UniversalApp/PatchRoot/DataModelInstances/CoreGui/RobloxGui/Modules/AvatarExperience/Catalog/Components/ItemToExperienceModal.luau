local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local UIBlox = require(CorePackages.Packages.UIBlox)
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local OpenGameDetails = require(Modules.LuaApp.Thunks.OpenGameDetails)
local ApiFetchGameIcons = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.ApiFetchGameIcons

require(Modules.AvatarExperience.Common.Models.CollectibleInstance)

local GameIconReducer = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.GameIconReducer
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local v19 = game:DefineFastFlag("AXOpenExperienceDetailsInFullView", false)

local function ItemToExperienceModal(t1: {[any]: any}) -- line: 45
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), React (copy), useSelector (copy), getUseSelectorDeepEquals (copy), GameIconReducer (copy), useLocalization (copy), ApiFetchGameIcons (copy), NavigationUtils (copy), AvatarScreen (copy), OpenGameDetails (copy), v19 (copy), ContextualMenu (copy), MenuDirection (copy)
	local v22 = useDispatch()
	local v23 = useRoactService(RoactNetworking)
	local v24, v25 = React.useState(nil)
	local v26 = useSelector(function(p1) -- line: 50
		return p1.ScreenSize
	end, getUseSelectorDeepEquals())
	local v27 = useSelector(function(p2) -- line: 54
		-- upvalues: GameIconReducer (copy)
		return p2[GameIconReducer.key]
	end, getUseSelectorDeepEquals())
	local v28 = useLocalization({
		soldOutTitle = "Feature.Catalog.Label.ItemExperienceSoldOutTitle",
		soldOutMessage = "Feature.Catalog.Label.ItemExperienceSoldOut",
		limitReachedTitle = "Feature.Catalog.Label.ItemExperienceLimitReachedTitle",
		limitReachedMessage = "Feature.Catalog.Label.ItemExperienceLimitReached"
	})
	local params = t1.navigation.state.params
	local collectibleData = params.collectibleData
	local isLimited = params.isLimited
	local v32 = collectibleData and collectibleData.experiences
	local v33 = not v32 and 0 or #v32
	local v34 = useSelector(function(p3) -- line: 71
		-- upvalues: collectibleData (copy)
		if collectibleData and collectibleData.collectibleItemId then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleData.collectibleItemId] or {}
		end

		return {}
	end, getUseSelectorDeepEquals())

	React.useEffect(function() -- line: 81
		-- upvalues: v32 (copy), v22 (copy), ApiFetchGameIcons (copy), v23 (copy), v33 (copy), v25 (copy)
		if not v32 then
			return
		end

		local t2 = {}

		for _, v in ipairs(v32) do
			table.insert(t2, v.id)
		end

		v22(ApiFetchGameIcons(v23, t2))

		if v33 == 1 then
			v25(v32[1])
		end
	end, {
		v32,
		v23
	})
	React.useEffect(function() -- line: 100
	end, { v27 })
	React.useEffect(function() -- line: 104
		-- upvalues: v24 (copy), v34 (copy), NavigationUtils (copy), t1 (copy), collectibleData (copy), isLimited (copy), v28 (copy), AvatarScreen (copy), v22 (copy), OpenGameDetails (copy), v19 (copy)
		if not v24 then
			return
		end

		assert(v24, "")

		local str = tostring(v24.id)
		local n1 = 0

		for _, _ in v34 do
			n1 += 1
		end

		NavigationUtils.closeOverlay(t1.navigation)

		local soldOutTitle = nil
		local soldOutMessage = nil

		if collectibleData.unitsAvailableForConsumption == 0 and isLimited then
			soldOutTitle = v28.soldOutTitle
			soldOutMessage = v28.soldOutMessage
		elseif collectibleData.quantityLimitPerUser > 0 and n1 >= collectibleData.quantityLimitPerUser then
			soldOutTitle = v28.limitReachedTitle
			soldOutMessage = v28.limitReachedMessage
		end

		if soldOutTitle or soldOutMessage then
			t1.navigation.navigate(AvatarScreen.OpenExperienceTraversalPrompt, {
				hideConfirmationButton = true,
				gameName = v24.name,
				gameUniverseId = str,
				overrideTitle = soldOutTitle,
				overrideBody = if not soldOutMessage then nil else soldOutMessage:gsub("{EXPERIENCE_NAME}", v24.name)
			})

			return
		end

		v22(OpenGameDetails(str, if not v19 then {} else {
			mountAsFullView = true
		}))
	end, {
		v24,
		collectibleData
	})

	local v35 = React.useCallback(function() -- line: 153
		-- upvalues: NavigationUtils (copy), t1 (copy)
		NavigationUtils.closeOverlay(t1.navigation)
	end, { t1.navigation })

	if not v32 or v33 == 1 then
		return
	end

	local t3 = {}

	for _, v in ipairs(v32) do
		local v39 = v27[tostring(v.id)]

		table.insert(t3, {
			icon = if not v39 then nil else v39.url,
			text = v.name,
			onActivated = function() -- line: 171
				-- upvalues: v25 (copy), v (copy)
				v25(v)
			end
		})
	end

	return React.createElement(ContextualMenu, {
		open = true,
		closeBackgroundVisible = false,
		buttonProps = t3,
		menuDirection = if not params.menuDirection then MenuDirection.Up else params.menuDirection,
		openPositionY = if not params.openPositionY then UDim.new(1, -76) else params.openPositionY,
		openPositionX = UDim.new(0.35, 0),
		screenSize = v26,
		onDismiss = v35
	})
end

return withOverlayFocusHandling(ItemToExperienceModal)
