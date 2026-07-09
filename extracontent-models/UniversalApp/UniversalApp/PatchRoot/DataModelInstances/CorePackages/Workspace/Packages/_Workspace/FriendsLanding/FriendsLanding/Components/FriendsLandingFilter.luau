local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local UIBlox = dependencies.UIBlox
local Roact = dependencies.Roact
local memoize = dependencies.memoize
local TextService = dependencies.TextService
local withLocalization = dependencies.withLocalization
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local SmallRadioButtonGroup = UIBlox.App.Cell.Small.SelectionGroup.SmallRadioButtonGroup
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Style.withStyle
local compose = dependencies.SocialLibraries.RoduxTools.compose
local FriendsLandingAnalytics = require(FriendsLanding.FriendsLandingAnalytics)
local ButtonClickEvents = require(FriendsLanding.FriendsLandingAnalytics.ButtonClickEvents)
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local makeFilterButtons = require(FriendsLanding.Friends.makeFilterButtons)
local filterStates = require(FriendsLanding.Friends.filterStates)
local navigationParamKeys = require(script.navigationParamKeys)
local InputHandlers = dependencies.InputHandlers
local FocusNavigationUtils = dependencies.FocusNavigationUtils
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local v24 = Roact.PureComponent:extend("FriendsLandingFilter")

v24.defaultProps = {
	analytics = nil,
	navigation = nil
}

function v24.init(p1) -- line: 46
	-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), memoize (copy), ButtonClickEvents (copy), filterStates (copy), TextService (copy), navigationParamKeys (copy)
	p1.state = {
		selectedValue = p1.props.filter
	}

	function p1.onClose() -- line: 52
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()
	end

	p1.focusEventHandlers = {
		[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p2) -- line: 58
				-- upvalues: p1 (copy)
				p1.onClose()
				p2:cancel()
			end)
		}
	}
	p1.onApply = memoize(function(p3) -- line: 65
		-- upvalues: p1 (copy), ButtonClickEvents (copy), filterStates (copy)
		return function() -- line: 66
			-- upvalues: p1 (copy), ButtonClickEvents (copy), p3 (copy), filterStates (copy)
			p1.props.analytics:buttonClick(ButtonClickEvents.FriendFilterApply, {
				filter = p1.state.selectedValue
			})
			p3(p1.state.selectedValue)
			p1.onClose()

			if p1.state.selectedValue == filterStates.Inactive then
				p1.onFewestInteractionsSelection()()
			end
		end
	end)

	function p1.setSelectedValue(p4) -- line: 78
		-- upvalues: p1 (copy)
		p1:setState({
			selectedValue = p4
		})
	end
	function p1.onCurrentSelected(p5) -- line: 84
		-- upvalues: p1 (copy)
		return p5 == p1.state.selectedValue
	end
	function p1.getAlertPlacement(p6, p7, n1: number, p8) -- line: 88
		-- upvalues: TextService (copy)
		local n2 = 0
		local s1 = ""

		for i, v in ipairs(p7) do
			if p6 == v.id then
				n2 = i
				s1 = v.text

				break
			end
		end

		assert(n2 ~= 0, "getAlertPlacement expects alertFilterId to have an entry in filterButtons")

		local v42 = p8.Header2.RelativeSize * p8.BaseSize
		local v43 = 24 + TextService:GetTextSize(s1, v42, p8.Header2.Font, Vector2.new(10000, 10000)).X + 12
		local v44 = (n2 - 1) * 57 + math.floor(28 - n1 / 2)

		return UDim2.fromOffset(v43, v44)
	end
	function p1.showInactiveFilterOption() -- line: 119
		-- upvalues: p1 (copy), navigationParamKeys (copy)
		if p1.props.navigation.getParam then
			return (p1.props.navigation.getParam(navigationParamKeys.ShowInactiveFilterOption))
		end

		return nil
	end
	function p1.onFewestInteractionsSelection() -- line: 125
		-- upvalues: p1 (copy), navigationParamKeys (copy)
		if p1.props.navigation.getParam then
			return (p1.props.navigation.getParam(navigationParamKeys.OnFewestInteractionsSelection))
		end

		return nil
	end
end
function v24.render(p9) -- line: 132
	-- upvalues: withStyle (copy), withLocalization (copy), makeFilterButtons (copy), Roact (copy), PartialPageModal (copy), ButtonType (copy), SmallRadioButtonGroup (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	return withStyle(function(_) -- line: 133
		-- upvalues: withLocalization (copy), makeFilterButtons (copy), p9 (copy), Roact (copy), PartialPageModal (copy), ButtonType (copy), SmallRadioButtonGroup (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy)
		return withLocalization({
			apply = "CommonUI.Messages.Action.Apply",
			all = "Feature.Friends.Label.All",
			inactive = "Feature.Friends.Label.FewestInteractions",
			inExperience = "Feature.Friends.Label.InGame",
			online = "Common.Presence.Label.Online",
			offline = "Common.Presence.Label.Offline",
			filterBy = "Feature.Friends.Heading.FilterBy",
			upsellNew = "Feature.Catalog.Label.New"
		})(function(p11) -- line: 143
			-- upvalues: makeFilterButtons (copy), p9 (copy), Roact (copy), PartialPageModal (copy), ButtonType (copy), SmallRadioButtonGroup (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy)
			local v47 = makeFilterButtons(p11, p9.showInactiveFilterOption())
			local v48 = Roact.createElement(PartialPageModal, {
				marginSize = 0,
				title = p11.filterBy,
				screenSize = p9.props.screenSize,
				onCloseClicked = p9.onClose,
				buttonStackProps = {
					buttons = {{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isDisabled = p9.onCurrentSelected(p9.props.filter),
							onActivated = p9.onApply(p9.props.setFilterKeys),
							text = p11.apply
						}
					}}
				}
			}, {
				ButtonContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, #v47 * 58 + 20)
				}, {
					RadioButtons = Roact.createElement(SmallRadioButtonGroup, {
						onActivated = p9.setSelectedValue,
						selectedValue = p9.state.selectedValue,
						items = v47
					})
				})
			})

			return (Roact.createElement(FocusNavigableSurfaceWrapper, {
				isIsolated = true,
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
				customEventHandlers = p9.focusEventHandlers
			}, {
				Modal = v48
			}))
		end)
	end)
end

return compose(FriendsLandingAnalytics.connect(function(p12) -- line: 187
	return {
		analytics = p12
	}
end), FriendsLandingContext.connect(function(p13, _) -- line: 192
	return {
		filter = p13.filter,
		screenSize = p13.screenSize,
		setFilterKeys = p13.setFilterKeys
	}
end))(v24)
