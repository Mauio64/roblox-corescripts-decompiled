local parent = script.Parent.Parent.Parent.Parent
local dependencies = require(parent.dependencies)

local t = dependencies.t
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization

local partialPageModal = uiBlox.App.Dialog.Modal.PartialPageModal
local buttonType = uiBlox.App.Button.Enum.ButtonType
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local images = uiBlox.App.ImageSet.Images
local iconSize = uiBlox.App.Constant.IconSize
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local withStyle = uiBlox.Style.withStyle
local TextKeys = require(parent.Common.TextKeys)
local dash = dependencies.Dash
local foundation = dependencies.Foundation
local normalizeFontFace = foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = dependencies.FFlagFontFaceSocialFriends
	and foundation.Utility.Flags.FoundationFontFaceMigration

local extended = roact.PureComponent:extend("ContactsImporterOverlay")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	onCloseClicked = dash.isCallable,
	onConnectContacts = dash.isCallable,
	onLearnMoreClick = dash.isCallable,
	onAddFriendsActivated = dash.isCallable,
	isFromAddFriendsPage = t.boolean,
	isFromSignup = t.optional(t.boolean)
})

function extended.render(p)
	return withLocalization({
		connectWithFriends = TextKeys.CONTACTS_LIST_TITLE,
		connectWithFriendsBody = TextKeys.CONNECT_CONTACTS_BODY,
		connectWithFriendsCaption = TextKeys.CONNECT_CONTACTS_CAPTION,
		getStarted = TextKeys.GET_STARTED,
		closeModal = TextKeys.CLOSE_MODAL,
		goToAddFriends = TextKeys.NOT_NOW,
		learnMore = TextKeys.LEARN_MORE
	})(function(data)
		return withStyle(function(props)
			local theme = props.Theme
			local font = props.Font
			local props2 = p.props

			local buttons = {}

			if props2.isFromAddFriendsPage or props2.isFromSignup then
				table.insert(buttons, {
					buttonType = buttonType.Secondary,
					props = { onActivated = props2.onCloseClicked, text = data.goToAddFriends }
				})
			else
				table.insert(buttons, {
					buttonType = buttonType.Secondary,
					props = {
						onActivated = props2.onAddFriendsActivated,
						text = data.goToAddFriends
					}
				})
			end

			table.insert(buttons, {
				buttonType = buttonType.PrimarySystem,
				props = { onActivated = props2.onConnectContacts, text = data.getStarted }
			})

			local createElement = roact.createElement
			local v = {
				title = data.connectWithFriends,
				screenSize = props2.screenSize,
				onCloseClicked = props2.onCloseClicked,
				buttonStackProps = {
					buttons = buttons,
					buttonHeight = 48,
					marginBetween = 6,
					forcedFillDirection = Enum.FillDirection.Vertical
				}
			}

			local createElement2 = roact.createElement
			local v2 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1
			}

			local v3 = {
				UIListLayout = roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12),
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				UIPadding = roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 36)
				}),
				IconContainer = roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.fromOffset(120, 132) },
					{
						Icon = roact.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							ImageTransparency = theme.IconEmphasis.Transparency,
							Image = images["icons/graphic/connectcontacts_xlarge"],
							Size = UDim2.fromOffset(iconSize.XLarge, iconSize.XLarge),
							Position = UDim2.fromScale(0.5, 0.5),
							LayoutOrder = 1
						})
					}
				),
				Header = roact.createElement(styledTextLabel, {
					text = data.connectWithFriendsBody,
					fontStyle = font.Body,
					colorStyle = theme.TextEmphasis,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Top,
					layoutOrder = 2
				}),
				Description = roact.createElement(styledTextLabel, {
					text = data.connectWithFriendsCaption,
					fontStyle = font.CaptionBody,
					colorStyle = theme.TextDefault,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Top,
					layoutOrder = 3
				}),
				LearnMore = 0
			}

			local createElement3 = roact.createElement
			local onLearnMoreClicksByActivated = {}
			onLearnMoreClicksByActivated.AutomaticSize = Enum.AutomaticSize.Y
			onLearnMoreClicksByActivated.BackgroundTransparency = 1
			local font2

			if not foundationFontFaceMigration then
				font2 = props.Font.CaptionBody.Font
			end

			onLearnMoreClicksByActivated.Font = font2
			local fontFace

			if foundationFontFaceMigration then
				fontFace = normalizeFontFace(props.Tokens.Typography.BodySmall.Font)
			end

			onLearnMoreClicksByActivated.FontFace = fontFace

			onLearnMoreClicksByActivated.Size = UDim2.fromScale(1, 0)
			onLearnMoreClicksByActivated.Text = data.learnMore
			onLearnMoreClicksByActivated.TextColor3 = theme.TextEmphasis.Color
			onLearnMoreClicksByActivated.TextSize = font.CaptionBody.RelativeSize * font.BaseSize
			onLearnMoreClicksByActivated.TextTransparency = theme.TextEmphasis.Transparency
			onLearnMoreClicksByActivated.TextXAlignment = Enum.TextXAlignment.Center
			onLearnMoreClicksByActivated.TextYAlignment = Enum.TextYAlignment.Top
			onLearnMoreClicksByActivated.LayoutOrder = 4

			onLearnMoreClicksByActivated[roact.Event.Activated] = props2.onLearnMoreClick
			v3.LearnMore = createElement3("TextButton", onLearnMoreClicksByActivated)
			return createElement(partialPageModal, v, {
				ViewContainer = createElement2("Frame", v2, v3)
			})
		end)
	end)
end

return extended
