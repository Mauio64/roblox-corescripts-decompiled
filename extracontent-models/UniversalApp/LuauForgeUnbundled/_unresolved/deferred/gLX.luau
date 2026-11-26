local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local t = require(CorePackages.Packages.t)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module = require("@luauforge/bundled/dXh")

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization
require("@luauforge/bundled/dKT")

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local focusable = RoactGamepad.Focusable

local module2 = require("@luauforge/deferred/gJI")

local module3 = require("@luauforge/deferred/gJH")

local module4 = require("@luauforge/bundled/fCe")

local extended = Roact.PureComponent:extend("DuplicateOutfitNamePrompt")

local fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation

extended.validateProps = t.strictInterface({
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

function extended:init()
	function self.goBack()
		module.navigateToNextOverlay(
			self.props.navigation,
			self.props.sourcePrompt,
			self.props.sourceParams
		)
	end
end

function extended.willUpdate(p2, p3, p4)
	if module4.isFetchingDoneOrFailed(p2.props.fetchingState, p3.fetchingState) then
		module.closeOverlay(p2.props.navigation)
	end
end

function extended:renderLocalized(props)
	return Roact.createElement(focusable.Frame, {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		inputBindings = not fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, self.goBack),
			Confirm = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonA, function() end, {
				key = "CommonUI.Controls.Action.Confirm"
			})
		} or nil
	}, {
		Alert = Roact.createElement(interactiveAlert, {
			title = props.titleText,
			bodyText = props.messageText,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = self.goBack,
							text = props.cancelButtonText
						},
						isDefaultChild = true
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							isLoading = self.props.fetchingState == retrievalStatus.Fetching,
							onActivated = self.props.saveCallback,
							text = props.confirmButtonText
						}
					}
				}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = self.props.screenSize,
			defaultChildRef = self.props.defaultChildRef
		})
	})
end

function extended:render()
	return withLocalization({
		titleText = "Feature.Avatar.Heading.UsedName",
		messageText = "Feature.Avatar.Label.UsedNameLong",
		confirmButtonText = "Feature.Avatar.Action.Save",
		cancelButtonText = "Feature.Avatar.Label.Back"
	})(function(p2)
		return self:renderLocalized(p2)
	end)
end

local function mapStateToProps(p2, p3)
	return {
		screenSize = p2.ScreenSize,
		fetchingState = performFetch.GetStatus(p2, p3.saveFetchingStateKey)
	}
end

return (module3((module2((RoactRodux.connect(mapStateToProps, nil)(extended))))))
