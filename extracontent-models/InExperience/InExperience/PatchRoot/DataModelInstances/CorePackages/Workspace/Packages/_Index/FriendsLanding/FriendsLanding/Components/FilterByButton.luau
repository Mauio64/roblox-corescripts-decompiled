local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local RoactRodux = require(parent.RoactRodux)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local coreGui = dependencies.CoreGui
local roact = dependencies.Roact
local textService = dependencies.TextService
local uiBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local Foundation = require(parent.Foundation)
local Chip = Foundation.Chip
local Enums = Foundation.Enums
local View = Foundation.View
local Text = Foundation.Text

local images = uiBlox.App.ImageSet.Images
local ImpressionEvents = require(FriendsLanding.FriendsLandingAnalytics.ImpressionEvents)

local pill = uiBlox.App.Control.Pill
local withStyle = uiBlox.Style.withStyle
local withTooltip = uiBlox.App.Dialog.TooltipV2.withTooltip
local tooltipOrientation = uiBlox.App.Dialog.Enum.TooltipOrientation
local filterStates = require(FriendsLanding.Friends.filterStates)
local PillWithAlert = require(FriendsLanding.Components.PillWithAlert)
local ChipFilterGroup = require(FriendsLanding.Components.ChipFilterGroup)

local iconSize = uiBlox.App.ImageSet.Enum.IconSize
local getIconSize = uiBlox.App.ImageSet.getIconSize

local FFlagFixScalingOnFriendsLanding = require(FriendsLanding.Flags.FFlagFixScalingOnFriendsLanding)
local SharedFlags = require(parent.SharedFlags)
local FFlagConnectionManagementChips = SharedFlags.FFlagConnectionManagementChips
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local SharedFlags3 = require(parent.SharedFlags)
local FFlagFriendsPageUserListEnabled = SharedFlags3.FFlagFriendsPageUserListEnabled

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

	if FFlagConnectionManagementChips then
		self.state.canAccessTrustedContacts = self.props.canAccessTrustedContacts
	end

	function self.convertFilterToTranslation(p, data)
		if p == filterStates.All then
			return data.all
		end

		if p == filterStates.Online then
			return data.online
		end

		if p == filterStates.InExperience then
			return data.inExperience
		end

		if p == filterStates.Offline then
			return data.offline
		end

		if p == filterStates.Inactive then
			return data.inactive
		end

		if FFlagConnectionManagementChips and p == filterStates.Trusted then
			return data.trusted
		end

		return nil
	end

	function self.buildFilterText(p, p2, p3)
		local convertFilterToTranslation = self.convertFilterToTranslation(p, p2)

		if p3 == 0 then
			return convertFilterToTranslation
		end

		return convertFilterToTranslation .. " (" .. p3 .. ")"
	end

	function self.isSelected(p): boolean
		return p ~= filterStates.All
	end

	function self.dismissFriendPruningTooltip()
		self:setState({ showFriendPruningTooltip = false, hasDismissedFriendPruningTooltip = true })

		self.props.onTooltipDismissal()
	end

	if FFlagConnectionManagementChips then
		function self.onLearnMoreClicked()
			self.props.navigateDown({
				name = AppPage.GenericWebPage,
				detail = "https://en.help.roblox.com/hc/articles/46158344285204",
				extraProps = { title = "" }
			})
		end
	end

	if FFlagConnectionManagementChips then
		function self.getTrustedFilterText(p)
			if self.props.canAccessTrustedContacts then
				return p.doMoreWithTrustedFriends
			end

			return p.trustedFriendsUnavailable
		end
	end
end

function extended.didMount(p)
	if p.props.initialShowFriendPruningTooltip and p.props.analytics then
		p.props.analytics:impressionEvent(ImpressionEvents.FriendPruningTooltipSeen, {
			friendCount = tostring(p.props.friendCount),
			inactiveFriendCount = tostring(p.props.inactiveFriendCount)
		})
	end
end

function extended.didUpdate(object)
	object:setState({
		showFriendPruningTooltip = object.props.initialShowFriendPruningTooltip and not object.state.hasDismissedFriendPruningTooltip
	})
end

