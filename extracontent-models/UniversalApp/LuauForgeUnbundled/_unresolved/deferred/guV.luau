local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/guW")
local module2 = require("@luauforge/bundled/guX")
local module3 = require("@luauforge/bundled/dCp")
local wizardContainer = require("@luauforge/bundled/eeI").WizardContainer
local ampWizardUserMismatchModal = require("@luauforge/bundled/eeI").AmpWizardUserMismatchModal
local actionTypeEnum = require("@luauforge/bundled/eeI").AmpEnums.ActionTypeEnum

local getFFlagEnableAmpEmailUpsellSupport = require("@luauforge/bundled/eeI").GetFFlagEnableAmpEmailUpsellSupport

local getFFlagEnableAmpIDVUpsellSupport = require("@luauforge/bundled/eeI").GetFFlagEnableAmpIDVUpsellSupport

local getFFlagEnableAmpSubscriptionUpsell = require("@luauforge/bundled/eeI").GetFFlagEnableAmpSubscriptionUpsell
local getFFlagEnableAmpVPCPrologue = require("@luauforge/bundled/eeI").GetFFlagEnableAmpVPCPrologue

local fFlagEnableAmpWizardDeepLinkValidateUserId = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAmpWizardDeepLinkValidateUserId

local fFlagEnableAmpV2Wizard = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAmpV2Wizard

local fFlagLuaAppOdpPrologueAnalytics = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppOdpPrologueAnalytics
local fFlagAmpWizardV2VpcHandoff = require("@luauforge/bundled/guY").FFlagAmpWizardV2VpcHandoff
local useAmpUpsellLauncher = require("@luauforge/bundled/guY").useAmpUpsellLauncher
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local v5 = { gameJoinContentMaturityLock = true, parentalEntrySettings = true }

local function AmpWizardContainerWithV2Vpc(p2)
	local v6, v7 = useAppPolicy(function(p3)
		return p3.getUseAmpV2WizardForVpc(), p3.getAmpV2VpcExcludedRequestTypes()
	end)

	local wizardContainerProps = p2.wizardContainerProps
	local prologueOptions = wizardContainerProps.prologueOptions
	local entryPointEventCtx = wizardContainerProps.entryPointEventCtx
	local ref = React.useRef(nil)

	local ref2 = if fFlagLuaAppOdpPrologueAnalytics then React.useRef(nil) else nil

	local v8 = wizardContainerProps.usePrologue == true and getFFlagEnableAmpVPCPrologue()

	local v9 = React.useCallback(function(p3)
		ref.current = p3.outcome

		if p3.node ~= "Prologue" or prologueOptions == nil then
			return
		end

		local v10 = fFlagLuaAppOdpPrologueAnalytics

		if v10 then
			v10 = not (entryPointEventCtx == nil) and v5[entryPointEventCtx]
		end

		if v10 and entryPointEventCtx == "gameJoinContentMaturityLock" then
			local odpEventUniverseId = if prologueOptions then prologueOptions.odpEventUniverseId else nil
			local current = if ref2 then ref2.current else nil

			if odpEventUniverseId == nil or tostring(odpEventUniverseId) == "" then
				v10 = not (current == nil) and current ~= ""
			else
				v10 = true
			end
		end

		if v10 then
			return
		end

		if p3.outcome == "ODP" or p3.outcome == "Remote" then
			if prologueOptions.onConfirm then
				prologueOptions.onConfirm()
			end
		elseif p3.outcome == "Cancel" and prologueOptions.onCancel then
			prologueOptions.onCancel()
		end
	end, { prologueOptions, entryPointEventCtx })

	local v10 = if prologueOptions then prologueOptions.odpEventUniverseId else nil

	local v11 = useAmpUpsellLauncher({
		surface = "AmpWizardContainer",
		odpEventContext = entryPointEventCtx,
		odpEventUniverseId = v10,
		onEvent = v9
	})

	local v12 = React.useCallback(function(data)
		ref.current = nil
		local v13 = { usePrologue = v8 }

		local config = if prologueOptions then prologueOptions.config else nil

		if config then
			local v14 = {}

			if config.titleText then
				v14.title = config.titleText
			end

			if config.bodyText then
				v14.description = config.bodyText
			end

			if config.confirmText then
				v14.confirmLabel = config.confirmText
			end

			if next(v14) ~= nil then
				v13.prologueCopy = v14
			end
		end

		local recourseData = data.recourseData

		if ref2 then
			local universeId = if type(recourseData) == "table" then recourseData.universeId else nil
			local v14 = ref2
			local v15 = if universeId ~= nil and tostring(universeId) ~= "" then tostring(universeId) else nil
			v14.current = v15
		end

		if
			fFlagLuaAppOdpPrologueAnalytics
			and type(recourseData) == "table"
			and recourseData.contentAgeRestriction ~= nil
			and recourseData.universeId ~= nil
		then
			recourseData = Cryo.Dictionary.join(recourseData, { universeId = Cryo.None })
		end

		local v18 = if data.parentConsentTypes then data.parentConsentTypes[1] else nil
		v11({
			flow = {
				name = "VPC",
				props = { requestType = v18, requestDetails = recourseData }
			},
			extraProps = v13
		}):andThen(function(p3)
			local outcome = p3.outcome or ref.current

			if p3.reason == "Completed" and outcome ~= "Cancel" then
				data.onSuccess()
			else
				data.onCancel()
			end
		end)
	end, { v11, v8, prologueOptions })

	if v6 then
		return React.createElement(wizardContainer, Cryo.Dictionary.join(wizardContainerProps, {
			vpcV2Launcher = v12,
			vpcExcludedRequestTypes = v7 or {}
		}))
	end

	return React.createElement(wizardContainer, wizardContainerProps)
