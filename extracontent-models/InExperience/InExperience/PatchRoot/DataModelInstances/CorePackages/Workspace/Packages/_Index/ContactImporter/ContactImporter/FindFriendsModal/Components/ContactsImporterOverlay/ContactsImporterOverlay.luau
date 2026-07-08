local ParentParent = script.Parent.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local t = dependencies.t
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local withLocalization = dependencies.withLocalization
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local withStyle = UIBlox.Style.withStyle
local TextKeys = require(ParentParent.Common.TextKeys)
local Dash = dependencies.Dash
local v16 = Roact.PureComponent:extend("ContactsImporterOverlay")

v16.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	onCloseClicked = Dash.isCallable,
	onConnectContacts = Dash.isCallable,
	onLearnMoreClick = Dash.isCallable,
	onAddFriendsActivated = Dash.isCallable,
	isFromAddFriendsPage = t.boolean,
	isFromSignup = t.optional(t.boolean)
})

function v16.render(p1) -- line: 48
	-- upvalues: withLocalization (copy), TextKeys (copy), withStyle (copy), ButtonType (copy), Roact (copy), PartialPageModal (copy), ImageSetLabel (copy), Images (copy), IconSize (copy), StyledTextLabel (copy)
	return withLocalization({
		connectWithFriends = TextKeys.CONTACTS_LIST_TITLE,
		connectWithFriendsBody = TextKeys.CONNECT_CONTACTS_BODY,
		connectWithFriendsCaption = TextKeys.CONNECT_CONTACTS_CAPTION,
		getStarted = TextKeys.GET_STARTED,
		closeModal = TextKeys.CLOSE_MODAL,
		goToAddFriends = TextKeys.NOT_NOW,
		learnMore = TextKeys.LEARN_MORE
	})(function(p2) -- line: 57
		-- upvalues: withStyle (copy), p1 (copy), ButtonType (copy), Roact (copy), PartialPageModal (copy), ImageSetLabel (copy), Images (copy), IconSize (copy), StyledTextLabel (copy)
		return withStyle(function(p3) -- line: 58
			-- upvalues: p1 (copy), ButtonType (copy), p2 (copy), Roact (copy), PartialPageModal (copy), ImageSetLabel (copy), Images (copy), IconSize (copy), StyledTextLabel (copy)
			local Theme = p3.Theme
			local p3Font = p3.Font
			local props = p1.props
			local t1 = {}

			if props.isFromAddFriendsPage or props.isFromSignup then
				table.insert(t1, {
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = props.onCloseClicked,
						text = p2.goToAddFriends
					}
				})
			else
				table.insert(t1, {
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = props.onAddFriendsActivated,
						text = p2.goToAddFriends
					}
				})
			end

			table.insert(t1, {
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = props.onConnectContacts,
					text = p2.getStarted
				}
			})

			return Roact.createElement(PartialPageModal, {
				title = p2.connectWithFriends,
				screenSize = props.screenSize,
				onCloseClicked = props.onCloseClicked,
				buttonStackProps = {
					buttonHeight = 48,
					marginBetween = 6,
					buttons = t1,
					forcedFillDirection = Enum.FillDirection.Vertical
				}
			}, {
				ViewContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 12),
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					UIPadding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 24),
						PaddingBottom = UDim.new(0, 36)
					}),
					IconContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(120, 132)
					}, {
						Icon = Roact.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							AnchorPoint = Vector2.new(0.5, 0.5),
							ImageTransparency = Theme.IconEmphasis.Transparency,
							Image = Images["icons/graphic/connectcontacts_xlarge"],
							Size = UDim2.fromOffset(IconSize.XLarge, IconSize.XLarge),
							Position = UDim2.fromScale(0.5, 0.5)
						})
					}),
					Header = Roact.createElement(StyledTextLabel, {
						layoutOrder = 2,
						text = p2.connectWithFriendsBody,
						fontStyle = p3Font.Body,
						colorStyle = Theme.TextEmphasis,
						size = UDim2.fromScale(1, 0),
						automaticSize = Enum.AutomaticSize.Y,
						textTruncate = Enum.TextTruncate.AtEnd,
						textXAlignment = Enum.TextXAlignment.Center,
						textYAlignment = Enum.TextYAlignment.Top
					}),
					Description = Roact.createElement(StyledTextLabel, {
						layoutOrder = 3,
						text = p2.connectWithFriendsCaption,
						fontStyle = p3Font.CaptionBody,
						colorStyle = Theme.TextDefault,
						size = UDim2.fromScale(1, 0),
						automaticSize = Enum.AutomaticSize.Y,
						textTruncate = Enum.TextTruncate.AtEnd,
						textXAlignment = Enum.TextXAlignment.Center,
						textYAlignment = Enum.TextYAlignment.Top
					}),
					LearnMore = Roact.createElement("TextButton", {
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Font = p3.Font.CaptionBody.Font,
						Size = UDim2.fromScale(1, 0),
						Text = p2.learnMore,
						TextColor3 = Theme.TextEmphasis.Color,
						TextSize = p3Font.CaptionBody.RelativeSize * p3Font.BaseSize,
						TextTransparency = Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Top,
						LayoutOrder = 4,
						[Roact.Event.Activated] = props.onLearnMoreClick
					})
				})
			})
		end)
	end)
end

return v16
