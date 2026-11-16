local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox

local react = dependencies.React

local button = uiBlox.App.Button.Button
local buttonType = uiBlox.App.Button.Enum.ButtonType
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/TextKeys")
local standardButtonSize = uiBlox.App.Button.Enum.StandardButtonSize

local smsProtocol = dependencies.SMSProtocol
local dash = dependencies.Dash
local useStyle = dependencies.useStyle
local useLocalization = dependencies.useLocalization

local getFFlagContactsListEntryUpdatedTruncationFix = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Flags/getFFlagContactsListEntryUpdatedTruncationFix")

local sendInviteLink = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/ContactsList/Components/ContactsListInviteEntry/sendInviteLink")

local v5 = { smsProtocol = smsProtocol.default }

function LUAUFORGE_MODULE_GLOBALS_ctY_ContactsListInviteEntry(p2)
	local joined = dash.join(v5, p2)

	local v6 = useLocalization({ invite = TextKeys.INVITE_BUTTON_TEXT })

	local v7 = useStyle()
	local v8 = sendInviteLink({
		address = joined.phoneNumber,
		deviceContactId = joined.deviceContactId,
		smsProtocol = smsProtocol.default
	})

	local state, setState = react.useState(0)

	local createElement = roact.createElement
	local v10 = {
		Name = joined.deviceContactId,
		Size = UDim2.new(1, 0, 0, 72),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local createElement2 = roact.createElement
	local v13 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v14 = {
		padding = roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 26),
			PaddingBottom = UDim.new(0, 26)
		}),
		contactNameLabel = 0,
		sendInviteButton = 0
	}
	local v15

	if getFFlagContactsListEntryUpdatedTruncationFix() then
		v15 = roact.createElement(styledTextLabel, {
			size = UDim2.new(1, state, 0, 20),
			colorStyle = v7.Theme.TextEmphasis,
			fontStyle = v7.Font.Header2,
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
		v15 = roact.createElement(styledTextLabel, {
			automaticSize = Enum.AutomaticSize.Y,
			colorStyle = v7.Theme.TextEmphasis,
			fontStyle = v7.Font.Header2,
			lineHeight = 1,
			text = joined.contactName,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Bottom
		})
	end

	v14.contactNameLabel = v15
	local v16

	if joined.hasSentRequest then
		v16 = roact.createElement(button, {
			buttonType = buttonType.Secondary,
			position = UDim2.new(1, -1, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5),
			standardSize = standardButtonSize.XSmall,
			isDisabled = true,
			text = v6.invite,
			onActivated = dash.noop,
			[react.Change.AbsoluteSize] = function(p3)
				if getFFlagContactsListEntryUpdatedTruncationFix() then
					setState(0 - (p3.AbsoluteSize.X + 10))
				end
			end
		})
	else
		v16 = roact.createElement(button, {
			buttonType = buttonType.PrimarySystem,
			position = UDim2.new(1, -1, 0.5, 0),
			anchorPoint = Vector2.new(1, 0.5),
			standardSize = standardButtonSize.XSmall,
			fitContent = true,
			text = v6.invite,
			isDisabled = v8.isLoading,
			onActivated = v8.sendInvite,
			[react.Change.AbsoluteSize] = function(p3)
				if getFFlagContactsListEntryUpdatedTruncationFix() then
					setState(0 - (p3.AbsoluteSize.X + 10))
				end
			end
		})
	end

	v14.sendInviteButton = v16
	local v11 = {
		entryContent = createElement2("Frame", v13, v14),
		divider = 0
	}

	local v17 = if joined.hasDivider then roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = v7.Theme.Divider.Color,
		BackgroundTransparency = v7.Theme.Divider.Transparency
	}) else nil
	v11.divider = v17
	return createElement("Frame", v10, v11)
end

return LUAUFORGE_MODULE_GLOBALS_ctY_ContactsListInviteEntry
