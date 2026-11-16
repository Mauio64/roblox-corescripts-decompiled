local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local Foundation = require(CorePackages.Packages.Foundation)
local View = Foundation.View

local Responsive = require(CorePackages.Workspace.Packages.Responsive)

local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider

local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local UniversalAppPolicy2 = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local AppFeaturePolicies = UniversalAppPolicy2.AppFeaturePolicies
local SocialPolicies = require(CorePackages.Workspace.Packages.SocialPolicies)
local ChatPolicies = SocialPolicies.ChatPolicies
local AvatarPolicies = require(CorePackages.Workspace.Packages.AvatarPolicies)
local avatarPolicies = AvatarPolicies.AvatarPolicies
local SocialPolicies2 = require(CorePackages.Workspace.Packages.SocialPolicies)
local SharePolicies = SocialPolicies2.SharePolicies
local SocialPolicies3 = require(CorePackages.Workspace.Packages.SocialPolicies)
local ShareTargetGamePolicies = SocialPolicies3.ShareTargetGamePolicies
local Enums = require(CorePackages.Workspace.Packages.ProfilePlatform.Enums)
local installReducer = require(CorePackages.Workspace.Packages.ProfilePlatform.installReducer)

local Constants = require(CorePackages.Workspace.Packages.ProfilePlatform.Constants)
local ProfileTypes = Enums.ProfileTypes
local ProfileWrapperContext = require(CorePackages.Workspace.Packages.ProfilePlatform.ProfileWrapperContext)

local PlayerProfile = require(script.Parent.PlayerProfile)

local function createStore(options)
	local v = Rodux.combineReducers({ [Constants.RODUX_KEY] = installReducer() })

	return Rodux.Store.new(v, options or {}, { Rodux.thunkMiddleware })
end

local function PlayerProfileContainer(props)
	local ref = React.useRef(nil)

	return React.createElement(RoactAppPolicy.Provider, {
		policy = {
			AppFeaturePolicies,
			ChatPolicies,
			avatarPolicies,
			SharePolicies,
			ShareTargetGamePolicies
		}
	}, {
		ProfileWrapperProvider = React.createElement(ProfileWrapperContext.Provider, {
			value = {
				profileId = tostring(props.userId),
				profileType = ProfileTypes.User,
				sourceInfo = { source = Enums.Sources.InExperienceProfile, contextualInfoType = "" },
				navigateTo = {
					qRCodePage = function() end,
					previousView = function(_: boolean) end,
					itemDetails = function(_) end,
					itemOrBundleDetails = function(_, _) end,
					catalogSearch = function(_) end,
					tryOnItem = function(_: string, _: string, _: string?, _: string?) end,
					inspectAvatar = props.inspectAvatar,
					editUsername = function() end,
					openLeaveRobloxAlertUIBlox = function(_) end,
					closeLeaveRobloxAlert = function() end
				},
				externalAnalytics = { catalogAnalytics = {} }
			}
		}, {
			CoreScriptsRootProvider = React.createElement(CoreScriptsRootProvider, {}, {
				RoduxStore = React.createElement(RoactRodux.StoreProvider, { store = createStore() }, {
					ResponsiveProvider = React.createElement(Responsive.ContainerRef.Provider, {
						value = ref
					}, {
						PlayerProfileContainer = React.createElement(View, {
							tag = "size-full",
							ref = ref
						}, {
							PlayerProfile = React.createElement(PlayerProfile, {
								userId = props.userId,
								closePage = props.closePage
							})
						})
					})
				})
			})
		})
	})
end

return PlayerProfileContainer
