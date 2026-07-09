local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local React = require(ChallengeDialogParent.React)
local UIBlox = require(ChallengeDialogParent.UIBlox)
local RoactRodux = require(ChallengeDialogParent.RoactRodux)
local HttpRequest = require(ChallengeDialogParent.HttpRequest)
local AppPage = require(ChallengeDialogParent.RobloxAppEnums).AppPage
local NavigateDown = require(ChallengeDialogParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ChallengeDialogParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(ChallengeDialogParent.RobloxAppNavigation).NavigationCommands
local useLocalization = require(ChallengeDialogParent.Localization).Hooks.useLocalization
local FullPageModalWrapper = require(ChallengeDialog.Common.FullPageModalWrapper)
local Lock = require(ChallengeDialog.Common.Lock)
local ModalTextComponent = require(ChallengeDialog.Common.ModalTextComponent)
local ModalErrorText = require(ChallengeDialog.Common.ModalErrorText)
local ModalButtonConfig = require(ChallengeDialog.Common.ModalButtonConfig)
local ModalFooter = require(ChallengeDialog.Common.ModalFooter)
local FinishDialog = require(ChallengeDialog.Thunks.FinishDialog)
local ModalState = require(ChallengeDialog.Enum.ModalState)
local ChallengeDialogAction = require(ChallengeDialog.Enum.ChallengeDialogAction)
local ChallengeDialogError = require(ChallengeDialog.Enum.ChallengeDialogError)
local ChallengeDialogType = require(ChallengeDialog.Enum.ChallengeDialogType)
local ChallengeDialogState = require(ChallengeDialog.Enum.ChallengeDialogState)
local getFormattedDeviceType = require(ChallengeDialog.Common.Utils).getFormattedDeviceType
local getFormattedRegionalLocation = require(ChallengeDialog.Common.Utils).getFormattedRegionalLocation
local getFormattedIPAddress = require(ChallengeDialog.Common.Utils).getFormattedIPAddress
local getFormattedDateTime = require(ChallengeDialog.Common.Utils).getFormattedDateTime
local EventService = require(ChallengeDialog.Analytics.EventService)
local MetricsService = require(ChallengeDialog.Analytics.MetricsService)
local ModalTextSizes = require(ChallengeDialog.Common.ModalTextSizes)
local FFlagLuaAppDefaultHttpRetry = require(ChallengeDialogParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local DEFAULT_PADDING = require(ChallengeDialog.Common.Constants).DEFAULT_PADDING
local X_BUTTON_SIZE = require(ChallengeDialog.Common.Constants).X_BUTTON_SIZE
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

local function v36(s1: string, s2: string, s3: string, n1: number, s4: string?) -- line: 59
	-- upvalues: ChallengeDialogType (copy)
	local s5 = "Authentication.TwoStepVerification.Description.LoginToNewDevice"

	if n1 == ChallengeDialogType.toRawValue(ChallengeDialogType.DIALOG_TYPE_APPROVAL_2SV_GENERIC) then
		s5 = if s4 ~= nil and s4 ~= "" then s4 else "Authentication.TwoStepVerification.Description.PostLoginActionConfirmation"
	end

	return {
		approve = "Authentication.TwoStepVerification.Action.Approve",
		deny = "Authentication.TwoStepVerification.Action.Deny",
		deviceTypeLabel = "Authentication.TwoStepVerification.Label.DeviceTypeLabel",
		locationLabel = "Authentication.TwoStepVerification.Label.LocationLabel",
		ipAddressLabel = "Authentication.TwoStepVerification.Label.IPAddressLabel",
		dateTimeLabel = "Authentication.TwoStepVerification.Label.DateTimeLabel",
		unknownDeviceType = "Authentication.TwoStepVerification.Label.UnknownDevice",
		unknownLocation = "Authentication.TwoStepVerification.Label.UnknownLocation",
		unknownIPAddress = "Authentication.TwoStepVerification.Label.UnknownIPAddress",
		errorMessage = "Authentication.TwoStepVerification.Response.DefaultError",
		helpMessage = "Authentication.TwoStepVerification.Label.NeedHelpMessage",
		description = s5,
		location = {
			"Authentication.TwoStepVerification.Label.Location",
			city = s1,
			subdivision = s2,
			country = s3
		},
		locationWithoutCity = {
			"Authentication.TwoStepVerification.Label.LocationWithoutCity",
			subdivision = s2,
			country = s3
		},
		locationWithoutSubdivision = {
			"Authentication.TwoStepVerification.Label.LocationWithoutSubdivision",
			city = s1,
			country = s3
		},
		locationWithoutCountry = {
			"Authentication.TwoStepVerification.Label.LocationWithoutCountry",
			city = s1,
			subdivision = s2
		}
	}
end

local v37 = HttpRequest.config({
	requestFunction = HttpRequest.requestFunctions.RequestInternal,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("ModalChallengeDialogApprovalHttpRetryCount", 4)
})

return RoactRodux.connect(function(_, _) -- line: 395
	return {}
end, function(p3) -- line: 397
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), FinishDialog (copy)
	return {
		navigateToPage = function(p4) -- line: 399
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v10 (copy), p3 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v10.down(v10.fromLegacyPage(p4))
			end

			return p3(NavigateDown(p4))
		end,
		finishDialog = function(p5, p6, p7) -- line: 406
			-- upvalues: p3 (copy), FinishDialog (copy)
			return p3(FinishDialog(p5, p6, p7))
		end
	}
end)(function(p8) -- line: 119
	-- upvalues: React (copy), useStyle (copy), useLocalization (copy), v36 (copy), MetricsService (copy), v37 (copy), ChallengeDialogError (copy), ModalState (copy), EventService (copy), ChallengeDialogState (copy), ChallengeDialogAction (copy), DEFAULT_PADDING (copy), ModalTextComponent (copy), ModalTextSizes (copy), FullPageModalWrapper (copy), X_BUTTON_SIZE (copy), Lock (copy), getFormattedDeviceType (copy), getFormattedRegionalLocation (copy), getFormattedIPAddress (copy), getFormattedDateTime (copy), ModalButtonConfig (copy), ButtonType (copy), ModalFooter (copy), ModalErrorText (copy), AppPage (copy)
	local v45, v46 = React.useState(false)
	local v47, v48 = React.useState(false)
	local v49, v50 = React.useState(Vector2.new(0, 0))
	local v51, v52 = React.useState(Vector2.new(0, 0))
	local v53, v54 = React.useState(nil)
	local Theme = useStyle().Theme
	local v56 = useLocalization((v36(p8.dialogItem.origin.city, p8.dialogItem.origin.subdivision, p8.dialogItem.origin.country, p8.dialogItem.type, p8.dialogItem.challengeActionTypeTranslationKey)))

	local function v57(p9) -- line: 137
		-- upvalues: v49 (copy), v50 (copy)
		if v49 ~= p9.AbsoluteSize then
			v50(p9.AbsoluteSize)
		end
	end
	local function v58(p10) -- line: 142
		-- upvalues: v51 (copy), v52 (copy)
		if v51 ~= p10.AbsoluteSize then
			v52(p10.AbsoluteSize)
		end
	end
	local function v59(p11) -- line: 147
		-- upvalues: MetricsService (copy)
		if p11.CanvasSize.Y.Offset > p11.AbsoluteSize.Y then
			MetricsService.loginInfoOverflowed()
		end
	end
	local function v60(p12, p13, p14, p15) -- line: 153
		-- upvalues: p8 (copy), v37 (copy), ChallengeDialogError (copy), ModalState (copy)
		p8.finishDialog(v37, p12, p13):andThen(function(_) -- line: 156
			-- upvalues: p14 (copy)
			p14()
		end):catch(function(p17) -- line: 159
			-- upvalues: ChallengeDialogError (copy), p8 (copy), ModalState (copy), p15 (copy)
			if p17 == ChallengeDialogError.InconsistentStateTransition then
				p8.navigateToModalState({
					modalState = ModalState.ChallengeDialogAlreadyCompleted
				})

				return
			end

			p15(p17)
		end):await()
	end
	local function v61(s6: string, s7: string, n2: number, n3: number) -- line: 229
		-- upvalues: React (copy), DEFAULT_PADDING (copy), ModalTextComponent (copy), ModalTextSizes (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			LayoutOrder = n3
		}, {
			ListLayout = React.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, DEFAULT_PADDING / 4),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Label = React.createElement(ModalTextComponent, {
				layoutOrder = 1,
				contentWidth = n2,
				size = ModalTextSizes.Footer,
				text = s6
			}),
			Info = React.createElement(ModalTextComponent, {
				layoutOrder = 2,
				useEmphasis = true,
				contentWidth = n2,
				text = s7
			})
		})
	end

	return React.createElement(FullPageModalWrapper, {
		title = "",
		closeModal = function() -- line: 215
			-- upvalues: EventService (copy), p8 (copy), v60 (copy), ChallengeDialogAction (copy)
			v60({
				type = p8.dialogItem.type,
				typeInternalId = p8.dialogItem.typeInternalId
			}, ChallengeDialogAction.Deny, function() -- line: 216
				-- upvalues: EventService (copy), p8 (copy)
				EventService.sendDialogAbandonedEvent(p8.dialogItem.type, p8.dialogItem.typeInternalId)
				p8.closeModal()
			end, function(_) -- line: 220
				-- upvalues: p8 (copy)
				p8.closeModal()
			end)
		end,
		makeBodyFragment = function(p19) -- line: 264
			-- upvalues: React (copy), v57 (copy), DEFAULT_PADDING (copy), ModalTextComponent (copy), X_BUTTON_SIZE (copy), ModalTextSizes (copy), v56 (copy), Lock (copy), v49 (copy), v51 (copy), Theme (copy), v59 (copy), v58 (copy), v61 (copy), getFormattedDeviceType (copy), p8 (copy), getFormattedRegionalLocation (copy), getFormattedIPAddress (copy), getFormattedDateTime (copy)
			return React.createElement(React.Fragment, nil, {
				Description = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					LayoutOrder = 1,
					[React.Change.AbsoluteSize] = v57
				}, {
					ListLayout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, DEFAULT_PADDING),
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					ModalBodyText = React.createElement(ModalTextComponent, {
						layoutOrder = 1,
						useBold = true,
						useEmphasis = true,
						contentWidth = p19 - 2 * X_BUTTON_SIZE,
						size = ModalTextSizes.Header1,
						text = v56.description
					}),
					Lock = React.createElement(Lock, {
						layoutOrder = 2
					})
				}),
				LoginAttemptInfoScrollable = React.createElement("ScrollingFrame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, -v49.Y - DEFAULT_PADDING),
					CanvasSize = UDim2.new(1, 0, 0, v51.Y),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollBarImageColor3 = Theme.UIEmphasis.Color,
					LayoutOrder = 2,
					[React.Change.CanvasSize] = v59
				}, {
					LoginAttemptInfoCanvas = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.fromScale(1, 0),
						[React.Change.AbsoluteSize] = v58
					}, {
						ListLayout = React.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, DEFAULT_PADDING / 2),
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						ContentPadding = React.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, DEFAULT_PADDING / 2)
						}),
						DeviceType = v61(v56.deviceTypeLabel, getFormattedDeviceType(p8.dialogItem.origin.deviceType, p8.dialogItem.origin.deviceOs, v56), p19, 1),
						RegionalLocation = v61(v56.locationLabel, getFormattedRegionalLocation(p8.dialogItem.origin.city, p8.dialogItem.origin.subdivision, p8.dialogItem.origin.country, v56), p19, 2),
						IPAddress = v61(v56.ipAddressLabel, getFormattedIPAddress(p8.dialogItem.origin.ipAddress, v56), p19, 3),
						DateTimeInfo = v61(v56.dateTimeLabel, getFormattedDateTime(p8.dialogItem.origin.timestamp, v56), p19, 4)
					})
				})
			})
		end,
		buttonConfig = ModalButtonConfig({
			{
				isDisabled = v45 or v47,
				isLoading = v45,
				onActivated = function() -- line: 171
					-- upvalues: v54 (copy), v46 (copy), EventService (copy), p8 (copy), ChallengeDialogState (copy), v60 (copy), ChallengeDialogAction (copy)
					v54(nil)
					v46(true)
					v60({
						type = p8.dialogItem.type,
						typeInternalId = p8.dialogItem.typeInternalId
					}, ChallengeDialogAction.Approve, function() -- line: 174
						-- upvalues: EventService (copy), p8 (copy), ChallengeDialogState (copy), v46 (copy)
						EventService.sendDialogActionSelectedEvent(p8.dialogItem.type, p8.dialogItem.typeInternalId, ChallengeDialogState.toRawValue(ChallengeDialogState.DIALOG_STATE_APPROVED))
						v46(false)
						p8.closeModal()
					end, function(p20) -- line: 183
						-- upvalues: v46 (copy), v54 (copy)
						v46(false)
						v54(p20)
					end)
				end,
				text = v56.approve,
				type = ButtonType.Secondary
			},
			{
				isDisabled = v47 or v45,
				isLoading = v47,
				onActivated = function() -- line: 193
					-- upvalues: v54 (copy), v48 (copy), EventService (copy), p8 (copy), ChallengeDialogState (copy), ModalState (copy), v60 (copy), ChallengeDialogAction (copy)
					v54(nil)
					v48(true)
					v60({
						type = p8.dialogItem.type,
						typeInternalId = p8.dialogItem.typeInternalId
					}, ChallengeDialogAction.Deny, function() -- line: 196
						-- upvalues: EventService (copy), p8 (copy), ChallengeDialogState (copy), v48 (copy), ModalState (copy)
						EventService.sendDialogActionSelectedEvent(p8.dialogItem.type, p8.dialogItem.typeInternalId, ChallengeDialogState.toRawValue(ChallengeDialogState.DIALOG_STATE_DENIED))
						v48(false)
						p8.navigateToModalState({
							modalState = ModalState.ChallengeDialogDenied
						})
					end, function(p21) -- line: 205
						-- upvalues: v48 (copy), v54 (copy)
						v48(false)
						v54(p21)
					end)
				end,
				text = v56.deny,
				type = ButtonType.Secondary
			}
		}),
		footerContent = ModalFooter(function(p22) -- line: 367
			-- upvalues: React (copy), v53 (copy), ModalErrorText (copy), v56 (copy), ModalTextComponent (copy), ModalTextSizes (copy), p8 (copy), AppPage (copy)
			return React.createElement(React.Fragment, nil, {
				ErrorMessage = v53 and React.createElement(ModalErrorText, {
					layoutOrder = 1,
					errorText = v56.errorMessage,
					contentWidth = p22
				}),
				SupportLink = React.createElement(ModalTextComponent, {
					BackgroundTransparency = 0,
					layoutOrder = 2,
					text = v56.helpMessage,
					contentWidth = p22,
					size = ModalTextSizes.Footer,
					onActivated = function() -- line: 380
						-- upvalues: p8 (copy), AppPage (copy)
						p8.navigateToPage({
							detail = "https://en.help.roblox.com/hc/en-us/articles/212459863-Add-2-Step-Verification-to-Your-Account",
							name = AppPage.GenericWebPage,
							extraProps = {
								title = ""
							}
						})
					end
				})
			})
		end)
	})
end)
