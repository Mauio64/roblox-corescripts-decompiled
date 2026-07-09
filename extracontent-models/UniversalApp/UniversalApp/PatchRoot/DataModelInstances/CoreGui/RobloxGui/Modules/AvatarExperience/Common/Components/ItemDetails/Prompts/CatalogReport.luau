local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local t = require(CorePackages.Packages.t)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local v14 = Roact.PureComponent:extend("CatalogReport")

v14.validateProps = t.strictInterface({
	userId = t.string,
	itemId = t.string,
	itemCreatorId = t.string,
	itemName = t.string,
	itemDescription = t.string,
	screenSize = t.Vector2,
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	navigation = t.table,
	onOverlayClosed = t.optional(t.callback)
})

function v14.init(p1) -- line: 44
	-- upvalues: WebApi (copy), NavigationUtils (copy)
	function p1.sendReport() -- line: 45
		-- upvalues: p1 (copy), WebApi (copy)
		local userId = p1.props.userId
		local itemId = p1.props.itemId
		local itemCreatorId = p1.props.itemCreatorId
		local itemName = p1.props.itemName
		local itemDescription = p1.props.itemDescription

		WebApi.ReportItemV2(userId, itemId, itemCreatorId, itemName, itemDescription, "xbox-app", "xbox-catalog", "7", "Item reported from the Xbox App.")
		p1.closePrompt()
	end
	function p1.closePrompt() -- line: 66
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.closeOverlay(p1.props.navigation)
	end
end
function v14.render(p2) -- line: 71
	-- upvalues: withLocalization (copy), Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	return withLocalization({
		titleText = "Feature.Catalog.Label.ReportItem",
		messageText = "Feature.Catalog.Message.ReportCatalogItemPhrase",
		submitText = "Feature.Catalog.Action.Submit",
		cancelButtonText = "Feature.Catalog.Action.Cancel"
	})(function(p3) -- line: 77
		-- upvalues: Roact (copy), InteractiveAlert (copy), p2 (copy), ButtonType (copy)
		return Roact.createElement(InteractiveAlert, {
			title = p3.titleText,
			bodyText = p3.messageText,
			buttonStackInfo = {
				buttons = {
					{
						isDefaultChild = true,
						props = {
							onActivated = p2.closePrompt,
							text = p3.cancelButtonText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = p2.sendReport,
							text = p3.submitText
						}
					}
				}
			},
			screenSize = p2.props.screenSize,
			defaultChildRef = p2.props.defaultChildRef
		})
	end)
end

return (withMappedNavigationParams((withOverlayFocusHandling((RoactRodux.connect(function(p4, _) -- line: 105
	return {
		screenSize = p4.ScreenSize
	}
end)(v14))))))
