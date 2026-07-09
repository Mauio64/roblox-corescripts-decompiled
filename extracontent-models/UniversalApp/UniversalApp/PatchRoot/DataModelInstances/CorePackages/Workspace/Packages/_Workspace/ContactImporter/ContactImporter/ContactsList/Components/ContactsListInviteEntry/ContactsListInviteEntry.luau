local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local React = dependencies.React
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local TextKeys = require(ContactImporter.Common.TextKeys)
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local SMSProtocol = dependencies.SMSProtocol
local Dash = dependencies.Dash
local useStyle = dependencies.useStyle
local useLocalization = dependencies.useLocalization
local getFFlagContactsListEntryUpdatedTruncationFix = require(ContactImporter.Flags.getFFlagContactsListEntryUpdatedTruncationFix)
local sendInviteLink = require(script.Parent.sendInviteLink)
local t1 = {
	smsProtocol = SMSProtocol.default
}

function ContactsListInviteEntry(t2: {[any]: any}) -- line: 42
	-- upvalues: Dash (copy), t1 (copy), useLocalization (copy), TextKeys (copy), useStyle (copy), sendInviteLink (copy), SMSProtocol (copy), React (copy), Roact (copy), getFFlagContactsListEntryUpdatedTruncationFix (copy), StyledTextLabel (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v19 = Dash.join(t1, t2)
	local v20 = useLocalization({
		invite = TextKeys.INVITE_BUTTON_TEXT
	})
	local v21 = useStyle()
	local v22 = sendInviteLink({
		address = v19.phoneNumber,
		deviceContactId = v19.deviceContactId,
		smsProtocol = SMSProtocol.default
	})
	local v23, v24 = React.useState(0)

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Name = v19.deviceContactId,
		Size = UDim2.new(1, 0, 0, 72)
	}, {
		entryContent = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 26),
				PaddingBottom = UDim.new(0, 26)
			}),
			contactNameLabel = if not getFFlagContactsListEntryUpdatedTruncationFix() then Roact.createElement(StyledTextLabel, {
				lineHeight = 1,
				automaticSize = Enum.AutomaticSize.Y,
				colorStyle = v21.Theme.TextEmphasis,
				fontStyle = v21.Font.Header2,
				text = v19.contactName,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Bottom
			}) else Roact.createElement(StyledTextLabel, {
				lineHeight = 1,
				fluidSizing = false,
				richText = false,
				textWrapped = false,
				size = UDim2.new(1, v23, 0, 20),
				colorStyle = v21.Theme.TextEmphasis,
				fontStyle = v21.Font.Header2,
				text = v19.contactName,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Bottom,
				textTruncate = Enum.TextTruncate.AtEnd
			}),
			sendInviteButton = if v19.hasSentRequest then Roact.createElement(Button, {
				buttonType = ButtonType.Secondary,
				position = UDim2.new(1, -1, 0.5, 0),
				anchorPoint = Vector2.new(1, 0.5),
				standardSize = StandardButtonSize.XSmall,
				isDisabled = true,
				text = v20.invite,
				onActivated = Dash.noop,
				[React.Change.AbsoluteSize] = function(p1) -- line: 122
					-- upvalues: getFFlagContactsListEntryUpdatedTruncationFix (copy), v24 (copy)
					if getFFlagContactsListEntryUpdatedTruncationFix() then
						v24(0 - (p1.AbsoluteSize.X + 10))
					end
				end
			}) else Roact.createElement(Button, {
				buttonType = ButtonType.PrimarySystem,
				position = UDim2.new(1, -1, 0.5, 0),
				anchorPoint = Vector2.new(1, 0.5),
				standardSize = StandardButtonSize.XSmall,
				fitContent = true,
				text = v20.invite,
				isDisabled = v22.isLoading,
				onActivated = v22.sendInvite,
				[React.Change.AbsoluteSize] = function(p2) -- line: 108
					-- upvalues: getFFlagContactsListEntryUpdatedTruncationFix (copy), v24 (copy)
					if getFFlagContactsListEntryUpdatedTruncationFix() then
						v24(0 - (p2.AbsoluteSize.X + 10))
					end
				end
			})
		}),
		divider = if not v19.hasDivider then nil else Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = v21.Theme.Divider.Color,
			BackgroundTransparency = v21.Theme.Divider.Transparency
		})
	})
end

return ContactsListInviteEntry
