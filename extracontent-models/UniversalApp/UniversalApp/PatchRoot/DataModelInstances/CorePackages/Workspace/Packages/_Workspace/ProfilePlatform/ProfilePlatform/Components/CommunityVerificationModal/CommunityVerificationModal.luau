local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Enums = require(ProfilePlatform.Common.Enums)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local UIBlox = require(ProfilePlatformParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local RobloxAppNavigation = require(ProfilePlatformParent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local useScreenSize = require(ProfilePlatformParent.RobloxAppHooks).useScreenSize
local UrlBuilder = require(ProfilePlatformParent.UrlBuilder).UrlBuilder
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local useDispatch = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useDispatch
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v20 = if not FFlagSignalsNavP3Dispatch then nil else RobloxAppNavigation.NavigationCommands
local useNavigation = require(ProfilePlatformParent.Navigation).useNavigation
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local getAvailableCommunityComponents = require(ProfilePlatform.Hooks.getAvailableCommunityComponents)

return function() -- line: 31
	-- upvalues: useStyle (copy), useDispatch (copy), useNavigation (copy), useProfileWrapperContext (copy), useScreenSize (copy), useLocalization (copy), TextKeys (copy), useNavigationProps (copy), React (copy), AppPage (copy), UrlBuilder (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateDown (copy), Enums (copy), InteractiveAlert (copy), StyledTextLabel (copy), ButtonType (copy)
	local v25 = useStyle()
	local v26 = useDispatch()
	local v27 = useNavigation()
	local v28 = useProfileWrapperContext()
	local v29 = useScreenSize()
	local profileType = v28.profileType
	local profileId = v28.profileId
	local v32 = useLocalization({
		continue = TextKeys.Continue,
		cancel = TextKeys.Cancel,
		verificationRequired = TextKeys.VerificationRequired,
		contentTextHigh = TextKeys.ContentTextHigh,
		contentTextMedium = TextKeys.ContentTextMedium,
		contentTextLow = TextKeys.ContentTextLow
	})
	local v33 = useNavigationProps(function(_, p2) -- line: 50
		return {
			disabledReason = p2.disabledReason
		}
	end)
	local v34 = React.useCallback(function() -- line: 56
		-- upvalues: AppPage (copy), UrlBuilder (copy), v32 (copy), v27 (copy), v26 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.GenericWebPage,
			detail = UrlBuilder.static.settings.account(),
			extraProps = {
				title = v32.verificationRequired,
				onClose = function() -- line: 62
					-- upvalues: v27 (copy), v26 (copy), getProfilePlatform (copy), profileType (copy), profileId (copy), getAvailableCommunityComponents (copy)
					v27.goBack()
					v26(getProfilePlatform.API({
						includeComponentOrdering = true,
						profileType = profileType,
						profileId = profileId,
						components = getAvailableCommunityComponents()
					}))
				end
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v20.down(v20.fromLegacyPage(t1))

			return
		end

		v26(NavigateDown(t1))
	end, {
		v26,
		v32,
		v27
	})
	local v35 = React.useCallback(function() -- line: 80
		-- upvalues: v27 (copy)
		v27.goBack()
	end, { v27 })
	local t2 = {
		[Enums.DisabledReasons.InsufficientVerificationLevelHigh] = v32.contentTextHigh,
		[Enums.DisabledReasons.InsufficientVerificationLevelMedium] = v32.contentTextMedium,
		[Enums.DisabledReasons.InsufficientVerificationLevelLow] = v32.contentTextLow
	}

	return React.createElement(InteractiveAlert, {
		title = v32.verificationRequired,
		screenSize = v29,
		middleContent = function() -- line: 94
			-- upvalues: React (copy), StyledTextLabel (copy), t2 (copy), v33 (copy), v25 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				Content = React.createElement(StyledTextLabel, {
					layoutOrder = 1,
					fluidSizing = false,
					text = t2[v33.disabledReason],
					fontStyle = v25.Font.Body,
					colorStyle = v25.Theme.TextDefault,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y
				})
			})
		end,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = v35,
						text = v32.cancel
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v34,
						text = v32.continue
					}
				}
			},
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	})
end
