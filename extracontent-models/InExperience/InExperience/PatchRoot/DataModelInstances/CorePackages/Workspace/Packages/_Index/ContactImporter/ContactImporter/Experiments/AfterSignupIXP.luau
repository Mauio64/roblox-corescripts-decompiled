local parent = script.Parent.Parent
local parent2 = parent.Parent
local IXPService = game:GetService("IXPService")

local RoactAppExperiment = require(parent2.RoactAppExperiment)

local useUserExperiment = RoactAppExperiment.useUserExperiment

local FStringPVCIAfterSignupLayer = require(parent.Flags.FStringPVCIAfterSignupLayer)
local FStringPVCIAfterSignupVariantKey = require(parent.Flags.FStringPVCIAfterSignupVariantKey)

local function fn(p)
	return (p[FStringPVCIAfterSignupLayer] or {})[FStringPVCIAfterSignupVariantKey]
end

local AfterSignupIXP = {}

function AfterSignupIXP.usePVAndCIAfterSignupVariant(p)
	return (useUserExperiment(
		{ FStringPVCIAfterSignupLayer },
		fn,
		(p or { isExposureEnabled = false }).isExposureEnabled
	))
end

function AfterSignupIXP.logExposure()
	IXPService:LogUserLayerExposure(FStringPVCIAfterSignupLayer)
end

return AfterSignupIXP
