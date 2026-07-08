game:GetService("CoreGui")

local SafetyService = nil
local CorePackages = game:GetService("CorePackages")
local AvatarIdentification = require(CorePackages.Workspace.Packages.TnSAvatarIdentification).AvatarIdentification
local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent
local Hide = require(ParentParent.Actions.Hide)
local Show = require(ParentParent.Actions.Show)
local SetIdentifiedAvatars = require(ParentParent.Actions.SetIdentifiedAvatars)
local ScreenshotHookManager = require(ParentParent.Utility.ScreenshotHookManager)
local getVisibleAvatars = AvatarIdentification.getVisibleAvatars

if game:GetEngineFeature("ReportAnythingScreenshot") then
	SafetyService = game:GetService("SafetyService")
end

return function() -- line: 22
	-- upvalues: SafetyService (ref), ScreenshotHookManager (copy), Hide (copy), getVisibleAvatars (copy), RunService (copy), Show (copy), SetIdentifiedAvatars (copy)
	return function(p1) -- line: 23
		-- upvalues: SafetyService (ref), ScreenshotHookManager (copy), Hide (copy), getVisibleAvatars (copy), RunService (copy), Show (copy), SetIdentifiedAvatars (copy)
		if SafetyService == nil then
			return
		end

		coroutine.wrap(function() -- line: 29
			-- upvalues: ScreenshotHookManager (copy), p1 (copy), Hide (copy), SafetyService (ref), getVisibleAvatars (copy), RunService (copy), Show (copy), SetIdentifiedAvatars (copy)
			ScreenshotHookManager.doPreScreenshot()
			p1:dispatch(Hide())
			SafetyService:TakeScreenshot({
				registerContent = 1
			})

			local v12, _ = getVisibleAvatars()

			for _ = 1, 61 do
				RunService.RenderStepped:Wait()
			end

			p1:dispatch(Show())
			ScreenshotHookManager.doPostScreenshot()
			p1:dispatch(SetIdentifiedAvatars(v12))
		end)()
	end
end
