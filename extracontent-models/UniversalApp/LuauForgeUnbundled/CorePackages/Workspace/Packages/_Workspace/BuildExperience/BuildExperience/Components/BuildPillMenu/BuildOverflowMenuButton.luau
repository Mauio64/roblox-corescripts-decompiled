local UserInputService = game:GetService("UserInputService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local VersionHistoryContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/VersionHistory/VersionHistoryContainer")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ShareAudience/FriendsOnlyShareDialog")
local ExperienceShareOverlays = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ShareAudience/ExperienceShareOverlays")
local leaveExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/leaveExperience")
local useExperienceShareFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useExperienceShareFlow")
local useSharePublishedExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/sharePublishedExperience").useSharePublishedExperience
local useOpenWebView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/WebViewUtils").useOpenWebView
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local urlBuilder

if FFlagBuildExperienceMonetizationNativeUI then
	urlBuilder = nil
else
	urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/UrlBuilder").UrlBuilder.fromString("create:dashboard/creations/experiences/{universeId}/monetization/developer-products")
end

local useCreatorCreditMenuItem = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/useCreatorCreditMenuItem").useCreatorCreditMenuItem
local FFlagBuildExperiencePrivateInvites = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePrivateInvites")
local FFlagEnableBuildAdPromotion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnableBuildAdPromotion")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")

local FFlagBuildExperienceReleaseFocusOnOverflowOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceReleaseFocusOnOverflowOpen")
local useGetAdCampaignEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useGetAdCampaignEligibility")
local adCampaignEligibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/adCampaignEligibilityUtils")

local iconButton = Foundation.IconButton
local menu = Foundation.Menu
local useScaledValue = Foundation.Hooks.useScaledValue

local badgeVariant = Foundation.Enums.BadgeVariant
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore/createBuildOverflowMenuStore")
local releaseAnyFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/releaseAnyFocus")

local defineFastInt = game:DefineFastInt("BuildOverflowMenuWidth", 172)

local function isItemPermitted(p2, p3)
	if p3 == nil or p2.requiredPermission == nil then
		return true
	end

	return p3[p2.requiredPermission]
end

local function getSourceText(p2, p3)
	if p2.getText == nil then
		return p2.text
	end

	return (p2.getText(p3))
end

