local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fTi")
local module2 = require("@luauforge/bundled/dTM")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module3 = require("@luauforge/bundled/eda")

local UIBlox = require(CorePackages.Packages.UIBlox)
local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module4 = require("@luauforge/bundled/eeH")

local module5 = require("@luauforge/deferred/gfc")

local module6 = require("@luauforge/bundled/dHo")
require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Models/CollectibleInstance")
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")

local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals
local defineFastFlag = game:DefineFastFlag("AXOpenExperienceDetailsInFullView", false)

local function ItemToExperienceModal(p2)
	local v5 = useDispatch()
	local v6 = module4(module3)
	local state, setState = React.useState(nil)

	local v7 = useSelector(function(p3)
		return p3.ScreenSize
	end, getUseSelectorDeepEquals())

	local v8 = module({
		soldOutTitle = "Feature.Catalog.Label.ItemExperienceSoldOutTitle",
		soldOutMessage = "Feature.Catalog.Label.ItemExperienceSoldOut",
		limitReachedTitle = "Feature.Catalog.Label.ItemExperienceLimitReachedTitle",
		limitReachedMessage = "Feature.Catalog.Label.ItemExperienceLimitReached"
	})

	local params = p2.navigation.state.params
	local collectibleData = params.collectibleData
	local isLimited = params.isLimited
	local experiences = collectibleData and collectibleData.experiences
	local v9 = experiences and #experiences or 0
	local ids = {}

	if experiences then
		for k, experience in experiences do
			table.insert(ids, experience.id)
		end
	end

	local v10 = GameHydrationReact.useFetchGameIcons(ids)

	local v11 = useSelector(function(p3)
		if collectibleData and collectibleData.collectibleItemId then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleData.collectibleItemId]
				or {}
		end

		return {}
	end, getUseSelectorDeepEquals())

	React.useEffect(function()
		if not experiences then
			return
		end

		local v12 = {}

		for i, experience in ipairs(experiences) do
			table.insert(v12, experience.id)
		end

		if v9 == 1 then
			setState(experiences[1])
		end
	end, { experiences, v6 })

	React.useEffect(function() end, { v10 })

	React.useEffect(function()
		if not state then
			return
		end

		assert(state, "")

		local id = tostring(state.id)
		local count = 0

		for k, v12 in v11 do
			count += 1
		end

		module2.closeOverlay(p2.navigation)

		local v12 = nil
		local v13 = nil

		if collectibleData.unitsAvailableForConsumption == 0 and isLimited then
			v12 = v8.soldOutTitle
			v13 = v8.soldOutMessage
		elseif
			collectibleData.quantityLimitPerUser > 0
			and collectibleData.quantityLimitPerUser <= count
		then
			v12 = v8.limitReachedTitle
			v13 = v8.limitReachedMessage
		end

		if not (v12 or v13) then
			v5(module6(id, defineFastFlag and { mountAsFullView = true } or {}))

			return
		end

		local navigate = p2.navigation.navigate
		local openExperienceTraversalPrompt = avatarScreen.OpenExperienceTraversalPrompt
		local v14 = {
			gameName = state.name,
			gameUniverseId = id,
			overrideTitle = v12,
			overrideBody = 0,
			hideConfirmationButton = true
		}
		local v15

		if v13 then
			v15 = v13:gsub("{EXPERIENCE_NAME}", function()
				return state.name
			end)
		end

		v14.overrideBody = v15
		navigate(openExperienceTraversalPrompt, v14)
	end, { state, collectibleData })

	local v12 = React.useCallback(function()
		module2.closeOverlay(p2.navigation)
	end, { p2.navigation })

	if not experiences or v9 == 1 then
		return
	end

	local v13 = {}

	for k, experience in experiences do
		table.insert(v13, {
			icon = v10[tostring(experience.id)],
			text = experience.name,
			onActivated = function()
				setState(experience)
			end
		})
	end

	local createElement = React.createElement

	local v16 = if params.menuDirection then params.menuDirection else menuDirection.Up
	local v17 = if params.openPositionY then params.openPositionY else UDim.new(1, -76)
	return createElement(contextualMenu, {
		buttonProps = v13,
		open = true,
		menuDirection = v16,
		openPositionY = v17,
		openPositionX = UDim.new(0.35, 0),
		closeBackgroundVisible = false,
		screenSize = v7,
		onDismiss = v12
	})
end

return module5(ItemToExperienceModal)
