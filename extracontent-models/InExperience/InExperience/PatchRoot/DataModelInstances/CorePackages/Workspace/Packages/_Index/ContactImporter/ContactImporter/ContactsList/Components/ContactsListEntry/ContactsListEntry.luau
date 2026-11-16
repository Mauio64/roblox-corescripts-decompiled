local ContactImporter = script:FindFirstAncestor("ContactImporter")
local parent = ContactImporter.Parent
local dependencies = require(ContactImporter.dependencies)
local Constants = require(ContactImporter.Common.Constants)
local NavigationRodux = require(parent.NavigationRodux)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local roactRodux = dependencies.RoactRodux

local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType
local images = uiBlox.App.ImageSet.Images
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local withStyle = uiBlox.Style.withStyle
local loadableImage = uiBlox.App.Loading.LoadableImage

local getFFlagContactsListEntryUpdatedTruncationFix = require(ContactImporter.Flags.getFFlagContactsListEntryUpdatedTruncationFix)

local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local extended = roact.PureComponent:extend("ContactsListEntry")

extended.defaultProps = { contextualInfo = "", contactName = "", hasDivider = false }

function extended:init()
	self:setState({ clicked = false, contactNameOffset = 0 })

	function self.addButtonSizeChanged(p)
		self:setState({
			contactNameOffset = 0 - (p.AbsoluteSize.X + 10)
		})
	end

	function self.requestContactFriendship()
		local props = self.props
		props.requestFriendship(props.contactId)
	end

	function self.openProfilePeekView()
		local props = self.props
		self.props.navigateToProfile({
			name = AppPage.ProfilePlatform,
			detail = props.contactId,
			extraProps = { profileType = Constants.CONTACT }
		})
	end
end

function extended.render(data)
	local props = data.props
	local v = not props.hasSentRequest

	return withStyle(function(p)
		local createElement = roact.createElement
		local v2 = {
			Name = props.deviceContactId,
			Size = UDim2.new(1, 0, 0, 72),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = data.props.layoutOrder
		}

		local createElement2 = roact.createElement
		local v3 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

		local children = {
			layout = roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 1)
			}),
			headshotThumbnailContainer = roact.createElement(
				"Frame",
				{ Size = UDim2.new(0, 64, 0, 64), LayoutOrder = 1, BackgroundTransparency = 1 },
				{ roact.createElement(
						"ImageButton",
						{
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							[roact.Event.Activated] = data.openProfilePeekView
						},
						{
							headshotThumbnailImage = roact.createElement(loadableImage, {
								Size = UDim2.new(0, 64, 0, 64),
								Image = props.headshotThumbnailUrl,
								onLoaded = function() end,
								BackgroundTransparency = 1,
								useShimmerAnimationWhileLoading = true,
								showFailedStateWhenLoadingFailed = true
							})
						}
					) }
			),
			headshotPadding = roact.createElement("Frame", {
				Size = UDim2.new(0, 12, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = 2
			}),
			middleTextGroup = 0,
			requestContactButton = 0
		}

		local createElement3 = roact.createElement
		local openProfilePeekViewsByActivated = {
			Size = UDim2.new(1, -123, 1, 0),
			Text = "",
			BackgroundTransparency = 1,
			[roact.Event.Activated] = data.openProfilePeekView,
			LayoutOrder = 3
		}

		local v5 = {
			layout = roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			contactNameLabel = 0
		}
		local contactNameLabel

		if getFFlagContactsListEntryUpdatedTruncationFix() then
			contactNameLabel = roact.createElement(styledTextLabel, {
				size = UDim2.new(1, data.state.contactNameOffset, 0, 20),
				colorStyle = p.Theme.TextEmphasis,
				fontStyle = p.Font.Header2,
				lineHeight = 1,
				text = props.contactName,
				fluidSizing = false,
				richText = false,
				textWrapped = false,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Bottom,
				textTruncate = Enum.TextTruncate.AtEnd,
				layoutOrder = 1
			})
		else
			contactNameLabel = roact.createElement(styledTextLabel, {
				automaticSize = Enum.AutomaticSize.Y,
				colorStyle = p.Theme.TextEmphasis,
				fontStyle = p.Font.Header2,
				lineHeight = 1,
				text = props.contactName,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Bottom,
				layoutOrder = 1
			})
		end

		v5.contactNameLabel = contactNameLabel
		children.middleTextGroup = createElement3("TextButton", openProfilePeekViewsByActivated, v5)
		local requestContactButton

		if v then
			local createElement4 = roact.createElement
			local v4 = {
				["buttonType"] = buttonType.PrimarySystem,
				icon = images["icons/actions/friends/friendAdd"],
				size = UDim2.fromOffset(44, 36),
				onActivated = data.requestContactFriendship,
				layoutOrder = 4
			}

			local absoluteSize = roact.Change.AbsoluteSize
			local v6

			if getFFlagContactsListEntryUpdatedTruncationFix() then
				v6 = data.addButtonSizeChanged
			end

			v4[absoluteSize] = v6
			requestContactButton = createElement4(button, v4)
		else
			local createElement4 = roact.createElement
			local v4 = {
				["buttonType"] = buttonType.Secondary,
				icon = images["icons/actions/friends/friendpending"],
				size = UDim2.fromOffset(44, 36),
				onActivated = function() end,
				isDisabled = true,
				layoutOrder = 4
			}

			local absoluteSize = roact.Change.AbsoluteSize
			local v6

			if getFFlagContactsListEntryUpdatedTruncationFix() then
				v6 = data.addButtonSizeChanged
			end

			v4[absoluteSize] = v6
			requestContactButton = createElement4(button, v4)
		end

		children.requestContactButton = requestContactButton
		local v4 = {
			entryContent = createElement2("Frame", v3, children),
			divider = 0
		}
		local divider

		if props.hasDivider then
			divider = roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = p.Theme.Divider.Color,
				BackgroundTransparency = p.Theme.Divider.Transparency
			})
		end

		v4.divider = divider
		return createElement("Frame", v2, v4)
	end)
end

local function mapDispatchToProps(callback)
	return {
		navigateToProfile = function(p)
			if FFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p))
			else
				callback(NavigateDown(p))
			end
		end
	}
end

return roactRodux.connect(nil, mapDispatchToProps)(extended)
