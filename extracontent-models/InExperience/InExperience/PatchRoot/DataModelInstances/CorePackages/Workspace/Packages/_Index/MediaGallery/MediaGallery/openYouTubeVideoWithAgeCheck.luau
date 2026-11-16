local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("MediaGallery").Parent

local CentralOverlay = require(parent.CentralOverlay)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local function openYouTubeVideoWithAgeCheck(list: string, value: string?, callback, callback2)
	if not list or #list == 0 then
		return
	end

	local function doOpen()
		GuiService:BroadcastNotification(HttpService:JSONEncode({
			url = `https://www.youtube-nocookie.com/embed/{list}?autoplay=1&controls=0&modestbranding=1&rel=0&loop=0&cc_load_policy=0&playsinline=0`,
			title = value or "",
			animated = true
		}), 23)

		if callback2 then
			callback2()
		end
	end

	if getAppFeaturePolicies().getShowYouTubeAgeAlert() then
		callback(SetCentralOverlay(CentralOverlayType.LeaveRobloxAlert, { continueFunc = doOpen }))
	else
		doOpen()
	end
end

return openYouTubeVideoWithAgeCheck
