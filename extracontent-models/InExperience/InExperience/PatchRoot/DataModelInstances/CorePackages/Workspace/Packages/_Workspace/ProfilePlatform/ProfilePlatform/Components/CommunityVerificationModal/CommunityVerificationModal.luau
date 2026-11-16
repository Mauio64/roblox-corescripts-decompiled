local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Enums = require(ProfilePlatform.Common.Enums)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UIBlox = require(parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local getAvailableCommunityComponents = require(ProfilePlatform.Hooks.getAvailableCommunityComponents)

return function()
	local v = useStyle()
	local v2 = useDispatch()
	local v3 = useNavigation()
	local v4 = useProfileWrapperContext()
	local screenSize = useScreenSize()

	local profileType = v4.profileType
	local profileId = v4.profileId

	local v5 = useLocalization({
		continue = TextKeys.Continue,
		cancel = TextKeys.Cancel,
		verificationRequired = TextKeys.VerificationRequired,
		contentTextHigh = TextKeys.ContentTextHigh,
		contentTextMedium = TextKeys.ContentTextMedium,
		contentTextLow = TextKeys.ContentTextLow
	})

	local v6 = useNavigationProps(function(_, p)
		return { disabledReason = p.disabledReason }
	end)

	local onActivated = React.useCallback(function()
		local v7 = {
			name = AppPage.GenericWebPage,
			detail = urlBuilder.static.settings.account(),
			extraProps = {
				title = v5.verificationRequired,
				onClose = function()
					v3.goBack()
					v2(getProfilePlatform.API({
						profileType = profileType,
						profileId = profileId,
						components = getAvailableCommunityComponents(),
						includeComponentOrdering = true
					}))
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7))
		else
			v2(NavigateDown(v7))
		end
	end, { v2, v5, v3 })

	local onActivated2 = React.useCallback(function()
		v3.goBack()
	end, { v3 })

	local v7 = {
		[Enums.DisabledReasons.InsufficientVerificationLevelHigh] = v5.contentTextHigh,
		[Enums.DisabledReasons.InsufficientVerificationLevelMedium] = v5.contentTextMedium,
		[Enums.DisabledReasons.InsufficientVerificationLevelLow] = v5.contentTextLow
	}

	return React.createElement(InteractiveAlert, {
		title = v5.verificationRequired,
		screenSize = screenSize,
		middleContent = function()
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				Content = React.createElement(StyledTextLabel, {
					layoutOrder = 1,
					text = v7[v6.disabledReason],
					fontStyle = v.Font.Body,
					colorStyle = v.Theme.TextDefault,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					fluidSizing = false
				})
			})
		end,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = { onActivated = onActivated2, text = v5.cancel }
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = onActivated, text = v5.continue }
				}
			},
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	})
end
