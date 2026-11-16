local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RoactRodux")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/UniversalAppPolicy").RoactAppPolicy
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/NavigationRodux").Thunks.NavigateDown
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppEnums").AppPage

local coreGui = dependencies.CoreGui
local roact = dependencies.Roact
local textService = dependencies.TextService
local uiBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Foundation")
local chip = Foundation.Chip
local enums = Foundation.Enums
local view = Foundation.View
local text = Foundation.Text

local images = uiBlox.App.ImageSet.Images
local ImpressionEvents = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/ImpressionEvents")

local pill = uiBlox.App.Control.Pill
local withStyle = uiBlox.Style.withStyle
local withTooltip = uiBlox.App.Dialog.TooltipV2.withTooltip
local tooltipOrientation = uiBlox.App.Dialog.Enum.TooltipOrientation
local filterStates = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/filterStates")
local PillWithAlert = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/PillWithAlert")
local ChipFilterGroup = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/ChipFilterGroup")

local iconSize = uiBlox.App.ImageSet.Enum.IconSize
local getIconSize = uiBlox.App.ImageSet.getIconSize

local FFlagFixScalingOnFriendsLanding = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Flags/FFlagFixScalingOnFriendsLanding")
local fFlagConnectionManagementChips = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagConnectionManagementChips
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppNavigation").NavigationCommands else nil

local fFlagFriendsPageUserListEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagFriendsPageUserListEnabled

local extended = roact.PureComponent:extend("FilterByButton")

extended.defaultProps = {
	analytics = nil,
	layoutOrder = 1,
	onActivated = function() end,
	filter = filterStates.All,
	friendCount = 0,
	inactiveFriendCount = 0,
	isDisabled = false,
	showFriendPruningAlert = false,
	initialShowFriendPruningTooltip = false,
	onTooltipDismissal = function() end
}

function extended:init()
	self.state = {
		showFriendPruningTooltip = self.props.initialShowFriendPruningTooltip,
		hasDismissedFriendPruningTooltip = false
	}

	if fFlagConnectionManagementChips then
		self.state.canAccessTrustedContacts = self.props.canAccessTrustedContacts
	end

	function self.convertFilterToTranslation(p2, data)
		if p2 == filterStates.All then
			return data.all
		end

		if p2 == filterStates.Online then
			return data.online
		end

		if p2 == filterStates.InExperience then
			return data.inExperience
		end

		if p2 == filterStates.Offline then
			return data.offline
		end

		if p2 == filterStates.Inactive then
			return data.inactive
		end

		if fFlagConnectionManagementChips and p2 == filterStates.Trusted then
			return data.trusted
		end

		return nil
	end

	function self.buildFilterText(p2, p3, p4)
		local convertFilterToTranslation = self.convertFilterToTranslation(p2, p3)

		if p4 == 0 then
			return convertFilterToTranslation
		end

		return convertFilterToTranslation .. " (" .. p4 .. ")"
	end

	function self.isSelected(p2): boolean
		return p2 ~= filterStates.All
	end

	function self.dismissFriendPruningTooltip()
		self:setState({
			showFriendPruningTooltip = false,
			hasDismissedFriendPruningTooltip = true
		})

		self.props.onTooltipDismissal()
	end

	if fFlagConnectionManagementChips then
		function self.onLearnMoreClicked()
			self.props.navigateDown({
				name = appPage.GenericWebPage,
				detail = "https://en.help.roblox.com/hc/articles/46158344285204",
				extraProps = { title = "" }
			})
		end
	end

	if fFlagConnectionManagementChips then
		function self.getTrustedFilterText(p2)
			if self.props.canAccessTrustedContacts then
				return p2.doMoreWithTrustedFriends
			end

			return p2.trustedFriendsUnavailable
		end
	end
end

