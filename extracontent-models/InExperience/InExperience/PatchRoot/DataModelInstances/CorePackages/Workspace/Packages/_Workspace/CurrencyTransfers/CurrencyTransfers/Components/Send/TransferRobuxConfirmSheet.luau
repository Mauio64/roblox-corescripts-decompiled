local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local SignalsReact = require(CurrencyTransfersParent.SignalsReact)
local SharedFlags = require(CurrencyTransfersParent.SharedFlags)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)
local Foundation = require(CurrencyTransfersParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local View = Foundation.View
local FoundationText = Foundation.Text
local FillBehavior = Foundation.Enums.FillBehavior
local Enums = Foundation.Enums
local IconVariant = Foundation.Enums.IconVariant
local getIconRichText = Foundation.Utility.getIconRichText
local useLocalization = require(CurrencyTransfersParent.Localization).Hooks.useLocalization
local TransferRobuxHeader = require(CurrencyTransfers.Components.Generic.TransferRobuxHeader)
local TransferProfileThumbnail = require(CurrencyTransfers.Components.Generic.TransferProfileThumbnail)
local RobuxText = require(CurrencyTransfers.Components.Generic.RobuxText)
local useTransferStore = require(CurrencyTransfers.Hooks.useTransferStore)
local setTransferPromptState = require(CurrencyTransfers.Actions.Send.setTransferPromptState)
local processTransfer = require(CurrencyTransfers.Actions.Send.processTransfer)
local PromptState = require(CurrencyTransfers.Enums.PromptState)
local TransferOrigination = require(CurrencyTransfers.Enums.TransferOrigination)
local CurrencyTransferTelemetry = require(CurrencyTransfers.Events.CurrencyTransferTelemetry)
local RobuxTransferFlowEventName = require(CurrencyTransfers.Enums.RobuxTransferFlowEventName)
local logCurrencyTransferCounter = require(CurrencyTransfers.Utils.logCurrencyTransferCounter)
local logRobuxTransferFlowEvent = require(CurrencyTransfers.Utils.logRobuxTransferFlowEvent)
local GetFFlagCurrencyTransferFixBalanceReRender = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFixBalanceReRender)
local GetFFlagCurrencyTransferFlowUIImprovementFix = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFlowUIImprovementFix)
local GetFIntCurrencyTransferDeveloperCommissionRate = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferDeveloperCommissionRate)
local GetFIntCurrencyTransferPlatformFeeRate = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferPlatformFeeRate)

