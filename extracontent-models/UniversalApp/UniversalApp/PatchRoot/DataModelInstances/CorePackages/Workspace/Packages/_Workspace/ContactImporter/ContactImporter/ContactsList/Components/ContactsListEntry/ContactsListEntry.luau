local ContactImporter = script:FindFirstAncestor("ContactImporter")
local ContactImporterParent = ContactImporter.Parent
local dependencies = require(ContactImporter.dependencies)
local Constants = require(ContactImporter.Common.Constants)
local NavigationRodux = require(ContactImporterParent.NavigationRodux)
local AppPage = require(ContactImporterParent.RobloxAppEnums).AppPage
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local RoactRodux = dependencies.RoactRodux
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local withStyle = UIBlox.Style.withStyle
local LoadableImage = UIBlox.App.Loading.LoadableImage
local getFFlagContactsListEntryUpdatedTruncationFix = require(ContactImporter.Flags.getFFlagContactsListEntryUpdatedTruncationFix)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ContactImporterParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v19 = if not FFlagSignalsNavP3Dispatch then nil else require(ContactImporterParent.RobloxAppNavigation).NavigationCommands
local v20 = Roact.PureComponent:extend("ContactsListEntry")

v20.defaultProps = {
	contextualInfo = "",
	contactName = "",
	hasDivider = false
}

function v20.init(p1) -- line: 60
	-- upvalues: AppPage (copy), Constants (copy)
	p1:setState({
		clicked = false,
		contactNameOffset = 0
	})

	function p1.addButtonSizeChanged(p2) -- line: 66
		-- upvalues: p1 (copy)
		p1:setState({
			contactNameOffset = 0 - (p2.AbsoluteSize.X + 10)
		})
	end
	function p1.requestContactFriendship() -- line: 72
		-- upvalues: p1 (copy)
		local props = p1.props

		props.requestFriendship(props.contactId)
	end
	function p1.openProfilePeekView() -- line: 77
		-- upvalues: p1 (copy), AppPage (copy), Constants (copy)
		local props = p1.props

		p1.props.navigateToProfile({
			name = AppPage.ProfilePlatform,
			detail = props.contactId,
			extraProps = {
				profileType = Constants.CONTACT
			}
		})
	end
end
function v20.render(p3) -- line: 91
	-- upvalues: withStyle (copy), Roact (copy), LoadableImage (copy), getFFlagContactsListEntryUpdatedTruncationFix (copy), StyledTextLabel (copy), Button (copy), ButtonType (copy), Images (copy)
	local props = p3.props
	local v25 = not props.hasSentRequest

	return withStyle(function(p4) -- line: 95
		-- upvalues: Roact (copy), props (copy), p3 (copy), LoadableImage (copy), getFFlagContactsListEntryUpdatedTruncationFix (copy), StyledTextLabel (copy), v25 (copy), Button (copy), ButtonType (copy), Images (copy)
		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Name = props.deviceContactId,
			Size = UDim2.new(1, 0, 0, 72),
			LayoutOrder = p3.props.layoutOrder
		}, {
			entryContent = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 1)
				}),
				headshotThumbnailContainer = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 64, 0, 64)
				}, { Roact.createElement("ImageButton", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = p3.openProfilePeekView
				}, {
					headshotThumbnailImage = Roact.createElement(LoadableImage, {
						BackgroundTransparency = 1,
						useShimmerAnimationWhileLoading = true,
						showFailedStateWhenLoadingFailed = true,
						Size = UDim2.new(0, 64, 0, 64),
						Image = props.headshotThumbnailUrl,
						onLoaded = function() -- line: 126
						end
					})
				}) }),
				headshotPadding = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(0, 12, 1, 0)
				}),
				middleTextGroup = Roact.createElement("TextButton", {
					Size = UDim2.new(1, -123, 1, 0),
					Text = "",
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = p3.openProfilePeekView,
					LayoutOrder = 3
				}, {
					layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					contactNameLabel = if not getFFlagContactsListEntryUpdatedTruncationFix() then Roact.createElement(StyledTextLabel, {
						lineHeight = 1,
						layoutOrder = 1,
						automaticSize = Enum.AutomaticSize.Y,
						colorStyle = p4.Theme.TextEmphasis,
						fontStyle = p4.Font.Header2,
						text = props.contactName,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Bottom
					}) else Roact.createElement(StyledTextLabel, {
						lineHeight = 1,
						fluidSizing = false,
						richText = false,
						textWrapped = false,
						layoutOrder = 1,
						size = UDim2.new(1, p3.state.contactNameOffset, 0, 20),
						colorStyle = p4.Theme.TextEmphasis,
						fontStyle = p4.Font.Header2,
						text = props.contactName,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Bottom,
						textTruncate = Enum.TextTruncate.AtEnd
					})
				}),
				requestContactButton = if not v25 then Roact.createElement(Button, {
					buttonType = ButtonType.Secondary,
					icon = Images["icons/actions/friends/friendpending"],
					size = UDim2.fromOffset(44, 36),
					onActivated = function() -- line: 196
					end,
					isDisabled = true,
					layoutOrder = 4,
					[Roact.Change.AbsoluteSize] = if not getFFlagContactsListEntryUpdatedTruncationFix() then nil else p3.addButtonSizeChanged
				}) else Roact.createElement(Button, {
					buttonType = ButtonType.PrimarySystem,
					icon = Images["icons/actions/friends/friendAdd"],
					size = UDim2.fromOffset(44, 36),
					onActivated = p3.requestContactFriendship,
					layoutOrder = 4,
					[Roact.Change.AbsoluteSize] = if not getFFlagContactsListEntryUpdatedTruncationFix() then nil else p3.addButtonSizeChanged
				})
			}),
			divider = if not props.hasDivider then nil else Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = p4.Theme.Divider.Color,
				BackgroundTransparency = p4.Theme.Divider.Transparency
			})
		})
	end)
end

local function mapDispatchToProps(p5) -- line: 218
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateDown (copy)
	return {
		navigateToProfile = function(p6) -- line: 220
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v19 (copy), p5 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				v19.down(v19.fromLegacyPage(p6))

				return
			end

			p5(NavigateDown(p6))
		end
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(v20)
