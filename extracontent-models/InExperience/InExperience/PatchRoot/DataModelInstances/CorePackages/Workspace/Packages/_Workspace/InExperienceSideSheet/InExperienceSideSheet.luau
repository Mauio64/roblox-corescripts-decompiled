local parent = script.Parent
local RoactUtils = require(parent.RoactUtils)
local createLazyComponent = RoactUtils.Components.createLazyComponent

local toggleSideSheet = require(script.Utils.toggleSideSheet)
local getSideSheetVisibility = require(script.Utils.getSideSheetVisibility)
local registerInGameMenuPeoplePageActions = require(script.Utils.registerInGameMenuPeoplePageActions)
local registerSideSheetIntegrations = require(script.Utils.registerSideSheetIntegrations)
local setIsRespawnEnabled = require(script.Utils.setIsRespawnEnabled)
return {
	Enums = require(script.Common.Enums),
	Constants = require(script.Common.Constants),
	Flags = require(script.Flags),
	SideSheet = require(script.SideSheet),
	AccountUpsell = require(script.Components.AccountUpsell),
	RobuxWidget = createLazyComponent(function()
		return require(script.RobuxWidget)
	end),
	toggleSideSheet = toggleSideSheet,
	getDidSideSheetOpenWithPeoplePage = function(p)
		local getDidSideSheetOpenWithPeoplePage = require(script.Utils.getDidSideSheetOpenWithPeoplePage)
		return getDidSideSheetOpenWithPeoplePage(p)
	end,
	getHasRoomForPeoplePage = function()
		local getHasRoomForPeoplePage = require(script.Utils.getHasRoomForPeoplePage)
		return getHasRoomForPeoplePage()
	end,
	getIsPeoplePageOpen = function(p)
		local getIsPeoplePageOpen = require(script.Utils.getIsPeoplePageOpen)
		return getIsPeoplePageOpen(p)
	end,
	getSideSheetAnimationDuration = function()
		local getSideSheetAnimationDuration = require(script.Utils.getSideSheetAnimationDuration)
		return getSideSheetAnimationDuration()
	end,
	getSideSheetDrawerWidth = function(p)
		local getSideSheetDrawerWidth = require(script.Utils.getSideSheetDrawerWidth)
		return getSideSheetDrawerWidth(p)
	end,
	getSideSheetMenuPageHeight = function(p, p2)
		local getSideSheetMenuPageHeight = require(script.Utils.getSideSheetMenuPageHeight)
		return getSideSheetMenuPageHeight(p, p2)
	end,
	getSideSheetMenuPageWidth = function(p, p2, p3)
		local getSideSheetMenuPageWidth = require(script.Utils.getSideSheetMenuPageWidth)
		return getSideSheetMenuPageWidth(p, p2, p3)
	end,
	getSideSheetVisibility = getSideSheetVisibility,
	registerInGameMenuPeoplePageActions = registerInGameMenuPeoplePageActions,
	registerSideSheetIntegrations = registerSideSheetIntegrations,
	setupInGameMenuPeoplePageActions = function(p)
		local setupInGameMenuPeoplePageActions = require(script.Utils.setupInGameMenuPeoplePageActions)
		setupInGameMenuPeoplePageActions(p)
	end,
	setupPeoplePageOpenTracking = function(p)
		local setupPeoplePageOpenTracking = require(script.Utils.setupPeoplePageOpenTracking)
		setupPeoplePageOpenTracking(p)
	end,
	closePeoplePageWhenNoRoomBesideSideSheet = function(p)
		local closePeoplePageWhenNoRoomBesideSideSheet = require(script.Utils.closePeoplePageWhenNoRoomBesideSideSheet)
		return closePeoplePageWhenNoRoomBesideSideSheet(p)
	end,
	setIsRespawnEnabled = setIsRespawnEnabled,
	["jest.config"] = script["jest.config"]
}
