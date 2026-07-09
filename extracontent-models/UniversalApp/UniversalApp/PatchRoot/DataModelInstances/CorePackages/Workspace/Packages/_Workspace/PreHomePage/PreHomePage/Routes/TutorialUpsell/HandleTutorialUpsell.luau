local Parent = script:FindFirstAncestor("PreHomePage").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local IXPServiceWrapper = require(Parent.IXPServiceWrapper).IXPServiceWrapper
local LinkingProtocol = require(Parent.LinkingProtocol).LinkingProtocol
local Logger = require(Parent.Loggers).Logger
local Promise = require(Parent.Promise)
local LaunchContext = require(Parent.AppStartup).Enums.LaunchContext
local FFlagTutorialUpsellEnabled = require(Parent.SharedFlags).FFlagTutorialUpsellEnabled
local v9 = game:DefineFastFlag("TutorialUpsellOverrideIXPEnabled", false)
local v10 = game:DefineFastString("TutorialUpsellIXPLayerName", "ConsumerPlatforms.TutorialUpsell.BTID")

local function userJustSignedUp(p1) -- line: 19
	-- upvalues: LaunchContext (copy)
	p1:flush()

	return p1:getState().LaunchContext == LaunchContext.SignUp
end
local function getTutorialUpsellIxpEligible() -- line: 25
	-- upvalues: v9 (copy), IXPServiceWrapper (copy), v10 (copy), Logger (copy)
	if v9 then
		return true
	end

	local ok, result = pcall(function() -- line: 30
		-- upvalues: IXPServiceWrapper (copy), v10 (copy)
		return IXPServiceWrapper:GetBTIDLayerData(v10)
	end)

	if not ok then
		Logger:error("Error fetching tutorial upsell IXP layer data")

		return false
	end

	if not result then
		Logger:error("Tutorial upsell IXP layer data is nil")

		return false
	end

	IXPServiceWrapper:LogBrowserTrackerLayerExposure(v10)

	return result.ShowTutorialUpsell or false
end
local function handleTutorialUpsell(_, p3, p4) -- line: 55
	-- upvalues: FFlagTutorialUpsellEnabled (copy), Logger (copy), Promise (copy), LaunchContext (copy), LinkingProtocol (copy), getTutorialUpsellIxpEligible (copy), AppPage (copy)
	if not FFlagTutorialUpsellEnabled then
		Logger:info("Tutorial upsell flag is not enabled")

		return Promise.resolve(false)
	end

	p3:flush()

	if p3:getState().LaunchContext ~= LaunchContext.SignUp then
		Logger:info("User is not eligible for tutorial upsell")

		return Promise.resolve(false)
	end

	if LinkingProtocol:getLastLuaURL() ~= nil and LinkingProtocol:getLastLuaURL() ~= "" then
		Logger:info("Skipping tutorial upsell due to deep link")

		return Promise.resolve(false)
	end

	if not getTutorialUpsellIxpEligible() then
		Logger:info("User is not eligible for tutorial upsell via IXP")

		return Promise.resolve(false)
	end

	p3:dispatch(p4({{
		name = AppPage.TutorialUpsellScreen,
		extraProps = {
			resetNavigationHistory = p4
		}
	}}))

	return Promise.resolve(true)
end

return handleTutorialUpsell
