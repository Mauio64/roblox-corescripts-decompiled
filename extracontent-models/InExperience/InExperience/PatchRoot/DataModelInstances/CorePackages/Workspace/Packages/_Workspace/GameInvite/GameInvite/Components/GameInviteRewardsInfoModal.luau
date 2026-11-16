local parent = script:FindFirstAncestor("GameInvite").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local LocalizationService = game:GetService("LocalizationService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local SharedFlags = require(parent.SharedFlags)
local GetFStringReferralRewardsTermsURL = SharedFlags.GetFStringReferralRewardsTermsURL
local defineFastFlag = game:DefineFastFlag("EnableRewardsWebViewOverlay", false)

local function fn(expiryUtc: string)
	if not expiryUtc or expiryUtc == "" then
		return ""
	end

	local dateTime = DateTime and DateTime.fromIsoDate(expiryUtc) or nil

	if not dateTime then
		return ""
	end

	local robloxLocaleId = LocalizationService.RobloxLocaleId
	return `{dateTime:FormatLocalTime("LL", robloxLocaleId)} {dateTime:FormatLocalTime("LT", robloxLocaleId)}`
end

local function fn2() -- 1 equivalent call inferred from this helper
	return workspace.CurrentCamera.ViewportSize
end

return function(props)
	return React.createElement(
		"ScreenGui",
		{ DisplayOrder = 100, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true },
		{
			RewardsInfoModalContainer = React.createElement(Foundation.View, {
				tag = "size-full-full bg-over-media-100",
				onActivated = function()
					if props.setModalOpen then
						props.setModalOpen(false)
					end
				end
			}, {
				RewardsInfoModal = React.createElement(PartialPageModal, {
					title = props.title,
					screenSize = fn2(), -- inferred equivalent call
					position = UDim2.new(0.5, 0, 0.5, 0),
					onCloseClicked = function()
						if props.setModalOpen then
							props.setModalOpen(false)
						end
					end
				}, {
					RewardsInfoModalContent = React.createElement(
						Foundation.View,
						{
							tag = "col size-full-0 auto-y gap-y-large padding-top-large",
							Size = UDim2.new(1, 0, 0, 180)
						},
						{
							RewardsInfoModalTitle = React.createElement(Foundation.Text, {
								tag = "text-title-medium auto-xy text-align-x-left text-wrap",
								Text = props.rewardDetailsTitle,
								LayoutOrder = 0
							}),
							RewardsInfoModalBody = React.createElement(Foundation.Text, {
								tag = "text-body-medium auto-xy text-align-x-left text-wrap padding-top-small",
								Text = props.rewardDetailsBody,
								LayoutOrder = 1
							}),
							RewardsInfoModalLimitsTitle = React.createElement(Foundation.Text, {
								tag = "text-title-medium auto-xy text-align-x-left text-wrap padding-top-medium",
								Text = props.rewardLimitsTitle,
								LayoutOrder = 2
							}),
							RewardInfoExpiresText = React.createElement(Foundation.Text, {
								tag = "text-body-medium auto-xy text-align-x-left text-wrap padding-top-small",
								Text = props.rewardsExpiresText .. " " .. fn(props.expiryUtc),
								LayoutOrder = 3
							}),
							RewardsInfoModalLimitsBody = React.createElement(Foundation.Text, {
								tag = "text-body-medium auto-xy text-align-x-left text-wrap",
								Text = props.rewardLimitsBody,
								LayoutOrder = 4
							}),
							RewardsInfoModalCreatorSupportText = React.createElement(Foundation.Text, {
								tag = "text-caption-medium auto-xy text-align-x-left text-wrap padding-top-xlarge",
								Text = props.rewardCreatorSupportText,
								LayoutOrder = 5
							}),
							RewardsInfoModalTermsContainer = React.createElement(Foundation.View, {
								tag = "row grow auto-xy align-x-left padding-top-small",
								BackgroundTransparency = 1,
								LayoutOrder = 6,
								onActivated = function()
									local v

									if defineFastFlag then
										v = HttpService:JSONEncode({
											url = GetFStringReferralRewardsTermsURL(),
											title = props.rewardsTerms,
											command = "open",
											visible = true,
											isGenericWebview = true,
											enableOverlayReplacement = true
										})
									else
										v = HttpService:JSONEncode({
											url = GetFStringReferralRewardsTermsURL(),
											title = props.rewardsTerms,
											command = "open"
										})
									end

									BrowserService:SendCommand(v)
								end
							}, {
								RewardsInfoModalTermsText = React.createElement(Foundation.Text, {
									tag = "text-label-small auto-xy text-align-x-left text-wrap",
									Text = `<u><b>{props.rewardsTerms}</b></u>`,
									RichText = true
								})
							})
						}
					)
				})
			})
		}
	)
end