function extended.didMount(p2)
	if p2.props.initialShowFriendPruningTooltip and p2.props.analytics then
		p2.props.analytics:impressionEvent(ImpressionEvents.FriendPruningTooltipSeen, {
			friendCount = tostring(p2.props.friendCount),
			inactiveFriendCount = tostring(p2.props.inactiveFriendCount)
		})
	end
end

function extended.didUpdate(object)
	object:setState({
		showFriendPruningTooltip = object.props.initialShowFriendPruningTooltip and not object.state.hasDismissedFriendPruningTooltip
	})
end

function extended.render(data)
	return withStyle(function(p2)
		local v5 = FFlagFixScalingOnFriendsLanding and "icons/actions/filter_small" or images["icons/actions/filter"]
		local v6 = {
			all = "Feature.Friends.Label.All",
			inactive = "Feature.Friends.Label.FewestInteractions",
			inExperience = "Feature.Friends.Label.InGame",
			tooltipHeader = "Feature.Friends.Label.ManageFriendsList",
			tooltipBody = "Feature.Friends.Label.ManageFriendsListCaption",
			online = "Common.Presence.Label.Online",
			offline = "Common.Presence.Label.Offline"
		}

		if fFlagConnectionManagementChips then
			v6.trusted = "Feature.Friends.TrustedConnection.Label.Trusted"
			v6.learnMore = "Feature.Chat.Action.LearnMore"
			v6.doMoreWithTrustedFriends = "Feature.Friends.Description.DoMoreWithTrustedFriends"
			v6.trustedFriendsUnavailable = "Feature.Friends.Description.TrustedFriendsUnavailable"
		end

		return withLocalization(v6)(function(props)
			local filter = data.props.filter
			local friendCount = data.props.friendCount
			local isDisabled = data.props.isDisabled
			local onActivated = data.props.onActivated
			local filterText = data.buildFilterText(filter, props, friendCount)
			local maxWidth, webViewSupported

			if fFlagConnectionManagementChips then
				maxWidth = data.props.maxWidth
				webViewSupported = data.props.webViewSupported
			end

			local v7 = {
				headerText = props.tooltipHeader,
				bodyText = props.tooltipBody
			}

			local v8 = {
				preferredOrientation = tooltipOrientation.Bottom,
				guiTarget = coreGui,
				active = true,
				DisplayOrder = 2
			}

			local createElement = roact.createElement
			local v10 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 36),
				LayoutOrder = data.props.layoutOrder,
				BackgroundTransparency = 1
			}
			local v12

			if data.state.showFriendPruningTooltip then
				v12 = withStyle(function(p3)
					return withTooltip(v7, v8, function(p4)
						local font = p3.Font

						local iconSize2 = getIconSize(iconSize.Small)
						local baseSize = font.BaseSize
						local v14 = textService:GetTextSize(
							filterText,
							font.CaptionHeader.RelativeSize * baseSize,
							font.CaptionHeader.Font,
							Vector2.new(10000, 10000)
						).X + 24

						local createElement2 = roact.createElement
						local v16 = {
							Size = UDim2.fromOffset(v14 + 4 + iconSize2, 28),
							LayoutOrder = data.props.layoutOrder,
							BackgroundTransparency = 1,
							[roact.Change.AbsoluteSize] = p4,
							[roact.Change.AbsolutePosition] = p4
						}
						local v17 = {
							PortalToCoreGui = roact.createElement(roact.Portal, {
								target = coreGui
							}, {
								ScreenGui = roact.createElement(
									"ScreenGui",
									{
										ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
										DisplayOrder = 1
									},
									{
										DismissFriendPruningTooltipButton = roact.createElement("TextButton", {
											ZIndex = 0,
											BackgroundTransparency = 1,
											Size = UDim2.fromScale(1, 1),
											Text = "",
											[roact.Event.Activated] = data.dismissFriendPruningTooltip,
											[roact.Event.TouchSwipe] = data.dismissFriendPruningTooltip,
											[roact.Event.MouseWheelForward] = data.dismissFriendPruningTooltip,
											[roact.Event.MouseWheelBackward] = data.dismissFriendPruningTooltip
										})
									}
								)
							}),
							FilterByButtonPillPossiblyWithAlert = 0
						}

						local v22 = if data.props.showFriendPruningAlert then roact.createElement(PillWithAlert, {
							icon = v5,
							text = filterText,
							isDisabled = isDisabled,
							isSelected = data.isSelected(filter),
							onActivated = onActivated
						}) else roact.createElement(pill, {
							icon = v5,
							text = filterText,
							isDisabled = isDisabled,
							isSelected = data.isSelected(filter),
							onActivated = onActivated
						})
						v17.FilterByButtonPillPossiblyWithAlert = v22
						return createElement2("Frame", v16, v17)
					end)
				end)
			elseif data.props.showFriendPruningAlert then
				v12 = roact.createElement(PillWithAlert, {
					icon = v5,
					text = filterText,
					isDisabled = isDisabled,
					isSelected = data.isSelected(filter),
					onActivated = onActivated
				})
			elseif fFlagConnectionManagementChips then
				local createElement2 = roact.createElement

				local v15 = if maxWidth then roact.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(maxWidth, 1e999)
				}) else nil
				local children = {
					UISizeConstraint = v15,
					Layout = roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					FilterGroup = roact.createElement(ChipFilterGroup, {
						onActivated = onActivated,
						isDisabled = isDisabled,
						LayoutOrder = 1
					}),
					EducationText = 0
				}
				local v16

				if filterStates.Trusted == filter then
					local createElement3 = roact.createElement

					local v19 = {
						Layout = roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						Content = roact.createElement(text, {
							LayoutOrder = 1,
							tag = "auto-y size-full-0 text-caption-medium text-align-x-left text-align-y-top text-wrap",
							Text = data.getTrustedFilterText(props)
						}),
						LearnMore = 0
					}

					local v20 = if webViewSupported and data.props.canAccessTrustedContacts then roact.createElement(
						view,
						{
							LayoutOrder = 2,
							tag = "auto-y size-full-0 padding-top-xsmall"
						},
						{
							Text = roact.createElement(text, {
								tag = "auto-xy text-caption-medium text-align-x-left text-align-y-top",
								RichText = true,
								Text = `<u>{props.learnMore}</u>`,
								onActivated = data.onLearnMoreClicked
							})
						}
					) else nil
					v19.LearnMore = v20
					v16 = createElement3(view, {
						tag = "auto-y size-full-0",
						LayoutOrder = 2
					}, v19)
				end

				children.EducationText = v16
				v12 = createElement2(view, {
					tag = fFlagFriendsPageUserListEnabled and "auto-y size-full-0 flex-between gap-large padding-top-large" or "auto-y size-full-0 flex-between gap-large padding-top-large padding-bottom-large"
				}, children)
			elseif FFlagFixScalingOnFriendsLanding then
				v12 = roact.createElement(chip, {
					leading = {
						name = v5,
						iconName = enums.IconName.ThreeBarsHorizontalNarrowing,
						position = enums.IconPosition.Left
					},
					text = filterText,
					isChecked = data.isSelected(filter),
					onActivated = onActivated,
					isDisabled = isDisabled
				})
			else
				v12 = roact.createElement(pill, {
					icon = v5,
					text = filterText,
					isDisabled = isDisabled,
					isSelected = data.isSelected(filter),
					onActivated = onActivated
				})
			end

			return createElement("Frame", v10, { Button = v12 })
		end)
	end)
end

if not fFlagConnectionManagementChips then
	return extended
end

local v5 = RoactRodux.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(navigateDown(p2))
		end
	}
end)(extended)

return roactAppPolicy.connect(function(p2)
	return { webViewSupported = p2.getWebViewSupport() }
end)(v5)