local function BuildOverflowMenuButton(props)
	local v5 = useScaledValue(defineFastInt)
	local v6 = useOpenWebView()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local v7

	if FFlagBuildCheckGamePermissions then
		v7 = useGamePermissions({
			universeId = props.target.universeId,
			isNewGame = props.target.isNewGameTarget
		})
	else
		v7 = nil
	end

	local v8 = useExperienceShareFlow(props.target.universeId, props.target.placeId)

	local onShare = v8.onShare

	local v9 = useSharePublishedExperience(props.target.universeId)
	local state3, setState3 = React.useState(nil)
	local v10 = props.onOpenCreatorCreditPage ~= nil

	local v11 = FFlagEnableBuildAdPromotion

	if v11 then
		if props.onOpenGetUsersPage == nil or props.target.universeId == nil then
			v11 = false
		else
			v11 = props.target.universeId ~= 0
		end
	end

	local v12

	if FFlagEnableBuildAdPromotion then
		local v14 = if v11 then props.target.universeId else nil
		v12 = useGetAdCampaignEligibility(v14)
	end

	local v13 = not (v12 == nil) and v12.userEligible == true

	local v14 = not (v12 == nil or v12.universeEligible ~= true) and props.isUniversePublic == true
	local freeCreditsRemaining = adCampaignEligibilityUtils.freeCreditsRemaining(v12)
	local v15 = props.target.universeId == nil and v10
	local v16 = props.isDisabled == true or props.target.universeId == nil and not v15
	local hasPublishedTurn = props.hasPublishedTurn == true

	local v17 = React.useMemo(function()
		if props.target.universeId == nil then
			return nil
		end

		return {
			universeId = props.target.universeId,
			placeId = props.target.placeId,
			sessionId = props.target.sessionId,
			shareAudience = v8.audience,
			isNewGameTarget = props.target.isNewGameTarget,
			hasPublishedTurn = hasPublishedTurn,
			hasPublishedVersion = props.hasPublishedVersion == true,
			canOpenGetUsers = v11,
			getUsersUserEligible = v13,
			getUsersUniverseEligible = v14,
			getUsersFreeCreditsRemaining = freeCreditsRemaining
		}
	end, {
		props.target.universeId,
		props.target.placeId,
		props.target.sessionId,
		v8.audience,
		props.target.isNewGameTarget,
		hasPublishedTurn,
		props.hasPublishedVersion,
		v11,
		v13,
		v14,
		freeCreditsRemaining
	})

	local v18 = props.store.useItems(v17)
	local v19 = {}

	if v17 ~= nil then
		for k, v20 in v18 do
			for k2, item in v20.items do
				local id = item.id
				local v21 = if item.getText == nil then item.text else item.getText(v17)

				v19[id] = v21
				local v22 = if item.getTrailingText ~= nil then item.getTrailingText(v17) else nil

				if v22 ~= nil then
					v19[item.id .. ":trailing"] = v22
				end
			end
		end
	end

	local v20 = useLocalization(v19)
	local v21 = useCreatorCreditMenuItem({
		onOpenCreatorCreditPage = props.onOpenCreatorCreditPage
	})

	local function getItemText(p2)
		return v20[p2.id]
	end

	local function getItemTrailing(p2)
		if not (p2.getTrailingText ~= nil and p2.getTrailingText(v17) ~= nil) then
			return nil
		end

		return {
			type = "Badge",
			text = v20[p2.id .. ":trailing"],
			variant = badgeVariant.Standard
		}
	end

	local function buildMenuItems()
		local menuItems = {}

		if v16 then
			return menuItems
		end

		if v17 ~= nil then
			for k, v22 in v18 do
				local v23 = { items = {} }

				for k2, item in v22.items do
					local v24 = v7
					local v25

					if v24 == nil or item.requiredPermission == nil or v24[item.requiredPermission] then
						if item.isDisabled ~= nil then
							v25 = item.isDisabled(v17)
						end
					else
						v25 = true
					end

					local v26 = {
						id = item.id,
						text = v20[item.id],
						icon = item.icon,
						isDisabled = v25,
						trailing = 0
					}
					local v27 = if item.getTrailingText ~= nil then item.getTrailingText(v17) ~= nil and {
						type = "Badge",
						text = v20[item.id .. ":trailing"],
						variant = badgeVariant.Standard
					} or nil else nil

					v26.trailing = v27

					table.insert(v23.items, v26)
				end

				table.insert(menuItems, v23)
			end
		end

		if v10 then
			table.insert(menuItems, {
				items = { v21.item }
			})
		end

		return menuItems
	end

	local menuItems = buildMenuItems()

	local v22 = React.useCallback(function()
		if v16 then
			return
		end

		local focusedTextBox = FFlagBuildExperienceReleaseFocusOnOverflowOpen and UserInputService:GetFocusedTextBox()

		if focusedTextBox then
			focusedTextBox:ReleaseFocus()
		end

		setState(function(p2): boolean
			return not p2
		end)

		if props.onActivated then
			props.onActivated()
		end
	end, { v16, props.onActivated })

	local v23 = React.useCallback(function()
		setState(false)
	end, {})

	local v24 = React.useCallback(function(p2)
		local focusedTextBox = UserInputService:GetFocusedTextBox()

		if focusedTextBox then
			focusedTextBox:ReleaseFocus()
		end

		if v10 and v21 ~= nil and p2 == v21.item.id then
			v21.activate()
			setState(false)
		else
			if v17 == nil then
				return
			end

			for k, v25 in v18 do
				for k2, item in v25.items do
					if item.id == p2 then
						local v26 = if item.onActivated then item.onActivated(v17) else nil

						if v26 ~= nil then
							if v26.type == "openPage" then
								if v26.page == "monetization" and not FFlagBuildExperienceMonetizationNativeUI then
									v6(
										urlBuilder({ universeId = v17.universeId }),
										LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB
									)
								elseif props.onAction then
									props.onAction(v26)
								end
							elseif v26.type == "openInvitePicker" then
								if props.onAction then
									props.onAction(v26)
								end
							elseif v26.type == "openInviteManagement" then
								if props.onAction then
									props.onAction(v26)
								end
							elseif v26.type == "openGetUsers" then
								if props.onOpenGetUsersPage then
									props.onOpenGetUsersPage()
								end
							elseif v26.type == "openVersionHistory" then
								releaseAnyFocus()
								setState2(true)
							elseif v26.type == "share" then
								if FFlagBuildExperiencePrivateInvites then
									onShare()
								elseif v26.placeId ~= nil then
									v9(v26.placeId)
								end
							elseif v26.type == "confirmFriendsShare" then
								setState3(v26.placeId)
							elseif v26.type == "leaveExperience" then
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
		v18,
		v17,
		v6,
		props.onAction,
		props.onOpenGetUsersPage,
		onShare,
		v9,
		v10,
		v21
	})

	local v25 = React.useCallback(function()
		setState2(false)
	end, {})

	local v26 = React.useCallback(function()
		local v27 = state3
		setState3(nil)

		if v27 ~= nil then
			v9(v27)
		end
	end, { state3, v9 })

	local v27 = React.useCallback(function()
		setState3(nil)
	end, {})
	local v28

	if state2 and props.target.placeId ~= nil then
		v28 = React.createElement(VersionHistoryContainer, {
			universeId = props.target.universeId,
			placeId = props.target.placeId,
			isOpen = true,
			onClose = v25,
			onAgentRollbackStarted = v25,
			testId = "build-version-history"
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v30 = {
		Menu = React.createElement(menu, {
			isOpen = state and not v16,
			items = menuItems,
			side = popoverSide.Bottom,
			size = inputSize.Large,
			align = popoverAlign.End,
			onPressedOutside = v23,
			onActivated = v24,
			LayoutOrder = props.layoutOrder,
			width = UDim.new(0, v5)
		}, React.createElement(iconButton, {
			icon = props.icon,
			variant = buttonVariant.Utility,
			size = inputSize.Medium,
			isCircular = true,
			isDisabled = v16,
			onActivated = v22,
			testId = "build-header-overflow-button"
		})),
		ShareOverlays = 0,
		FriendsOnlyShareDialog = 0,
		VersionHistory = 0
	}

	local v31 = if FFlagBuildExperiencePrivateInvites then React.createElement(ExperienceShareOverlays, {
		activeDialog = v8.activeDialog,
		hasShareError = v8.hasShareError,
		onCancel = v8.onCancelDialog,
		onConfirmFriends = v8.onConfirmFriends,
		onConfirmPlaytesters = v8.onConfirmPlaytesters
	}) else nil
	v30.ShareOverlays = v31

	local v32 = if not FFlagBuildExperiencePrivateInvites and state3 ~= nil then React.createElement(module5, {
		onCancel = v27,
		onShare = v26
	}) else nil
	v30.FriendsOnlyShareDialog = v32

	v30.VersionHistory = v28
	return createElement(fragment, nil, v30)
end

return BuildOverflowMenuButton
