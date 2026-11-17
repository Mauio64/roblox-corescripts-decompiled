local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)
local TransferLocalizationKeys = require(CurrencyTransfers.Localization.TransferLocalizationKeys)

local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local View = Foundation.View
local Text = Foundation.Text
local FillBehavior = Foundation.Enums.FillBehavior
local Enums = Foundation.Enums
local IconVariant = Foundation.Enums.IconVariant
local getIconRichText = Foundation.Utility.getIconRichText

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

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

local GetFFlagCurrencyTransferFlowUIImprovementFix = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFlowUIImprovementFix)

local GetFIntCurrencyTransferDeveloperCommissionRate = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferDeveloperCommissionRate)
local GetFIntCurrencyTransferPlatformFeeRate = require(CurrencyTransfers.Flags.GetFIntCurrencyTransferPlatformFeeRate)
local GetFFlagCurrencyTransferFocusNavigation = require(CurrencyTransfers.Flags.GetFFlagCurrencyTransferFocusNavigation)
local useTransferSheetFocus = require(CurrencyTransfers.Hooks.useTransferSheetFocus)

local function TransferRobuxConfirmSheet(_)
	local v = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxConfirmSheet)

	local v2 = useTransferStore()

	React.useEffect(function(): nil
		logCurrencyTransferCounter(v2, CurrencyTransferTelemetry.CurrencyTransferConfirmSheetShownCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v2, RobuxTransferFlowEventName.confirm_shown)
		end

		return nil
	end, { v2 })

	local robuxBalanceAmount = SignalsReact.useSignalState(v2.getRobuxBalanceAmount) or 0
	local v3 = SignalsReact.useSignalState(v2.getSelectedAmount) or 0
	local userRelationshipDetail = v2.getUserRelationshipDetail(false)
	local recipient = v2.getRecipient(false)
	local v4 = v2.getTransferOrigination(false) == TransferOrigination.InExperience
	local triggerOnClose = v2.triggerOnClose
	local ref, ref2

	if GetFFlagCurrencyTransferFocusNavigation() then
		ref, ref2 = useTransferSheetFocus(triggerOnClose)
	end

	local year = os.date("*t").year

	local state, setState = React.useState(userRelationshipDetail)
	local state2, setState2 = React.useState(recipient)

	React.useEffect(function()
		if userRelationshipDetail then
			setState(userRelationshipDetail)
		end
	end, { userRelationshipDetail })

	React.useEffect(function()
		if recipient then
			setState2(recipient)
		end
	end, { recipient })

	local v5 = React.useMemo(function()
		if GetFFlagCurrencyTransferFlowUIImprovementFix() then
			if not (state and state.friendSinceDate) then
				return v.NewConnection
			end

			local friendSinceDate = state.friendSinceDate
			local now = os.time()
			local v5 = math.floor((now - os.time({
				year = friendSinceDate.year,
				month = friendSinceDate.month,
				day = friendSinceDate.day,
				hour = 0,
				min = 0,
				sec = 0
			})) / 86400)

			if v5 < 1 then
				return v.NewConnection
			end

			local v6 = os.date("*t", now)
			local v7 = (v6.year - friendSinceDate.year) * 12 + (v6.month - friendSinceDate.month)

			if v6.day < friendSinceDate.day then
				v7 -= 1
			end

			if v7 >= 12 then
				local v8 = math.floor(v7 / 12)
				return string.gsub(v.ConnectedYear, "{year}", (tostring(v8)))
			end

			if v7 >= 1 then
				if v7 <= 1 then
					return string.gsub(v.ConnectedMonthsSingular, "{amount}", (tostring(v7)))
				end

				return string.gsub(v.ConnectedMonths, "{amount}", (tostring(v7)))
			elseif v5 <= 1 then
				return string.gsub(v.ConnectedDaysSingular, "{amount}", (tostring(v5)))
			else
				return string.gsub(v.ConnectedDays, "{amount}", (tostring(v5)))
			end
		else
			if not (state and state.friendSinceYear) then
				return v.NewConnection
			end

			local v5 = year - state.friendSinceYear

			if v5 == 0 then
				return v.NewConnection
			end

			return string.gsub(v.ConnectedYear, "{year}", (tostring(v5)))
		end
	end, {
		year,
		state,
		v.ConnectedYear,
		v.ConnectedMonths,
		v.ConnectedMonthsSingular,
		v.ConnectedDays,
		v.ConnectedDaysSingular,
		v.NewConnection
	})

	local v6 = React.useMemo(function()
		local mutualFriendsCount = state.mutualFriendsCount

		if GetFFlagCurrencyTransferFlowUIImprovementFix() and state.areFriends and mutualFriendsCount <= 1 then
			return string.gsub(v.MutualConnectionSingular, "{amount}", (tostring(mutualFriendsCount)))
		end

		return string.gsub(v.MutualConnection, "{amount}", (tostring(mutualFriendsCount)))
	end, {
		state.mutualFriendsCount,
		state.areFriends,
		v.MutualConnection,
		v.MutualConnectionSingular
	})

	local v7 = React.useMemo(function()
		return string.gsub(v.JoinedInYear, "{year}", (tostring(state.userAccountSinceYear)))
	end, { state.userAccountSinceYear })

	local text = React.useMemo(function()
		if GetFFlagCurrencyTransferFlowUIImprovementFix() then
			if v4 and v3 then
				local fIntCurrencyTransferDeveloperCommissionRate = GetFIntCurrencyTransferDeveloperCommissionRate()
				local fIntCurrencyTransferPlatformFeeRate = GetFIntCurrencyTransferPlatformFeeRate()
				local v8 = math.ceil(v3 * (1 - (fIntCurrencyTransferDeveloperCommissionRate + fIntCurrencyTransferPlatformFeeRate) / 100))
				local fIntCurrencyTransferDeveloperCommissionRate2 = GetFIntCurrencyTransferDeveloperCommissionRate()
				local v9 = string.gsub(v.RecipientWillGetInGame, "{amount}", (tostring(v8)))
				return (string.gsub(
					v9,
					"{commissionPercentage}",
					(tostring(fIntCurrencyTransferDeveloperCommissionRate2))
				))
			elseif v3 then
				return string.gsub(v.RecipientWillGetInApp, "{amount}", (tostring(v3)))
			else
				return nil
			end
		else
			if not (v4 and v3) then
				return nil
			end

			local fIntCurrencyTransferDeveloperCommissionRate = GetFIntCurrencyTransferDeveloperCommissionRate()
			local fIntCurrencyTransferPlatformFeeRate = GetFIntCurrencyTransferPlatformFeeRate()
			local v8 = math.ceil(v3 * (1 - (fIntCurrencyTransferDeveloperCommissionRate + fIntCurrencyTransferPlatformFeeRate) / 100))
			return (string.gsub(v.RecipientWillGet, "{amount}", (tostring(v8))))
		end
	end, {
		v4,
		v3,
		v.RecipientWillGet,
		v.RecipientWillGetInGame,
		v.RecipientWillGetInApp,
		GetFFlagCurrencyTransferFlowUIImprovementFix()
	})

	local tag = GetFFlagCurrencyTransferFlowUIImprovementFix()
		and "size-full-0 auto-y text-body-small text-wrap text-align-x-center content-default"
		or "auto-xy text-caption-small text-align-x-center content-muted"

	local tag2 = GetFFlagCurrencyTransferFlowUIImprovementFix()
		and "col align-x-center align-y-center size-full-0 auto-y radius-medium bg-shift-100 padding-large"
		or "col align-x-center align-y-center size-full-2000 radius-medium bg-shift-100"
	local udim

	if not GetFFlagCurrencyTransferFlowUIImprovementFix() then
		udim = UDim2.new(1, 0, 0, 250)
	end

	local tag3 = GetFFlagCurrencyTransferFlowUIImprovementFix()
		and "col gap-xlarge align-x-center bg-shift-100 size-full-0 auto-y radius-medium padding-large"
		or "col gap-xlarge align-x-center bg-shift-100 align-y-center radius-medium padding-large"

	local v8 = GetFFlagCurrencyTransferFlowUIImprovementFix() and not state.areFriends

	local createElement = React.createElement
	local root = Sheet.Root

	local children = {
		Header = React.createElement(Sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(TransferRobuxHeader, {
				titleText = v.SendRobux,
				robuxBalanceAmount = robuxBalanceAmount
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local recipientProfile

	if state2 and state2.targetId then
		recipientProfile = React.createElement(TransferProfileThumbnail, {
			userId = tostring(state2.targetId),
			username = state2.targetName,
			displayName = state2.targetDisplayName,
			showUsername = true,
			size = UDim2.fromOffset(60, 60),
			layoutOrder = 1,
			thumbnailSize = Enum.ThumbnailSize.Size48x48
		})
	end

	local createElement5 = React.createElement

	local createElement6 = React.createElement
	local connectedDetail

	if state and state.areFriends then
		connectedDetail = React.createElement(Text, {
			Text = `{getIconRichText(Enums.IconName.Calendar, IconVariant.Filled)} {v5}`,
			tag = "auto-xy text-body-medium content-default text-no-wrap",
			RichText = true,
			LayoutOrder = 1
		})
	end

	local spacer

	if state and state.areFriends then
		spacer = React.createElement(View, {
			tag = "auto-xy",
			Size = UDim2.new(0, 8, 0, 0),
			LayoutOrder = 2
		})
	end

	local v9 = {
		ConnectedDetail = connectedDetail,
		Spacer = spacer,
		MutualDetail = React.createElement(Text, {
			Text = `{getIconRichText(Enums.IconName.TwoPeople, IconVariant.Filled)} {v6}`,
			tag = "auto-xy text-body-medium content-default text-no-wrap",
			RichText = true,
			LayoutOrder = 3
		}),
		Spacer2 = 0,
		InlineJoinedDetail = 0
	}
	local spacer2

	if v8 then
		spacer2 = React.createElement(View, {
			tag = "auto-xy",
			Size = UDim2.new(0, 8, 0, 0),
			LayoutOrder = 4
		})
	end

	v9.Spacer2 = spacer2
	local inlineJoinedDetail

	if v8 then
		inlineJoinedDetail = React.createElement(Text, {
			Text = `{getIconRichText(Enums.IconName.CircleI, IconVariant.Filled)} {v7}`,
			tag = "auto-xy text-body-medium content-default text-no-wrap",
			RichText = true,
			LayoutOrder = 5
		})
	end

	v9.InlineJoinedDetail = inlineJoinedDetail
	local v10 = {
		FirstRow = createElement6(View, {
			tag = "row align-x-center align-y-center auto-xy",
			LayoutOrder = 1
		}, v9),
		JoinedDetail = 0
	}
	local joinedDetail

	if not v8 then
		joinedDetail = React.createElement(Text, {
			Text = `{getIconRichText(Enums.IconName.CircleI, IconVariant.Filled)} {v7}`,
			tag = "auto-xy text-body-medium content-default text-no-wrap padding-y-xsmall",
			RichText = true,
			LayoutOrder = 2
		})
	end

	v10.JoinedDetail = joinedDetail
	local children2 = {
		ProfileCard = createElement4(View, { Size = udim, tag = tag3, LayoutOrder = 1 }, {
			RecipientProfile = recipientProfile,
			InfoRow = createElement5(
				View,
				{
					tag = "col gap-medium align-x-center align-y-start auto-y size-full-0",
					LayoutOrder = 2
				},
				v10
			)
		}),
		AmountDisplay = 0
	}

	local createElement7 = React.createElement

	local v11 = {
		Amount = React.createElement(RobuxText, {
			amount = v3 or 0,
			layoutOrder = 1
		}),
		RecipientText = 0
	}
	local recipientText

	if text then
		recipientText = React.createElement(Text, { Text = text, tag = tag, LayoutOrder = 2 })
	end

	v11.RecipientText = recipientText
	children2.AmountDisplay = createElement7(View, { tag = tag2, LayoutOrder = 2 }, v11)
	children.Content = createElement2(content, { LayoutOrder = 2 }, {
		SheetContentContainer = createElement3(
			View,
			{ tag = "col gap-large auto-y size-full-0 align-x-center" },
			children2
		)
	})

	local createElement8 = React.createElement
	local actions = Sheet.Actions

	local createElement9 = React.createElement

	local createElement10 = React.createElement

	local v12 = {
		SendButton = React.createElement(Button, {
			LayoutOrder = 1,
			ref = ref2,
			text = v.Send,
			onActivated = function()
				if v3 and robuxBalanceAmount < v3 then
					setTransferPromptState(v2, PromptState.TransferInsufficientBalance)
				else
					processTransfer(v2, v3 or 0)
				end
			end,
			inputDelay = v4 and 2.5 or nil,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill
		}),
		EditButton = 0
	}
	local editButton

	if not v4 then
		editButton = React.createElement(Button, {
			LayoutOrder = 2,
			text = v.Edit,
			onActivated = function()
				setTransferPromptState(v2, PromptState.TransferInput)
			end,
			variant = ButtonVariant.Standard,
			fillBehavior = FillBehavior.Fill
		})
	end

	v12.EditButton = editButton
	children.Actions = createElement8(actions, { LayoutOrder = 3 }, {
		createElement9(View, { tag = "col align-x-center align-y-center gap-medium size-full-1000" }, {
			createElement10(View, { tag = "row gap-small size-full-0 auto-y", LayoutOrder = 1 }, v12),
			Disclaimer = React.createElement(Foundation.Text, {
				Text = v.AgeEstimationDisclaimer,
				tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left",
				LayoutOrder = 2
			})
		})
	})
	return createElement(root, { preferCenterSheet = true, onClose = triggerOnClose, ref = ref }, children)
end

return TransferRobuxConfirmSheet
