local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local RoactRodux = require(FriendsLandingParent.RoactRodux)
local RoactAppPolicy = require(FriendsLandingParent.UniversalAppPolicy).RoactAppPolicy
local NavigateDown = require(FriendsLandingParent.NavigationRodux).Thunks.NavigateDown
local AppPage = require(FriendsLandingParent.RobloxAppEnums).AppPage
local CoreGui = dependencies.CoreGui
local Roact = dependencies.Roact
local TextService = dependencies.TextService
local UIBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local Foundation = require(FriendsLandingParent.Foundation)
local Chip = Foundation.Chip
local Enums = Foundation.Enums
local View = Foundation.View
local FoundationText = Foundation.Text
local Images = UIBlox.App.ImageSet.Images
local ImpressionEvents = require(FriendsLanding.FriendsLandingAnalytics.ImpressionEvents)
local Pill = UIBlox.App.Control.Pill
local withStyle = UIBlox.Style.withStyle
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local filterStates = require(FriendsLanding.Friends.filterStates)
local PillWithAlert = require(FriendsLanding.Components.PillWithAlert)
local ChipFilterGroup = require(FriendsLanding.Components.ChipFilterGroup)
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local FFlagFixScalingOnFriendsLanding = require(FriendsLanding.Flags.FFlagFixScalingOnFriendsLanding)
local FFlagConnectionManagementChips = require(FriendsLandingParent.SharedFlags).FFlagConnectionManagementChips
local FFlagSignalsNavP3Dispatch = require(FriendsLandingParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v32 = if not FFlagSignalsNavP3Dispatch then nil else require(FriendsLandingParent.RobloxAppNavigation).NavigationCommands
local FFlagConnectionsToFriendsRename = require(FriendsLandingParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagFriendsPageUserListEnabled = require(FriendsLandingParent.SharedFlags).FFlagFriendsPageUserListEnabled
local v35 = Roact.PureComponent:extend("FilterByButton")

v35.defaultProps = {
	analytics = nil,
	layoutOrder = 1,
	friendCount = 0,
	inactiveFriendCount = 0,
	isDisabled = false,
	showFriendPruningAlert = false,
	initialShowFriendPruningTooltip = false,
	onActivated = function() -- line: 55
	end,
	filter = filterStates.All,
	onTooltipDismissal = function() -- line: 62
	end
}

function v35.init(p1) -- line: 65
	-- upvalues: FFlagConnectionManagementChips (copy), filterStates (copy), AppPage (copy), FFlagConnectionsToFriendsRename (copy)
	p1.state = {
		hasDismissedFriendPruningTooltip = false,
		showFriendPruningTooltip = p1.props.initialShowFriendPruningTooltip
	}

	if FFlagConnectionManagementChips then
		p1.state.canAccessTrustedContacts = p1.props.canAccessTrustedContacts
	end

	function p1.convertFilterToTranslation(p2, p3) -- line: 75
		-- upvalues: filterStates (copy), FFlagConnectionManagementChips (copy)
		if p2 == filterStates.All then
			return p3.all
		end

		if p2 == filterStates.Online then
			return p3.online
		end

		if p2 == filterStates.InExperience then
			return p3.inExperience
		end

		if p2 == filterStates.Offline then
			return p3.offline
		end

		if p2 == filterStates.Inactive then
			return p3.inactive
		end

		if FFlagConnectionManagementChips and p2 == filterStates.Trusted then
			return p3.trusted
		end

		return nil
	end
	function p1.buildFilterText(p4, p5, p6) -- line: 93
		-- upvalues: p1 (copy)
		local v50 = p1.convertFilterToTranslation(p4, p5)

		if p6 == 0 then
			return v50
		end

		return v50 .. " (" .. p6 .. ")"
	end
	function p1.isSelected(p7) -- line: 102
		-- upvalues: filterStates (copy)
		if p7 == filterStates.All then
			return false
		end

		return true
	end
	function p1.dismissFriendPruningTooltip() -- line: 110
		-- upvalues: p1 (copy)
		p1:setState({
			showFriendPruningTooltip = false,
			hasDismissedFriendPruningTooltip = true
		})
		p1.props.onTooltipDismissal()
	end

	if FFlagConnectionManagementChips then
		function p1.onLearnMoreClicked() -- line: 119
			-- upvalues: p1 (copy), AppPage (copy)
			p1.props.navigateDown({
				detail = "https://en.help.roblox.com/hc/articles/46158344285204",
				name = AppPage.GenericWebPage,
				extraProps = {
					title = ""
				}
			})
		end
	end

	if FFlagConnectionManagementChips then
		function p1.getTrustedFilterText(p8) -- line: 129
			-- upvalues: FFlagConnectionsToFriendsRename (copy), p1 (copy)
			if FFlagConnectionsToFriendsRename then
				if p1.props.canAccessTrustedContacts then
					return p8.doMoreWithTrustedFriends
				end

				return p8.trustedFriendsUnavailable
			end

			if p1.props.canAccessTrustedContacts then
				return p8.doMoreWithTrustedConnections
			end

			return p8.trustedConnectionsUnavailable
		end
	end
end
function v35.didMount(p9) -- line: 142
	-- upvalues: ImpressionEvents (copy)
	if p9.props.initialShowFriendPruningTooltip and p9.props.analytics then
		p9.props.analytics:impressionEvent(ImpressionEvents.FriendPruningTooltipSeen, {
			friendCount = tostring(p9.props.friendCount),
			inactiveFriendCount = tostring(p9.props.inactiveFriendCount)
		})
	end
end
function v35.didUpdate(p10) -- line: 153
	p10:setState({
		showFriendPruningTooltip = p10.props.initialShowFriendPruningTooltip and not p10.state.hasDismissedFriendPruningTooltip
	})
end
function v35.render(p11) -- line: 161
	-- upvalues: withStyle (copy), FFlagFixScalingOnFriendsLanding (copy), Images (copy), FFlagConnectionManagementChips (copy), withLocalization (copy), TooltipOrientation (copy), CoreGui (copy), Roact (copy), withTooltip (copy), getIconSize (copy), IconSize (copy), TextService (copy), PillWithAlert (copy), Pill (copy), View (copy), FFlagFriendsPageUserListEnabled (copy), ChipFilterGroup (copy), filterStates (copy), FoundationText (copy), Chip (copy), Enums (copy)
	return withStyle(function(_) -- line: 162
		-- upvalues: FFlagFixScalingOnFriendsLanding (copy), Images (copy), FFlagConnectionManagementChips (copy), withLocalization (copy), p11 (copy), TooltipOrientation (copy), CoreGui (copy), Roact (copy), withStyle (copy), withTooltip (copy), getIconSize (copy), IconSize (copy), TextService (copy), PillWithAlert (copy), Pill (copy), View (copy), FFlagFriendsPageUserListEnabled (copy), ChipFilterGroup (copy), filterStates (copy), FoundationText (copy), Chip (copy), Enums (copy)
		local v54 = if not FFlagFixScalingOnFriendsLanding then Images["icons/actions/filter"] else "icons/actions/filter_small"
		local t1 = {
			all = "Feature.Friends.Label.All",
			inactive = "Feature.Friends.Label.FewestInteractions",
			inExperience = "Feature.Friends.Label.InGame",
			tooltipHeader = "Feature.Friends.Label.ManageFriendsList",
			tooltipBody = "Feature.Friends.Label.ManageFriendsListCaption",
			online = "Common.Presence.Label.Online",
			offline = "Common.Presence.Label.Offline"
		}

		if FFlagConnectionManagementChips then
			t1.trusted = "Feature.Friends.TrustedConnection.Label.Trusted"
			t1.learnMore = "Feature.Chat.Action.LearnMore"
			t1.doMoreWithTrustedConnections = "Feature.Friends.Description.DoMoreWithTrustedConnections"
			t1.doMoreWithTrustedFriends = "Feature.Friends.Description.DoMoreWithTrustedFriends"
			t1.trustedConnectionsUnavailable = "Feature.Friends.Description.TrustedConnectionsUnavailable"
			t1.trustedFriendsUnavailable = "Feature.Friends.Description.TrustedFriendsUnavailable"
		end

		return withLocalization(t1)(function(p13) -- line: 183
			-- upvalues: p11 (copy), FFlagConnectionManagementChips (copy), TooltipOrientation (copy), CoreGui (copy), Roact (copy), withStyle (copy), withTooltip (copy), getIconSize (copy), IconSize (copy), TextService (copy), PillWithAlert (copy), v54 (copy), Pill (copy), View (copy), FFlagFriendsPageUserListEnabled (copy), ChipFilterGroup (copy), filterStates (copy), FoundationText (copy), FFlagFixScalingOnFriendsLanding (copy), Chip (copy), Enums (copy)
			local filter = p11.props.filter
			local friendCount = p11.props.friendCount
			local isDisabled = p11.props.isDisabled
			local onActivated = p11.props.onActivated
			local v62 = p11.buildFilterText(filter, p13, friendCount)
			local maxWidth = nil
			local webViewSupported = nil

			if FFlagConnectionManagementChips then
				maxWidth = p11.props.maxWidth
				webViewSupported = p11.props.webViewSupported
			end

			local t2 = {
				headerText = p13.tooltipHeader,
				bodyText = p13.tooltipBody
			}
			local t3 = {
				active = true,
				DisplayOrder = 2,
				preferredOrientation = TooltipOrientation.Bottom,
				guiTarget = CoreGui
			}

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 36),
				LayoutOrder = p11.props.layoutOrder
			}, {
				Button = if not p11.state.showFriendPruningTooltip then if not p11.props.showFriendPruningAlert then if not FFlagConnectionManagementChips then if not FFlagFixScalingOnFriendsLanding then Roact.createElement(Pill, {
					icon = v54,
					text = v62,
					isDisabled = isDisabled,
					isSelected = p11.isSelected(filter),
					onActivated = onActivated
				}) else Roact.createElement(Chip, {
					leading = {
						name = v54,
						iconName = Enums.IconName.ThreeBarsHorizontalNarrowing,
						position = Enums.IconPosition.Left
					},
					text = v62,
					isChecked = p11.isSelected(filter),
					onActivated = onActivated,
					isDisabled = isDisabled
				}) else Roact.createElement(View, {
					tag = not FFlagFriendsPageUserListEnabled and "auto-y size-full-0 flex-between gap-large padding-top-large padding-bottom-large" or "auto-y size-full-0 flex-between gap-large padding-top-large"
				}, {
					UISizeConstraint = if not maxWidth then nil else Roact.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(maxWidth, 1e999)
					}),
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					FilterGroup = Roact.createElement(ChipFilterGroup, {
						LayoutOrder = 1,
						onActivated = onActivated,
						isDisabled = isDisabled
					}),
					EducationText = if filter ~= filterStates.Trusted then nil else Roact.createElement(View, {
						tag = "auto-y size-full-0",
						LayoutOrder = 2
					}, {
						Layout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						Content = Roact.createElement(FoundationText, {
							LayoutOrder = 1,
							tag = "auto-y size-full-0 text-caption-medium text-align-x-left text-align-y-top text-wrap",
							Text = p11.getTrustedFilterText(p13)
						}),
						LearnMore = if not webViewSupported or not p11.props.canAccessTrustedContacts then nil else Roact.createElement(View, {
							LayoutOrder = 2,
							tag = "auto-y size-full-0 padding-top-xsmall"
						}, {
							Text = Roact.createElement(FoundationText, {
								tag = "auto-xy text-caption-medium text-align-x-left text-align-y-top",
								RichText = true,
								Text = `<u>{ p13.learnMore }</u>`,
								onActivated = p11.onLearnMoreClicked
							})
						})
					})
				}) else Roact.createElement(PillWithAlert, {
					icon = v54,
					text = v62,
					isDisabled = isDisabled,
					isSelected = p11.isSelected(filter),
					onActivated = onActivated
				}) else withStyle(function(p14) -- line: 213
					-- upvalues: withTooltip (copy), t2 (copy), t3 (copy), getIconSize (copy), IconSize (copy), TextService (copy), v62 (copy), Roact (copy), p11 (copy), CoreGui (copy), PillWithAlert (copy), v54 (copy), isDisabled (copy), filter (copy), onActivated (copy), Pill (copy)
					return withTooltip(t2, t3, function(p15) -- line: 214
						-- upvalues: p14 (copy), getIconSize (copy), IconSize (copy), TextService (copy), v62 (copy), Roact (copy), p11 (copy), CoreGui (copy), PillWithAlert (copy), v54 (copy), isDisabled (copy), filter (copy), onActivated (copy), Pill (copy)
						local p14Font = p14.Font
						local v70 = getIconSize(IconSize.Small)
						local BaseSize = p14Font.BaseSize
						local v72 = p14Font.CaptionHeader.RelativeSize * BaseSize
						local v73 = TextService:GetTextSize(v62, v72, p14Font.CaptionHeader.Font, Vector2.new(10000, 10000)).X + 24

						return Roact.createElement("Frame", {
							Size = UDim2.fromOffset(v73 + 4 + v70, 28),
							LayoutOrder = p11.props.layoutOrder,
							BackgroundTransparency = 1,
							[Roact.Change.AbsoluteSize] = p15,
							[Roact.Change.AbsolutePosition] = p15
						}, {
							PortalToCoreGui = Roact.createElement(Roact.Portal, {
								target = CoreGui
							}, {
								ScreenGui = Roact.createElement("ScreenGui", {
									DisplayOrder = 1,
									ZIndexBehavior = Enum.ZIndexBehavior.Sibling
								}, {
									DismissFriendPruningTooltipButton = Roact.createElement("TextButton", {
										ZIndex = 0,
										BackgroundTransparency = 1,
										Size = UDim2.fromScale(1, 1),
										Text = "",
										[Roact.Event.Activated] = p11.dismissFriendPruningTooltip,
										[Roact.Event.TouchSwipe] = p11.dismissFriendPruningTooltip,
										[Roact.Event.MouseWheelForward] = p11.dismissFriendPruningTooltip,
										[Roact.Event.MouseWheelBackward] = p11.dismissFriendPruningTooltip
									})
								})
							}),
							FilterByButtonPillPossiblyWithAlert = if not p11.props.showFriendPruningAlert then Roact.createElement(Pill, {
								icon = v54,
								text = v62,
								isDisabled = isDisabled,
								isSelected = p11.isSelected(filter),
								onActivated = onActivated
							}) else Roact.createElement(PillWithAlert, {
								icon = v54,
								text = v62,
								isDisabled = isDisabled,
								isSelected = p11.isSelected(filter),
								onActivated = onActivated
							})
						})
					end)
				end)
			})
		end)
	end)
end

if FFlagConnectionManagementChips then
	local v36 = RoactRodux.connect(function(_, _) -- line: 358
		return {}
	end, function(p18) -- line: 360
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v32 (copy), NavigateDown (copy)
		return {
			navigateDown = function(p19) -- line: 362
				-- upvalues: FFlagSignalsNavP3Dispatch (copy), v32 (copy), p18 (copy), NavigateDown (copy)
				if FFlagSignalsNavP3Dispatch then
					return v32.down(v32.fromLegacyPage(p19))
				end

				return p18(NavigateDown(p19))
			end
		}
	end)(v35)

	return RoactAppPolicy.connect(function(p20) -- line: 372
		return {
			webViewSupported = p20.getWebViewSupport()
		}
	end)(v36)
end

return v35
