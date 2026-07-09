local VerifiedBadges = script:FindFirstAncestor("VerifiedBadges")
local VerifiedBadgesParent = VerifiedBadges.Parent
local React = require(VerifiedBadgesParent.React)
local UIBlox = require(VerifiedBadgesParent.UIBlox)
local useSelector = require(VerifiedBadgesParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(VerifiedBadgesParent.Localization).Hooks.useLocalization
local constants = require(VerifiedBadges.constants)
local uDim = UDim.new(0, 24)
local uDim2 = UDim.new(0, 12)

local function selectScreenSize(p1) -- line: 20
	return p1.ScreenSize
end
local function AboutVerifiedBadgeModal(t1: {[any]: any}) -- line: 24
	-- upvalues: UIBlox (copy), useSelector (copy), selectScreenSize (copy), useLocalization (copy), React (copy), uDim (copy), uDim2 (copy), constants (copy)
	local v14 = UIBlox.Core.Style.useStyle()
	local v15 = useSelector(selectScreenSize)
	local v16 = useLocalization({
		titleText = "Feature.ProfileBadges.VerifiedBadgeInfoTitle",
		bodyText = "Feature.ProfileBadges.VerifiedBadgeInfo",
		learnMoreText = "Feature.ProfileBadges.VerifiedBadgeInfoLink"
	})
	local v17 = React.useCallback(function() -- line: 34
		-- upvalues: t1 (copy)
		if t1.onClose then
			t1.onClose()
		end
	end, { t1 })
	local v18 = React.useCallback(function() -- line: 40
		-- upvalues: t1 (copy)
		if t1.onConfirm then
			t1.onConfirm()
		end
	end, { t1 })

	return React.createElement(UIBlox.App.Dialog.Modal.PartialPageModal, {
		title = v16.titleText,
		screenSize = v15,
		buttonStackProps = {
			buttons = {{
				buttonType = UIBlox.App.Button.Enum.ButtonType.PrimarySystem,
				props = {
					onActivated = v18,
					text = v16.learnMoreText
				}
			}}
		},
		contentPadding = uDim,
		onCloseClicked = v17
	}, {
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = uDim2
			}),
			Padding = React.createElement("UIPadding", {
				PaddingTop = uDim2,
				PaddingBottom = uDim2
			}),
			Icon = React.createElement(UIBlox.App.Text.StyledTextLabel, {
				layoutOrder = 1,
				fluidSizing = false,
				text = constants.VERIFIED_EMOJI,
				fontStyle = v14.Font.Title,
				colorStyle = v14.Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.XY
			}),
			Body = React.createElement(UIBlox.App.Text.StyledTextLabel, {
				layoutOrder = 2,
				fluidSizing = false,
				text = v16.bodyText,
				fontStyle = v14.Font.Body,
				colorStyle = v14.Theme.TextMuted,
				size = UDim2.fromScale(1, 0),
				automaticSize = Enum.AutomaticSize.Y
			})
		})
	})
end

return AboutVerifiedBadgeModal
