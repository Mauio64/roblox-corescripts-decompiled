local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local uiBlox = dependencies.UIBlox
local roact = dependencies.Roact
local memoize = dependencies.memoize
local textService = dependencies.TextService
local withLocalization = dependencies.withLocalization

local partialPageModal = uiBlox.App.Dialog.Modal.PartialPageModal
local smallRadioButtonGroup = uiBlox.App.Cell.Small.SelectionGroup.SmallRadioButtonGroup
local buttonType = uiBlox.App.Button.Enum.ButtonType
local withStyle = uiBlox.Style.withStyle

local compose = dependencies.SocialLibraries.RoduxTools.compose

local FriendsLandingAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics")
local ButtonClickEvents = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/ButtonClickEvents")

local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")
local makeFilterButtons = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/makeFilterButtons")
local filterStates = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/filterStates")

local navigationParamKeys = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingFilter/navigationParamKeys")

local inputHandlers = dependencies.InputHandlers
local focusNavigationUtils = dependencies.FocusNavigationUtils
local focusNavigableSurfaceWrapper = focusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = focusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = focusNavigationUtils.FocusNavigationEventNameEnum

local extended = roact.PureComponent:extend("FriendsLandingFilter")

extended.defaultProps = { analytics = nil, navigation = nil }

function extended:init()
	self.state = { selectedValue = self.props.filter }

	function self.onClose()
		self.props.navigation.goBack()
	end

	self.focusEventHandlers = {
		[focusNavigationEventNameEnum.NavigateBack] = {
			handler = inputHandlers.onRelease(function(object2)
				self.onClose()
				object2:cancel()
			end)
		}
	}

	self.onApply = memoize(function(callback)
		return function()
			self.props.analytics:buttonClick(ButtonClickEvents.FriendFilterApply, {
				filter = self.state.selectedValue
			})

			callback(self.state.selectedValue)
			self.onClose()

			if self.state.selectedValue == filterStates.Inactive then
				self.onFewestInteractionsSelection()()
			end
		end
	end)

	function self.setSelectedValue(p2)
		self:setState({ selectedValue = p2 })
	end

	function self.onCurrentSelected(p2): boolean
		return p2 == self.state.selectedValue
	end

	function self.getAlertPlacement(p2, list, p3, p4)
		local v6 = 0
		local v7 = ""

		for i, item in ipairs(list) do
			if item.id == p2 then
				v7 = item.text
				v6 = i
				break
			end
		end

		assert(v6 ~= 0, "getAlertPlacement expects alertFilterId to have an entry in filterButtons")

		local v10 = 24 + textService:GetTextSize(
			v7,
			p4.Header2.RelativeSize * p4.BaseSize,
			p4.Header2.Font,
			Vector2.new(10000, 10000)
		).X + 12

		local v11 = (v6 - 1) * 57 + math.floor(28 - p3 / 2)

		return UDim2.fromOffset(v10, v11)
	end

	function self.showInactiveFilterOption()
		if self.props.navigation.getParam then
			return (self.props.navigation.getParam(navigationParamKeys.ShowInactiveFilterOption))
		end

		return nil
	end

	function self.onFewestInteractionsSelection()
		if self.props.navigation.getParam then
			return (self.props.navigation.getParam(navigationParamKeys.OnFewestInteractionsSelection))
		end

		return nil
	end
end

function extended.render(data)
	return withStyle(function(p2)
		return withLocalization({
			apply = "CommonUI.Messages.Action.Apply",
			all = "Feature.Friends.Label.All",
			inactive = "Feature.Friends.Label.FewestInteractions",
			inExperience = "Feature.Friends.Label.InGame",
			online = "Common.Presence.Label.Online",
			offline = "Common.Presence.Label.Offline",
			filterBy = "Feature.Friends.Heading.FilterBy",
			upsellNew = "Feature.Catalog.Label.New"
		})(function(p3)
			local v5 = makeFilterButtons(p3, data.showInactiveFilterOption())
			local element = roact.createElement(partialPageModal, {
				title = p3.filterBy,
				screenSize = data.props.screenSize,
				onCloseClicked = data.onClose,
				marginSize = 0,
				buttonStackProps = {
					buttons = {
						{
							buttonType = buttonType.PrimarySystem,
							props = {
								isDisabled = data.onCurrentSelected(data.props.filter),
								onActivated = data.onApply(data.props.setFilterKeys),
								text = p3.apply
							}
						}
					}
				}
			}, {
				ButtonContainer = roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, #v5 * 58 + 20),
					BackgroundTransparency = 1
				}, {
					RadioButtons = roact.createElement(smallRadioButtonGroup, {
						onActivated = data.setSelectedValue,
						selectedValue = data.state.selectedValue,
						items = v5
					})
				})
			})

			return (roact.createElement(
				focusNavigableSurfaceWrapper,
				{
					surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
					isIsolated = true,
					customEventHandlers = data.focusEventHandlers
				},
				{ Modal = element }
			))
		end)
	end)
end

return compose(FriendsLandingAnalytics.connect(function(p2)
	return { analytics = p2 }
end), FriendsLandingContext.connect(function(data, p2)
	return {
		filter = data.filter,
		screenSize = data.screenSize,
		setFilterKeys = data.setFilterKeys
	}
end))(extended)
