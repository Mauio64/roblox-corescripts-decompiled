local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagSignalsNavP3fGameDetails = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3fGameDetails
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local Roact = require(Modules.Common.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactRodux = require(Modules.Common.RoactRodux)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local v10 = if not FFlagSignalsNavP3fGameDetails then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Functional = require(Modules.Common.Functional)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local AlertWindow = require(Modules.LuaApp.Components.AlertWindow)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local withLocalization = require(Modules.LuaApp.withLocalization)
local ThemeContext_DEPRECATED = require(Modules.LuaApp.ThemeContext_DEPRECATED)
local OpenPurchaseRobuxPage = require(Modules.LuaApp.Thunks.Economy.OpenPurchaseRobuxPage)
local GetFFlagLuaAppUseWithLocalization = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseWithLocalization)
local v22 = Roact.PureComponent:extend("PurchaseGameRobuxShortfallPrompt")

function v22.init(p1) -- line: 29
	function p1.buyRobux() -- line: 30
		-- upvalues: p1 (copy)
		p1.props.closePrompt()
		p1.props.openPurchaseRobuxPage(p1.props.networking)
	end
end
function v22.didMount(p2) -- line: 37
	-- upvalues: Functional (copy)
	local pageFilter = p2.props.pageFilter
	local currentPage = p2.props.currentPage
	local closePrompt = p2.props.closePrompt

	if pageFilter and not Functional.Find(pageFilter, currentPage) then
		closePrompt()
	end
end
function v22.render(p3) -- line: 47
	-- upvalues: Roact (copy), ThemeContext_DEPRECATED (copy), AlertWindow (copy), GetFFlagLuaAppUseWithLocalization (copy), withLocalization (copy)
	local theme = p3.props.theme
	local containerWidth = p3.props.containerWidth
	local robuxShortfall = p3.props.robuxShortfall
	local closePrompt = p3.props.closePrompt
	local localization = p3.props.localization
	local gameName = p3.props.gameName

	local function v37(p4) -- line: 55
		-- upvalues: Roact (copy), ThemeContext_DEPRECATED (copy), theme (copy), AlertWindow (copy), containerWidth (copy), p3 (copy), closePrompt (copy)
		return Roact.createElement(ThemeContext_DEPRECATED.Provider, {
			value = theme
		}, {
			AlertWindow = Roact.createElement(AlertWindow, {
				hasCancelButton = true,
				containerWidth = containerWidth,
				titleText = p4.titleText,
				titleFont = theme.GameDetails.Text.BoldFont,
				messageText = p4.messageText,
				messageFont = theme.GameDetails.Text.Font,
				buttonFont = theme.GameDetails.Text.Font,
				confirmButtonText = p4.confirmButtonText,
				onConfirm = p3.buyRobux,
				onCancel = closePrompt
			})
		})
	end

	if GetFFlagLuaAppUseWithLocalization() then
		return withLocalization({
			titleText = "Feature.GameDetails.Heading.PurchaseGame",
			confirmButtonText = "Feature.GameDetails.Action.BuyRobux",
			messageText = {
				"Feature.GameDetails.Message.BuyMoreRobuxToPurchaseGameV2",
				gameName = gameName,
				shortfallPrice = robuxShortfall
			}
		})(v37)
	end

	return v37({
		titleText = localization:Format("Feature.GameDetails.Heading.PurchaseGame"),
		messageText = localization:Format("Feature.GameDetails.Message.BuyMoreRobuxToPurchaseGameV2", {
			gameName = gameName,
			shortfallPrice = robuxShortfall
		}),
		confirmButtonText = localization:Format("Feature.GameDetails.Action.BuyRobux")
	})
end

local v23 = RoactRodux.connect(not FFlagSignalsNavP3fGameDetails and function(p5, _) -- line: 97
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v40 = if not FFlagUseNavigationSelectors then p5.Navigation.history[#p5.Navigation.history] else Selectors.selectCurrentLegacyRoute(p5)

	return {
		currentPage = v40[#v40].name
	}
end or nil, function(p7) -- line: 105
	-- upvalues: CloseCentralOverlay (copy), OpenPurchaseRobuxPage (copy)
	return {
		closePrompt = function() -- line: 107
			-- upvalues: p7 (copy), CloseCentralOverlay (copy)
			p7(CloseCentralOverlay())
		end,
		openPurchaseRobuxPage = function(p8) -- line: 110
			-- upvalues: p7 (copy), OpenPurchaseRobuxPage (copy)
			return p7(OpenPurchaseRobuxPage(nil, p8))
		end
	}
end)(v22)

if FFlagSignalsNavP3fGameDetails then
	local v24 = v23

	function v23(p9) -- line: 119
		-- upvalues: v10 (copy), useSignalState (copy), Roact (copy), v24 (copy), Cryo (copy)
		local v43 = v10(false)
		local v44 = useSignalState(v43.getCurrentPage)

		return Roact.createElement(v24, Cryo.Dictionary.union(p9, {
			currentPage = v44.name
		}))
	end
end

return (RoactServices.connect({
	localization = RoactLocalization,
	guiService = AppGuiService,
	networking = RoactNetworking
})(v23))