end

return function(options)
	local v6 = useNavigation()

	local v7 = false

	if fFlagEnableAmpWizardDeepLinkValidateUserId then
		local targetUserId = options.metadata and options.metadata.targetUserId

		if targetUserId and targetUserId ~= "" then
			local localPlayer = Players.LocalPlayer
			local userId

			if localPlayer and localPlayer.UserId and localPlayer.UserId ~= 0 then
				userId = tostring(localPlayer.UserId)
			end

			v7 = userId ~= nil and userId ~= targetUserId or false
		end
	end

	local v8 = useDispatch()

	local v9 = React.useCallback(function(p2)
		v8(module(p2))
	end, { v8 })

	local v10 = React.useCallback(function(p2)
		v6.push(module3.AccountSettingsUpsell, { extraProps = p2 })
	end, { v6 })

	local v11 = { [actionTypeEnum.Phone] = v9 }

	if getFFlagEnableAmpEmailUpsellSupport() then
		local v12 = React.useCallback(function(p2)
			v8(module2(p2))
		end, { v8 })
		v11[actionTypeEnum.AddedEmail] = v12
	end

	if getFFlagEnableAmpIDVUpsellSupport() then
		local v12 = React.useCallback(function(p2)
			v6.push(module3.IDVUpsellContainer, { extraProps = p2 })
		end, { v6 })

		v11[actionTypeEnum.GovernmentId] = v12
	end

	local v12 = React.useCallback(function(p2)
		v6.push(module3.VPCUpsellContainer, { extraProps = p2 })
	end, { v6 })

	v11[actionTypeEnum.ParentLink] = v12
	v11[actionTypeEnum.ParentConsent] = v12

	local v13 = React.useCallback(function(p2)
		v6.push(module3.FAEUpsell, { extraProps = p2 })
	end, { v6 })

	v11[actionTypeEnum.AgeEstimation] = v13

	if getFFlagEnableAmpSubscriptionUpsell() then
		local v14 = React.useCallback(function(p2)
			v6.push(module3.RobloxSubscriptionUpsell, { extraProps = p2 })
		end, { v6 })
		v11[actionTypeEnum.Subscription] = v14
	end

	if v7 then
		return React.createElement(ampWizardUserMismatchModal, {
			navigation = v6,
			entryPointEventCtx = options.entryPointEventCtx
		})
	end

	local joined = Cryo.Dictionary.join(options or {}, {
		openUpsells = v11,
		openAccountSettingsUpsell = v10
	})

	if fFlagEnableAmpV2Wizard and fFlagAmpWizardV2VpcHandoff then
		return React.createElement(AmpWizardContainerWithV2Vpc, {
			wizardContainerProps = joined
		})
	end

	return React.createElement(wizardContainer, joined)
end
