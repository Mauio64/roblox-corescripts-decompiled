local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

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

local FriendsLandingAnalytics = require(FriendsLanding.FriendsLandingAnalytics)
local ButtonClickEvents = require(FriendsLanding.FriendsLandingAnalytics.ButtonClickEvents)

local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local makeFilterButtons = require(FriendsLanding.Friends.makeFilterButtons)
local filterStates = require(FriendsLanding.Friends.filterStates)

local navigationParamKeys = require(script.navigationParamKeys)

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
			handler = inputHandlers.onRelease(function(object)
				self.onClose()
				object:cancel()
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

	function self.setSelectedValue(selectedValue)
		self:setState({ selectedValue = selectedValue })
	end

	function self.onCurrentSelected(p): boolean
		return p == self.state.selectedValue
	end

	function self.getAlertPlacement(p, list, p2: number, p3)
		local v = 0
		local v2 = ""

		for i, item in ipairs(list) do
			if item.id == p then
				v2 = item.text
				v = i
				break
			end
		end

		assert(v ~= 0, "getAlertPlacement expects alertFilterId to have an entry in filterButtons")

		local v3 = 24 + textService:GetTextSize(
			v2,
			p3.Header2.RelativeSize * p3.BaseSize,
			p3.Header2.Font,
			Vector2.new(10000, 10000)
		).X + 12

		local v4 = (v - 1) * 57 + math.floor(28 - p2 / 2)

		return UDim2.fromOffset(v3, v4)
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
	return withStyle(function(_)
		return withLocalization({
			apply = "CommonUI.Messages.Action.Apply",
			all = "Feature.Friends.Label.All",
			inactive = "Feature.Friends.Label.FewestInteractions",
			inExperience = "Feature.Friends.Label.InGame",
			online = "Common.Presence.Label.Online",
			offline = "Common.Presence.Label.Offline",
			filterBy = "Feature.Friends.Heading.FilterBy",
			upsellNew = "Feature.Catalog.Label.New"
		})(function(p)
			local filterButtons = makeFilterButtons(p, data.showInactiveFilterOption())
			local element = roact.createElement(partialPageModal, {
				title = p.filterBy,
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
								text = p.apply
							}
						}
					}
				}
			}, {
				ButtonContainer = roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, #filterButtons * 58 + 20),
					BackgroundTransparency = 1
				}, {
					RadioButtons = roact.createElement(smallRadioButtonGroup, {
						onActivated = data.setSelectedValue,
						selectedValue = data.state.selectedValue,
						items = filterButtons
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

return compose(FriendsLandingAnalytics.connect(function(analytics)
	return { analytics = analytics }
end), FriendsLandingContext.connect(function(data, _)
	return {
		filter = data.filter,
		screenSize = data.screenSize,
		setFilterKeys = data.setFilterKeys
	}
end))(extended)
