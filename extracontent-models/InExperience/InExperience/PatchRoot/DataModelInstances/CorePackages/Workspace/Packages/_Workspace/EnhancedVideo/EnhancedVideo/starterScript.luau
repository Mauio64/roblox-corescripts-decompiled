local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local ReactRoblox = require(scriptParentParent.ReactRoblox)
local Foundation = require(scriptParentParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Enums = Foundation.Enums
local AdLabel = require(scriptParent.interactivity.AdLabel)
local Localization = require(scriptParentParent.InExperienceLocales).Localization
local LocalizationProvider = require(scriptParentParent.Localization).LocalizationProvider
local v14 = game:DefineFastFlag("LuaAppIsEnhancedVideoUniverse", false)
local FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline = require(scriptParent.FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline)
local v16 = game:DefineFastFlag("LuaAppEnableEnhancedVideoExperienceGroupIdCheck", false)
local v17 = if not v16 then nil else 427968160
local EnhancedVideoStore = require(scriptParent.EnhancedVideoStore)
local v19 = if not FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then nil else require(scriptParent.dispatchEnhancedVideoConfig)
local v20 = require(scriptParentParent.Http).NetworkLayers.requestInternalWrapper(nil)

local function starterScript() -- line: 38
	-- upvalues: v16 (copy), v17 (copy), v14 (copy), Localization (copy), LocalizationService (copy), FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline (copy), EnhancedVideoStore (copy), v20 (copy), v19 (copy), ReplicatedStorage (copy), CoreGui (copy), ReactRoblox (copy), React (copy), LocalizationProvider (copy), FoundationProvider (copy), Enums (copy), AdLabel (copy)
	if v16 then
		if game.CreatorType ~= Enum.CreatorType.Group or game.CreatorId ~= v17 then
			return
		end
	elseif not v14 then
		return
	end

	local v22 = Localization.new(LocalizationService.RobloxLocaleId)

	if FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then
		EnhancedVideoStore(false).fetchInitialData(v20, game.GameId):andThen(function(p1) -- line: 53
			-- upvalues: v19 (copy)
			if p1 then
				v19(p1)
			end
		end)
	else
		EnhancedVideoStore(false).fetchInitialData(v20, game.GameId)
	end

	local AdDisclosurePauseEvent = ReplicatedStorage:WaitForChild("AdDisclosurePauseEvent")
	local Folder = Instance.new("Folder")

	Folder.Name = "EnhancedVideoInteractivityControls"
	Folder.Parent = CoreGui
	ReactRoblox.createRoot(Folder):render(React.createElement("ScreenGui", {
		DisplayOrder = -5
	}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = v22
		}, {
			FoundationProvider = React.createElement(FoundationProvider, {
				theme = Enums.Theme.Dark
			}, {
				AdLabel = React.createElement(AdLabel, {
					sendPauseEvent = function() -- line: 79
						-- upvalues: AdDisclosurePauseEvent (copy)
						AdDisclosurePauseEvent:Fire()
					end
				})
			})
		})
	}))
end

return starterScript
