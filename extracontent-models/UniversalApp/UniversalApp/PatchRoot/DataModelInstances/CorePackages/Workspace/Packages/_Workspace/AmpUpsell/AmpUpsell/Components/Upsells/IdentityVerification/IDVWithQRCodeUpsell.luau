local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local UIBlox = require(AmpUpsellParent.UIBlox)
local Foundation = require(AmpUpsellParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local React = require(AmpUpsellParent.React)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local AnalyticsService = require(AmpUpsell.Analytics.AnalyticsService)
local sendButtonClickEvent = require(AmpUpsell.Analytics.sendButtonClickEvent)
local AppScreens = require(AmpUpsell.Common.AppScreens)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local useStyle = UIBlox.Core.Style.useStyle
local LinkButton = UIBlox.App.Button.LinkButton
local DirectionsTile = require(script.Parent.DirectionsTile)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local QRCodeDisplay = require(AmpUpsellParent.QRCodeDisplay)
local DisplayQRCode = QRCodeDisplay.DisplayQRCode
local ECLevels = QRCodeDisplay.ECLevels
local ProgressChecklist = require(script.Parent.ProgressChecklist)
local useSelector = require(AmpUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector
local idvWithQRCodeUpsellStrings = require(AmpUpsell.Common.LocalizationStrings).idvWithQRCodeUpsellStrings

local function IDVWithQRCodeUpsell(t1: {[any]: any}) -- line: 43
	-- upvalues: useLocalization (copy), idvWithQRCodeUpsellStrings (copy), useStyle (copy), AnalyticsService (copy), useSelector (copy), React (copy), PartialPageModal (copy), sendButtonClickEvent (copy), AppScreens (copy), StyledTextLabel (copy), DirectionsTile (copy), ProgressChecklist (copy), DisplayQRCode (copy), ECLevels (copy), Loading (copy), IconSize (copy), LinkButton (copy)
	local featureName = t1.featureName
	local qrCodeLink = t1.qrCodeLink
	local v27 = useLocalization(idvWithQRCodeUpsellStrings)
	local v28 = useStyle()
	local onClose = t1.onClose
	local openPrivacyPolicyLink = t1.openPrivacyPolicyLink
	local BodyFont = v28.Font.Body.Font
	local BaseSize = v28.Font.BaseSize
	local TextEmphasisTransparency = v28.Theme.TextEmphasis.Transparency
	local v34 = BaseSize * v28.Font.CaptionBody.RelativeSize
	local v35 = if not t1.analyticsService then AnalyticsService.EventStream else t1.analyticsService
	local uDim2 = UDim2.fromOffset(153, 153)
	local latestStepCompleted = t1.latestStepCompleted
	local v38 = latestStepCompleted > 0
	local v39 = useSelector(function(p1) -- line: 58
		return p1.ScreenSize
	end)

	return React.createElement(PartialPageModal, {
		bottomPadding = 0,
		title = v27.title,
		screenSize = v39,
		onCloseClicked = function() -- line: 65
			-- upvalues: sendButtonClickEvent (copy), v35 (copy), AppScreens (copy), featureName (copy), onClose (copy)
			sendButtonClickEvent(v35, AppScreens.IDVWithQRCodeUpsell, featureName, "CloseModal")
			onClose()
		end
	}, {
		QRCodeViewFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 24)
			}),
			HeaderText = React.createElement(StyledTextLabel, {
				lineHeight = 1,
				layoutOrder = 0,
				text = if not v38 then v27.ageVerifyPrompt else v27.verifyInBrowser,
				fontStyle = v28.Font.Header2,
				colorStyle = v28.Theme.TextEmphasis,
				size = UDim2.new(1, 0, 0, 0),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Center,
				automaticSize = Enum.AutomaticSize.XY
			}),
			DirectionsFrame = if v38 then nil else React.createElement("Frame", {
				BackgroundTransparency = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 144),
				BackgroundColor3 = v28.Theme.BackgroundContrast.Color
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 12),
					PaddingLeft = UDim.new(0, 12),
					PaddingRight = UDim.new(0, 12)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 24)
				}),
				IDDirection = React.createElement(DirectionsTile, {
					imagePath = "icons/menu/document",
					frameHeight = 48,
					layoutOrder = 1,
					headerText = v27.idDirectionsHeader,
					descriptionText = v27.idDirectionsBody
				}),
				PhoneDirection = React.createElement(DirectionsTile, {
					imagePath = "icons/menu/mobile",
					frameHeight = 48,
					layoutOrder = 2,
					headerText = v27.phoneDirectionsHeader,
					descriptionText = v27.phoneDirectionsBody
				})
			}),
			Checklist = if not v38 then nil else React.createElement(ProgressChecklist, {
				entryHeight = 18,
				layoutOrder = 1,
				latestStepCompleted = latestStepCompleted
			}),
			BeginText = if v38 then nil else React.createElement(StyledTextLabel, {
				lineHeight = 1,
				layoutOrder = 2,
				text = v27.beginText,
				fontStyle = v28.Font.Header1,
				colorStyle = v28.Theme.TextEmphasis,
				size = UDim2.new(1, 0, 0, 0),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Center,
				automaticSize = Enum.AutomaticSize.XY
			}),
			QRCodeWrapper = React.createElement("Frame", {
				BackgroundTransparency = 0,
				LayoutOrder = 3,
				Size = uDim2,
				BackgroundColor3 = Color3.fromHex("#FFFFFF")
			}, {
				QrCode = if qrCodeLink == nil then React.createElement(Loading, {
					size = IconSize.Medium
				}) else React.createElement(DisplayQRCode, {
					sideLength = 150,
					backgroundTransparency = 1,
					ecLevel = ECLevels.EC_LEVEL_1,
					toEncode = qrCodeLink
				}),
				UIListLayout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 4),
					PaddingLeft = UDim.new(0, 4),
					PaddingRight = UDim.new(0, 4),
					PaddingTop = UDim.new(0, 4)
				})
			}),
			DisclaimerFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 100)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				Disclaimer = if v38 then nil else React.createElement("TextLabel", {
					TextWrapped = true,
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Text = v27.disclaimer,
					Font = BodyFont,
					TextSize = v34,
					TextColor3 = v28.Theme.TextDefault.Color,
					TextTransparency = TextEmphasisTransparency,
					TextXAlignment = Enum.TextXAlignment.Center,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.new(1, 0, 0, 24)
				}),
				PrivacyPolicy = if v38 then nil else React.createElement(LinkButton, {
					layoutOrder = 2,
					fontStyle = "CaptionBody",
					underlineAlwaysEnabled = true,
					text = v27.privacyLinkText,
					onActivated = function() -- line: 227
						-- upvalues: sendButtonClickEvent (copy), v35 (copy), AppScreens (copy), featureName (copy), openPrivacyPolicyLink (copy)
						sendButtonClickEvent(v35, AppScreens.IDVWithQRCodeUpsell, featureName, "OpenPrivacyPolicy")
						openPrivacyPolicyLink()
					end
				}),
				HavingTroubleInfoText = if not v38 then nil else React.createElement(StyledTextLabel, {
					lineHeight = 1,
					layoutOrder = 1,
					text = v27.havingTroubleInfoText,
					size = UDim2.new(1, 0, 0.5, 0),
					fontStyle = v28.Font.CaptionBody,
					colorStyle = v28.Theme.TextEmphasis,
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Center
				}),
				DontCloseWindowDisclaimer = if not v38 then nil else React.createElement(StyledTextLabel, {
					lineHeight = 1,
					layoutOrder = 2,
					text = v27.dontCloseWindowDisclaimer,
					fontStyle = v28.Font.CaptionBody,
					size = UDim2.new(1, 0, 0.5, 0),
					colorStyle = v28.Theme.TextEmphasis,
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Center
				})
			})
		})
	})
end

return IDVWithQRCodeUpsell
