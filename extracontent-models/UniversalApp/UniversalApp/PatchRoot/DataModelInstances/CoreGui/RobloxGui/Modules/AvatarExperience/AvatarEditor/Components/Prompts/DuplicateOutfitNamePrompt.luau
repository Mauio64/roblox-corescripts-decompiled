local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Focusable = RoactGamepad.Focusable
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local v18 = Roact.PureComponent:extend("DuplicateOutfitNamePrompt")
local FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation

v18.validateProps = t.strictInterface({
	outfitName = t.string,
	sourcePrompt = t.string,
	sourceParams = t.table,
	saveCallback = t.callback,
	saveFetchingStateKey = t.string,
	onOverlayClosed = t.optional(t.callback),
	defaultChildRef = t.optional(t.table),
	focusController = t.optional(t.table),
	navigation = t.table,
	screenSize = t.Vector2,
	fetchingState = t.string
})

function v18.init(p1) -- line: 63
	-- upvalues: NavigationUtils (copy)
	function p1.goBack() -- line: 64
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.navigateToNextOverlay(p1.props.navigation, p1.props.sourcePrompt, p1.props.sourceParams)
	end
end
function v18.willUpdate(p2, p3, _) -- line: 69
	-- upvalues: Utils (copy), NavigationUtils (copy)
	if Utils.isFetchingDoneOrFailed(p2.props.fetchingState, p3.fetchingState) then
		NavigationUtils.closeOverlay(p2.props.navigation)
	end
end
function v18.renderLocalized(p5, p6) -- line: 75
	-- upvalues: Roact (copy), Focusable (copy), FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation (copy), RoactGamepad (copy), InteractiveAlert (copy), ButtonType (copy), RetrievalStatus (copy)
	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		inputBindings = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p5.goBack),
			Confirm = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() -- line: 85
			end, {
				key = "CommonUI.Controls.Action.Confirm"
			})
		} else nil
	}, {
		Alert = Roact.createElement(InteractiveAlert, {
			title = p6.titleText,
			bodyText = p6.messageText,
			buttonStackInfo = {
				buttons = {
					{
						isDefaultChild = true,
						props = {
							onActivated = p5.goBack,
							text = p6.cancelButtonText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isLoading = p5.props.fetchingState == RetrievalStatus.Fetching,
							onActivated = p5.props.saveCallback,
							text = p6.confirmButtonText
						}
					}
				}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = p5.props.screenSize,
			defaultChildRef = p5.props.defaultChildRef
		})
	})
end
function v18.render(p7) -- line: 119
	-- upvalues: withLocalization (copy)
	return withLocalization({
		titleText = "Feature.Avatar.Heading.UsedName",
		messageText = "Feature.Avatar.Label.UsedNameLong",
		confirmButtonText = "Feature.Avatar.Action.Save",
		cancelButtonText = "Feature.Avatar.Label.Back"
	})(function(p8) -- line: 125
		-- upvalues: p7 (copy)
		return p7:renderLocalized(p8)
	end)
end

local function mapStateToProps(p9, p10) -- line: 130
	-- upvalues: PerformFetch (copy)
	return {
		screenSize = p9.ScreenSize,
		fetchingState = PerformFetch.GetStatus(p9, p10.saveFetchingStateKey)
	}
end

return (withMappedNavigationParams((withOverlayFocusHandling((RoactRodux.connect(mapStateToProps, nil)(v18))))))
