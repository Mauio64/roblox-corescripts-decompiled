local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/UIBlox")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/Localization").Hooks.useLocalization

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/VerifiedBadges/constants")

local udim = UDim.new(0, 24)
local udim2 = UDim.new(0, 12)

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function AboutVerifiedBadgeModal(p2)
	local v5 = UIBlox.Core.Style.useStyle()
	local v6 = useSelector(selectScreenSize)

	local v7 = useLocalization({
		titleText = "Feature.ProfileBadges.VerifiedBadgeInfoTitle",
		bodyText = "Feature.ProfileBadges.VerifiedBadgeInfo",
		learnMoreText = "Feature.ProfileBadges.VerifiedBadgeInfoLink"
	})

	local v8 = React.useCallback(function()
		if p2.onClose then
			p2.onClose()
		end
	end, { p2 })

	local v9 = React.useCallback(function()
		if p2.onConfirm then
			p2.onConfirm()
		end
	end, { p2 })

	return React.createElement(UIBlox.App.Dialog.Modal.PartialPageModal, {
		title = v7.titleText,
		screenSize = v6,
		buttonStackProps = {
			buttons = {
				{
					buttonType = UIBlox.App.Button.Enum.ButtonType.PrimarySystem,
					props = { onActivated = v9, text = v7.learnMoreText }
				}
			}
		},
		contentPadding = udim,
		onCloseClicked = v8
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
					fontStyle = v5.Font.Title,
					colorStyle = v5.Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.XY,
					fluidSizing = false
				}),
				Body = React.createElement(UIBlox.App.Text.StyledTextLabel, {
					layoutOrder = 2,
					text = v7.bodyText,
					fontStyle = v5.Font.Body,
					colorStyle = v5.Theme.TextMuted,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					fluidSizing = false
				})
			}
		)
	})
end

return AboutVerifiedBadgeModal