function extended.render(data)
	return withStyle(function(_)
		local v = FFlagFixScalingOnFriendsLanding and "icons/actions/filter_small" or images["icons/actions/filter"]
		local v2 = {
			all = "Feature.Friends.Label.All",
			inactive = "Feature.Friends.Label.FewestInteractions",
			inExperience = "Feature.Friends.Label.InGame",
			tooltipHeader = "Feature.Friends.Label.ManageFriendsList",
			tooltipBody = "Feature.Friends.Label.ManageFriendsListCaption",
			online = "Common.Presence.Label.Online",
			offline = "Common.Presence.Label.Offline"
		}

		if FFlagConnectionManagementChips then
			v2.trusted = "Feature.Friends.TrustedConnection.Label.Trusted"
			v2.learnMore = "Feature.Chat.Action.LearnMore"
			v2.doMoreWithTrustedFriends = "Feature.Friends.Description.DoMoreWithTrustedFriends"
			v2.trustedFriendsUnavailable = "Feature.Friends.Description.TrustedFriendsUnavailable"
		end

		return withLocalization(v2)(function(props)
			local filter = data.props.filter
			local friendCount = data.props.friendCount
			local isDisabled = data.props.isDisabled
			local onActivated = data.props.onActivated
			local filterText = data.buildFilterText(filter, props, friendCount)
			local maxWidth, webViewSupported

			if FFlagConnectionManagementChips then
				maxWidth = data.props.maxWidth
				webViewSupported = data.props.webViewSupported
			end

			local v3 = { headerText = props.tooltipHeader, bodyText = props.tooltipBody }

			local v4 = {
				preferredOrientation = tooltipOrientation.Bottom,
				guiTarget = coreGui,
				active = true,
				DisplayOrder = 2
			}

			local createElement = roact.createElement
			local v5 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 36),
				LayoutOrder = data.props.layoutOrder,
				BackgroundTransparency = 1
			}
			local button

			if data.state.showFriendPruningTooltip then
				button = withStyle(function(p)
					return withTooltip(v3, v4, function(p2)
						local font = p.Font

						local iconSize2 = getIconSize(iconSize.Small)
						local baseSize = font.BaseSize
						local v6 = textService:GetTextSize(
							filterText,
							font.CaptionHeader.RelativeSize * baseSize,
							font.CaptionHeader.Font,
							Vector2.new(10000, 10000)
						).X + 24

						local createElement2 = roact.createElement
						local v7 = {
							Size = UDim2.fromOffset(v6 + 4 + iconSize2, 28),
							LayoutOrder = data.props.layoutOrder,
							BackgroundTransparency = 1,
							[roact.Change.AbsoluteSize] = p2,
							[roact.Change.AbsolutePosition] = p2
						}
						local v8 = {
							PortalToCoreGui = roact.createElement(roact.Portal, { target = coreGui }, {
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
						local filterByButtonPillPossiblyWithAlert

						if data.props.showFriendPruningAlert then
							filterByButtonPillPossiblyWithAlert = roact.createElement(PillWithAlert, {
								icon = v,
								text = filterText,
								isDisabled = isDisabled,
								isSelected = data.isSelected(filter),
								onActivated = onActivated
							})
						else
							filterByButtonPillPossiblyWithAlert = roact.createElement(pill, {
								icon = v,
								text = filterText,
								isDisabled = isDisabled,
								isSelected = data.isSelected(filter),
								onActivated = onActivated
							})
						end

						v8.FilterByButtonPillPossiblyWithAlert = filterByButtonPillPossiblyWithAlert
						return createElement2("Frame", v7, v8)
					end)
				end)
			elseif data.props.showFriendPruningAlert then
				button = roact.createElement(PillWithAlert, {
					icon = v,
					text = filterText,
					isDisabled = isDisabled,
					isSelected = data.isSelected(filter),
					onActivated = onActivated
				})
			elseif FFlagConnectionManagementChips then
				local createElement2 = roact.createElement
				local uiSizeConstraint

				if maxWidth then
					uiSizeConstraint = roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(maxWidth, 1e999)
					})
				end

				local children = {
					UISizeConstraint = uiSizeConstraint,
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
				local educationText

				if filterStates.Trusted == filter then
					local createElement3 = roact.createElement

					local v6 = {
						Layout = roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						Content = roact.createElement(Text, {
							LayoutOrder = 1,
							tag = "auto-y size-full-0 text-caption-medium text-align-x-left text-align-y-top text-wrap",
							Text = data.getTrustedFilterText(props)
						}),
						LearnMore = 0
					}
					local learnMore

					if webViewSupported and data.props.canAccessTrustedContacts then
						learnMore = roact.createElement(
							View,
							{ LayoutOrder = 2, tag = "auto-y size-full-0 padding-top-xsmall" },
							{
								Text = roact.createElement(Text, {
									tag = "auto-xy text-caption-medium text-align-x-left text-align-y-top",
									RichText = true,
									Text = `<u>{props.learnMore}</u>`,
									onActivated = data.onLearnMoreClicked
								})
							}
						)
					end

					v6.LearnMore = learnMore
					educationText = createElement3(View, {
						tag = "auto-y size-full-0",
						LayoutOrder = 2
					}, v6)
				end

				children.EducationText = educationText
				button = createElement2(View, {
					tag = FFlagFriendsPageUserListEnabled and "auto-y size-full-0 flex-between gap-large padding-top-large" or "auto-y size-full-0 flex-between gap-large padding-top-large padding-bottom-large"
				}, children)
			elseif FFlagFixScalingOnFriendsLanding then
				button = roact.createElement(Chip, {
					leading = {
						name = v,
						iconName = Enums.IconName.ThreeBarsHorizontalNarrowing,
						position = Enums.IconPosition.Left
					},
					text = filterText,
					isChecked = data.isSelected(filter),
					onActivated = onActivated,
					isDisabled = isDisabled
				})
			else
				button = roact.createElement(pill, {
					icon = v,
					text = filterText,
					isDisabled = isDisabled,
					isSelected = data.isSelected(filter),
					onActivated = onActivated
				})
			end

			return createElement("Frame", v5, { Button = button })
		end)
	end)
end

if not FFlagConnectionManagementChips then
	return extended
end

local v = RoactRodux.connect(function(_, _)
	return {}
end, function(callback)
	return {
		navigateDown = function(p)
			if FFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p))
			end

			return callback(NavigateDown(p))
		end
	}
end)(extended)

return RoactAppPolicy.connect(function(p)
	return { webViewSupported = p.getWebViewSupport() }
end)(v)
