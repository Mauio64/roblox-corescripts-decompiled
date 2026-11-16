local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local UserInputService = game:GetService("UserInputService")

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local VersionHistoryContainer = require(BuildExperience.Components.VersionHistory.VersionHistoryContainer)
local FriendsOnlyShareDialog = require(BuildExperience.Components.ShareAudience.FriendsOnlyShareDialog)
local ExperienceShareOverlays = require(BuildExperience.Components.ShareAudience.ExperienceShareOverlays)
local leaveExperience = require(BuildExperience.utils.leaveExperience)
local useExperienceShareFlow = require(BuildExperience.utils.useExperienceShareFlow)
local sharePublishedExperience = require(BuildExperience.utils.sharePublishedExperience)
local useSharePublishedExperience = sharePublishedExperience.useSharePublishedExperience
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)
local urlBuilder

if FFlagBuildExperienceMonetizationNativeUI then
	urlBuilder = nil
else
	local UrlBuilder = require(parent.UrlBuilder)
	urlBuilder = UrlBuilder.UrlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/monetization/developer-products")
end

local useCreatorCreditMenuItem = require(script.Parent.useCreatorCreditMenuItem)
local useCreatorCreditMenuItem2 = useCreatorCreditMenuItem.useCreatorCreditMenuItem
local FFlagBuildExperiencePrivateInvites = require(BuildExperience.Flags.FFlagBuildExperiencePrivateInvites)
local FFlagEnableBuildAdPromotion = require(BuildExperience.Flags.FFlagEnableBuildAdPromotion)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local useGamePermissions = require(BuildExperience.useGamePermissions)

local FFlagBuildExperienceReleaseFocusOnOverflowOpen = require(BuildExperience.Flags.FFlagBuildExperienceReleaseFocusOnOverflowOpen)
local useGetAdCampaignEligibility = require(BuildExperience.Components.Ads.useGetAdCampaignEligibility)
local adCampaignEligibilityUtils = require(BuildExperience.Components.Ads.adCampaignEligibilityUtils)

local IconButton = Foundation.IconButton
local Menu = Foundation.Menu
local useScaledValue = Foundation.Hooks.useScaledValue

local BadgeVariant = Foundation.Enums.BadgeVariant
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
local releaseAnyFocus = require(parent.BuildExperiencePlaytestLaunch.releaseAnyFocus)

local defineFastInt = game:DefineFastInt("BuildOverflowMenuWidth", 172)

local function isItemPermitted(item, p) -- 1 equivalent call inferred from this helper
	return p == nil or item.requiredPermission == nil or p[item.requiredPermission]
end

local function getSourceText(item, p) -- 1 equivalent call inferred from this helper
	if item.getText == nil then
		return item.text
	end

	return (item.getText(p))
end

