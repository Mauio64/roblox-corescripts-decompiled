local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local parent = script.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local ReactRoblox = require(parent2.ReactRoblox)
local Foundation = require(parent2.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Enums = Foundation.Enums

local AdLabel = require(parent.interactivity.AdLabel)

local InExperienceLocales = require(parent2.InExperienceLocales)
local Localization = InExperienceLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local defineFastFlag = game:DefineFastFlag("LuaAppIsEnhancedVideoUniverse", false)

local FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline = require(parent.FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline)

local defineFastFlag2 = game:DefineFastFlag("LuaAppEnableEnhancedVideoExperienceGroupIdCheck", false)
local v = defineFastFlag2 and 427968160 or nil
local EnhancedVideoStore = require(parent.EnhancedVideoStore)
local dispatchEnhancedVideoConfig

if FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then
	dispatchEnhancedVideoConfig = require(parent.dispatchEnhancedVideoConfig)
else
	dispatchEnhancedVideoConfig = nil
end

local Http = require(parent2.Http)
local internalWrapper = Http.NetworkLayers.requestInternalWrapper(nil)
local function starterScript()
	if defineFastFlag2 then
		if game.CreatorType ~= Enum.CreatorType.Group or game.CreatorId ~= v then
			return
		end
	elseif not defineFastFlag then
		return
	end

	local localization = Localization.new(LocalizationService.RobloxLocaleId)

	if FFlagLuaAppEnableEnhancedVideoExperienceAssetAndTimeline then
		EnhancedVideoStore(false).fetchInitialData(internalWrapper, game.GameId):andThen(function(p)
			if p then
				dispatchEnhancedVideoConfig(p)
			end
		end)
	else
		EnhancedVideoStore(false).fetchInitialData(internalWrapper, game.GameId)
	end

	local adDisclosurePauseEvent = ReplicatedStorage:WaitForChild("AdDisclosurePauseEvent")

	local enhancedVideoInteractivityControls = Instance.new("Folder")
	enhancedVideoInteractivityControls.Name = "EnhancedVideoInteractivityControls"
	enhancedVideoInteractivityControls.Parent = CoreGui
	ReactRoblox.createRoot(enhancedVideoInteractivityControls):render(React.createElement("ScreenGui", {
		DisplayOrder = -5
	}, {
		LocalizationProvider = React.createElement(LocalizationProvider, {
			localization = localization
		}, {
			FoundationProvider = React.createElement(FoundationProvider, {
				colorMode = Enums.ColorMode.Dark
			}, {
				AdLabel = React.createElement(AdLabel, {
					sendPauseEvent = function()
						adDisclosurePauseEvent:Fire()
					end
				})
			})
		})
	}))
end

return starterScript
