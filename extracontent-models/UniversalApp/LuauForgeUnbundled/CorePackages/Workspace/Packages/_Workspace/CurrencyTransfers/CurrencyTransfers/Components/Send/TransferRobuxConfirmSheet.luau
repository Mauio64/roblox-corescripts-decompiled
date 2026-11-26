local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SignalsReact")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/SharedFlags")
local TransferLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Localization/TransferLocalizationKeys")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local sheet = Foundation.Sheet
local button = Foundation.Button
local view = Foundation.View
local text = Foundation.Text
local fillBehavior = Foundation.Enums.FillBehavior
local enums = Foundation.Enums
local iconVariant = Foundation.Enums.IconVariant
local getIconRichText = Foundation.Utility.getIconRichText

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/Localization").Hooks.useLocalization

local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/TransferRobuxHeader")
local TransferProfileThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/TransferProfileThumbnail")
local RobuxText = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/Generic/RobuxText")

local useTransferStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferStore")

local setTransferPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/setTransferPromptState")
local processTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Actions/Send/processTransfer")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/PromptState")
local TransferOrigination = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/TransferOrigination")
local CurrencyTransferTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/CurrencyTransferTelemetry")
local RobuxTransferFlowEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/RobuxTransferFlowEventName")
local logCurrencyTransferCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logCurrencyTransferCounter")
local logRobuxTransferFlowEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Utils/logRobuxTransferFlowEvent")

local GetFFlagCurrencyTransferFlowUIImprovementFix = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFlowUIImprovementFix")

local GetFIntCurrencyTransferDeveloperCommissionRate = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFIntCurrencyTransferDeveloperCommissionRate")
local GetFIntCurrencyTransferPlatformFeeRate = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFIntCurrencyTransferPlatformFeeRate")
local GetFFlagCurrencyTransferFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagCurrencyTransferFocusNavigation")
local useTransferSheetFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useTransferSheetFocus")

