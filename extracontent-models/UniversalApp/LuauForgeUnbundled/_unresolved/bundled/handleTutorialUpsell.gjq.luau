local appPage = require("@luauforge/bundled/gjk").AppPage
local ixpServiceWrapper = require("@luauforge/bundled/gjn").IXPServiceWrapper
local linkingProtocol = require("@luauforge/bundled/gjj").LinkingProtocol
local logger = require("@luauforge/bundled/gir").Logger
local module = require("@luauforge/bundled/gis")

local launchContext = require("@luauforge/bundled/giw").Enums.LaunchContext

local fFlagTutorialUpsellEnabled = require("@luauforge/bundled/git").FFlagTutorialUpsellEnabled
local defineFastFlag = game:DefineFastFlag("TutorialUpsellOverrideIXPEnabled", false)

local defineFastString = game:DefineFastString(
	"TutorialUpsellIXPLayerName",
	"ConsumerPlatforms.TutorialUpsell.BTID"
)

local function userJustSignedUp(object): boolean
	object:flush()
	return object:getState().LaunchContext == launchContext.SignUp
end

local function getTutorialUpsellIxpEligible()
	if defineFastFlag then
		return true
	end

	local success, result = pcall(function()
		return ixpServiceWrapper:GetBTIDLayerData(defineFastString)
	end)

	if not success then
		logger:error("Error fetching tutorial upsell IXP layer data")
		return false
	end

	if result then
		ixpServiceWrapper:LogBrowserTrackerLayerExposure(defineFastString)
		return result.ShowTutorialUpsell or false
	end

	logger:error("Tutorial upsell IXP layer data is nil")
	return false
end

local function handleTutorialUpsell(p2, object, callback)
	if not fFlagTutorialUpsellEnabled then
		logger:info("Tutorial upsell flag is not enabled")
		return module.resolve(false)
	end

	object:flush()

	if object:getState().LaunchContext ~= launchContext.SignUp then
		logger:info("User is not eligible for tutorial upsell")
		return module.resolve(false)
	end

	local v5 = not (linkingProtocol:getLastLuaURL() == nil) and linkingProtocol:getLastLuaURL() ~= ""

	if v5 then
		logger:info("Skipping tutorial upsell due to deep link")
		return module.resolve(false)
	end

	if getTutorialUpsellIxpEligible() then
		object:dispatch(callback({
			{
				name = appPage.TutorialUpsellScreen,
				extraProps = { resetNavigationHistory = callback }
			}
		}))

		return module.resolve(true)
	end

	logger:info("User is not eligible for tutorial upsell via IXP")
	return module.resolve(false)
end

return handleTutorialUpsell
