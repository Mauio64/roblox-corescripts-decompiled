local Parent = script:FindFirstAncestor("GameInvite").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local PartialPageModal = require(Parent.UIBlox).App.Dialog.Modal.PartialPageModal
local LocalizationService = game:GetService("LocalizationService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local GetFStringReferralRewardsTermsURL = require(Parent.SharedFlags).GetFStringReferralRewardsTermsURL
local v9 = game:DefineFastFlag("EnableRewardsWebViewOverlay", false)

local function v10(s1: string) -- line: 32
	-- upvalues: LocalizationService (copy)
	if not s1 or s1 == "" then
		return ""
	end

	local v12 = DateTime and DateTime.fromIsoDate(s1) or nil

	if not v12 then
		return ""
	end

	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	return `{ v12:FormatLocalTime("LL", RobloxLocaleId) } { v12:FormatLocalTime("LT", RobloxLocaleId) }`
end

return function(t1: {[any]: any}) -- line: 46
	-- upvalues: React (copy), Foundation (copy), PartialPageModal (copy), v10 (copy), v9 (copy), HttpService (copy), GetFStringReferralRewardsTermsURL (copy), BrowserService (copy)
	return React.createElement("ScreenGui", {
		DisplayOrder = 100,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		RewardsInfoModalContainer = React.createElement(Foundation.View, {
			tag = "size-full-full bg-over-media-100",
			onActivated = function() -- line: 55
				-- upvalues: t1 (copy)
				if t1.setModalOpen then
					t1.setModalOpen(false)
				end
			end
		}, {
			RewardsInfoModal = React.createElement(PartialPageModal, {
				title = t1.title,
				screenSize = workspace.CurrentCamera.ViewportSize,
				position = UDim2.new(0.5, 0, 0.5, 0),
				onCloseClicked = function() -- line: 65
					-- upvalues: t1 (copy)
					if t1.setModalOpen then
						t1.setModalOpen(false)
					end
				end
			}, {
				RewardsInfoModalContent = React.createElement(Foundation.View, {
					tag = "col size-full-0 auto-y gap-y-large padding-top-large",
					Size = UDim2.new(1, 0, 0, 180)
				}, {
					RewardsInfoModalTitle = React.createElement(Foundation.Text, {
						tag = "text-title-medium auto-xy text-align-x-left text-wrap",
						LayoutOrder = 0,
						Text = t1.rewardDetailsTitle
					}),
					RewardsInfoModalBody = React.createElement(Foundation.Text, {
						tag = "text-body-medium auto-xy text-align-x-left text-wrap padding-top-small",
						LayoutOrder = 1,
						Text = t1.rewardDetailsBody
					}),
					RewardsInfoModalLimitsTitle = React.createElement(Foundation.Text, {
						tag = "text-title-medium auto-xy text-align-x-left text-wrap padding-top-medium",
						LayoutOrder = 2,
						Text = t1.rewardLimitsTitle
					}),
					RewardInfoExpiresText = React.createElement(Foundation.Text, {
						tag = "text-body-medium auto-xy text-align-x-left text-wrap padding-top-small",
						LayoutOrder = 3,
						Text = t1.rewardsExpiresText .. " " .. v10(t1.expiryUtc)
					}),
					RewardsInfoModalLimitsBody = React.createElement(Foundation.Text, {
						tag = "text-body-medium auto-xy text-align-x-left text-wrap",
						LayoutOrder = 4,
						Text = t1.rewardLimitsBody
					}),
					RewardsInfoModalCreatorSupportText = React.createElement(Foundation.Text, {
						tag = "text-caption-medium auto-xy text-align-x-left text-wrap padding-top-xlarge",
						LayoutOrder = 5,
						Text = t1.rewardCreatorSupportText
					}),
					RewardsInfoModalTermsContainer = React.createElement(Foundation.View, {
						tag = "row grow auto-xy align-x-left padding-top-small",
						BackgroundTransparency = 1,
						LayoutOrder = 6,
						onActivated = function() -- line: 109
							-- upvalues: v9 (copy), HttpService (copy), GetFStringReferralRewardsTermsURL (copy), t1 (copy), BrowserService (copy)
							local v15 = if not v9 then HttpService:JSONEncode({
								command = "open",
								url = GetFStringReferralRewardsTermsURL(),
								title = t1.rewardsTerms
							}) else HttpService:JSONEncode({
								command = "open",
								visible = true,
								isGenericWebview = true,
								enableOverlayReplacement = true,
								url = GetFStringReferralRewardsTermsURL(),
								title = t1.rewardsTerms
							})

							BrowserService:SendCommand(v15)
						end
					}, {
						RewardsInfoModalTermsText = React.createElement(Foundation.Text, {
							tag = "text-label-small auto-xy text-align-x-left text-wrap",
							RichText = true,
							Text = `<u><b>{ t1.rewardsTerms }</b></u>`
						})
					})
				})
			})
		})
	})
end
