local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("MediaGallery").Parent
local CentralOverlay = require(Parent.CentralOverlay)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local UniversalAppPolicy = require(Parent.UniversalAppPolicy)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local function openYouTubeVideoWithAgeCheck(s1: string, s2: string?, p1: ((...any) -> ...any), p2: ((...any) -> ...any)?) -- line: 19
	-- upvalues: HttpService (copy), GuiService (copy), getAppFeaturePolicies (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
	if not s1 or #s1 == 0 then
		return
	end

	local function doOpen() -- line: 29
		-- upvalues: s1 (copy), HttpService (copy), s2 (copy), GuiService (copy), p2 (copy)
		local v16 = `https://www.youtube-nocookie.com/embed/{ s1 }?autoplay=1&controls=0&modestbranding=1&rel=0&loop=0&cc_load_policy=0&playsinline=0`
		local json = HttpService:JSONEncode({
			animated = true,
			url = v16,
			title = s2 or ""
		})

		GuiService:BroadcastNotification(json, 23)

		if p2 then
			p2()
		end
	end

	if getAppFeaturePolicies().getShowYouTubeAgeAlert() then
		p1(SetCentralOverlay(CentralOverlayType.LeaveRobloxAlert, {
			continueFunc = doOpen
		}))

		return
	end

	doOpen()
end

return openYouTubeVideoWithAgeCheck
