local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AlertWindow = require(Modules.LuaApp.Components.AlertWindow)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local withLocalization = require(Modules.LuaApp.withLocalization)
local withStyle = UIBlox.Style.withStyle
local t = require(CorePackages.Packages.t)
local v15 = Roact.PureComponent:extend("PurchasePassInsufficientRobux")

v15.validateProps = t.strictInterface({
	containerWidth = t.number,
	defaultChildRef = t.optional(t.any),
	focusController = t.optional(t.any),
	openPurchaseRobuxPage = t.callback,
	closePrompt = t.callback
})

function v15.init(p1) -- line: 32
	function p1.openPurchaseRobuxPage() -- line: 33
		-- upvalues: p1 (copy)
		p1.props.closePrompt()
		p1.props.openPurchaseRobuxPage()
	end
end
function v15.render(p2) -- line: 39
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), AlertWindow (copy)
	local containerWidth = p2.props.containerWidth
	local closePrompt = p2.props.closePrompt

	return withStyle(function(p3) -- line: 43
		-- upvalues: withLocalization (copy), Roact (copy), AlertWindow (copy), containerWidth (copy), p2 (copy), closePrompt (copy)
		return withLocalization({
			titleText = "Feature.Catalog.Heading.InsufficientFunds",
			messageText = "Feature.Catalog.Label.InsufficientFunds",
			confirmButtonText = "Feature.GameDetails.Action.BuyRobux"
		})(function(p4) -- line: 48
			-- upvalues: Roact (copy), AlertWindow (copy), containerWidth (copy), p3 (copy), p2 (copy), closePrompt (copy)
			return Roact.createElement(AlertWindow, {
				hasCancelButton = true,
				containerWidth = containerWidth,
				titleText = p4.titleText,
				titleFont = p3.Font.Header1.Font,
				messageText = p4.messageText,
				messageFont = p3.Font.Body.Font,
				buttonFont = p3.Font.Header2.Font,
				confirmButtonText = p4.confirmButtonText,
				onConfirm = p2.openPurchaseRobuxPage,
				onCancel = closePrompt
			})
		end)
	end)
end

return (RoactRodux.connect(nil, function(p5) -- line: 65
	-- upvalues: CloseCentralOverlay (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateDown (copy)
	return {
		closePrompt = function() -- line: 67
			-- upvalues: p5 (copy), CloseCentralOverlay (copy)
			p5(CloseCentralOverlay())
		end,
		openPurchaseRobuxPage = function() -- line: 70
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), p5 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.PurchaseRobux
			}

			if FFlagSignalsNavP3Dispatch then
				return v11.down(v11.fromLegacyPage(t1))
			end

			return p5(NavigateDown(t1))
		end
	}
end)(v15))
