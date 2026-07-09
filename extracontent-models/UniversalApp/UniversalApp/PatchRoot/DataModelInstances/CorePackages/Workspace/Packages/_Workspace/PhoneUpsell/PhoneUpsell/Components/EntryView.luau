local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local React = require(PhoneUpsellParent.React)
local UIBlox = require(PhoneUpsellParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(PhoneUpsellParent.Localization).Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local mergeProps = require(PhoneUpsell.Utils.mergeProps)

local function noOp() -- line: 31
end

local t1 = {
	isButtonDisabled = false,
	isExtraButtonDisabled = false,
	onClose = noOp,
	onExtraButtonClick = noOp
}

local function getButtonStackProps(s1: string, p1: ((...any) -> ...any), b1: boolean, s2: string, p2: ((...any) -> ...any), b2: boolean) -- line: 40
	-- upvalues: ButtonType (copy)
	local t2 = {{
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = p1,
			text = s1,
			isDisabled = b1
		}
	}}

	if s2 and s2 ~= "" then
		table.insert(t2, 1, {
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = p2,
				text = s2,
				isDisabled = b2
			}
		})
	end

	return {
		buttonHeight = 48,
		forcedFillDirection = Enum.FillDirection.Vertical,
		buttons = t2
	}
end
local function EntryView(t3: {[any]: any}) -- line: 76
	-- upvalues: mergeProps (copy), t1 (copy), getPartialPageModalMiddleContentWidth (copy), useStyle (copy), useLocalization (copy), React (copy), PartialPageModal (copy), getButtonStackProps (copy)
	local v23 = mergeProps(t1, t3)
	local v24 = getPartialPageModalMiddleContentWidth(v23.screenSize.X)
	local t4 = {
		titleKey = v23.titleKey,
		descriptionKey = v23.descriptionKey,
		buttonKey = v23.buttonKey
	}

	if v23.extraButtonKey and v23.extraButtonKey ~= "" then
		t4.extraButtonKey = v23.extraButtonKey
	end

	local v26 = useStyle()

	useLocalization(t4)

	local t5 = {
		titleKey = "Before you leave",
		descriptionKey = "This experience would be even more exciting with Voice Chat turned on. Unlock now before your next session.",
		buttonKey = "Unlock voice chat",
		extraButtonKey = "Leave experience"
	}
	local BaseSize = v26.Font.BaseSize

	return React.createElement(PartialPageModal, {
		title = t5.titleKey,
		screenSize = v23.screenSize,
		buttonStackProps = getButtonStackProps(t5.buttonKey, v23.onButtonClick, v23.isButtonDisabled, t5.extraButtonKey, v23.onExtraButtonClick, v23.isExtraButtonDisabled),
		onCloseClicked = v23.onClose
	}, {
		Middle = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			ContentPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 24)
			}),
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 6)
			}),
			BodyText = React.createElement("TextLabel", {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				TextWrapped = true,
				RichText = true,
				Text = t5.descriptionKey,
				TextSize = BaseSize,
				TextColor3 = v26.Theme.TextDefault.Color,
				TextTransparency = v26.Theme.TextDefault.Transparency,
				Font = v26.Font.Body.Font,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(0, v24, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			})
		})
	})
end

return EntryView
