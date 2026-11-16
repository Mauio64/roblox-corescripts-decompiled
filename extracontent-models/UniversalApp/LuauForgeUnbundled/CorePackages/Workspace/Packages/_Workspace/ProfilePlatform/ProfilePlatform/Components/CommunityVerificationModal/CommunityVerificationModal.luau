local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local RobloxAppNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation")
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useScreenSize
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UrlBuilder").UrlBuilder
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useDispatch
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands = if fFlagSignalsNavP3Dispatch then RobloxAppNavigation.NavigationCommands else nil
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Navigation").useNavigation
local getProfilePlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local getAvailableCommunityComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/getAvailableCommunityComponents")

return function()
	local v5 = useStyle()
	local v6 = useDispatch()
	local v7 = useNavigation()
	local v8 = useProfileWrapperContext()
	local v9 = useScreenSize()

	local profileType = v8.profileType
	local profileId = v8.profileId

	local v10 = useLocalization({
		continue = TextKeys.Continue,
		cancel = TextKeys.Cancel,
		verificationRequired = TextKeys.VerificationRequired,
		contentTextHigh = TextKeys.ContentTextHigh,
		contentTextMedium = TextKeys.ContentTextMedium,
		contentTextLow = TextKeys.ContentTextLow
	})

	local v11 = useNavigationProps(function(p2, p3)
		return { disabledReason = p3.disabledReason }
	end)

	local v12 = React.useCallback(function()
		local v13 = {
			name = appPage.GenericWebPage,
			detail = urlBuilder.static.settings.account(),
			extraProps = {
				title = v10.verificationRequired,
				onClose = function()
					v7.goBack()
					v6(getProfilePlatform.API({
						profileType = profileType,
						profileId = profileId,
						components = getAvailableCommunityComponents(),
						includeComponentOrdering = true
					}))
				end
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v13))
		else
			v6(navigateDown(v13))
		end
	end, { v6, v10, v7 })

	local v13 = React.useCallback(function()
		v7.goBack()
	end, { v7 })

	local v14 = {
		[Enums.DisabledReasons.InsufficientVerificationLevelHigh] = v10.contentTextHigh,
		[Enums.DisabledReasons.InsufficientVerificationLevelMedium] = v10.contentTextMedium,
		[Enums.DisabledReasons.InsufficientVerificationLevelLow] = v10.contentTextLow
	}

	return React.createElement(interactiveAlert, {
		title = v10.verificationRequired,
		screenSize = v9,
		middleContent = function()
			return React.createElement(
				"Frame",
				{ BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY },
				{
					Content = React.createElement(styledTextLabel, {
						layoutOrder = 1,
						text = v14[v11.disabledReason],
						fontStyle = v5.Font.Body,
						colorStyle = v5.Theme.TextDefault,
						size = UDim2.fromScale(1, 0),
						automaticSize = Enum.AutomaticSize.Y,
						fluidSizing = false
					})
				}
			)
		end,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = v13, text = v10.cancel }
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = v12, text = v10.continue }
				}
			},
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	})
end
