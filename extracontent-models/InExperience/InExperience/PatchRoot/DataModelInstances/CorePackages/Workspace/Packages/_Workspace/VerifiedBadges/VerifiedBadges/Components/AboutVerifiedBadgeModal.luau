local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")

local parent = VerifiedBadges.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local constants = require(VerifiedBadges.constants)

local udim = UDim.new(0, 24)
local udim2 = UDim.new(0, 12)

local function selectScreenSize(p)
	return p.ScreenSize
end

local function AboutVerifiedBadgeModal(p)
	local v = UIBlox.Core.Style.useStyle()
	local screenSize = useSelector(selectScreenSize)

	local v2 = useLocalization({
		titleText = "Feature.ProfileBadges.VerifiedBadgeInfoTitle",
		bodyText = "Feature.ProfileBadges.VerifiedBadgeInfo",
		learnMoreText = "Feature.ProfileBadges.VerifiedBadgeInfoLink"
	})

	local onCloseClicked = React.useCallback(function()
		if p.onClose then
			p.onClose()
		end
	end, { p })

	local onActivated = React.useCallback(function()
		if p.onConfirm then
			p.onConfirm()
		end
	end, { p })

	return React.createElement(UIBlox.App.Dialog.Modal.PartialPageModal, {
		title = v2.titleText,
		screenSize = screenSize,
		buttonStackProps = {
			buttons = {
				{
					buttonType = UIBlox.App.Button.Enum.ButtonType.PrimarySystem,
					props = { onActivated = onActivated, text = v2.learnMoreText }
				}
			}
		},
		contentPadding = udim,
		onCloseClicked = onCloseClicked
	}, {
		Wrapper = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = udim2
				}),
				Padding = React.createElement("UIPadding", {
					PaddingTop = udim2,
					PaddingBottom = udim2
				}),
				Icon = React.createElement(UIBlox.App.Text.StyledTextLabel, {
					layoutOrder = 1,
					text = constants.VERIFIED_EMOJI,
					fontStyle = v.Font.Title,
					colorStyle = v.Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.XY,
					fluidSizing = false
				}),
				Body = React.createElement(UIBlox.App.Text.StyledTextLabel, {
					layoutOrder = 2,
					text = v2.bodyText,
					fontStyle = v.Font.Body,
					colorStyle = v.Theme.TextMuted,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					fluidSizing = false
				})
			}
		)
	})
end

return AboutVerifiedBadgeModal
