local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local fFlagSignalsNavP3fGameDetails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3fGameDetails
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local module3 = require("@luauforge/bundled/egx")
local module4 = require("@luauforge/deferred/gHK")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService
local module5 = require("@luauforge/bundled/egY")
local module6 = require("@luauforge/deferred/hWp")
local module7 = require("@luauforge/bundled/fCM")
local module8 = require("@luauforge/bundled/egZ")
local module9 = require("@luauforge/bundled/gsk")
local module10 = require("@luauforge/bundled/fAF")

local module11 = require("@luauforge/bundled/eha")

local extended = module.PureComponent:extend("PurchaseGameRobuxShortfallPrompt")

function extended:init()
	function self.buyRobux()
		self.props.closePrompt()
		self.props.openPurchaseRobuxPage(self.props.networking)
	end
end

function extended.didMount(p2)
	local pageFilter = p2.props.pageFilter
	local v5

	if fFlagSignalsNavP3fGameDetails then
		v5 = getLegacyNavigationStore(false).getCurrentPage(false).name
	else
		v5 = p2.props.currentPage
	end

	local closePrompt = p2.props.closePrompt

	if pageFilter and not module4.Find(pageFilter, v5) then
		closePrompt()
	end
end

function extended.render(p2)
	local theme = p2.props.theme
	local containerWidth = p2.props.containerWidth
	local robuxShortfall = p2.props.robuxShortfall
	local closePrompt = p2.props.closePrompt
	local localization = p2.props.localization
	local gameName = p2.props.gameName

	local function fn(props)
		return module.createElement(module9.Provider, { value = theme }, {
			AlertWindow = module.createElement(module6, {
				containerWidth = containerWidth,
				titleText = props.titleText,
				titleFont = theme.GameDetails.Text.BoldFont,
				messageText = props.messageText,
				messageFont = theme.GameDetails.Text.Font,
				buttonFont = theme.GameDetails.Text.Font,
				confirmButtonText = props.confirmButtonText,
				onConfirm = p2.buyRobux,
				hasCancelButton = true,
				onCancel = closePrompt
			})
		})
	end

	if module11() then
		return module8({
			titleText = "Feature.GameDetails.Heading.PurchaseGame",
			messageText = {
				"Feature.GameDetails.Message.BuyMoreRobuxToPurchaseGameV2",
				gameName = gameName,
				shortfallPrice = robuxShortfall
			},
			confirmButtonText = "Feature.GameDetails.Action.BuyRobux"
		})(fn)
	end

	return fn({
		titleText = localization:Format("Feature.GameDetails.Heading.PurchaseGame"),
		messageText = localization:Format("Feature.GameDetails.Message.BuyMoreRobuxToPurchaseGameV2", {
			gameName = gameName,
			shortfallPrice = robuxShortfall
		}),
		confirmButtonText = localization:Format("Feature.GameDetails.Action.BuyRobux")
	})
end

local v5 = useSheetNavigation.connect(not fFlagSignalsNavP3fGameDetails and function(p2, p3)
	local v6

	if fFlagUseNavigationSelectors then
		v6 = selectors.selectCurrentLegacyRoute(p2)
	else
		v6 = p2.Navigation.history[#p2.Navigation.history]
	end

	return {
		currentPage = v6[#v6].name
	}
end or nil, function(callback)
	return {
		closePrompt = function()
			callback(module7())
		end,
		openPurchaseRobuxPage = function(p2)
			return callback(module10(nil, p2))
		end
	}
end)(extended)

return (roactServices.connect({
	localization = module5,
	guiService = appGuiService,
	networking = module3
})(v5))
