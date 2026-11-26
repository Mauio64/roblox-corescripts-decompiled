local CorePackages = game:GetService("CorePackages")
local FaceAnimatorService = game:GetService("FaceAnimatorService")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local usePrevious = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.usePrevious
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local module = require("@luauforge/bundled/eie")
local module2 = require("@luauforge/bundled/fCe")

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience

local fFlagEnableSplitPaneAvatarOverlay = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPaneAvatarOverlay

local fFlagAXFixSplitPaneHomeTryOnReset = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixSplitPaneHomeTryOnReset
local splitPaneStore

if fFlagEnableSplitPaneAvatarOverlay then
	splitPaneStore = require("@luauforge/bundled/dIW").SplitPaneStore
else
	splitPaneStore = nil
end

local module3 = require("@luauforge/deferred/gQx")
local module4 = require("@luauforge/bundled/haq")
local module5 = require("@luauforge/bundled/dKU")
local setCameraButtonStatus = module5.Actions.SetCameraButtonStatus
local setCameraButtonErrorOccurred = module5.Actions.SetCameraButtonErrorOccurred
local module6 = require("@luauforge/bundled/dFs")
local module7 = require("@luauforge/bundled/dzE")
local module8 = require("@luauforge/bundled/dFm")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local module9 = require("@luauforge/bundled/egx")

local getCameraOptIn = require("@luauforge/deferred/gUY").getCameraOptIn
local module10 = require("@luauforge/bundled/dPR")
local module11 = require("@luauforge/bundled/fCk")

local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.transition")

local v5 = {
	toastMessage = "Feature.FaceChat.Subtitle.FeatureDisabled",
	isLocalized = false,
	toastType = module7.InformationMessage
}

local v6 = nil

local function AvatarExperienceTransitionManager(p2): nil
	local v7 = useDispatch()
	local v8

	if fFlagSignalsNavP3gAvatarExperience then
		v8 = useSignalState(module2.getIsAvatarExperienceRoute())
	else
		v8 = useSelector(module2.isAvatarExperienceRoute, getUseSelectorDeepEquals())
	end

	local v9 = usePrevious(v8)
	local v11 = usePrevious((useAvatarRoute()))
	local v12 = module(module9)
	local v13 = module10.useTestVariables(module11.EnabledForUser)

	local function onLeaveAvatarExperience()
		logger:debug("Leaving AvatarExperience")
		local v14

		if fFlagAXFixSplitPaneHomeTryOnReset then
			v14 = fFlagEnableSplitPaneAvatarOverlay
				and splitPaneStore.getStore().getIsBreakpointEnabled(false)
		else
			v14 = fFlagEnableSplitPaneAvatarOverlay and splitPaneStore.isSplitEnabledNow()
		end

		if v14 then
			v7(module4())
		end

		v7(module3())
	end

	local function onEnterAvatarExperience()
		logger:debug("Entering AvatarExperience")
	end

	local function handleTransitions()
		if v9 and not v8 then
			onLeaveAvatarExperience()
		elseif v8 and not v9 then
			if v13 and module2.isUserCameraEligible() then
				getCameraOptIn(v12, true):andThen(function(p3)
					if v6 ~= p3 then
						FaceAnimatorService:Init(p3, false)
						FaceAnimatorService.TrackerError:Connect(function(p4)
							v7(setCameraButtonStatus(false))
							v7(setCameraButtonErrorOccurred(true))
							v7(module8(v5))
							module6(string.format(
								"Universal App Camera FaceAnimatorService TrackerError: %s",
								(tostring(p4))
							))
						end)
						v6 = p3
					end
				end)
			end

			logger:debug("Entering AvatarExperience")
		end
	end

	React.useEffect(handleTransitions, { v8, v9, v11 })

	return nil
end

return AvatarExperienceTransitionManager
