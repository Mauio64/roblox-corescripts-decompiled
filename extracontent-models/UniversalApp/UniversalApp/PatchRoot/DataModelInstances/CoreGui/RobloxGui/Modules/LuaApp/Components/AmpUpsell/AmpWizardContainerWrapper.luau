local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Modules = script:FindFirstAncestor("Modules")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local Cryo = require(CorePackages.Packages.Cryo)
local OpenPhoneUpsellModal = require(Modules.LuaApp.Thunks.Verification.OpenPhoneUpsellModal)
local OpenEmailUpsellModal = require(Modules.LuaApp.Thunks.Verification.OpenEmailUpsellModal)
local AppPage = require(Modules.LuaApp.AppPage)
local WizardContainer = require(CorePackages.Workspace.Packages.AmpUpsell).WizardContainer
local AmpWizardUserMismatchModal = require(CorePackages.Workspace.Packages.AmpUpsell).AmpWizardUserMismatchModal
local ActionTypeEnum = require(CorePackages.Workspace.Packages.AmpUpsell).AmpEnums.ActionTypeEnum
local GetFFlagEnableAmpEmailUpsellSupport = require(CorePackages.Workspace.Packages.AmpUpsell).GetFFlagEnableAmpEmailUpsellSupport
local GetFFlagEnableAmpIDVUpsellSupport = require(CorePackages.Workspace.Packages.AmpUpsell).GetFFlagEnableAmpIDVUpsellSupport
local GetFFlagEnableAmpSubscriptionUpsell = require(CorePackages.Workspace.Packages.AmpUpsell).GetFFlagEnableAmpSubscriptionUpsell
local FFlagEnableAmpWizardDeepLinkValidateUserId = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAmpWizardDeepLinkValidateUserId

return function(p1) -- line: 24
	-- upvalues: useNavigation (copy), FFlagEnableAmpWizardDeepLinkValidateUserId (copy), Players (copy), useDispatch (copy), React (copy), OpenPhoneUpsellModal (copy), AppPage (copy), ActionTypeEnum (copy), GetFFlagEnableAmpEmailUpsellSupport (copy), OpenEmailUpsellModal (copy), GetFFlagEnableAmpIDVUpsellSupport (copy), GetFFlagEnableAmpSubscriptionUpsell (copy), AmpWizardUserMismatchModal (copy), Cryo (copy), WizardContainer (copy)
	local v19 = useNavigation()
	local v20 = false

	if FFlagEnableAmpWizardDeepLinkValidateUserId then
		local v21 = p1.metadata and p1.metadata.targetUserId

		if v21 and v21 ~= "" then
			local LocalPlayer = Players.LocalPlayer
			local v23 = if not LocalPlayer or (not LocalPlayer.UserId or LocalPlayer.UserId == 0) then nil else tostring(LocalPlayer.UserId)

			if v23 ~= nil and v23 ~= v21 then
				v20 = true
			end
		end
	end

	local v24 = useDispatch()
	local v25 = React.useCallback(function(p2) -- line: 45
		-- upvalues: v24 (copy), OpenPhoneUpsellModal (copy)
		v24(OpenPhoneUpsellModal(p2))
	end, { v24 })
	local v26 = React.useCallback(function(p3) -- line: 49
		-- upvalues: v19 (copy), AppPage (copy)
		v19.push(AppPage.AccountSettingsUpsell, {
			extraProps = p3
		})
	end, { v19 })
	local t1 = {
		[ActionTypeEnum.Phone] = v25
	}

	if GetFFlagEnableAmpEmailUpsellSupport() then
		local v28 = React.useCallback(function(p4) -- line: 58
			-- upvalues: v24 (copy), OpenEmailUpsellModal (copy)
			v24(OpenEmailUpsellModal(p4))
		end, { v24 })

		t1[ActionTypeEnum.AddedEmail] = v28
	end

	if GetFFlagEnableAmpIDVUpsellSupport() then
		local v29 = React.useCallback(function(p5) -- line: 65
			-- upvalues: v19 (copy), AppPage (copy)
			v19.push(AppPage.IDVUpsellContainer, {
				extraProps = p5
			})
		end, { v19 })

		t1[ActionTypeEnum.GovernmentId] = v29
	end

	local v30 = React.useCallback(function(p6) -- line: 72
		-- upvalues: v19 (copy), AppPage (copy)
		v19.push(AppPage.VPCUpsellContainer, {
			extraProps = p6
		})
	end, { v19 })

	t1[ActionTypeEnum.ParentLink] = v30
	t1[ActionTypeEnum.ParentConsent] = v30

	local v31 = React.useCallback(function(p7) -- line: 79
		-- upvalues: v19 (copy), AppPage (copy)
		v19.push(AppPage.FAEUpsell, {
			extraProps = p7
		})
	end, { v19 })

	t1[ActionTypeEnum.AgeEstimation] = v31

	if GetFFlagEnableAmpSubscriptionUpsell() then
		local v32 = React.useCallback(function(p8) -- line: 86
			-- upvalues: v19 (copy), AppPage (copy)
			v19.push(AppPage.RobloxSubscriptionUpsell, {
				extraProps = p8
			})
		end, { v19 })

		t1[ActionTypeEnum.Subscription] = v32
	end

	if v20 then
		return React.createElement(AmpWizardUserMismatchModal, {
			navigation = v19,
			entryPointEventCtx = p1.entryPointEventCtx
		})
	end

	local v33 = Cryo.Dictionary.join(p1 or {}, {
		openUpsells = t1,
		openAccountSettingsUpsell = v26
	})

	return React.createElement(WizardContainer, v33)
end