local function BuildOverflowMenuButton(props)
	local v = useScaledValue(defineFastInt)
	local v2 = useOpenWebView()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local v3

	if FFlagBuildCheckGamePermissions then
		v3 = useGamePermissions({
			universeId = props.target.universeId,
			isNewGame = props.target.isNewGameTarget
		})
	else
		v3 = nil
	end

	local v4 = useExperienceShareFlow(props.target.universeId, props.target.placeId)

	local onShare = v4.onShare

	local v5 = useSharePublishedExperience(props.target.universeId)
	local state3, setState3 = React.useState(nil)
	local v6 = props.onOpenCreatorCreditPage ~= nil

	local canOpenGetUsers = FFlagEnableBuildAdPromotion

	if canOpenGetUsers then
		if props.onOpenGetUsersPage == nil or props.target.universeId == nil then
			canOpenGetUsers = false
		else
			canOpenGetUsers = props.target.universeId ~= 0
		end
	end

	local v7

	if FFlagEnableBuildAdPromotion then
		local v8

		if canOpenGetUsers then
			v8 = props.target.universeId
		end

		v7 = useGetAdCampaignEligibility(v8)
	end

	local getUsersUserEligible

	if v7 == nil then
		getUsersUserEligible = false
	else
		getUsersUserEligible = v7.userEligible == true
	end

	local getUsersUniverseEligible

	if v7 == nil or v7.universeEligible ~= true then
		getUsersUniverseEligible = false
	else
		getUsersUniverseEligible = props.isUniversePublic == true
	end

	local freeCreditsRemaining = adCampaignEligibilityUtils.freeCreditsRemaining(v7)
	local v8 = props.target.universeId == nil and v6
	local isDisabled

	if props.isDisabled == true then
		isDisabled = true
	elseif props.target.universeId == nil then
		isDisabled = not v8
	else
		isDisabled = false
	end

	local hasPublishedTurn = props.hasPublishedTurn == true

	local v9 = React.useMemo(function()
		if props.target.universeId == nil then
			return nil
		end

		return {
			universeId = props.target.universeId,
			placeId = props.target.placeId,
			sessionId = props.target.sessionId,
			shareAudience = v4.audience,
			isNewGameTarget = props.target.isNewGameTarget,
			hasPublishedTurn = hasPublishedTurn,
			hasPublishedVersion = props.hasPublishedVersion == true,
			canOpenGetUsers = canOpenGetUsers,
			getUsersUserEligible = getUsersUserEligible,
			getUsersUniverseEligible = getUsersUniverseEligible,
			getUsersFreeCreditsRemaining = freeCreditsRemaining
		}
	end, {
		props.target.universeId,
		props.target.placeId,
		props.target.sessionId,
		v4.audience,
		props.target.isNewGameTarget,
		hasPublishedTurn,
		props.hasPublishedVersion,
		canOpenGetUsers,
		getUsersUserEligible,
		getUsersUniverseEligible,
		freeCreditsRemaining
	})

	local v10 = props.store.useItems(v9)
	local v11 = {}

	if v9 ~= nil then
		for _, v12 in v10 do
			for _, item in v12.items do
				local id = item.id
				v11[id] = getSourceText(item, v9) -- inferred equivalent call
				local v13

				if item.getTrailingText ~= nil then
					v13 = item.getTrailingText(v9)
				end

				if v13 ~= nil then
					v11[item.id .. ":trailing"] = v13
				end
			end
		end
	end

	local v12 = useLocalization(v11)
	local v13 = useCreatorCreditMenuItem2({
		onOpenCreatorCreditPage = props.onOpenCreatorCreditPage
	})

	local function getItemText(item) -- 1 equivalent call inferred from this helper
		return v12[item.id]
	end

	local function getItemTrailing(item) -- 1 equivalent call inferred from this helper
		if not (item.getTrailingText ~= nil and item.getTrailingText(v9) ~= nil) then
			return nil
		end

		return {
			type = "Badge",
			text = v12[item.id .. ":trailing"],
			variant = BadgeVariant.Standard
		}
	end

	local function buildMenuItems()
		local menuItems = {}

		if isDisabled then
			return menuItems
		end

		if v9 ~= nil then
			for _, v14 in v10 do
				local v15 = { items = {} }

				for _, item in v14.items do
					local isDisabled2

					if isItemPermitted(item, v3) then -- inferred equivalent call
						if item.isDisabled ~= nil then
							isDisabled2 = item.isDisabled(v9)
						end
					else
						isDisabled2 = true
					end

					local v16 = {
						id = item.id,
						text = getItemText(item), -- inferred equivalent call
						icon = item.icon,
						isDisabled = isDisabled2,
						trailing = getItemTrailing(item) -- inferred equivalent call
					}

					table.insert(v15.items, v16)
				end

				table.insert(menuItems, v15)
			end
		end

		if v6 then
			table.insert(menuItems, {
				items = { v13.item }
			})
		end

		return menuItems
	end

	local menuItems = buildMenuItems()

	local onActivated = React.useCallback(function()
		if isDisabled then
			return
		end

		local focusedTextBox = FFlagBuildExperienceReleaseFocusOnOverflowOpen and UserInputService:GetFocusedTextBox()

		if focusedTextBox then
			focusedTextBox:ReleaseFocus()
		end

		setState(function(p): boolean
			return not p
		end)

		if props.onActivated then
			props.onActivated()
		end
	end, { isDisabled, props.onActivated })

	local onPressedOutside = React.useCallback(function()
		setState(false)
	end, {})

	local onActivated2 = React.useCallback(function(p)
		local focusedTextBox = UserInputService:GetFocusedTextBox()

		if focusedTextBox then
			focusedTextBox:ReleaseFocus()
		end

		if v6 and v13 ~= nil and p == v13.item.id then
			v13.activate()
			setState(false)
		else
			if v9 == nil then
				return
			end

			for _, v14 in v10 do
				for _, item in v14.items do
					if item.id == p then
						local v15

						if item.onActivated then
							v15 = item.onActivated(v9)
						end

						if v15 ~= nil then
							if v15.type == "openPage" then
								if v15.page == "monetization" and not FFlagBuildExperienceMonetizationNativeUI then
									v2(
										urlBuilder({ universeId = v9.universeId }),
										LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB
									)
								elseif props.onAction then
									props.onAction(v15)
								end
							elseif v15.type == "openInvitePicker" then
								if props.onAction then
									props.onAction(v15)
								end
							elseif v15.type == "openInviteManagement" then
								if props.onAction then
									props.onAction(v15)
								end
							elseif v15.type == "openGetUsers" then
								if props.onOpenGetUsersPage then
									props.onOpenGetUsersPage()
								end
							elseif v15.type == "openVersionHistory" then
								releaseAnyFocus()
								setState2(true)
							elseif v15.type == "share" then
								if FFlagBuildExperiencePrivateInvites then
									onShare()
								elseif v15.placeId ~= nil then
									v5(v15.placeId)
								end
							elseif v15.type == "confirmFriendsShare" then
								setState3(v15.placeId)
							elseif v15.type == "leaveExperience" then
								setState(false)
								leaveExperience()
								return
							end
						end

						setState(false)
						return
					end
				end
			end
		end
	end, {
		v10,
		v9,
		v2,
		props.onAction,
		props.onOpenGetUsersPage,
		onShare,
		v5,
		v6,
		v13
	})

	local v14 = React.useCallback(function()
		setState2(false)
	end, {})

	local onShare2 = React.useCallback(function()
		local v15 = state3
		setState3(nil)

		if v15 ~= nil then
			v5(v15)
		end
	end, { state3, v5 })

	local onCancel = React.useCallback(function()
		setState3(nil)
	end, {})
	local versionHistory

	if state2 and props.target.placeId ~= nil then
		versionHistory = React.createElement(VersionHistoryContainer, {
			universeId = props.target.universeId,
			placeId = props.target.placeId,
			isOpen = true,
			onClose = v14,
			onAgentRollbackStarted = v14,
			testId = "build-version-history"
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v15 = {
		Menu = React.createElement(Menu, {
			isOpen = state and not isDisabled,
			items = menuItems,
			side = PopoverSide.Bottom,
			size = InputSize.Large,
			align = PopoverAlign.End,
			onPressedOutside = onPressedOutside,
			onActivated = onActivated2,
			LayoutOrder = props.layoutOrder,
			width = UDim.new(0, v)
		}, React.createElement(IconButton, {
			icon = props.icon,
			variant = ButtonVariant.Utility,
			size = InputSize.Medium,
			isCircular = true,
			isDisabled = isDisabled,
			onActivated = onActivated,
			testId = "build-header-overflow-button"
		})),
		ShareOverlays = 0,
		FriendsOnlyShareDialog = 0,
		VersionHistory = 0
	}
	local shareOverlays

	if FFlagBuildExperiencePrivateInvites then
		shareOverlays = React.createElement(ExperienceShareOverlays, {
			activeDialog = v4.activeDialog,
			hasShareError = v4.hasShareError,
			onCancel = v4.onCancelDialog,
			onConfirmFriends = v4.onConfirmFriends,
			onConfirmPlaytesters = v4.onConfirmPlaytesters
		})
	end

	v15.ShareOverlays = shareOverlays
	local friendsOnlyShareDialog

	if not (FFlagBuildExperiencePrivateInvites or state3 == nil) then
		friendsOnlyShareDialog = React.createElement(FriendsOnlyShareDialog, {
			onCancel = onCancel,
			onShare = onShare2
		})
	end

	v15.FriendsOnlyShareDialog = friendsOnlyShareDialog

	v15.VersionHistory = versionHistory
	return createElement(fragment, nil, v15)
end

return BuildOverflowMenuButton
