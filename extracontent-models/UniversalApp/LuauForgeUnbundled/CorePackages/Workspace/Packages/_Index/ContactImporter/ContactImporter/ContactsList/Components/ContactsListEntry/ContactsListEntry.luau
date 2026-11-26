local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/NavigationRodux")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RobloxAppEnums").AppPage

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local roactRodux = dependencies.RoactRodux

local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType
local images = uiBlox.App.ImageSet.Images
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local withStyle = uiBlox.Style.withStyle
local loadableImage = uiBlox.App.Loading.LoadableImage

local getFFlagContactsListEntryUpdatedTruncationFix = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFFlagContactsListEntryUpdatedTruncationFix")

local navigateDown = NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RobloxAppNavigation").NavigationCommands else nil

local extended = roact.PureComponent:extend("ContactsListEntry")

extended.defaultProps = { contextualInfo = "", contactName = "", hasDivider = false }

function extended:init()
	self:setState({ clicked = false, contactNameOffset = 0 })

	function self.addButtonSizeChanged(p2)
		self:setState({
			contactNameOffset = 0 - (p2.AbsoluteSize.X + 10)
		})
	end

	function self.requestContactFriendship()
		local props = self.props
		props.requestFriendship(props.contactId)
	end

	function self.openProfilePeekView()
		local props = self.props
		self.props.navigateToProfile({
			name = appPage.ProfilePlatform,
			detail = props.contactId,
			extraProps = { profileType = Constants.CONTACT }
		})
	end
end

function extended.render(data)
	local props = data.props
	local v5 = not props.hasSentRequest

	return withStyle(function(p2)
		local createElement = roact.createElement
		local v7 = {
			Name = props.deviceContactId,
			Size = UDim2.new(1, 0, 0, 72),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = data.props.layoutOrder
		}

		local createElement2 = roact.createElement
		local v10 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

		local children = {
			layout = roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 1)
			}),
			headshotThumbnailContainer = roact.createElement(
				"Frame",
				{
					Size = UDim2.new(0, 64, 0, 64),
					LayoutOrder = 1,
					BackgroundTransparency = 1
				},
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

		local createElement5 = roact.createElement
		local openProfilePeekViewsByActivated2 = {
			Size = UDim2.new(1, -123, 1, 0),
			Text = "",
			BackgroundTransparency = 1,
			[roact.Event.Activated] = data.openProfilePeekView,
			LayoutOrder = 3
		}

		local v13 = {
			layout = roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			contactNameLabel = 0
		}
		local v14

		if getFFlagContactsListEntryUpdatedTruncationFix() then
			v14 = roact.createElement(styledTextLabel, {
				size = UDim2.new(1, data.state.contactNameOffset, 0, 20),
				colorStyle = p2.Theme.TextEmphasis,
				fontStyle = p2.Font.Header2,
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
			v14 = roact.createElement(styledTextLabel, {
				automaticSize = Enum.AutomaticSize.Y,
				colorStyle = p2.Theme.TextEmphasis,
				fontStyle = p2.Font.Header2,
				lineHeight = 1,
				text = props.contactName,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Bottom,
				layoutOrder = 1
			})
		end

		v13.contactNameLabel = v14
		children.middleTextGroup = createElement5("TextButton", openProfilePeekViewsByActivated2, v13)
		local v15

		if v5 then
			local createElement6 = roact.createElement
			local v17 = {
				["buttonType"] = buttonType.PrimarySystem,
				icon = images["icons/actions/friends/friendAdd"],
				size = UDim2.fromOffset(44, 36),
				onActivated = data.requestContactFriendship,
				layoutOrder = 4
			}

			local absoluteSize = roact.Change.AbsoluteSize
			local v18 = if getFFlagContactsListEntryUpdatedTruncationFix() then data.addButtonSizeChanged else nil
			v17[absoluteSize] = v18
			v15 = createElement6(button, v17)
		else
			local createElement6 = roact.createElement
			local v17 = {
				["buttonType"] = buttonType.Secondary,
				icon = images["icons/actions/friends/friendpending"],
				size = UDim2.fromOffset(44, 36),
				onActivated = function() end,
				isDisabled = true,
				layoutOrder = 4
			}

			local absoluteSize = roact.Change.AbsoluteSize
			local v18 = if getFFlagContactsListEntryUpdatedTruncationFix() then data.addButtonSizeChanged else nil
			v17[absoluteSize] = v18
			v15 = createElement6(button, v17)
		end

		children.requestContactButton = v15
		local v8 = {
			entryContent = createElement2("Frame", v10, children),
			divider = 0
		}

		local v16 = if props.hasDivider then roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = p2.Theme.Divider.Color,
			BackgroundTransparency = p2.Theme.Divider.Transparency
		}) else nil
		v8.divider = v16
		return createElement("Frame", v7, v8)
	end)
end

local function mapDispatchToProps(callback)
	return {
		navigateToProfile = function(p2)
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			else
				callback(navigateDown(p2))
			end
		end
	}
end

return roactRodux.connect(nil, mapDispatchToProps)(extended)