local function TransferRobuxConfirmSheet(p2)
	local v5 = useLocalization(TransferLocalizationKeys.Presets.TransferRobuxConfirmSheet)

	local v6 = useTransferStore()

	React.useEffect(function(): nil
		logCurrencyTransferCounter(v6, CurrencyTransferTelemetry.CurrencyTransferConfirmSheetShownCounter)

		if SharedFlags.FFlagEnableRobuxTransferFlowEventIngest then
			logRobuxTransferFlowEvent(v6, RobuxTransferFlowEventName.confirm_shown)
		end

		return nil
	end, { v6 })

	local v7 = SignalsReact.useSignalState(v6.getRobuxBalanceAmount) or 0
	local v8 = SignalsReact.useSignalState(v6.getSelectedAmount) or 0
	local userRelationshipDetail = v6.getUserRelationshipDetail(false)
	local recipient = v6.getRecipient(false)
	local v9 = v6.getTransferOrigination(false) == TransferOrigination.InExperience
	local triggerOnClose = v6.triggerOnClose
	local v10, v11

	if GetFFlagCurrencyTransferFocusNavigation() then
		v10, v11 = useTransferSheetFocus(triggerOnClose)
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

	local v12 = React.useMemo(function()
		if GetFFlagCurrencyTransferFlowUIImprovementFix() then
			if not (state and state.friendSinceDate) then
				return v5.NewConnection
			end

			local friendSinceDate = state.friendSinceDate
			local now = os.time()
			local v13 = math.floor((now - os.time({
				year = friendSinceDate.year,
				month = friendSinceDate.month,
				day = friendSinceDate.day,
				hour = 0,
				min = 0,
				sec = 0
			})) / 86400)

			if v13 < 1 then
				return v5.NewConnection
			end

			local v14 = os.date("*t", now)
			local v15 = (v14.year - friendSinceDate.year) * 12 + (v14.month - friendSinceDate.month)

			if v14.day < friendSinceDate.day then
				v15 -= 1
			end

			if v15 >= 12 then
				local v16 = math.floor(v15 / 12)
				return string.gsub(v5.ConnectedYear, "{year}", (tostring(v16)))
			end

			if v15 >= 1 then
				if v15 <= 1 then
					return string.gsub(v5.ConnectedMonthsSingular, "{amount}", (tostring(v15)))
				end

				return string.gsub(v5.ConnectedMonths, "{amount}", (tostring(v15)))
			elseif v13 <= 1 then
				return string.gsub(v5.ConnectedDaysSingular, "{amount}", (tostring(v13)))
			else
				return string.gsub(v5.ConnectedDays, "{amount}", (tostring(v13)))
			end
		else
			if not (state and state.friendSinceYear) then
				return v5.NewConnection
			end

			local v13 = year - state.friendSinceYear

			if v13 == 0 then
				return v5.NewConnection
			end

			return string.gsub(v5.ConnectedYear, "{year}", (tostring(v13)))
		end
	end, {
		year,
		state,
		v5.ConnectedYear,
		v5.ConnectedMonths,
		v5.ConnectedMonthsSingular,
		v5.ConnectedDays,
		v5.ConnectedDaysSingular,
		v5.NewConnection
	})

	local v13 = React.useMemo(function()
		local mutualFriendsCount = state.mutualFriendsCount

		if GetFFlagCurrencyTransferFlowUIImprovementFix() and state.areFriends and mutualFriendsCount <= 1 then
			return string.gsub(v5.MutualConnectionSingular, "{amount}", (tostring(mutualFriendsCount)))
		end

		return string.gsub(v5.MutualConnection, "{amount}", (tostring(mutualFriendsCount)))
	end, {
		state.mutualFriendsCount,
		state.areFriends,
		v5.MutualConnection,
		v5.MutualConnectionSingular
	})

	local v14 = React.useMemo(function()
		return string.gsub(v5.JoinedInYear, "{year}", (tostring(state.userAccountSinceYear)))
	end, { state.userAccountSinceYear })

	local v15 = React.useMemo(function()
		if GetFFlagCurrencyTransferFlowUIImprovementFix() then
			if v9 and v8 then
				local v16 = GetFIntCurrencyTransferDeveloperCommissionRate()
				local v17 = GetFIntCurrencyTransferPlatformFeeRate()
				local v18 = math.ceil(v8 * (1 - (v16 + v17) / 100))
				local v19 = GetFIntCurrencyTransferDeveloperCommissionRate()
				local v20 = string.gsub(v5.RecipientWillGetInGame, "{amount}", (tostring(v18)))
				return (string.gsub(v20, "{commissionPercentage}", (tostring(v19))))
			elseif v8 then
				return string.gsub(v5.RecipientWillGetInApp, "{amount}", (tostring(v8)))
			else
				return nil
			end
		else
			if not (v9 and v8) then
				return nil
			end

			local v16 = GetFIntCurrencyTransferDeveloperCommissionRate()
			local v17 = GetFIntCurrencyTransferPlatformFeeRate()
			local v18 = math.ceil(v8 * (1 - (v16 + v17) / 100))
			return (string.gsub(v5.RecipientWillGet, "{amount}", (tostring(v18))))
		end
	end, {
		v9,
		v8,
		v5.RecipientWillGet,
		v5.RecipientWillGetInGame,
		v5.RecipientWillGetInApp,
		GetFFlagCurrencyTransferFlowUIImprovementFix()
	})

	local v16 = GetFFlagCurrencyTransferFlowUIImprovementFix()
		and "size-full-0 auto-y text-body-small text-wrap text-align-x-center content-default"
		or "auto-xy text-caption-small text-align-x-center content-muted"

	local v17 = GetFFlagCurrencyTransferFlowUIImprovementFix()
		and "col align-x-center align-y-center size-full-0 auto-y radius-medium bg-shift-100 padding-large"
		or "col align-x-center align-y-center size-full-2000 radius-medium bg-shift-100"

	local udim = if not GetFFlagCurrencyTransferFlowUIImprovementFix() then UDim2.new(1, 0, 0, 250) else nil
	local v18 = GetFFlagCurrencyTransferFlowUIImprovementFix()
		and "col gap-xlarge align-x-center bg-shift-100 size-full-0 auto-y radius-medium padding-large"
		or "col gap-xlarge align-x-center bg-shift-100 align-y-center radius-medium padding-large"

	local v19 = GetFFlagCurrencyTransferFlowUIImprovementFix() and not state.areFriends

	local createElement = React.createElement
	local root = sheet.Root

	local children = {
		Header = React.createElement(sheet.Header, {}, {
			TransferRobuxHeader = React.createElement(module6, {
				titleText = v5.SendRobux,
				robuxBalanceAmount = v7
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local v28 = if state2 and state2.targetId then React.createElement(TransferProfileThumbnail, {
		userId = tostring(state2.targetId),
		username = state2.targetName,
		displayName = state2.targetDisplayName,
		showUsername = true,
		size = UDim2.fromOffset(60, 60),
		layoutOrder = 1,
		thumbnailSize = Enum.ThumbnailSize.Size48x48
	}) else nil

	local createElement5 = React.createElement

	local createElement6 = React.createElement

	local v35 = if state and state.areFriends then React.createElement(text, {
		Text = `{getIconRichText(enums.IconName.Calendar, iconVariant.Filled)} {v12}`,
		tag = "auto-xy text-body-medium content-default text-no-wrap",
		RichText = true,
		LayoutOrder = 1
	}) else nil

	local v36 = if state and state.areFriends then React.createElement(view, {
		tag = "auto-xy",
		Size = UDim2.new(0, 8, 0, 0),
		LayoutOrder = 2
	}) else nil
	local v34 = {
		ConnectedDetail = v35,
		Spacer = v36,
		MutualDetail = React.createElement(text, {
			Text = `{getIconRichText(enums.IconName.TwoPeople, iconVariant.Filled)} {v13}`,
			tag = "auto-xy text-body-medium content-default text-no-wrap",
			RichText = true,
			LayoutOrder = 3
		}),
		Spacer2 = 0,
		InlineJoinedDetail = 0
	}

	local v37 = if v19 then React.createElement(view, {
		tag = "auto-xy",
		Size = UDim2.new(0, 8, 0, 0),
		LayoutOrder = 4
	}) else nil
	v34.Spacer2 = v37

	local v38 = if v19 then React.createElement(text, {
		Text = `{getIconRichText(enums.IconName.CircleI, iconVariant.Filled)} {v14}`,
		tag = "auto-xy text-body-medium content-default text-no-wrap",
		RichText = true,
		LayoutOrder = 5
	}) else nil
	v34.InlineJoinedDetail = v38
	local v31 = {
		FirstRow = createElement6(
			view,
			{ tag = "row align-x-center align-y-center auto-xy", LayoutOrder = 1 },
			v34
		),
		JoinedDetail = 0
	}

	local v39 = if not v19 then React.createElement(text, {
		Text = `{getIconRichText(enums.IconName.CircleI, iconVariant.Filled)} {v14}`,
		tag = "auto-xy text-body-medium content-default text-no-wrap padding-y-xsmall",
		RichText = true,
		LayoutOrder = 2
	}) else nil
	v31.JoinedDetail = v39
	local children2 = {
		ProfileCard = createElement4(view, { Size = udim, tag = v18, LayoutOrder = 1 }, {
			RecipientProfile = v28,
			InfoRow = createElement5(
				view,
				{
					tag = "col gap-medium align-x-center align-y-start auto-y size-full-0",
					LayoutOrder = 2
				},
				v31
			)
		}),
		AmountDisplay = 0
	}

	local createElement7 = React.createElement

	local v42 = {
		Amount = React.createElement(RobuxText, {
			amount = v8 or 0,
			layoutOrder = 1
		}),
		RecipientText = 0
	}

	local v43 = if v15 then React.createElement(text, {
		Text = v15,
		tag = v16,
		LayoutOrder = 2
	}) else nil
	v42.RecipientText = v43
	children2.AmountDisplay = createElement7(view, { tag = v17, LayoutOrder = 2 }, v42)
	children.Content = createElement2(content, { LayoutOrder = 2 }, {
		SheetContentContainer = createElement3(
			view,
			{ tag = "col gap-large auto-y size-full-0 align-x-center" },
			children2
		)
	})

	local createElement8 = React.createElement
	local actions = sheet.Actions

	local createElement9 = React.createElement

	local createElement10 = React.createElement

	local v51 = {
		SendButton = React.createElement(button, {
			LayoutOrder = 1,
			ref = v11,
			text = v5.Send,
			onActivated = function()
				if v8 and v7 < v8 then
					setTransferPromptState(v6, PromptState.TransferInsufficientBalance)
				else
					processTransfer(v6, v8 or 0)
				end
			end,
			inputDelay = v9 and 2.5 or nil,
			variant = buttonVariant.Emphasis,
			fillBehavior = fillBehavior.Fill
		}),
		EditButton = 0
	}
	local v52

	if not v9 then
		v52 = React.createElement(button, {
			LayoutOrder = 2,
			text = v5.Edit,
			onActivated = function()
				setTransferPromptState(v6, PromptState.TransferInput)
			end,
			variant = buttonVariant.Standard,
			fillBehavior = fillBehavior.Fill
		})
	end

	v51.EditButton = v52
	children.Actions = createElement8(actions, { LayoutOrder = 3 }, {
		createElement9(view, {
			tag = "col align-x-center align-y-center gap-medium size-full-1000"
		}, {
			createElement10(view, {
				tag = "row gap-small size-full-0 auto-y",
				LayoutOrder = 1
			}, v51),
			Disclaimer = React.createElement(Foundation.Text, {
				Text = v5.AgeEstimationDisclaimer,
				tag = "wrap size-full-0 auto-y text-caption-small text-wrap text-align-x-left",
				LayoutOrder = 2
			})
		})
	})
	return createElement(root, {
		preferCenterSheet = true,
		onClose = triggerOnClose,
		ref = v10
	}, children)
end

return TransferRobuxConfirmSheet