local function TransferRobuxConfirmSheet(_: {[any]: any}) -- line: 61
	-- upvalues: useLocalization (copy), TransferLocalizationKeys (copy), useTransferStore (copy), React (copy), logCurrencyTransferCounter (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy), GetFFlagCurrencyTransferFixBalanceReRender (copy), SignalsReact (copy), TransferOrigination (copy), GetFFlagCurrencyTransferFlowUIImprovementFix (copy), GetFIntCurrencyTransferDeveloperCommissionRate (copy), GetFIntCurrencyTransferPlatformFeeRate (copy), Sheet (copy), TransferRobuxHeader (copy), View (copy), TransferProfileThumbnail (copy), FoundationText (copy), getIconRichText (copy), Enums (copy), IconVariant (copy), RobuxText (copy), Button (copy), setTransferPromptState (copy), PromptState (copy), processTransfer (copy), ButtonVariant (copy), FillBehavior (copy), Foundation (copy)
	local v36 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxConfirmSheet)
	local v37 = useTransferStore()

	React.useEffect(function() -- line: 66
		-- upvalues: logCurrencyTransferCounter (copy), v37 (copy), CurrencyTransferTelemetry (copy), SharedFlags (copy), logRobuxTransferFlowEvent (copy), RobuxTransferFlowEventName (copy)
		logCurrencyTransferCounter(v37, CurrencyTransferTelemetry.CurrencyTransferConfirmSheetShownCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v37, RobuxTransferFlowEventName.confirm_shown)
		end

		return nil
	end, { v37 })

	local v38 = if not GetFFlagCurrencyTransferFixBalanceReRender() then v37.getRobuxBalanceAmount(false) else SignalsReact.useSignalState(v37.getRobuxBalanceAmount) or 0
	local v39 = if not GetFFlagCurrencyTransferFixBalanceReRender() then v37.getSelectedAmount(false) or 0 else SignalsReact.useSignalState(v37.getSelectedAmount) or 0
	local v40 = v37.getUserRelationshipDetail(false)
	local v41 = v37.getRecipient(false)
	local v42 = v37.getTransferOrigination(false) == TransferOrigination.InExperience
	local triggerOnClose = v37.triggerOnClose
	local year = os.date("*t").year
	local v45, v46 = React.useState(v40)
	local v47, v48 = React.useState(v41)

	React.useEffect(function() -- line: 90
		-- upvalues: v40 (copy), v46 (copy)
		if v40 then
			v46(v40)
		end
	end, { v40 })
	React.useEffect(function() -- line: 96
		-- upvalues: v41 (copy), v48 (copy)
		if v41 then
			v48(v41)
		end
	end, { v41 })

	local v49 = React.useMemo(function() -- line: 103
		-- upvalues: GetFFlagCurrencyTransferFlowUIImprovementFix (copy), v45 (copy), v36 (copy), year (copy)
		if GetFFlagCurrencyTransferFlowUIImprovementFix() then
			if not v45 or not v45.friendSinceDate then
				return v36.NewConnection
			end

			local friendSinceDate = v45.friendSinceDate
			local timestamp = os.time()
			local v60 = math.floor((timestamp - os.time({
				hour = 0,
				min = 0,
				sec = 0,
				year = friendSinceDate.year,
				month = friendSinceDate.month,
				day = friendSinceDate.day
			})) / 86400)

			if v60 < 1 then
				return v36.NewConnection
			end

			local v61 = os.date("*t", timestamp)
			local v62 = (v61.year - friendSinceDate.year) * 12 + (v61.month - friendSinceDate.month)

			if v61.day < friendSinceDate.day then
				v62 -= 1
			end

			if v62 >= 12 then
				local v63 = math.floor(v62 / 12)

				return string.gsub(v36.ConnectedYear, "{year}", (tostring(v63)))
			end

			if v62 >= 1 then
				if v62 <= 1 then
					return string.gsub(v36.ConnectedMonthsSingular, "{amount}", (tostring(v62)))
				end

				return string.gsub(v36.ConnectedMonths, "{amount}", (tostring(v62)))
			end

			if v60 <= 1 then
				return string.gsub(v36.ConnectedDaysSingular, "{amount}", (tostring(v60)))
			end

			return string.gsub(v36.ConnectedDays, "{amount}", (tostring(v60)))
		end

		if not v45 or not v45.friendSinceYear then
			return v36.NewConnection
		end

		local friendSinceYear = v45.friendSinceYear
		local v65 = year - friendSinceYear

		if v65 == 0 then
			return v36.NewConnection
		end

		return string.gsub(v36.ConnectedYear, "{year}", (tostring(v65)))
	end, {
		year,
		v45,
		v36.ConnectedYear,
		v36.ConnectedMonths,
		v36.ConnectedMonthsSingular,
		v36.ConnectedDays,
		v36.ConnectedDaysSingular,
		v36.NewConnection
	})
	local v50 = React.useMemo(function() -- line: 166
		-- upvalues: v45 (copy), GetFFlagCurrencyTransferFlowUIImprovementFix (copy), v36 (copy)
		local mutualFriendsCount = v45.mutualFriendsCount

		if GetFFlagCurrencyTransferFlowUIImprovementFix() and (v45.areFriends and mutualFriendsCount <= 1) then
			return string.gsub(v36.MutualConnectionSingular, "{amount}", (tostring(mutualFriendsCount)))
		end

		return string.gsub(v36.MutualConnection, "{amount}", (tostring(mutualFriendsCount)))
	end, {
		v45.mutualFriendsCount,
		v45.areFriends,
		v36.MutualConnection,
		v36.MutualConnectionSingular
	})
	local v51 = React.useMemo(function() -- line: 185
		-- upvalues: v36 (copy), v45 (copy)
		return string.gsub(v36.JoinedInYear, "{year}", (tostring(v45.userAccountSinceYear)))
	end, { v45.userAccountSinceYear })
	local v52 = React.useMemo(function() -- line: 190
		-- upvalues: GetFFlagCurrencyTransferFlowUIImprovementFix (copy), v42 (copy), v39 (copy), GetFIntCurrencyTransferDeveloperCommissionRate (copy), GetFIntCurrencyTransferPlatformFeeRate (copy), v36 (copy)
		if GetFFlagCurrencyTransferFlowUIImprovementFix() then
			if v42 and v39 then
				local v67 = GetFIntCurrencyTransferDeveloperCommissionRate()
				local v68 = GetFIntCurrencyTransferPlatformFeeRate()
				local v69 = math.ceil(v39 * (1 - (v67 + v68) / 100))
				local v70 = GetFIntCurrencyTransferDeveloperCommissionRate()
				local v71 = string.gsub(v36.RecipientWillGetInGame, "{amount}", (tostring(v69)))

				return (string.gsub(v71, "{commissionPercentage}", (tostring(v70))))
			end

			if v39 then
				return string.gsub(v36.RecipientWillGetInApp, "{amount}", (tostring(v39)))
			end

			return nil
		end

		if not v42 or not v39 then
			return nil
		end

		local v72 = GetFIntCurrencyTransferDeveloperCommissionRate()
		local v73 = GetFIntCurrencyTransferPlatformFeeRate()
		local v74 = math.ceil(v39 * (1 - (v72 + v73) / 100))

		return (string.gsub(v36.RecipientWillGet, "{amount}", (tostring(v74))))
	end, {
		v42,
		v39,
		v36.RecipientWillGet,
		v36.RecipientWillGetInGame,
		v36.RecipientWillGetInApp,
		GetFFlagCurrencyTransferFlowUIImprovementFix()
	})
	local v53 = not GetFFlagCurrencyTransferFlowUIImprovementFix() and "auto-xy text-caption-small text-align-x-center content-muted" or "size-full-0 auto-y text-body-small text-wrap text-align-x-center content-default"
	local v54 = not GetFFlagCurrencyTransferFlowUIImprovementFix() and "col align-x-center align-y-center size-full-2000 radius-medium bg-shift-100" or "col align-x-center align-y-center size-full-0 auto-y radius-medium bg-shift-100 padding-large"
	local v55 = if not GetFFlagCurrencyTransferFlowUIImprovementFix() then UDim2.new(1, 0, 0, 250) else nil
	local v56 = not GetFFlagCurrencyTransferFlowUIImprovementFix() and "col gap-xlarge align-x-center bg-shift-100 align-y-center radius-medium padding-large" or "col gap-xlarge align-x-center bg-shift-100 size-full-0 auto-y radius-medium padding-large"
	local v57 = GetFFlagCurrencyTransferFlowUIImprovementFix() and not v45.areFriends

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = triggerOnClose
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
				titleText = v36.SendRobux,
				robuxBalanceAmount = v38
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			SheetContentContainer = React.createElement(View, {
				tag = "col gap-large auto-y size-full-0 align-x-center"
			}, {
				ProfileCard = React.createElement(View, {
					LayoutOrder = 1,
					Size = v55,
					tag = v56
				}, {
					RecipientProfile = if not v47 or not v47.targetId then nil else React.createElement(TransferProfileThumbnail, {
						showUsername = true,
						layoutOrder = 1,
						userId = tostring(v47.targetId),
						username = v47.targetName,
						displayName = v47.targetDisplayName,
						size = UDim2.fromOffset(60, 60),
						thumbnailSize = Enum.ThumbnailSize.Size48x48
					}),
					InfoRow = React.createElement(View, {
						tag = "col gap-medium align-x-center align-y-start auto-y size-full-0",
						LayoutOrder = 2
					}, {
						FirstRow = React.createElement(View, {
							tag = "row align-x-center align-y-center auto-xy",
							LayoutOrder = 1
						}, {
							ConnectedDetail = if not v45 or not v45.areFriends then nil else React.createElement(FoundationText, {
								tag = "auto-xy text-body-medium content-default text-no-wrap",
								RichText = true,
								LayoutOrder = 1,
								Text = `{ getIconRichText(Enums.IconName.Calendar, IconVariant.Filled) } { v49 }`
							}),
							Spacer = if not v45 or not v45.areFriends then nil else React.createElement(View, {
								tag = "auto-xy",
								LayoutOrder = 2,
								Size = UDim2.new(0, 8, 0, 0)
							}),
							MutualDetail = React.createElement(FoundationText, {
								tag = "auto-xy text-body-medium content-default text-no-wrap",
								RichText = true,
								LayoutOrder = 3,
								Text = `{ getIconRichText(Enums.IconName.TwoPeople, IconVariant.Filled) } { v50 }`
							}),
							Spacer2 = if not v57 then nil else React.createElement(View, {
								tag = "auto-xy",
								LayoutOrder = 4,
								Size = UDim2.new(0, 8, 0, 0)
							}),
							InlineJoinedDetail = if not v57 then nil else React.createElement(FoundationText, {
								tag = "auto-xy text-body-medium content-default text-no-wrap",
								RichText = true,
								LayoutOrder = 5,
								Text = `{ getIconRichText(Enums.IconName.CircleI, IconVariant.Filled) } { v51 }`
							})
						}),
						JoinedDetail = if not v57 then React.createElement(FoundationText, {
							tag = "auto-xy text-body-medium content-default text-no-wrap padding-y-xsmall",
							RichText = true,
							LayoutOrder = 2,
							Text = `{ getIconRichText(Enums.IconName.CircleI, IconVariant.Filled) } { v51 }`
						}) else nil
					})
				}),
				AmountDisplay = React.createElement(View, {
					LayoutOrder = 2,
					tag = v54
				}, {
					Amount = React.createElement(RobuxText, {
						layoutOrder = 1,
						amount = v39 or 0
					}),
					RecipientText = if not v52 then nil else React.createElement(FoundationText, {
						LayoutOrder = 2,
						Text = v52,
						tag = v53
					})
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, { React.createElement(View, {
			tag = "col align-x-center align-y-center gap-medium size-full-1000"
		}, {
			React.createElement(View, {
				tag = "row gap-small size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				SendButton = React.createElement(Button, {
					LayoutOrder = 1,
					text = v36.Send,
					onActivated = function() -- line: 369
						-- upvalues: v39 (copy), v38 (copy), setTransferPromptState (copy), v37 (copy), PromptState (copy), processTransfer (copy)
						if v39 and v39 > v38 then
							setTransferPromptState(v37, PromptState.TransferInsufficientBalance)

							return
						end

						processTransfer(v37, v39 or 0)
					end,
					inputDelay = if not v42 then nil else 2.5,
					variant = ButtonVariant.Emphasis,
					fillBehavior = FillBehavior.Fill
				}),
				EditButton = if v42 then nil else React.createElement(Button, {
					LayoutOrder = 2,
					text = v36.Edit,
					onActivated = function() -- line: 384
						-- upvalues: setTransferPromptState (copy), v37 (copy), PromptState (copy)
						setTransferPromptState(v37, PromptState.TransferInput)
					end,
					variant = ButtonVariant.Standard,
					fillBehavior = FillBehavior.Fill
				})
			}),
			Disclaimer = React.createElement(Foundation.Text, {
				tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left",
				LayoutOrder = 2,
				Text = v36.AgeEstimationDisclaimer
			})
		}) })
	})
end

return TransferRobuxConfirmSheet
