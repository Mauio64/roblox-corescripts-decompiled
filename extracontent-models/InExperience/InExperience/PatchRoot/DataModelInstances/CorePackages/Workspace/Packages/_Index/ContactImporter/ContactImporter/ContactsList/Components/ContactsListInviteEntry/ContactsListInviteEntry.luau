local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox

local react = dependencies.React

local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local TextKeys = require(ContactImporter.Common.TextKeys)
local standardButtonSize = uiBlox.App.Button.Enum.StandardButtonSize

local smsProtocol = dependencies.SMSProtocol
local dash = dependencies.Dash
local useStyle = dependencies.useStyle
local useLocalization = dependencies.useLocalization

local getFFlagContactsListEntryUpdatedTruncationFix = require(ContactImporter.Flags.getFFlagContactsListEntryUpdatedTruncationFix)

local sendInviteLink = require(script.Parent.sendInviteLink)

local v = { smsProtocol = smsProtocol.default }

function ContactsListInviteEntry(p)
	local joined = dash.join(v, p)

	local v2 = useLocalization({ invite = TextKeys.INVITE_BUTTON_TEXT })

	local v3 = useStyle()
	local v4 = sendInviteLink({
		address = joined.phoneNumber,
		deviceContactId = joined.deviceContactId,
		smsProtocol = smsProtocol.default
	})

	local state, setState = react.useState(0)

	local createElement = roact.createElement
	local v5 = {
		Name = joined.deviceContactId,
		Size = UDim2.new(1, 0, 0, 72),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local createElement2 = roact.createElement
	local v6 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v8 = {
		padding = roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 26),
			PaddingBottom = UDim.new(0, 26)
		}),
		contactNameLabel = 0,
		sendInviteButton = 0
	}
	local contactNameLabel

	if getFFlagContactsListEntryUpdatedTruncationFix() then
		contactNameLabel = roact.createElement(styledTextLabel, {
			size = UDim2.new(1, state, 0, 20),
			colorStyle = v3.Theme.TextEmphasis,
			fontStyle = v3.Font.Header2,
			lineHeight = 1,
			text = joined.contactName,
			fluidSizing = false,
			richText = false,
			textWrapped = false,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Bottom,
			textTruncate = Enum.TextTruncate.AtEnd
		})
	else
		contactNameLabel = roact.createElement(styledTextLabel, {
			automaticSize = Enum.AutomaticSize.Y,
			colorStyle = v3.Theme.TextEmphasis,
			fontStyle = v3.Font.Header2,
			lineHeight = 1,
			text = joined.contactName,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Bottom
		})
	end

	v8.contactNameLabel = contactNameLabel
	local sendInviteButton

	if joined.hasSentRequest then
		sendInviteButton = roact.createElement(button, {
			buttonType = buttonType.Secondary,
			position = UDim2.new(1, -1, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5),
			standardSize = standardButtonSize.XSmall,
			isDisabled = true,
			text = v2.invite,
			onActivated = dash.noop,
			[react.Change.AbsoluteSize] = function(p2)
				if getFFlagContactsListEntryUpdatedTruncationFix() then
					setState(0 - (p2.AbsoluteSize.X + 10))
				end
			end
		})
	else
		sendInviteButton = roact.createElement(button, {
			buttonType = buttonType.PrimarySystem,
			position = UDim2.new(1, -1, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5),
			standardSize = standardButtonSize.XSmall,
			fitContent = true,
			text = v2.invite,
			isDisabled = v4.isLoading,
			onActivated = v4.sendInvite,
			[react.Change.AbsoluteSize] = function(p2)
				if getFFlagContactsListEntryUpdatedTruncationFix() then
					setState(0 - (p2.AbsoluteSize.X + 10))
				end
			end
		})
	end

	v8.sendInviteButton = sendInviteButton
	local v7 = {
		entryContent = createElement2("Frame", v6, v8),
		divider = 0
	}
	local divider

	if joined.hasDivider then
		divider = roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = v3.Theme.Divider.Color,
			BackgroundTransparency = v3.Theme.Divider.Transparency
		})
	end

	v7.divider = divider
	return createElement("Frame", v5, v7)
end

return ContactsListInviteEntry
